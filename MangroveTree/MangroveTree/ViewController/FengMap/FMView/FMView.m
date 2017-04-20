//
//  FMView.m
//  mgmanager
//
//  Created by fengmap on 16/6/29.
//  Copyright © 2016年 Beijing Century Union. All rights reserved.
//

#import "FMView.h"
#import "FMMapKit.h"
#import "FMView+ShowModel.h"
#import "FMKSceneAnimator.h"

#import "ModelInfoPopView.h"
#import "RouteDisplayView.h"
#import "NumberLineView.h"
#import "NaviPopView.h"
#import "NaviTopView.h"
#import "CategoryView.h"
#import "SwitchMapInfoView.h"

#import "FMKNodeAssociation.h"

#import "Const.h"

#import "QueryDBModel.h"
#import "DBSearchTool.h"

#import "UIImage+AddText.h"
#import "FMView+AddView.h"
#import "UIView+TransitionAnimation.h"

#import "FMIndoorMapVC.h"
#import "FMParserJsonData.h"
#import "FMKLocationServiceManager.h"

#import "FMIndoorMapVC.h"
#import "MapViewController.h"
#import "FrameViewController.h"
#import "UIViewExt.h"

CGFloat const kFMBottomViewCornerRadius = 8.0f;

CGFloat const kModelInfoViewWidth = 254.0f;
CGFloat const kModelInfoViewHeight = 136.0f;
CGFloat const kImageMarkerOffset = 5.0f;
NSInteger const kRecoverMapFollowTime = 5;//倒计时
NSString * const dimian01 = @"999800170";
NSString * const dimian02 = @"999800171";
NSString * const treeType = @"100000";

int const kMuMianA = 70147;
int const kMuMianB = 70148;
int const kDaWangZong = 79981;
int const KZonglv     = 70146;

extern NSString* FMModelSelected;

@interface FMView()<FMKMapViewDelegate,FMKLayerDelegate,FMKNaviAnalyserDelegate,FMKAnimatorDelegate,FMKPathAnimatorDelegate,FMKSearchAnalyserDelegate,ModelInfoPopViewDelegate,FMLocationManagerDelegate,SwitchMapInfoBtnDelegate,NaviPopViewDelegate>
{
	NSTimer * _locationMarkerTimer;
	
	FMKLocationMarker * _locationMarker;
	FMKImageLayer * _imageLayer;
	
	NSTimer * _recoverMapFollow;//倒计时
	NSInteger _recoverTime;//恢复跟随倒计时间
	
	NSString * _indoorMapID;//室内地图ID
	
	NSDictionary * _indoorAndOutdoorInfo;
	
	BOOL _isEnableMove;//跟随模式手指触摸时 移动开关
	
	FMKNaviContraintPara _pathPara;
	
	BOOL _isContainModel;
	
	FMKExternalModel * _highlightModel;//高亮显示的模型
	
	FMKMapCoord _currentMapCoord;//当前定位位置
	
	FMKMapPoint _lastMapPoint;//上一次定位的位置
	
	int _lastSetupMapID;//导航模式下非上次设置地图ID
}

@property (nonatomic, assign) __block int categoryTag;
@property (nonatomic, assign) __block int oldImageMarkerIndex;
@property (nonatomic, strong) NSMutableArray * naviResults;
@property (nonatomic, strong) UIAlertController *alertView;
@property (nonatomic, assign) BOOL resultDistance;
@property (nonatomic, assign) FMKMapCoord currentMapCoord;
@property (nonatomic, assign) FMKMapCoord waiterMapCoord;
@property (nonatomic, copy) NSString * cancelMapID;//取消跳转的mapID
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) FMKNodeAssociation *nodeAssociation;

@end

@implementation FMView

- (instancetype)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame: frame])
    {
		[self initParas];//初始化所需参数
		[self addNotif];//通知相关
	}
	
	return self;
}
- (void)addNotif
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNaviResult:) name:kPostNaviResultInfo object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveSelectedPoi:) name:@"postSelectedPoi" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveStopNavi:) name:@"FMStopNavi" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableLocationBtnClick:) name:NotiCurrentLocation object:nil];
}
- (void)initParas
{
	self.showList = [NSMutableArray array];
	self.naviResults = [NSMutableArray array];
	
	self.type = ButtonType_NOTFOUND;
    self.mapFinish = NO;
	_categoryTag = NSNotFound;
    self.resultDistance = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self getMacAndStartLocationService];//获取MAC地址并且开启定位服务
    });
	
	_isEnableMove = YES;
    _showChangMap = NO;
    
}
#pragma mark - AddMap

- (void)addFengMapView
{
    if (!self.fengMapView)
    {
        _mapPath = [[NSBundle mainBundle] pathForResource:@(kOutdoorMapID).stringValue ofType:@"fmap"];
        CGRect rect = CGRectMake(0, 64, self.frame.size.width, kScreenHeight - 64);
        self.fengMapView = [[FMMangroveMapView alloc] initWithFrame:rect path:_mapPath delegate:self];
        [self addSubview:self.fengMapView];
        [self.fengMapView zoomWithScale:1.8];
        [self.fengMapView setRotateWithAngle:0.0];
        //		[self.fengMapView setInclineAngle:50.0/180*M_PI];
        // 默认加载90度
        [self.fengMapView inclineWithAngle:60.0f];
        self.fengMapView.showCompass = YES;
        [self.fengMapView moveToViewCenterByMapCoord:FMKGeoCoordMake(0, FMKMapPointMake(1.2188250E7, 2071090.0))];
        //添加图片标注物图层
        _imageLayer = [[FMKImageLayer alloc] initWithGroupID:@"1"];
        [self.fengMapView.map addLayer:_imageLayer];
        
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 160) textContainer:nil];
        //        [self.fengMapView addSubview:_textView];
        //        [self.fengMapView setCompassOrigin:CGPointMake(200, 200)];
        //[self addModelInfoPopView];//模型信息弹框
        //		self.modelInfoPopView.delegate = self;
        [self addlocateBtn];//定位按钮
        //		[self addRouteView];//路线信息弹框
        [self addNaviPopView];//导航信息弹框
        self.naviPopView.delegate = self;
        [self addInforView];
        [self addNaviTopView];//顶部导航信息框
        [self addSwitchMapInfoView];
        self.switchMapInfoView.delegate = self;
        [self setLayerDelegate];//设置相关图层的代理
        [self addLocationMarker];//添加定位标注物
        
        //路径规划
        __weak typeof (self)wSelf = self;
        __weak FMMangroveMapView * wMapView = _fengMapView;
        [FMNaviAnalyserTool shareNaviAnalyserTool].returnNaviResult = ^(NSArray * result, NSString * mapID)
        {
            if ([mapID isEqualToString:@(kOutdoorMapID).stringValue]) {
                FMKNaviResult * naviResult = result[0];
                [wSelf.naviContraint updateNaviConstraintDataWith:naviResult.pointArray groupID:@"1"];
                [wMapView.map.lineLayer removeAllLine];
                
                //				[wSelf drawSingleLineByNaviResult:result containStartAndEnd:YES];
            }
        };
    }
    
    __weak typeof (self)wSelf = self;
    _categoryView.categoryBtnClickBlock = ^(NSInteger tag,BOOL buttonSelected) {
        wSelf.categoryTag = (int)tag;
    };
}
- (void)resetTheme
{
    [_fengMapView setThemeWithLocalPath:_fengMapView.currentThemePath];
}
- (void)addlocateBtn
{
    _enableLocateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _enableLocateBtn.frame = CGRectMake(kLocationSpace, kScreenHeight-64-kLocBtnHeight, kLocBtnWidth, kLocBtnHeight);
    [_enableLocateBtn setBackgroundImage:[UIImage imageNamed:@"location_icon_nomarl"] forState:UIControlStateNormal];
    [_enableLocateBtn setBackgroundImage:[UIImage imageNamed:@"location_icon_sele"] forState:UIControlStateSelected];
    [_enableLocateBtn setBackgroundImage:[UIImage imageNamed:@"location_icon_sele"] forState:UIControlStateHighlighted];
    [self addSubview:_enableLocateBtn];
    [_enableLocateBtn addTarget:self action:@selector(inDoorMapView:) forControlEvents:UIControlEventTouchUpInside];
}
- (FMKNodeAssociation *)nodeAssociation
{
    if (!_nodeAssociation)
    {
        NSString *bundlepath = [[NSBundle mainBundle] pathForResource:@"FMBundle.bundle" ofType:nil];
        NSBundle *fmBundle = [NSBundle bundleWithPath:bundlepath];
        NSString *jsonPath = [fmBundle pathForResource:@"nodeassociation.json" ofType:nil];
        _nodeAssociation = [[FMKNodeAssociation alloc] initWithMap:self.fengMapView.map path:jsonPath];
    }
    return _nodeAssociation;
}
//进入2D模式
- (void)enter2DMode
{
    self.fengMapView.enable3D = NO;
    [self.fengMapView setInclineEnable: NO];
}
//退出2D模式
- (void)exit2DMode
{
    self.fengMapView.enable3D = YES;
    [self.fengMapView setInclineEnable:YES];
}
//添加定位标注物
- (void)addLocationMarker
{
    _locationMarker = [[FMKLocationMarker alloc] initWithPointerImageName:@"pointer.png" DomeImageName:@"dome.png"];
    [self.fengMapView.map.locateLayer addLocationMarker:_locationMarker];
    _locationMarker.size = CGSizeMake(70, 70);
    _locationMarker.hidden = YES;
}
//获取MAC地址并且开启定位服务
- (void)getMacAndStartLocationService
{
	_mapPath = [[NSBundle mainBundle] pathForResource:@"79980.fmap" ofType:nil];
	__block NSString *macAddress;
	
	macAddress = [[DataManager defaultInstance] getParameter].diviceId;
    
    FMKLocationServiceManager * locationManager = [FMKLocationServiceManager shareLocationServiceManager];
    locationManager.delegate = self;
    
    if (!macAddress || [macAddress isEqualToString:@""])
    {
//		dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
		[[FMDHCPNetService shareDHCPNetService] localMacAddress:^(NSString *macAddr)
        {
            if (macAddr != nil && ![macAddr isEqualToString:@""])
            {
                macAddress = macAddr;
                [[DataManager defaultInstance] getParameter].diviceId = macAddr;
                [[DataManager defaultInstance] saveContext];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [locationManager startLocateWithMacAddress:macAddress mapPath:_mapPath];
            });

//			dispatch_semaphore_signal(semaphore);
		}];
//		dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    }else
    {
        [locationManager startLocateWithMacAddress:macAddress mapPath:_mapPath];
    }
	
	
}
#pragma mark - NSNotification
//接收路径规划返回结果
- (void)receiveNaviResult:(NSNotification *)noti
{
    NSDictionary * dic = (NSDictionary *)noti.userInfo;
    NSString * mapID = dic[@"mapID"];
    
    if ([mapID isEqualToString:@(kOutdoorMapID).stringValue]) {
        NSArray * result = dic[@"naviResult"];
        if (result)
        {
            [self.naviResults addObjectsFromArray:result];
            FMKNaviResult * naviResult = result[0];
            [self.naviContraint updateNaviConstraintDataWith:naviResult.pointArray groupID:@"1"];
            [self drawSingleLineByNaviResult:result containStartAndEnd:YES];
        }
    }
}
//接受搜索结果选中的poi 插标
- (void)receiveSelectedPoi:(NSNotification *)noti
{
    [_imageLayer removeAllImageMarker];
    QueryDBModel * model = noti.object;
    FMKMapPoint mapPoint = FMKMapPointMake(model.x, model.y);
    FMKImageMarker * poiPositionMarker = [[FMKImageMarker alloc] initWithImage:[UIImage imageNamed:@"line_icon_fun"] Coord:mapPoint];
    poiPositionMarker.offsetMode = FMKImageMarker_USERDEFINE;
    poiPositionMarker.imageOffset = model.z;
    [_imageLayer addImageMarker:poiPositionMarker animated:NO];
    [self moveToViewCenterWithDBModel:model];
}
//将搜索页面得到的模型居中并弹框
- (void)moveToViewCenterWithDBModel:(QueryDBModel *)model
{
    self.queryModel = model;
    FMKGeoCoord coord = FMKGeoCoordMake(model.gid, FMKMapPointMake(model.x, model.y));
    [self.fengMapView moveToViewCenterByMapCoord:coord];
    FMKExternalModelLayer * modelLayer = [self.fengMapView.map getExternalModelLayerWithGroupID:@(model.gid).stringValue];
    FMKExternalModel * myModel = [modelLayer queryExternalModelByFid:model.fid];
    [self didSelectedEnd:myModel];
}
//接收停止导航消息
- (void)receiveStopNavi:(NSNotification *)noti
{
    BOOL outDoor = noti.object;
    if (outDoor == NO)
        [self stopNavi];
}

#pragma mark - Set Delegate
//设置相关图层的代理
- (void)setLayerDelegate
{
    for ( NSString * groupID in self.fengMapView.groupIDs)
    {
        FMKModelLayer * modelLayer = [self.fengMapView.map getModelLayerWithGroupID:groupID];
        modelLayer.hidden = YES;
        FMKExternalModelLayer * emLayer = [self.fengMapView.map getExternalModelLayerWithGroupID:groupID];
        emLayer.delegate = self;
    }
    for (NSString *groupID in self.fengMapView.groupIDs)
    {
        FMKLabelLayer *labelLayer = [self.fengMapView.map getLabelLayerWithGroupID:groupID];
        labelLayer.delegate = self;
    }
}
//在导航模式下 模型拾取关闭
- (void)modelLayerDelegateIgnore
{
    FMKExternalModelLayer * modelLayer = [self.fengMapView.map getExternalModelLayerWithGroupID:@"1"];
    if ([FMNaviAnalyserTool shareNaviAnalyserTool].hasStartNavi)
        modelLayer.delegate = nil;
    else
        modelLayer.delegate = self;
}
- (void)addLocationDelegate
{
    [FMKLocationServiceManager shareLocationServiceManager].delegate = self;
    [FMLocationManager shareLocationManager].delegate = self;
}
#pragma mark - FMKLocationServiceManagerDelegate

- (void)didUpdatePosition:(FMKMapCoord)mapCoord success:(BOOL)success
{
    _locationMarker.hidden = [FMLocationManager shareLocationManager].isCallingService;
//    _enableLocateBtn.hidden = ![FMLocationManager shareLocationManager].isCallingService;
//    _locationMarker.hidden = !_locationMarker.hidden;
    if ([FMLocationManager shareLocationManager].isCallingService == YES) return;
	if (success)
    {
		if ([FMNaviAnalyserTool shareNaviAnalyserTool].hasStartNavi)
		{
			if (mapCoord.mapID != kOutdoorMapID)
			{
				[self setupSwitchMapInfoView:NO currentMapCoord:mapCoord];
			}
			else
			{
				[self setupSwitchMapInfoView:YES currentMapCoord:mapCoord];
				if (_isFirstLocate)
				{
					_lastMapPoint = mapCoord.coord.mapPoint;
					_isFirstLocate = NO;
					[self updateConstraintData];
				}
				else
				{
					FMKNaviContraintResult result = [self.naviContraint naviContraintByLastPoint:_lastMapPoint currentMapPoint:mapCoord.coord.mapPoint];
					if (result.type == FMKCONSTRAINT_SUCCESS)
					{
						FMKNaviContraintResult result = [self naviConstraintWithMapCoord:mapCoord];
						if (result.type == FMKCONSTRAINT_SUCCESS)
						{
							[self calSurplusLengthAndUpdateTopViewWithNaviConstraint:result];
						}
						_isFirstLocate = NO;
					}
				}
			}
		}
		else
		{
			_currentMapCoord = mapCoord;
			//跳转或更新地图
			[self switchToIndoorOrUpdateLocationMarkerByMapCoord:mapCoord];
		}
	}
}
- (void)didUpdateHeading:(double)heading
{
    if (_locationMarker)
    {
        [_locationMarker updateRotate:heading];
    }
}
- (void)mapViewDidUpdate:(FMKMapView *)mapView
{
    _enableLocateBtn.selected = NO;
    
    __weak typeof (self) wSelf = self;
    self.naviTopView.stopNaviBlock = ^{
        [wSelf showAlertView];
        [FMNaviAnalyserTool shareNaviAnalyserTool].naviResult = nil;
    };
}
- (void)mapViewDidFinishLoadingMap:(FMKMapView *)mapView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideAllHUDsForView:[AppDelegate sharedDelegate].window animated:YES];
    });
    self.mapFinish = YES;
    if ([Util locationServicesEnabled] == NO)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提醒" message:@"使用酒店地图定位以及导航功能需要应用允许访问您当前的位置，是否前往设置打开GPS定位" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"前往" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                 {
                                     [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                 }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                       {
                                           
                                       }];
        
        [alert addAction:cancelAction];
        [alert addAction:action];
        [[self getCurrentController]  presentViewController:alert animated:YES completion:^{
            
        }];
    }
}

#pragma mark - FMLocationManagerDelegate

- (void)wifiInfoTime:(NSTimeInterval)time wifiStatus:(BOOL)wifiStatus GPSHorizontalAccuracy:(float)GPSHorizontalAccuracy wifiMaxRssi:(int)MaxRssi uMapID:(int)uMapID
{
    
}
- (void)testDistanceWithResult:(BOOL)result distance:(double)distance
{
    NSLog(@"+++++++++++++++++++++++++++++++++++++++++++++++++");
    self.resultDistance = result;
}
- (void)updateLocPosition:(FMKMapCoord)mapCoord macAddress:(NSString * )macAddress
{
    NSLog(@"_________________%d____________________%d",mapCoord.mapID, [FMKLocationServiceManager shareLocationServiceManager].currentMapCoord.mapID);
    _locationMarker.hidden = YES;
    if ([macAddress isEqualToString: [[DataManager defaultInstance] getParameter].diviceId] && mapCoord.mapID != kOutdoorMapID)
    {
        if ([self testIndoorMapIsxistByMapCoord:mapCoord.mapID])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.currentMapCoord = mapCoord;
                self.waiterMapCoord = mapCoord;
                if ([FMKLocationServiceManager shareLocationServiceManager].currentMapCoord.mapID != kOutdoorMapID)
                {
                    if (_showChangMap == NO)
                    {
                        self.showChangMap = YES;
                    }
                }
            });
        }
    }
}
- (void)setResultDistance:(BOOL)resultDistance
{
    if (_resultDistance != resultDistance)
    {
        _resultDistance = resultDistance;
        if (_resultDistance == YES)
        {
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"距离提醒" message:@"服务员距离您十米之内啦" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sureAcion = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }] ;
            [alertView addAction:sureAcion];
            [[self getCurrentController] presentViewController:alertView animated:YES completion:^{
                
            }];
        }
    }
}

#pragma mark - FMKLayerDelegate
//模型的拾取
- (void)onMapClickNode:(FMKNode *)node inLayer:(FMKLayer *)layer
{
    if ([FMLocationManager shareLocationManager].isCallingService == YES)
        return;
    if ([FMNaviAnalyserTool shareNaviAnalyserTool].hasStartNavi == YES) return;
    //导航模式下模型拾取关闭
    [self modelLayerDelegateIgnore];
    [self stopNavi];
    //	[self.modelInfoPopView hide];//隐藏信息弹框
    FMKExternalModel * model = nil;
    if ([node isKindOfClass:[FMKExternalModel class]])
    {
        model = (FMKExternalModel *)node;
        if ([model.fid isEqualToString:dimian01] ||
            [model.fid isEqualToString:dimian02] ||
            [model.type isEqualToString:treeType])
        {
            [self.fengMapView showAllOnMap];
            //			[self.modelInfoPopView hide];
            [self setEnableLocationBtnFrameByView:nil];
            return;
        }
    }
    if ([node isKindOfClass:[FMKLabel class]])
    {
        if (!_nodeAssociation) [self nodeAssociation];
        model = [_nodeAssociation externalModelByLabel:(FMKLabel *)node];
    }
    
    [self didSelectedEnd:model];
}
- (void)mapView:(FMKMapView *)mapView didSingleTapWithPoint:(CGPoint)point
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NotiCloseTopAlert object:nil];
    if ([FMNaviAnalyserTool shareNaviAnalyserTool].hasStartNavi == YES) return;
    if ([FMLocationManager shareLocationManager].isCallingService == YES)
        return;
    //	[self.modelInfoPopView hide];
    [self.routeDisplayView hide];
    [self.naviPopView hide];
    [self.inforView hide];
    [self stopNavi];
    [self.fengMapView showAllOnMap];
    
}
- (void)mapView:(FMKMapView *)mapView didMovedWithPoint:(CGPoint)point
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NotiCloseTopAlert object:nil];
}

#pragma mark - InDoor
- (void)inDoorMapView:(UIButton *)button
{
    button.highlighted = YES;
    button.selected = YES;
    [self enableLocationInDoor];
    button.selected = NO;
    
}
- (void)enableLocationInDoor
{
    FMKMapCoord currentMapCoord = [FMKLocationServiceManager shareLocationServiceManager].currentMapCoord;
    if (currentMapCoord.mapID == kOutdoorMapID) {
        [FMKLocationServiceManager shareLocationServiceManager].delegate = self;
    }
    else
    {
        FMKMapCoord mapCoord;
        if ([FMLocationManager shareLocationManager].isCallingService == YES)
        {
            mapCoord = self.waiterMapCoord;
        }
        else
        {
            mapCoord = currentMapCoord;
        }
        NSDictionary * dic = @{@"mapid":@(mapCoord.mapID).stringValue, @"groupID":@(mapCoord.coord.storey).stringValue,@"isNeedLocate":@(![FMLocationManager shareLocationManager].isCallingService)};
        [self enterIndoorByIndoorInfo:dic];
    }
    
}
- (void)enableLocationBtnClick:(NSNotification *)noti
{
    if ([noti.object boolValue] == YES) return;
    [self enableLocationInDoor];
}
#pragma mark - ModelInfoPopViewDelegate

- (void)enterIndoorMapBtnClick:(NSString *)modelFid
{
    BOOL isNeedLocate  = NO;
    if ([FMKLocationServiceManager shareLocationServiceManager].currentMapCoord.mapID == modelFid.intValue)
        isNeedLocate = YES;
    else
        isNeedLocate = NO;
    NSString *groupID = @"1";
    if (modelFid.intValue == kDaWangZong || modelFid.intValue == kMuMianA || modelFid.intValue == kMuMianB || modelFid.intValue == KZonglv)
        groupID = @"2";
    
    [self enterIndoorByIndoorInfo:@{@"mapid":modelFid, @"groupID":groupID,@"isNeedLocate":@(isNeedLocate)}];
}
- (void)goHere:(FMKGeoCoord)coord
{
    //开始导航
    [self setEnableLocationBtnFrameByView:self.naviPopView];
    
    FMNaviAnalyserTool * tool = [FMNaviAnalyserTool shareNaviAnalyserTool];
#warning 这里需要处理区分是否有定位点信息
    FMKMapCoord startMapCoord = [self getDefaultMapCoord];//[FMKLocationServiceManager shareLocationServiceManager].currentMapCoord;
    FMKMapCoord endMapCoord = FMKMapCoordMake(kOutdoorMapID, coord);
    //路径规划
    BOOL naviSuccess = [tool naviAnalyseByStartMapCoord:startMapCoord endMapCoord:endMapCoord];
    //	tool.planNavi = YES;
    [self.naviPopView setTimeByLength:tool.naviLength];
    if (naviSuccess)
    {
        _isFirstLocate = YES;
        [self.naviPopView show];
        //        [self.inforView show];
        //		[self.modelInfoPopView hide];
        NSArray * naviResults = tool.naviResult[@(kOutdoorMapID).stringValue];
        [self drawSingleLineByNaviResult:naviResults containStartAndEnd:YES];
    }
    else
    {
        [self showProgressWithText:@"路径规划失败"];
    }
    
    __weak FMView * wSelf = self;
    //开始导航
    self.naviPopView.startNaviBlock = ^{
        if (naviSuccess) {
            [wSelf startNaviAct];
        }
    };
    
    [UIView animateWithDuration:0.3f animations:^{
        CGRect rect = _enableLocateBtn.frame;
        _enableLocateBtn.frame = CGRectMake(rect.origin.x, kScreenHeight-kNaviPopViewHeight-rect.size.height-5, rect.size.width, rect.size.height);
    }];
    
    //停止导航
    self.naviTopView.stopNaviBlock = ^{
        [wSelf showAlertView];
    };
}
#pragma mark- switchMapInfoViewDelegate

- (void)switchMapInfoBtnClick
{
    FMKMapCoord currentMapCoord = [FMKLocationServiceManager shareLocationServiceManager].currentMapCoord;
    [self switchToIndoorMapAtNaviByMapCoord:currentMapCoord];
    [self.switchMapInfoView hide];
    _lastSetupMapID = 0;
}
- (void)setupSwitchMapInfoView:(BOOL)isCurrentMap currentMapCoord:(FMKMapCoord)currentMapCoord
{
    if (isCurrentMap)
    {
        if (!self.switchMapInfoView.hidden)
        {
            [self.switchMapInfoView hide];
        }
    }
    else
    {
        if (currentMapCoord.mapID != _lastSetupMapID)
        {
            NSString * mapName = [self getMapNameByMapID:currentMapCoord.mapID];
            self.switchMapInfoView.switchMapInfoLabel.text = [NSString stringWithFormat:@"准备切换到%@",mapName];
            [self.switchMapInfoView show];
            _lastSetupMapID = currentMapCoord.mapID;
        }
    }
}
//获取地图名称
- (NSString *)getMapNameByMapID:(int)mapID
{
    NSString * mapName;
    switch (mapID) {
        case 70144:
            mapName = @"国际会展中心";
            break;
        case 70145:
            mapName = @"椰林酒店";
            break;
        case 70146:
            mapName = @"棕榈酒店";
            break;
        case 70147:
            mapName = @"木棉酒店A";
            break;
        case 79981:
            mapName = @"皇后棕/大王棕酒店";
            break;
        case 70148:
            mapName = @"木棉酒店B";
            break;
        case 79982:
            mapName = @"菩提酒店";
            break;
        default:
            break;
    }
    return mapName;
}
//回到我的位置
- (void)locateMyPosition
{
    FMKMapCoord currentMapCoord = [FMKLocationServiceManager shareLocationServiceManager].currentMapCoord;
    if (currentMapCoord.mapID == kOutdoorMapID)
    {
        [FMKLocationServiceManager shareLocationServiceManager].delegate = self;
    }
    else
    {
        [FMKLocationServiceManager shareLocationServiceManager].delegate = nil;
        NSDictionary * dic = @{@"mapid":@(currentMapCoord.mapID).stringValue, @"groupID":@(currentMapCoord.coord.storey).stringValue,@"isNeedLocate":@(![FMLocationManager shareLocationManager].isCallingService)};
        [self enterIndoorByIndoorInfo:dic];
    }
}
- (FMKMapCoord)getDefaultMapCoord
{
    FMKMapStorey mapStorey = 1;
    FMKMapPoint mapPoint = FMKMapPointMake(1.21884255544187E7, 2071275.90186538);
    FMKGeoCoord geoCoord = FMKGeoCoordMake(mapStorey, mapPoint);
    FMKMapCoord mapsCoord = FMKMapCoordMake(79980, geoCoord);
    return mapsCoord;
}

#pragma mark - Navi and UI

//计算导航约束的地图坐标点
- (FMKNaviContraintResult)naviConstraintWithMapCoord:(FMKMapCoord)mapCoord
{
	FMKNaviContraintResult naviResult;
	if (!_isFirstLocate)
	{
		[self.naviTopView show];
		naviResult = [self.naviContraint naviContraintByLastPoint:_lastMapPoint currentMapPoint:mapCoord.coord.mapPoint];
		_lastMapPoint = naviResult.mapPoint;
		[_locationMarker locateWithGeoCoord:FMKGeoCoordMake(mapCoord.coord.storey, naviResult.mapPoint)];
//		[self.fengMapView moveToViewCenterByMapCoord:mapCoord.coord];
	}
	else
	{
		_locationMarker.hidden = NO;
		_lastMapPoint = mapCoord.coord.mapPoint;
	}
	return naviResult;
}
//计算剩余路程并更新UI
- (void)calSurplusLengthAndUpdateTopViewWithNaviConstraint:(FMKNaviContraintResult)naviResult
{
	FMKMapCoord mapCoord = FMKMapCoordMake(kOutdoorMapID, FMKGeoCoordMake(1, naviResult.mapPoint));
	double surplusLength = [[FMNaviAnalyserTool shareNaviAnalyserTool] calSurplusLengthByMapCoord:mapCoord index:naviResult.index];
	
	if (surplusLength<10.0) {
		[self showProgressWithText:@"您已到达目的地附近"];
		[self stopNavi];
        _showChangMap = NO;
	}
	[self.naviTopView updateLength:surplusLength];
}
//计划导航
- (void)planNaviAct
{
    FMNaviAnalyserTool * tool = [FMNaviAnalyserTool shareNaviAnalyserTool];
    
    if (tool.planNavi)
    {
        [self stopNavi];
        //		[self.naviPopView.endPointBtn setTitle:tool.endName forState:UIControlStateNormal];
        
        [self startNaviAct];
    }
}
- (void)startNaviAct
{
    [self stopNavi];
    FMNaviAnalyserTool * tool = [FMNaviAnalyserTool shareNaviAnalyserTool];
#warning 这里需要区分是否可以拿到定位信息
    FMKMapCoord currentMapCoord = [self getDefaultMapCoord];//[FMKLocationServiceManager shareLocationServiceManager].currentMapCoord;
    
    BOOL naviResult = [tool naviAnalyseByStartMapCoord:currentMapCoord endMapCoord:tool.endMapCoord];
    if (!naviResult) return;
    
    [[self getCurrentController] showMangroveIcon:NO];
    [self.fengMapView inclineWithAngle:90.0f];
    double totalLength = tool.naviLength;
    tool.hasStartNavi = YES;
    tool.planNavi = NO;
    [self.naviPopView setTimeByLength:totalLength];
    [self.naviTopView updateLength:totalLength];
    
    [self.naviPopView hide];//隐藏模型信息弹框
    [self.inforView hide];
    //	[self.modelInfoPopView hide];
    [self.naviTopView show];
    [self setEnableLocationBtnFrameByView:nil];
    //计划导航状态下画线
    NSArray * naviResults = tool.naviResult[@(kOutdoorMapID).stringValue];
    [self drawSingleLineByNaviResult:naviResults containStartAndEnd:YES];
    [self hideNaviBar:YES];
    [self locateMyPosition];//回到我的位置
    [self.switchMapInfoView hide];
    //	_enableLocateBtn.hidden = YES;
}
//添加起点和终点图标
- (void)addLocationImageMarker:(FMKGeoCoord)coord isStart:(BOOL)isStart
{
    if (isStart) {
        FMKImageMarker * startImageMarker = [[FMKImageMarker alloc] initWithImage:[UIImage imageNamed:@"query_location_icon_oth"] Coord:coord.mapPoint];
        [_imageLayer addImageMarker:startImageMarker animated:NO];
    }
    else
    {
        FMKImageMarker * endImageMarker = [[FMKImageMarker alloc] initWithImage:[UIImage imageNamed:@"query_location_icon_oth"] Coord:coord.mapPoint];
        [_imageLayer addImageMarker:endImageMarker animated:NO];
    }
}
- (void)stopNavi
{
    [self hideNaviBar:NO];
    [_imageLayer removeAllImageMarker];
    [FMNaviAnalyserTool shareNaviAnalyserTool].hasStartNavi = NO;
    [FMNaviAnalyserTool shareNaviAnalyserTool].planNavi = NO;
    [self.fengMapView.map.lineLayer removeAllLine];
    [FMNaviAnalyserTool shareNaviAnalyserTool].naviResult = nil;
    [self.naviTopView hide];
    [[self getCurrentController] showMangroveIcon:YES];
    [self exit2DMode];//退出2D模式
    _enableLocateBtn.hidden = NO;
    FMKExternalModelLayer * modelLayer = [self.fengMapView.map getExternalModelLayerWithGroupID:@"1"];
    modelLayer.delegate = self;
    [[self getCurrentController].centerVC changNavViewStyleByLayerMode:NAVIVARTYPE_OUT];
    
}
//地图进入导航模式
- (void)mapEnterNaviMode
{
    [self.fengMapView inclineWithAngle:90.0];
    [self.naviPopView hide];
    [self.inforView hide];
    [self.naviTopView show];
    //	[self.modelInfoPopView hide];
    [self hideNaviBar:YES];
    _isFirstLocate = YES;
    [self setEnableLocationBtnFrameByView:nil];
    FMNaviAnalyserTool * tool = [FMNaviAnalyserTool shareNaviAnalyserTool];
    NSArray * naviResults = tool.naviResult[@(kOutdoorMapID).stringValue];
    if (naviResults.count>0)
    {
        [self drawSingleLineByNaviResult:naviResults containStartAndEnd:YES];
    }
}
//初始化导航约束对象
- (void)updateConstraintData
{
	if (!self.naviContraint) {
		self.naviContraint = [[FMKNaviContraint alloc] initWithMapPath:_mapPath];
	}
	FMKNaviResult * naviResult = [FMNaviAnalyserTool shareNaviAnalyserTool].naviResult[@(kOutdoorMapID).stringValue][0];
	[self.naviContraint updateNaviConstraintDataWith:naviResult.pointArray groupID:@"1"];
}
- (void)showAlertView
{
    UIAlertController * alertView = [UIAlertController alertControllerWithTitle:@"确认退出导航" message:nil preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(self)wSelf = self;
    [alertView addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [wSelf.naviTopView hide];
        [wSelf stopNavi];
        _showChangMap = NO;
    }]];
    [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [[self getCurrentController] presentViewController:alertView animated:YES completion:nil];
}
#pragma  mark - drawLine

- (void)drawSingleLineByNaviResult:(NSArray *)result containStartAndEnd:(BOOL)containt
{
    [_fengMapView.map.lineLayer removeAllLine];
    
    FMKLineMarker * lineMarker = [[FMKLineMarker alloc] init];
    
    for (FMKNaviResult * naviResult in result) {
        NSMutableArray * points = [NSMutableArray array];
        [points addObjectsFromArray:naviResult.pointArray];
        if (!containt) {
            [points removeObject:points.firstObject];
            [points removeObject:points.lastObject];
        }
        
        FMKSegment * segment = [[FMKSegment alloc] initWithGroupID:naviResult.groupID pointArray:points];
        [lineMarker addSegment:segment];
        [self.fengMapView refreshViewRangeByMapPoints:naviResult.pointArray	onGroup:naviResult.groupID];
    }
    lineMarker.mode = FMKLINE_PLANE;
    lineMarker.type = FMKLINE_TEXTURE_MIX;
    lineMarker.width = 2.0f;
    lineMarker.color = [UIColor blueColor];
    
    lineMarker.imageName = @"jiantou.png";
    [self.fengMapView.map.lineLayer addLineMarker:lineMarker];
}

//路线上添加图片
- (void)addImageOnRouteByMapPoints:(NSArray *)mapPoints
{
    [_imageLayer removeAllImageMarker];
    for ( int i = 0; i<mapPoints.count; i++) {
        NSValue * pointValue = mapPoints[i];
        FMKMapPoint mapPoint = [pointValue FMKMapPointValue];
        UIImage * image = [UIImage addNumberText:@(i+1).stringValue];
        
        FMKImageMarker * imageMarker = [[FMKImageMarker alloc] initWithImage:image Coord:mapPoint];
        imageMarker.offsetMode = FMKImageMarker_USERDEFINE;
        imageMarker.imageOffset = 10.0f;
        imageMarker.nodeTag = i+1;
        [_imageLayer addImageMarker:imageMarker animated:NO];
    }
}

#pragma mark - SWitch Map
//导航模式下切换地图
- (void)switchToIndoorMapAtNaviByMapCoord:(FMKMapCoord)mapCoord
{
	NSArray * allMapIDs = [[FMNaviAnalyserTool shareNaviAnalyserTool].naviResult allKeys];
	for (NSString * mapID in allMapIDs) {
		if ([mapID isEqualToString:@(mapCoord.mapID).stringValue])
        {
            for (UIViewController *VC in [self getCurrentController].navigationController.viewControllers)
            {
                if ([VC isKindOfClass:[FMIndoorMapVC class]])
                {
                    FMIndoorMapVC *FMvc = (FMIndoorMapVC *)VC;
                    FMvc.mapID = @(mapCoord.mapID).stringValue;
                    FMvc.displayGroupID = @(mapCoord.coord.storey).stringValue;
                    FMvc.isNeedLocate = YES;
                    [[self getCurrentController].navigationController pushViewController:FMvc animated:YES];
                    [FMKLocationServiceManager shareLocationServiceManager].delegate = nil;
                }
                break;
            }
            
			FMIndoorMapVC * indoorVC = [[FMIndoorMapVC alloc] initWithMapID:@(mapCoord.mapID).stringValue];
			indoorVC.isNeedLocate = YES;
			indoorVC.displayGroupID = @(mapCoord.coord.storey).stringValue;
			[[self getCurrentController].navigationController pushViewController:indoorVC animated:YES];
			[FMKLocationServiceManager shareLocationServiceManager].delegate = nil;
			break;
		}
	}
}

- (void)switchToIndoorOrUpdateLocationMarkerByMapCoord:(FMKMapCoord)mapCoord
{
	if (mapCoord.mapID != kOutdoorMapID && mapCoord.mapID != _cancelMapID.intValue)
	{
//		BOOL indoorMapIsExist = [self testIndoorMapIsxistByMapCoord:mapCoord];
//		if (indoorMapIsExist)
//		{
//            self.currentMapCoord = mapCoord;
//            self.showChangMap = YES;
//		}
	}
	else
	{
//		_locationMarker.hidden = NO;
//        [_locationMarker locateWithGeoCoord:mapsCoord.coord];
#warning 这里需要区分是否有定位信息
        [_locationMarker locateWithGeoCoord:[self getDefaultMapCoord].coord];
        // 现场使用的方法
//		[_locationMarker locateWithGeoCoord:mapCoord.coord];
         
	}
}

- (void)setShowChangMap:(BOOL)showChangMap
{
    if (_showChangMap != showChangMap)
    {
        _showChangMap = showChangMap;
        BOOL show = [[NSUserDefaults standardUserDefaults] boolForKey:@"OPENMAP"];
        BOOL inDoorMap = [[NSUserDefaults standardUserDefaults] boolForKey:@"inDoorMap"];

        if (_showChangMap == YES && show == YES)
        {
			__weak typeof(self)wSelf = self;
            wSelf.alertView = [UIAlertController alertControllerWithTitle:@"是否回到您当前所处位置" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                       {
                                           [self enterIndoorMapBy:self.currentMapCoord];
                                       }];
            
            UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                wSelf.cancelMapID = @(wSelf.currentMapCoord.mapID).stringValue;

            }];
            
            [self.alertView addAction:action1];
            [self.alertView addAction:action2];
            if (inDoorMap == NO)
            {
                [[self getCurrentController] presentViewController:self.alertView animated:YES completion:^{
                    
                }];
            }
        }
        else
        {
            [self enterIndoorMapBy:self.currentMapCoord];
        }
    }
}

- (void)enterIndoorMapBy:(FMKMapCoord)mapCoord
{
    FMIndoorMapVC * indoorMapVC = [[FMIndoorMapVC alloc] initWithMapID:@(self.currentMapCoord.mapID).stringValue];
    indoorMapVC.displayGroupID = @(self.currentMapCoord.coord.storey).stringValue;
    indoorMapVC.isNeedLocate = YES;
    [FMKLocationServiceManager shareLocationServiceManager].delegate = nil;
    _showChangMap = NO;
    [[self getCurrentController].navigationController pushViewController:indoorMapVC animated:YES];
    _showChangMap = YES;
}

- (void)enterIndoorByIndoorInfo:(NSDictionary * )dic
{
    FMKMapCoord currentMapCoord = [FMKLocationServiceManager shareLocationServiceManager].currentMapCoord;
    
    NSString * mapID = dic[@"mapid"];
    NSString * groupID = dic[@"groupID"];
    BOOL isNeedLocate = [dic[@"isNeedLocate"] boolValue];
    
    
    if (currentMapCoord.mapID == mapID.intValue) {
        isNeedLocate = YES;
    }
    else
    {
        isNeedLocate = isNeedLocate;
    }
    // 在界面跳转时isNeedLocate＝ NO 不需要代理
    //    if (isNeedLocate == NO)
    [FMKLocationServiceManager shareLocationServiceManager].delegate = nil;
    
    BOOL indoorMapIDIsExist = [self testIndoorMapIsxistByMapCoord:mapID.intValue];
    if (indoorMapIDIsExist)
    {
        MBProgressHUD *HUD =[MBProgressHUD showHUDAddedTo:[AppDelegate sharedDelegate].window animated:YES];
        HUD.labelText = @"正在加载地图，请稍等";
        [HUD show:YES];
        for (UIViewController *VC in [self getCurrentController].navigationController.viewControllers)
        {
            if ([VC isKindOfClass:[FMIndoorMapVC class]])
            {
                FMIndoorMapVC *FMvc = (FMIndoorMapVC *)VC;
                FMvc.mapID = mapID;
                FMvc.displayGroupID = groupID;
                FMvc.isNeedLocate = isNeedLocate;
                [[self getCurrentController].navigationController pushViewController:VC animated:YES];
            }
            break;
        }
        
        FMIndoorMapVC * VC = [[FMIndoorMapVC alloc] initWithMapID:mapID];
        VC.displayGroupID = groupID;
        VC.isNeedLocate = isNeedLocate;
        [[self getCurrentController].navigationController pushViewController:VC animated:YES];
    }
}

#pragma mark - FMKSearchAnalyserDelegate

- (void)onExternalModelSearchDone:(FMKExternalModelSearchRequest *)request result:(NSArray *)resultArray
{
    if (resultArray.count > 0)
	{
        FMKExternalModelSearchResult *result = resultArray[0];
        
        FMKImageLayer *layer = [[FMKImageLayer alloc] initWithGroupID:result.groupID];
//        layer.delegate = self;
        [self.fengMapView.map addLayer:layer];
        FMKImageMarker *marker = [[FMKImageMarker alloc] initWithImage:[UIImage imageNamed:@"query_location_icon_nor"] Coord:result.centerCoord];
        marker.imageSize = CGSizeMake(25, 25);
        marker.offsetMode = FMKImageMarker_MODELTOP;
        [layer addImageMarker:marker animated:YES];
    }
}

#pragma mark - MyMethod

- (void)didSelectedEnd:(FMKExternalModel *)model
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NotiCloseTopAlert object:nil];
    [self.naviPopView show];
    NSLog(@"%@",model.fid);
    NSString *name = @"";
    if (self.queryModel.name == nil||[self.queryModel.name isEqualToString:@""])
        name = model.name;
    else
        name = self.queryModel.name;
    self.queryModel = nil;
    QueryDBModel *models = [[DBSearchTool shareDBSearchTool] queryModelByFid:model.fid andName:name];
    
    [self.naviPopView setupInfoByModel:model];
    
    if (models.activityCode != NULL && ![models.activityCode isEqualToString:@""])
    {
        [self.inforView showByView:self.naviPopView];
        [self.inforView requsrtActivityInforByActivityCode:models.activityCode];
    }else
    {
        [self.inforView hide];
    }
    
    //	[self.naviPopView.endPointBtn setTitle:model.name forState:UIControlStateNormal];
    //	[self.modelInfoPopView show];
    
    //	[self setEnableLocationBtnFrameByView:self.modelInfoPopView];
    [self goHere:model.mapCoord];
    if (_categoryTag != -1) {
        if (!model.highlight) {
            if (_highlightModel) {
                FMActivity * oldActivity = [self queryActicityByFid:_highlightModel.fid];
                [self.fengMapView hiddenActivityListOnMap:@[oldActivity]];
                //				[self.fengMapView showActivityListOnMap:@[oldActivity]];
            }
            [self highlightActivityByModel:model];
        }
    }
    else
    {
        if (_highlightModel) {
            FMActivity * oldActivity = [self queryActicityByFid:_highlightModel.fid];
            if (oldActivity)
            {
                [self.fengMapView hiddenActivityListOnMap:@[oldActivity]];
            }
            
        }
        [self highlightActivityByModel:model];
    }
}
- (void)highlightActivityByModel:(FMKExternalModel * )model
{
    FMActivity * activity = [self queryActicityByFid:model.fid];
    [self.fengMapView highlightActivityOnMapCenter:activity];
    _highlightModel = model;
}
- (FMActivity *)queryActicityByFid:(NSString *)fid
{
    NSArray * acts = [FMParserJsonData parserActs];
    for (FMActivity * activity in acts) {
        if ([activity.fmap_fid isEqualToString:fid]) {
            return activity;
        }
    }
    FMActivity * activity = [[FMActivity alloc] init];
    activity.fmap_fid = fid;
    return activity;
}
//判断室内地图是否存在
- (BOOL)testIndoorMapIsxistByMapCoord:(int)mapID
{
    NSArray * indoorMapIDs = @[@"70144",@"70145",@"70146",@"70147",@"70148",@"79982",@"79981"];
    BOOL indootMapIsExist = NO;
    for (NSString * indoorMapID in indoorMapIDs) {
        if (indoorMapID.intValue == mapID) {
            indootMapIsExist = YES;
            break;
        }
    }
    return indootMapIsExist;
}
- (void)hideNaviBar:(BOOL)hide
{
    // 双层导航栏的问题需要隐藏两个层
    [[self getCurrentController].centerVC.navigationController setNavigationBarHidden:hide animated:YES];
    [[self getCurrentController].navigationController setNavigationBarHidden:hide animated:YES];
}
- (void)hideNavView
{
    //    [self.modelInfoPopView hide];
    [self.routeDisplayView hide];
    [self.naviPopView hide];
    [self.inforView hide];
}

#pragma mark - Activity Category

- (void)setCategoryTag:(int)categoryTag
{
	if (_categoryTag != categoryTag)
	{
		_categoryTag = categoryTag;
		[self showCategoryByTag:_categoryTag];
	}
	else
	{
		[self hiddenCategoryByTag:_categoryTag];
		_categoryTag = NSNotFound;
	}
}
- (void)showCategoryByTag:(int)tag
{
	[self.fengMapView showAllOnMap];
	[self hiddenRoute];
	switch (tag) {
		case 100://设施
		{
			NSString * serviceJsonPath = [[NSBundle mainBundle] pathForResource:@"facility.json" ofType:nil];
			[self showActivitiesByJsonPath:serviceJsonPath];
		}
			break;
		case 101://购物
		{
			NSString * serviceJsonPath = [[NSBundle mainBundle] pathForResource:@"shop.json" ofType:nil];
			[self showActivitiesByJsonPath:serviceJsonPath];
		}
			break;
		case 102://美食
		{
			NSString * serviceJsonPath = [[NSBundle mainBundle] pathForResource:@"food.json" ofType:nil];
			[self showActivitiesByJsonPath:serviceJsonPath];
		}
			break;
		case 103://路线
		{
			[self showRoute];
			NSArray * activities = [self queryActivityByActivityCodes:[self route].activity_code_list];
			[self addRouteDisplayViewByActivities:activities];
		}
			break;
		case 104://区域
		{
//			[self queryModel];
//			[self.fengMapView showActivityListOnMap:_models];
		}
			break;
		default:
			break;
	}
}
- (void)hiddenCategoryByTag:(int)tag
{
	switch (tag) {
		case 100://设施
		{
			NSString * serviceJsonPath = [[NSBundle mainBundle] pathForResource:@"facility.json" ofType:nil];
			[self hiddenActivitiesByJsonPath:serviceJsonPath];
		}
			
			break;
		case 101://购物
		{
			NSString * serviceJsonPath = [[NSBundle mainBundle] pathForResource:@"shop.json" ofType:nil];
			[self hiddenActivitiesByJsonPath:serviceJsonPath];
		}
			
			break;
		case 102://美食
		{
			NSString * serviceJsonPath = [[NSBundle mainBundle] pathForResource:@"food.json" ofType:nil];
			[self hiddenActivitiesByJsonPath:serviceJsonPath];
		}
			
			break;
		case 103://路线
		{
			[self hiddenRoute];
			_routeDisplayView.alpha = 0.0f;
		}
			
			break;
		case 104://区域
		{
//			[self.fengMapView hiddenActivityListOnMap:_models];
		}
			break;
		default:
			break;
	}
}
#pragma mark -  Test
//获取测试路线数据
- (FMRoute *)route
{
	NSString * jsonPath = [[NSBundle mainBundle] pathForResource:@"shop1.json" ofType:nil];
	NSData * data = [NSData dataWithContentsOfFile:jsonPath];
	NSDictionary * dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
	FMRoute * route = [[FMRoute alloc] init];
	route.route_code = dictionary[@"route_code"];
	route.activity_code_list = dictionary[@"activity_code_list"];
	route.route_points = dictionary[@"route_points"];
	return route;
}
//hidden 路线
- (void)hiddenRoute
{
	[self.fengMapView hiddenRoute:[self route]];
}
//show  路线
- (void)showRoute
{
	[self.fengMapView showRouteOnMap:[self route]];
}
- (void)hideRouteDisplayView
{
    [self.routeDisplayView hide];
}

- (void)showRouteDisplayView
{
    [self.routeDisplayView show];
}

- (void)showActivitiesByJsonPath:(NSString *)jsonPath
{
	NSArray * acts = [self getActivitiesByJsonPath:jsonPath];
	[self.fengMapView showActivityListOnMap:acts];
}

- (NSArray <FMActivity *>*)queryActivityByActivityCodes:(NSArray *)activityCodes
{
	NSMutableArray * activities = [NSMutableArray arrayWithCapacity:activityCodes.count];
	NSArray * acts = [FMParserJsonData parserActs];
	for (NSString * activityCode in activityCodes)
	{
		for (FMActivity * activity in acts)
		{
			if ([activity.activity_code isEqualToString:activityCode])
			{
				[activities addObject:activity];
			}
		}
	}
	return activities;
}

- (void)addRouteDisplayViewByActivities:(NSArray *)activities
{
	NSMutableArray * names = [NSMutableArray arrayWithCapacity:activities.count];
	for (FMActivity * activity in activities)
	{
		[names addObject:activity.activity_name];
	}
	_routeDisplayView.alpha = 1.0f;
	[_routeDisplayView addNumberLineViewByActivityNames:names];
	
	FMRoute * route = [self route];
	__weak typeof(self) wSelf = self;
	_routeDisplayView.selectedPointIndex = ^(int index)
	{
		[wSelf.fengMapView zoomImageMarkerOnRoute:route index:wSelf.oldImageMarkerIndex size:CGSizeMake(30, 30)];
		[wSelf.fengMapView zoomImageMarkerOnRoute:route index:index size:CGSizeMake(50, 50)];
		_oldImageMarkerIndex = index;
	};
}

//隐藏activity
- (void)hiddenActivitiesByJsonPath:(NSString *)jsonPath
{
	NSArray * acts = [self getActivitiesByJsonPath:jsonPath];
	[self.fengMapView hiddenActivityListOnMap:acts];
}

//根据json获取activity
- (NSArray *)getActivitiesByJsonPath:(NSString *)jsonPath
{
	NSArray * codes = [self parserJsonDataByPath:jsonPath];
	NSMutableArray * acts = [NSMutableArray arrayWithCapacity:codes.count];
	NSArray * activities = [FMParserJsonData parserActs];
	for (NSString *code in codes)
	{
		for (FMActivity * act in activities) {
			if ([act.activity_code isEqualToString:code]) {
				[acts addObject:act];
			}
		}
	}
	return acts;
}

//获取json中的code_list
- (NSArray *)parserJsonDataByPath:(NSString *)jsonPath
{
	NSData * data = [[NSData alloc] initWithContentsOfFile:jsonPath];
	NSError * error = nil;
	NSDictionary * dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
	if (!error) return dictionary[@"activity_code_list"];
	return nil;
}


- (void)sceneMoveToViewCenterAnimatorFromPoint:(CGPoint)currentPoint withDurationTime:(NSTimeInterval)durationTime
{
	FMKSceneAnimator * sceneAnimator = [[FMKSceneAnimator alloc] initWithMapView:self.fengMapView withDurationTime:durationTime];
	
	[sceneAnimator moveWithStart:currentPoint withEnd:self.center];
	[sceneAnimator startAnimation];
}

#pragma mark - 暂未使用的方法

- (void)setModelSelected:(FMKExternalModel *)model inLayer:(FMKExternalModelLayer *)externalModelLayer
{
	NSArray * arr = [self getPoisByModel:model];
	
	NSNotification *notification =[NSNotification notificationWithName:FMModelSelected object:nil userInfo:@{@"poiNames":arr,@"modelName":model.name}];
	
	//通过通知中心发送通知
	[[NSNotificationCenter defaultCenter] postNotification:notification];
	
	//设置高亮	
//	[self.nodeAssociation setHighlightByExternalModel:model highlight:YES];
	
	[self.showList removeObject:model];
}

//获取随机坐标点
- (FMKMapPoint)getRandomMapPoint
{
	FMKDegrees minX = self.fengMapView.map.info.minX;
	FMKDegrees minY = self.fengMapView.map.info.minY;
	FMKDegrees maxX = self.fengMapView.map.info.maxX;
	FMKDegrees maxY = self.fengMapView.map.info.maxY;
	double offsetX = maxX - minX;
	double offsetY = maxY - minY;
	FMKMapPoint point;
	point.x = (((float)rand() / RAND_MAX) * offsetX) + minX;
	point.y = (((float)rand() / RAND_MAX) * offsetY) + minY;
	return point;
}

//在这里调用蒙版效果
- (void)setType:(ButtonType)type
{
	_type = type;
	[self showExternalModel];
}

- (void)addRouteView
{
	if (!self.routeDisplayView) {
		self.routeDisplayView = [RouteDisplayView routeDisplayView];
		self.routeDisplayView.frame = CGRectMake(0, kScreenHeight-kRouteViewHeight, kScreenWidth, kRouteViewHeight);
		[self addSubview:self.routeDisplayView];
	}
	
	__weak FMView * wSelf = self;
	__weak FMKImageLayer * imageLayer = _imageLayer;
	
	//选择路线
	self.routeDisplayView.routeSelectedBlock = ^{
		[imageLayer removeAllImageMarker];
	};
	
	self.routeDisplayView.returnRouteNaviResult = ^(NSArray * naviResult, NSArray * points)
	{
		[wSelf drawSingleLineByNaviResult:naviResult containStartAndEnd:NO];
		[wSelf addImageOnRouteByMapPoints:points];
	};
	
	self.routeDisplayView.selectedPointIndex = ^(int index){
		for (FMKImageMarker * imageMarker in imageLayer.subNodes) {
			imageMarker.imageSize = CGSizeMake(30, 30);
			if (imageMarker.nodeTag-1 == index) {
				imageMarker.imageSize = CGSizeMake(50, 50);
			}
		}
	};
}

- (void)dealloc
{
	for (NSString * groupID in self.fengMapView.groupIDs)
	{
		FMKModelLayer * modelLayer = [self.fengMapView.map getModelLayerWithGroupID:groupID];
		modelLayer.delegate = nil;
		FMKExternalModelLayer * layer = [self.fengMapView.map getExternalModelLayerWithGroupID:groupID];
		layer.delegate = nil;
	}
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[FMKLocationServiceManager shareLocationServiceManager].delegate = nil;
	self.fengMapView.delegate = nil;
    [FMNaviAnalyserTool shareNaviAnalyserTool].hasStartNavi = NO;
    [FMNaviAnalyserTool shareNaviAnalyserTool].planNavi = NO;
	[self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
	
	NSLog(@"fmview dealloc");
}


@end
