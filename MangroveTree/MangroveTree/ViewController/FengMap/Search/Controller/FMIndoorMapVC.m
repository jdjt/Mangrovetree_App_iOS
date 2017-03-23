//
//  FMIndoorMapVC.m
//  mgmanager
//
//  Created by fengmap on 16/7/8.
//  Copyright © 2016年 Beijing Century Union. All rights reserved.
//

#import "FMIndoorMapVC.h"
#import "FMMapKit.h"

#import "ParserJsondata.h"
#import "FMKGeometry.h"
#import "ChooseFloorScrollView.h"

#import "DevicePositionInfo.h"

#import "FMKNaviContraint.h"

#import "FMIndoorMapVC+Navi.h"

#import "QueryDBModel.h"
#import "DBSearchTool.h"

#import "MapSearchViewController.h"

#import "FMNaviAnalyserTool.h"
#import "MBProgressHUD.h"
#import "FMIndoorMapVC+Navi.h"
#import "UIView+TransitionAnimation.h"

#import "MapViewController.h"
#import "FrameViewController.h"
#import "SwitchMapInfoView.h"

#define DEBUG_ONLINE 0

NSString * const dimians01 = @"999800170";
NSString * const dimians02 = @"999800171";
NSString * const treeTypes = @"100000";

int const kCallingServiceCount = 5;

@interface FMIndoorMapVC () <FMKMapViewDelegate,ChooseFloorScrollViewDelegate,FMKLocationServiceDelegate,FMKLayerDelegate,FMKNaviAnalyserDelegate,FMKLocationServiceManagerDelegate,FMLocationManagerDelegate,SwitchMapInfoBtnDelegate,NaviPopViewDelegate>
{
	ChooseFloorScrollView * _chooseFloorScrollView;//选择楼层视图

	NSString * _locateGroupID;//定位楼层ID
	
	FMKNaviContraint * _naviConstraint;//导航约束对象
	FMKMapPoint _lastMapPoint;//上一次定位位置
	
	NSString * _mapPath;//地图数据路径
	NSString * _cancelMapID;//取消切换的地图ID
    
    int _callingServiceMapID;//双点服务下的地图ID
	
	int _lastSetupMapID;//导航模式下
    
    FMKModel * _highlightModel;//选中的模型
}
@property (nonatomic, strong) FMMangroveMapView * mapView;
@property (nonatomic, strong) FMKNaviAnalyser * naviAnalyser;//路径规划分析对象

@property (nonatomic, strong) NSArray * naviResults;//路径规划结果

@property (nonatomic, copy) NSString * cancelGroupID;//取消的楼层ID

@property (nonatomic, assign) BOOL resultDistance;
@property (nonatomic, assign) FMKMapCoord currentMapCoord;
@property (nonatomic, assign) BOOL showChangeMap;

@property (nonatomic, strong) FMKLocationMarker * locationMarker;//定位标注物
@property (nonatomic, assign) BOOL alertIsExist;//弹框已经存在

@property (nonatomic, assign) BOOL isFirstLocate;//第一次定位
@property (nonatomic, assign) BOOL moveMapToCenter;
@property (nonatomic, assign) int callingServiceCount;//双点服务下初次判断定位次数
@property (nonatomic, strong) UITextView *textView;

@end

@implementation FMIndoorMapVC

@synthesize displayGroupID = _displayGroupID;

- (instancetype)initWithMapID:(NSString *)mapID
{
	if (self = [super init]) {
		_mapID = mapID;
	}
	return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	NSLog(@"室内地图析构");
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hideMavBar:[FMNaviAnalyserTool shareNaviAnalyserTool].hasStartNavi];
    [[NSNotificationCenter defaultCenter] postNotificationName:NotiHideCallView object:@([FMNaviAnalyserTool shareNaviAnalyserTool].hasStartNavi)];
    
    for (UIViewController *VC in self.navigationController.viewControllers)
    {
        if ([VC isKindOfClass:[MapViewController class]])
        {
            MapViewController *mapVC = (MapViewController *)VC;
            if ([mapVC.centerVC.navigationItem.leftBarButtonItem.title isEqualToString:@"取消"])
            {
                [mapVC.centerVC showCallResult:YES];
            }
            [mapVC.centerVC changNavViewStyleByLayerMode:NAVIVARTYPE_IN];
            mapVC.centerVC.navigationController.navigationBar.hidden = NO;
            self.navigationController.navigationBar.hidden = YES;
        }
    }
}

- (void)viewDidLoad
{
	[super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"OPENMAP"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"inDoorMap"];
    [FMLocationManager shareLocationManager].delegate = self;
//	[self setupRightBarButtonItem];
	[self addNotifi];//通知消息
}
- (void)viewDidAppear:(BOOL)animated
{
//    [super viewDidAppear:animated];
	if (!self.mapView)
	{
		[self createMapView];//地图
//        [self addEnable3DBtn];//定位开关
		[self addLocationMarker];//定位图标
		[self addNaviPopView];
        self.naviPopView.delegate = self;
		[self addNaviTopView];
//		[self addModelInfoPopView];
        [self addInforView];
		[self createChooseScrollView];//楼层选择视图
		[self addlocateBtn];//添加定位开关
		[self addSwitchMapInfoView];
		self.switchMapInfoView.delegate = self;
		[self initNaviInfo];//初始化路径约束对象
    }
	
	self.displayGroupID = _displayGroupID;
    self.resultDistance = NO;
    self.moveMapToCenter = YES;
    _showChangeMap = NO;
    _enableLocateBtn.hidden = ![FMLocationManager shareLocationManager].isCallingService;
	if (_dbModel) {
		if (_dbModel.mid.intValue != self.mapID.intValue)
		{
			_displayGroupID = @(_dbModel.gid).stringValue;
			//如果模型的mapid与地图不匹配 切换地图
			self.mapID = _dbModel.mid;
			[self switchMap];
			self.mapView.displayGids = @[_displayGroupID];
            [self resetMapPara];
			self.displayGroupID = @(_dbModel.gid).stringValue;
		}
	}
	
//    if (self.isNeedLocate)
//	{
		 [FMKLocationServiceManager shareLocationServiceManager].delegate = self;
//	}
	
    [FMLocationManager shareLocationManager].delegate = self;
    //设置标题
    [self setTitleByMapID:_mapID];
	[self setupNaviPopView];
	
    __weak typeof (self) wSelf = self;
    self.naviTopView.stopNaviBlock = ^{
        [wSelf showAlertView];
    };
	
    //设置主题
    [_mapView setThemeWithLocalPath:[[NSBundle mainBundle] pathForResource:@"2002.theme" ofType:nil]];
	
    //添加搜索结果标注
    [self addPositionMarker];
    if (![FMLocationManager shareLocationManager].isCallingService)
    {
		//当计划导航时 显示起点和终点信息
		[self planNaviAct];
	}
	
    [MBProgressHUD hideAllHUDsForView:[AppDelegate sharedDelegate].window animated:YES];
	
	//导航模式下
	if ([FMNaviAnalyserTool shareNaviAnalyserTool].hasStartNavi) {
		[self.naviPopView hide];
		[self.naviTopView show];
		[self updateLine];
        [self hideMavBar:YES];
	}
    [self resetMapPara];
    
}
//根据fid获取模型
- (FMKModel *)queryModelByFid:(NSString *)fid groupID:(NSString *)groupID
{
	FMKModelLayer * modelLayer = [self.mapView.map getModelLayerWithGroupID:groupID];
	return [modelLayer queryModelByFID:fid];
}

//判断当前是否在计划导航状态并做处理
- (void)planNaviAct
{
	FMNaviAnalyserTool * tool = [FMNaviAnalyserTool shareNaviAnalyserTool];

	if (tool.planNavi)
	{
		//stop后会退出导航状态 影响后续操作
//		[self stopNavi];
		[self setupNaviPopViewInfoByEndName:tool.endName];
		[self.naviPopView setTimeByLength:tool.naviLength];
		[self updateLine];
		[self.naviPopView show];
		[self setEnableLocationBtnFrameByView:self.naviPopView];
	}
}
- (void)viewDidDisappear:(BOOL)animated
{
//    [super viewDidDisappear:animated];
    for (NSString * groupID in _mapView.groupIDs)
	{
        FMKModelLayer * modelLayer = [_mapView.map getModelLayerWithGroupID:groupID];
        modelLayer.delegate = nil;
    }
//    if (self.isNeedLocate == YES)
	[FMKLocationServiceManager shareLocationServiceManager].delegate = nil;
//    [self.modelInfoPopView hide];
//    [self.routeDisplayView hide];
    [self.naviPopView hide];
}
- (void)viewWillDisappear:(BOOL)animated
{
    for (UIViewController *VC in self.navigationController.viewControllers)
    {
        if ([VC isKindOfClass:[MapViewController class]])
        {
            MapViewController *mapVC = (MapViewController *)VC;
            if ([mapVC.centerVC.navigationItem.leftBarButtonItem.title isEqualToString:@"取消"])
            {
                [mapVC.centerVC showCallResult:YES];
            }
            [mapVC.centerVC changNavViewStyleByLayerMode:NAVIVARTYPE_OUT];
        }
    }
    self.navigationController.navigationBar.hidden = NO;
    [super viewWillDisappear:animated];
}

- (void)adddelegateToMap
{
    [FMKLocationServiceManager shareLocationServiceManager].delegate = self;
    self.callingServiceCount = 0;
}

- (void)addNotifi
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNaviResult:) name:kPostNaviResultInfo object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adddelegateToMap) name:@"AddDelegateToMap" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableLocation:) name:NotiCurrentLocation object:nil];

}

//跳转到搜索页面
- (void)transformToSearchViewController
{
	BOOL containSearchVC = NO;
	for (UIViewController * VC in self.navigationController.viewControllers) {
		if ([VC isKindOfClass:[MapSearchViewController class]]) {
			containSearchVC = YES;
			MapSearchViewController * searchVC = (MapSearchViewController *)VC;
			[self.navigationController popToViewController:searchVC animated:YES];
			break;
		}
	}
	if (!containSearchVC)
	{
		MapSearchViewController * vc = [[MapSearchViewController alloc] init];
		[self.navigationController pushViewController:vc animated:YES];
	}
}

- (void)addPositionMarker
{
	if (self.dbModel)
	{
		self.displayGroupID = @(self.dbModel.gid).stringValue;
		if (![self testDisplayGroupIsSameWithWillDisplayGroup:_displayGroupID])
		{
			_mapView.displayGids = @[_displayGroupID];
		}
		
		FMKGeoCoord modelCenter = FMKGeoCoordMake(_dbModel.gid, FMKMapPointMake(_dbModel.x, _dbModel.y));
		[self.mapView moveToViewCenterByMapCoord:modelCenter];
		FMKModel * model = [self queryModelByFid:_dbModel.fid groupID:@(_dbModel.gid).stringValue];
		[self setupModelInfoPopViewByModel:model];
		model.selected = YES;
		[[NSNotificationCenter defaultCenter] postNotificationName:NotiHideCallView object:@(YES)];
		
		NSArray * imageLayers = [_mapView.map getImageLayerWithGroupID:@(self.dbModel.gid).stringValue];
		FMKImageLayer * imageLayer;
		if (imageLayers.count>0) {
			imageLayer = imageLayers.firstObject;
			[imageLayer removeAllImageMarker];
		}
		else
		{
			imageLayer = [[FMKImageLayer alloc] initWithGroupID:@(self.dbModel.gid).stringValue];
			[_mapView.map addLayer:imageLayer];
		}
		
		FMKImageMarker * imageMarker = [[FMKImageMarker alloc] initWithImage:[UIImage imageNamed:@"line_icon_fun"] Coord:FMKMapPointMake(self.dbModel.x, self.dbModel.y)];
		
		[imageLayer addImageMarker:imageMarker animated:NO];
		imageMarker.offsetMode = FMKImageMarker_USERDEFINE;
		imageMarker.imageOffset = self.dbModel.z;
	}
}
//设置导航栏标题
- (NSString *)setTitleByMapID:(NSString *)mapID
{
	NSString * mapName;
	switch (mapID.intValue) {
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

- (void)didUpdatePosition:(FMKMapCoord)mapCoord success:(BOOL)success
{
    
    if (mapCoord.coord.storey != _displayGroupID.intValue)
        _locationMarker.hidden = YES;
    else
        _locationMarker.hidden = NO;
    _enableLocateBtn.hidden = ![FMLocationManager shareLocationManager].isCallingService;
    if ([FMLocationManager shareLocationManager].isCallingService == YES) {
        NSLog(@"开启了双点模式");
        _locationMarker.hidden = YES;
    }

    if(!success) return;
    self.currentMapCoord = mapCoord;
	_locateGroupID = @(mapCoord.coord.storey).stringValue;
    NSLog(@"室内定位回调%@", NSStringFromFMKMapCoord(mapCoord));
    if ([FMLocationManager shareLocationManager].isCallingService == YES) return;
	
	if ([FMNaviAnalyserTool shareNaviAnalyserTool].hasStartNavi)
	{
		if( [self testNaviMapIDIsExistByMapCoord:mapCoord])
		{
			if (mapCoord.mapID != self.mapID.intValue && mapCoord.mapID != kOutdoorMapID)
			{
				if ([self testIndoorMapIsxistByMapCoord:mapCoord])
				{
					[self setupSwitchMapInfoWithCurrentMapCoord:mapCoord];
				}
			}
			//导航状态下直接切换地图
			else if (mapCoord.mapID == kOutdoorMapID)
			{
				[self setupSwitchMapInfoWithCurrentMapCoord:mapCoord];
			}
			else if (mapCoord.coord.storey != _displayGroupID.intValue)
			{
				self.displayGroupID = @(mapCoord.coord.storey).stringValue;
				self.mapView.displayGids = @[@(mapCoord.coord.storey).stringValue];
			}
			else
			{
				self.locationMarker.hidden = NO;
				[self naviConstraintWithMapCoord:mapCoord];
			}
		}
	}
	else
	{
		if (mapCoord.mapID == kOutdoorMapID)
		{
//			[self popToOtherMapByMapCoord:mapCoord];
		}
		//切换楼层 非导航状态下提示切楼层
		else if([self testIndoorMapIsxistByMapCoord:mapCoord])
		{
			if(mapCoord.coord.storey != _displayGroupID.intValue && mapCoord.mapID == self.mapID.integerValue)
			{
//				[self popSwitchFloorViewWithMapCoord:mapCoord];
			}
			else if (mapCoord.mapID != self.mapID.integerValue)
			{
//				[self popToOtherMapByMapCoord:mapCoord];
			}
			else
			{
//				if (_cancelGroupID && mapCoord.coord.storey == _cancelGroupID.intValue)
//				{
//					_cancelGroupID = nil;
//				}
				self.locationMarker.hidden = NO;
				[self pathConstraintAndUpdateByMapCoord:mapCoord];
			}
			
			if (self.moveMapToCenter == YES && [FMKLocationServiceManager shareLocationServiceManager].currentMapCoord.mapID == self.mapID.intValue && mapCoord.coord.storey == _displayGroupID.intValue)
			{
				[self.mapView moveToViewCenterByMapCoord:mapCoord.coord];
				self.moveMapToCenter = NO;
			}
		}
	}
}

//判断室内地图是否存在
- (BOOL)testIndoorMapIsxistByMapCoord:(FMKMapCoord)mapCoord
{
	NSArray * indoorMapIDs = @[@"70144",@"70145",@"70146",@"70147",@"70148",@"79982",@"79981"];
	BOOL indootMapIsExist = NO;
	for (NSString * indoorMapID in indoorMapIDs) {
		if (indoorMapID.intValue == mapCoord.mapID) {
			indootMapIsExist = YES;
			break;
		}
	}
	return indootMapIsExist;
}

//路径约束并更新定位标注物
- (void)pathConstraintAndUpdateByMapCoord:(FMKMapCoord)mapCoord
{
	if (!_naviConstraint)
	{
		_naviConstraint = [[FMKNaviContraint alloc] initWithMapPath:_mapPath];
	}
	if (_isFirstLocate)
	{
		_lastMapPoint = mapCoord.coord.mapPoint;
		[_locationMarker locateWithGeoCoord:mapCoord.coord];
		_isFirstLocate = NO;
	}
	else
	{
		FMKNaviContraintPara para = [_naviConstraint pathContraintWithRoadInfo:_lastMapPoint currentGeoCoord:mapCoord.coord];
		if (para.resultType == FMKCONSTRAINT_SUCCESS)
		{
			[_locationMarker locateWithGeoCoord:FMKGeoCoordMake(mapCoord.coord.storey, para.mapPoint)];
		}
	}
}

//导航状态下导航约束和定位图标更新
- (void)naviConstraintAndUpdateByMapCoord:(FMKMapCoord)mapCoord
{
	//更新导航约束数据
	self.displayGroupID = @(mapCoord.coord.storey).stringValue;
	if (![self testDisplayGroupIsSameWithWillDisplayGroup:self.displayGroupID]) {
		self.mapView.displayGids = @[self.displayGroupID];
	}
	
	[self updateNaviConstraintData];
	FMKNaviContraintResult result = [self naviConstraintWithMapCoord:mapCoord];
	if (result.type == FMKCONSTRAINT_SUCCESS && !_isFirstLocate) {
		[self calSurplusLengthAndUpdateTopViewWithNaviConstraint:result];
	}
	_isFirstLocate = NO;
}

//检查导航状态下当前定位的地图是否在路径规划结果中
- (BOOL)testNaviMapIDIsExistByMapCoord:(FMKMapCoord)mapCoord
{
	BOOL mapIsExist = NO;
	NSArray * allNaviMapIDs = [FMNaviAnalyserTool shareNaviAnalyserTool].naviResult.allKeys;
	for (NSString * mapID in allNaviMapIDs) {
		if ([mapID isEqualToString:@(mapCoord.mapID).stringValue]) {
			mapIsExist = YES;
			break;
		}
	}
	return mapIsExist;
}

//室内切室内
- (void)switchToOtherIndoorByMapCoord:(FMKMapCoord)mapCoord
{
	_naviConstraint = nil;
	[self.mapView.map.locateLayer removeLocateMark:_locationMarker];
	self.mapID = @(mapCoord.mapID).stringValue;
	_mapPath = [[NSBundle mainBundle] pathForResource:self.mapID ofType:@"fmap"];
	[self.mapView transformMapWithDataPath:_mapPath];
	[self resetMapPara];
	self.displayGroupID = @(mapCoord.coord.storey).stringValue;
	[_chooseFloorScrollView createScrollView:self.mapView.map.names];
	_locationMarker = [[FMKLocationMarker alloc] initWithPointerImageName:@"pointer.png" DomeImageName:@"dome.png"];
	[self.mapView.map.locateLayer addLocationMarker:_locationMarker];
	_locationMarker.size = CGSizeMake(50, 50);
}

//set显示楼层
- (void)setDisplayGroupID:(NSString *)displayGroupID
{
/**
 *	加上这句代码 在地图刚加载时会调用set方法，此时地图还没有创建 无法获取模型层
 *	但是displayGids中会保存设置显示的楼层 导致无法给模型层设置代理
 */
//	if ([self testDisplayGroupIsSameWithWillDisplayGroup:displayGroupID])
//		return;
	_displayGroupID = displayGroupID;
	
	[self resetModelLayerDelegate];
	
//	更新选择楼层偏移量
	[self updateChooseScrollView];
	
	if ([FMNaviAnalyserTool shareNaviAnalyserTool].hasStartNavi || [FMNaviAnalyserTool shareNaviAnalyserTool].planNavi)
	{
		[self drawLineOnMapByGroupID:_displayGroupID];
	}
}

- (NSString *)displayGroupID
{
	return _displayGroupID;
}

//当定位楼层改变时弹框
- (void)popSwitchFloorViewWithMapCoord:(FMKMapCoord)locateMapCoord
{
    if (self.isNeedLocate == NO) return;
	self.locationMarker.hidden = YES;
	if (_cancelGroupID.intValue != locateMapCoord.coord.storey && _cancelGroupID.intValue != _displayGroupID.intValue && !_alertIsExist)
	{
		__weak typeof(self)wSelf = self;
		UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"是否切换到您当前的位置" message:nil preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
			wSelf.displayGroupID = @(locateMapCoord.coord.storey).stringValue;
			wSelf.mapView.displayGids = @[@(locateMapCoord.coord.storey).stringValue];
			wSelf.locationMarker.hidden = NO;
			wSelf.alertIsExist = NO;
			wSelf.isFirstLocate = YES;
		}];
		UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
			wSelf.cancelGroupID = wSelf.displayGroupID;
			wSelf.alertIsExist = NO;
		}];
		[alertVC addAction:action1];
		[alertVC addAction:action2];
		[self presentViewController:alertVC animated:YES completion:nil];
		_alertIsExist = YES;
	}
}

//导航约束 并更新定位标注物
- (FMKNaviContraintResult)naviConstraintWithMapCoord:(FMKMapCoord)mapCoord
{
	FMKNaviContraintResult naviResult;
	if (!_isFirstLocate)
	{
		[self.naviTopView show];
        [self hideMavBar:YES];
		[self updateNaviConstraintData];
		naviResult = [_naviConstraint naviContraintByLastPoint:_lastMapPoint currentMapPoint:mapCoord.coord.mapPoint];
		_lastMapPoint = naviResult.mapPoint;
		[_locationMarker locateWithGeoCoord:FMKGeoCoordMake(mapCoord.coord.storey, naviResult.mapPoint)];
		//导航模式下跟随
		[self.mapView moveToViewCenterByMapCoord:FMKGeoCoordMake(mapCoord.coord.storey, naviResult.mapPoint)];
		
		if (naviResult.type == FMKCONSTRAINT_SUCCESS)
		{
			[self calSurplusLengthAndUpdateTopViewWithNaviConstraint:naviResult];
		}
	}
	else
	{
		_lastMapPoint = mapCoord.coord.mapPoint;
		[self.mapView moveToViewCenterByMapCoord:mapCoord.coord];
		_isFirstLocate = NO;
	}
	return naviResult;
}

//计算剩余路程并更新UI
- (void)calSurplusLengthAndUpdateTopViewWithNaviConstraint:(FMKNaviContraintResult)naviResult
{
	FMKMapCoord mapCoord = FMKMapCoordMake(_mapID.intValue, FMKGeoCoordMake(_locateGroupID.intValue, naviResult.mapPoint));
	
	double surplusLength = [[FMNaviAnalyserTool shareNaviAnalyserTool] calSurplusLengthByMapCoord:mapCoord index:naviResult.index];
	
	if (surplusLength<10.0)
	{
		[self showProgressWithText:@"您已到达目的地附近"];
		[self stopNavi];
        _showChangeMap = NO;
	}
	[self.naviTopView updateLength:surplusLength];
}

- (void)switchMap
{
	_naviConstraint = nil;
	[self.mapView.map.locateLayer removeLocateMark:_locationMarker];
	_locationMarker = nil;
	_mapPath = [[NSBundle mainBundle] pathForResource:self.mapID ofType:@"fmap"];
	[_mapView transformMapWithDataPath:_mapPath];
	[self addLocationMarker];
	//设置主题
	[_mapView setThemeWithLocalPath:[[NSBundle mainBundle] pathForResource:@"2002.theme" ofType:nil]];
    _isFirstLocate = YES;
    _lastMapPoint = FMKMapPointZero();
	[self hideMavBar:NO];
}

//获取该地图上的路径规划结果 并画出当前显示的楼层上的线
- (void)updateLine
{
	NSDictionary * dic = [FMNaviAnalyserTool shareNaviAnalyserTool].naviResult;
	NSArray * mapIDs = [dic allKeys];
	for (NSString * mapID in mapIDs) {
		if ([mapID isEqualToString:_mapID]) {
			self.naviResults = [dic objectForKey:mapID];
			[self updateNaviConstraintData];
			[self drawSingleLineByNaviResult:self.naviResults];
			break;
		}
	}
}

- (void)addEnable3DBtn
{
	UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.frame = CGRectMake(self.view.frame.size.width-10-40, _chooseFloorScrollView.frame.origin.y+_chooseFloorScrollView.frame.size.height+10, 40, 40);
	[button setBackgroundImage:[UIImage imageNamed:@"fun_icon_2d"] forState:UIControlStateNormal];
	[button setBackgroundImage:[UIImage imageNamed:@"fun_icon_3d"] forState:UIControlStateSelected];
	[button addTarget:self action:@selector(enable3DBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:button];
}

- (void)createMapView
{
#if DEBUG_ONLINE
	CGRect rect = CGRectMake(0, kNaviHeight+kFloorButtonHeight-8, kScreenWidth, kScreenHeight-kNaviHeight-kFloorButtonHeight+3);
	_mapView = [[FMMangroveMapView alloc] initWithFrame:rect ID:_mapID delegate:self];
	_mapPath = [[FMKMapDataManager shareInstance]getMapDataPathWithID:_mapID];
#else
	_mapPath = [[NSBundle mainBundle] pathForResource:self.mapID ofType:@"fmap"];
	_mapView = [[FMMangroveMapView alloc] initWithFrame:CGRectMake(0, 84, kScreenWidth, kScreenHeight-84) path:_mapPath delegate:self];
#endif
    if (self.dbModel)
        self.displayGroupID = @(self.dbModel.gid).stringValue;
       
    self.mapView.displayGids = @[self.displayGroupID];
	[self.view addSubview:_mapView];
	
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 160) textContainer:nil];
//    [self.mapView addSubview:_textView];
	self.displayGroupID = _displayGroupID;
	
	[self resetMapPara];
	
	if (self.isNeedLocate)
	{
		 [FMKLocationServiceManager shareLocationServiceManager].delegate = self;
	}
}

//设置地图显示的初始值
- (void)resetMapPara
{
    [FMKLocationServiceManager shareLocationServiceManager].delegate = nil;
	[[FMLocationManager shareLocationManager] setMapView:nil];
    
    float scale = 2.0;
    if (kScreenWidth == 320)
        scale = 3.0;
    else if (kScreenWidth == 375)
        scale = 3.0;
    else if (kScreenWidth == 414)
        scale = 3.0;
    
	[_mapView zoomWithScale:scale];
	[_mapView rotateWithAngle:45.0];
//	[_mapView setInclineAngle:60.0];
    [_mapView inclineWithAngle:90.0f];

	_mapView.showCompass = YES;
	_isFirstLocate = YES;
//    _mapView.enable3D = NO;
	[_mapView setThemeWithLocalPath:[[NSBundle mainBundle] pathForResource:@"2002.theme" ofType:nil]];
	[[FMLocationManager shareLocationManager] setMapView:_mapView];
    [FMKLocationServiceManager shareLocationServiceManager].delegate = self;
}

//初始化路径约束对象
- (void)initNaviInfo
{
	_naviConstraint = [[FMKNaviContraint alloc] initWithMapPath:_mapPath];
	_isFirstLocate = YES;
	_lastMapPoint = FMKMapPointZero();
}

//添加定位标注物
- (void)addLocationMarker
{
	if (!_locationMarker) {
		_locationMarker = [[FMKLocationMarker alloc] initWithPointerImageName:@"pointer.png" DomeImageName:@"dome.png"];
		[_mapView.map.locateLayer addLocationMarker:_locationMarker];
		_locationMarker.size = CGSizeMake(50, 50);
	}
	FMKMapCoord mapCoord = [FMKLocationServiceManager shareLocationServiceManager].currentMapCoord;
	if (mapCoord.mapID != self.mapID.intValue)
	{
		_locationMarker.hidden = YES;
	}
}

//创建选择楼层滚动视图
- (void)createChooseScrollView
{
	_chooseFloorScrollView = [[ChooseFloorScrollView alloc] initWithGids:_mapView.map.names];
	_chooseFloorScrollView.delegate = self;
	[self.view addSubview:_chooseFloorScrollView];
    [self.view insertSubview:_chooseFloorScrollView belowSubview:self.naviTopView];
}

/**********************/
- (void)addlocateBtn
{
	_enableLocateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	_enableLocateBtn.frame = CGRectMake(kLocationSpace, kScreenHeight-64-kLocBtnHeight, kLocBtnWidth, kLocBtnHeight);
	[_enableLocateBtn setBackgroundImage:[UIImage imageNamed:@"location_icon_nomarl"] forState:UIControlStateNormal];
	[_enableLocateBtn setBackgroundImage:[UIImage imageNamed:@"location_icon_sele"] forState:UIControlStateSelected];
	[_enableLocateBtn setBackgroundImage:[UIImage imageNamed:@"location_icon_sele"] forState:UIControlStateHighlighted];
	[self.view addSubview:_enableLocateBtn];
    [_enableLocateBtn addTarget:self action:@selector(inDoorMapView:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)inDoorMapView:(UIButton *)button
{
    button.highlighted = YES;
    [self enableLocationInOutdoor];
    button.highlighted = NO;
}
- (void)enableLocationInOutdoor
{
    FMKMapCoord currentMapCoord = [FMKLocationServiceManager shareLocationServiceManager].currentMapCoord;
    if (currentMapCoord.mapID == kOutdoorMapID)
    {
        [self popToOtherMapByMapCoord:currentMapCoord];
    }
    else if(currentMapCoord.mapID == self.mapID.intValue)
    {
        //定位室内且地图相同
        [FMKLocationServiceManager shareLocationServiceManager].delegate = self;
        self.displayGroupID = @(currentMapCoord.coord.storey).stringValue;
        
        if (![self testDisplayGroupIsSameWithWillDisplayGroup:self.displayGroupID])
        {
            self.mapView.displayGids = @[self.displayGroupID];
        }
    }
    else if(currentMapCoord.mapID != self.mapID.integerValue)
    {
        if ([self testIndoorMapIsxistByMapCoord:currentMapCoord] == YES)
        {
            self.mapID = @(currentMapCoord.mapID).stringValue;
            self.displayGroupID = @(currentMapCoord.coord.storey).stringValue;
            self.mapView.displayGids = @[self.displayGroupID];
            [self switchMap];
            [self resetMapPara];
        }
    }
}
//开启定位开关
- (void)enableLocation:(NSNotification *)noti
{
    if ([noti.object boolValue] == NO) return;
    self.moveMapToCenter = YES;
    [self enableLocationInOutdoor];
}

//弹框提示切换到其他地图
- (void)popToOtherMapByMapCoord:(FMKMapCoord)mapCoord
{
	if (mapCoord.mapID != _cancelMapID.intValue)
    {
        self.currentMapCoord = mapCoord;
        self.showChangeMap = YES;
	}
}
- (void)setShowChangeMap:(BOOL)showChangeMap
{
    if (_showChangeMap != showChangeMap)
    {
        _showChangeMap = showChangeMap;
        if (_showChangeMap == YES)
        {
			__weak typeof(self)wSelf = self;
            UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"是否切换到您当前的位置" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                       {
                                           if (wSelf.currentMapCoord.mapID == kOutdoorMapID)
                                           {
                                               for (UIViewController *controller in self.navigationController.viewControllers)
                                               {
                                                   if ([controller isKindOfClass:[MapViewController class]])
                                                   {
                                                       [wSelf.navigationController popToViewController:controller animated:YES];
                                                   }
                                               }
                                           }
                                           else
                                           {
                                               [wSelf switchToOtherIndoorByMapCoord:wSelf.currentMapCoord];
                                               [wSelf.locationMarker locateWithGeoCoord:wSelf.currentMapCoord.coord];
                                           }
                                           _showChangeMap = NO;
                                       }];
            UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                wSelf.cancelGroupID = @(wSelf.currentMapCoord.mapID).stringValue;
            }];
            [alertVC addAction:action1];
            [alertVC addAction:action2];
            if (wSelf.isNeedLocate == YES)
            {
                [self presentViewController:alertVC animated:YES completion:nil];
            }
        }
    }
}
- (void)enable3DBtnClick:(UIButton *)button
{
	button.selected = !button.selected;
	_mapView.enable3D = button.selected;
}

//更新导航约束数据
- (void)updateNaviConstraintData
{
	if (!_naviConstraint) {
		_naviConstraint = [[FMKNaviContraint alloc] initWithMapPath:_mapPath];
	}
	if (self.naviResults.count>0)
	{
		for (FMKNaviResult * naviResult in self.naviResults) {
			if ([naviResult.groupID isEqualToString:_displayGroupID]) {
				[_naviConstraint updateNaviConstraintDataWith:naviResult.pointArray groupID:_displayGroupID];
				break;
			}
		}
	}
}
- (void)updateChooseScrollView
{
	NSInteger index = [self.mapView.groupIDs indexOfObject:_displayGroupID];
	[_chooseFloorScrollView updateScrollViewContentOffsetByIndex:index];
}

- (void)didUpdateHeading:(double)heading
{
    if (_locationMarker)
    {
        [_locationMarker updateRotate:heading];
    }
	
}

//滚动视图选择楼层触发事件
- (void)buttonClick:(NSInteger)page
{
	_displayGroupID = _mapView.groupIDs[page];
	if (![self testDisplayGroupIsSameWithWillDisplayGroup:_displayGroupID])
	{
		self.mapView.displayGids = @[_displayGroupID];
	}
//    _locationMarker.hidden = [FMKLocationServiceManager shareLocationServiceManager].currentMapCoord.coord.storey != _displayGroupID.intValue;
	[self resetModelLayerDelegate];
}

//地图点击事件
- (void)onMapClickNode:(FMKNode *)node inLayer:(FMKLayer *)layer
{
	if ([FMNaviAnalyserTool shareNaviAnalyserTool].hasStartNavi)
		return;
    if ([FMLocationManager shareLocationManager].isCallingService == YES)
        return;

	FMKModel * model;
	if ([node isKindOfClass:[FMKModel class]]) {
		model = (FMKModel *)node;
		[self setupModelInfoPopViewByModel:model];
		
		FMKModelLayer * modelLayer = (FMKModelLayer *)layer;
		[self setModelSelected:model modelLayer:modelLayer];
	}
}
//设置模型选中
- (void)setModelSelected:(FMKModel *)model modelLayer:(FMKModelLayer *)modelLayer
{
//	for (FMKModel * indoorModel in modelLayer.subNodes) {
//		indoorModel.selected = NO;
//	}
    _highlightModel.selected = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:NotiHideCallView object:@(YES)];
	model.selected = YES;
    _highlightModel = model;
}
- (void)mapView:(FMKMapView *)mapView didSingleTapWithPoint:(CGPoint)point
{
    if ([FMNaviAnalyserTool shareNaviAnalyserTool].hasStartNavi == YES) return;
    if ([FMLocationManager shareLocationManager].isCallingService == YES)
        return;
    
//    [self.modelInfoPopView hide];
//    [self.routeDisplayView hide];
    [self.naviPopView hide];
    [self.inforView hide];
    [self.mapView showAllOnMap];
    [self stopNavi];
    [[NSNotificationCenter defaultCenter] postNotificationName:NotiHideCallView object:@(NO)];
}
- (void)setupModelInfoPopViewByModel:(FMKModel *)model
{	
//	[self.modelInfoPopView show];
//	[self setEnableLocationBtnFrameByView:self.modelInfoPopView];
	NSLog(@"%f %f",model.centerPoint.x,model.centerPoint.y);
	QueryDBModel * queryModel = [[DBSearchTool shareDBSearchTool] queryModelByFid:model.fid];
    
	[self.naviPopView setupModelInfoByNodel:queryModel];//设置模型弹框信息
	
	[self.naviPopView show];
    if (queryModel.activityCode != nil && ![queryModel.activityCode isEqualToString:@""])
    {
        [self.inforView show];
        [self.inforView requsrtActivityInforByActivityCode:queryModel.activityCode];
    }
    
	[self.naviTopView hide];
#warning 这里需要区分是否能拿到定位服务
    FMKMapCoord startMapCoord = [self getDefaultMapCoord]; //[FMKLocationServiceManager shareLocationServiceManager].currentMapCoord;
    NSLog(@"%@",NSStringFromFMKMapCoord(startMapCoord));

	FMKMapCoord endMapCoord = FMKMapCoordMake(queryModel.mid.intValue, FMKGeoCoordMake(queryModel.gid, FMKMapPointMake(queryModel.x, queryModel.y)));
    NSLog(@"%@",NSStringFromFMKMapCoord(endMapCoord));

	FMNaviAnalyserTool * naviTool = [FMNaviAnalyserTool shareNaviAnalyserTool];
	[self setupNaviPopViewInfoByEndName:model.title];
	
	__weak typeof(self)wSelf = self;
    
    BOOL naviSuccess = [naviTool naviAnalyseByStartMapCoord:startMapCoord endMapCoord:endMapCoord];
    
    if (naviSuccess)
    {
        [wSelf startNaviAct];//路径规划
    }
    else
    {
        [wSelf showProgressWithText:@"路径规划失败"];
    }

//    [self ];
//	//到这去
//	self.naviPopView.goHereBlock = ^{
//		BOOL naviSuccess = [naviTool naviAnalyseByStartMapCoord:startMapCoord endMapCoord:endMapCoord];
//		
//		if (naviSuccess)
//		{
//			[wSelf startNaviAct];//路径规划
//		}
//		else
//		{
//			[wSelf showProgressWithText:@"路径规划失败"];
//		}
//	};
//	
//	
    if (naviSuccess)
    {
        [self setupNaviPopView];
    }
	
}

//设置导航信息弹框信息
- (void)setupNaviPopViewInfoByEndName:(NSString *)endName
{
	[self.naviPopView.endPointBtn setTitle:endName forState:UIControlStateNormal];
}

- (void)startNaviAct
{
	_isFirstLocate = YES;
	FMNaviAnalyserTool * naviTool = [FMNaviAnalyserTool shareNaviAnalyserTool];
	double length = [naviTool.naviResult[@"totalLength"] doubleValue];
	[self.naviPopView setTimeByLength:length];
	[self.naviTopView updateLength:length];
	[self getNaviResult];
	
	[self setupNaviPopView];
	[self drawLineOnMapByGroupID:_displayGroupID];
//	[self.modelInfoPopView hide];
	[self.naviPopView show];
	[self setEnableLocationBtnFrameByView:self.naviPopView];
    [[NSNotificationCenter defaultCenter] postNotificationName:NotiHideCallView object:@(YES)];
}

- (void)getNaviResult
{
	NSDictionary * naviResult = [FMNaviAnalyserTool shareNaviAnalyserTool].naviResult;
	self.naviResults = naviResult[_mapID];
	
	FMKNaviResult * endNaviResult = nil;
	for (FMKNaviResult * result in self.naviResults) {
		if (result.groupID.intValue == _displayGroupID.intValue) {
			endNaviResult = result;
			break;
		}
	}
	
	if (endNaviResult) {
		self.displayGroupID = endNaviResult.groupID;
	}
	if (![self testDisplayGroupIsSameWithWillDisplayGroup:_displayGroupID]) {
		_mapView.displayGids = @[_displayGroupID];
	}
	_locationMarker.hidden = NO;
//	[self updateNaviConstraintData];
}

- (void)setupNaviPopView
{
#warning 这里需要区分是否可以拿到定位信息
    FMKMapCoord startMapCoord = [self getDefaultMapCoord]; //[FMKLocationServiceManager shareLocationServiceManager].currentMapCoord;
    
    FMNaviAnalyserTool * tool = [FMNaviAnalyserTool shareNaviAnalyserTool];
    
    BOOL naviResult = [tool naviAnalyseByStartMapCoord:startMapCoord endMapCoord:tool.endMapCoord];
    if (naviResult == NO)
        return;
    
	__weak typeof(self)wSelf = self;
	//开始导航
	self.naviPopView.startNaviBlock = ^{
        if (naviResult == NO)
            return ;
        
		[wSelf stopNavi];//先停止导航
        [[NSNotificationCenter defaultCenter] postNotificationName:NotiHideCallView object:@(YES)];

		//开始导航标志位
		[FMNaviAnalyserTool shareNaviAnalyserTool].hasStartNavi = YES;
        [wSelf hideMavBar:YES];

		if (!naviResult) return;
        [wSelf getNaviResult];
        [wSelf drawLineOnMapByGroupID:wSelf.displayGroupID];
		//切换地图
		if (startMapCoord.mapID == kOutdoorMapID)
		{
			for (UIViewController * VC in wSelf.navigationController.viewControllers) {
				if ([VC isKindOfClass:[MapViewController class]]) {
					[wSelf.navigationController popToViewController:VC animated:YES];
				}
			}
		}
		else if (startMapCoord.mapID != wSelf.mapID.intValue)
		{
			wSelf.mapID = @(startMapCoord.mapID).stringValue;
			[wSelf switchMap];//室内地图的切换
            [wSelf resetMapPara];
			wSelf.displayGroupID = @(startMapCoord.coord.storey).stringValue;
			wSelf.mapView.displayGids = @[wSelf.displayGroupID];
			[wSelf updateLine];//更新路线标注物
		}
		else
		{
			
		}
		
		wSelf.isNeedLocate = YES;
		[wSelf.naviPopView hide];
        [wSelf.inforView hide];
		[wSelf.naviTopView show];
		[wSelf setEnableLocationBtnFrameByView:nil];//设置定位按钮的位置
		
	};
	
	FMNaviAnalyserTool * naviTool = [FMNaviAnalyserTool shareNaviAnalyserTool];
	FMKMapCoord endMapCoord = FMKMapCoordZero();
	if (self.dbModel) {
		endMapCoord = FMKMapCoordMake(self.dbModel.mid.intValue, FMKGeoCoordMake(self.dbModel.gid, FMKMapPointMake(self.dbModel.x, self.dbModel.y)));
	}
//	FMKMapCoord startMapCoord = [FMKLocationServiceManager shareLocationServiceManager].currentMapCoord;
	
	self.naviPopView.switchStartAndEndBlock = ^{
		[wSelf stopNavi];
        [[NSNotificationCenter defaultCenter] postNotificationName:NotiHideCallView object:@(YES)];
		BOOL naviSuccess = [naviTool naviAnalyseByStartMapCoord:endMapCoord endMapCoord:startMapCoord];
		
		if (naviSuccess) {
			[wSelf startNaviAct];//路径规划
		}
		else
		{
			[wSelf showProgressWithText:@"路径规划失败"];
		}
	};
}
//停止导航
- (void)stopNavi
{
    [self hideMavBar:NO];
    _highlightModel.selected = NO;
	[FMNaviAnalyserTool shareNaviAnalyserTool].hasStartNavi = NO;
	[FMNaviAnalyserTool shareNaviAnalyserTool].planNavi = NO;
	[self.mapView.map.lineLayer removeAllLine];
	[self.naviTopView hide];
	self.naviResults = nil;
	_isFirstLocate = YES;
	_lastMapPoint = FMKMapPointZero();
    [[NSNotificationCenter defaultCenter] postNotificationName:NotiHideCallView object:@(NO)];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"FMStopNavi" object:@(YES)];
}

//根据路径规划结果画线
- (void)drawLineOnMapByGroupID:(NSString *)groupID
{
	if (self.naviResults.count>0) {
		[self.mapView.map.lineLayer removeAllLine];
		FMKLineMarker * lineMarker = [[FMKLineMarker alloc] init];
		
		for (FMKNaviResult * naviResult in self.naviResults) {
			if ([naviResult.groupID isEqualToString:groupID] && naviResult.pointArray.count>1) {
				FMKSegment * segment = [[FMKSegment alloc] initWithGroupID:groupID pointArray:naviResult.pointArray];
                NSLog(@"%@",naviResult);
				[lineMarker addSegment:segment];
			}
		}
		lineMarker.mode = FMKLINE_PLANE;
		lineMarker.type = FMKLINE_TEXTURE_MIX;
		lineMarker.width = 2.0f;
		lineMarker.imageName = @"jiantou.png";
		lineMarker.color = [UIColor blueColor];
		[_mapView.map.lineLayer addLineMarker:lineMarker];
	}
}

//通知消息事件处理
- (void)receiveNaviResult:(NSNotification * )noti
{
	NSDictionary * dic = (NSDictionary *)noti.userInfo;
	NSString * startMapID = dic[@"startMapID"];
	NSString * endMapID = dic[@"endMapID"];
	
	if ([startMapID isEqualToString:_mapID]) {
		self.naviResults = dic[@"startResult"];
	}
	
	if ([endMapID isEqualToString:_mapID]) {
		self.naviResults = dic[@"endResult"];
	}
	
	[self drawSingleLineByNaviResult:self.naviResults];
}
#pragma  mark --drawLine
- (void)drawSingleLineByNaviResult:(NSArray *)result
{
	[self.mapView.map.lineLayer removeAllLine];
	FMKLineMarker * lineMarker = [[FMKLineMarker alloc] init];
	for (FMKNaviResult * naviResult in result) {
		if ([naviResult.groupID isEqualToString:_displayGroupID] && naviResult.pointArray.count>1)
		{
			FMKSegment * segment = [[FMKSegment alloc] initWithGroupID:naviResult.groupID pointArray:naviResult.pointArray];
			[lineMarker addSegment:segment];
		}
	}
	
	lineMarker.mode = FMKLINE_PLANE;
	lineMarker.type = FMKLINE_TEXTURE_MIX;
	lineMarker.width = 2.0f;
	lineMarker.color = [UIColor blueColor];
	lineMarker.imageName = @"jiantou.png";
	
	[_mapView.map.lineLayer addLineMarker:lineMarker];
}

//根据显示的视图调整定位按钮的位置
- (void)showAlertView
{
	UIAlertController * alertView = [UIAlertController alertControllerWithTitle:@"确认退出导航" message:nil preferredStyle:UIAlertControllerStyleAlert];
	
	__weak typeof(self)wSelf = self;
	[alertView addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		[wSelf stopNavi];
        _showChangeMap = NO;
	}]];
	
	[alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
		
	}]];
	
	[self presentViewController:alertView animated:YES completion:nil];
}
//提示信息
- (void)showProgressWithText:(NSString *)text
{
	MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	hud.mode = MBProgressHUDModeText;
	hud.labelText = text;
	hud.removeFromSuperViewOnHide = YES;
	[hud hide:YES afterDelay:2.0f];
}

//根据显示楼层重新设置模型层代理
- (void)resetModelLayerDelegate
{
	FMKModelLayer * modelLayer = [self.mapView.map getModelLayerWithGroupID:_displayGroupID];
	if (modelLayer.delegate != self)
	{
		modelLayer.delegate = self;
	}
}

- (void)testDistanceWithResult:(BOOL)result distance:(double)distance
{
    NSLog(@"+++++++++++++++++++++++++++++++++++++++++++++++++");
    self.resultDistance = result;
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
            [self presentViewController:alertView animated:YES completion:^{
                
            }];
        }
    }
}
- (void)updateLocPosition:(FMKMapCoord)mapCoord macAddress:(NSString * )macAddress
{
    if (_callingServiceMapID != mapCoord.mapID)
    {
        _callingServiceCount = 0;
        _callingServiceMapID = mapCoord.mapID;
    }
    else
    {
        if (_callingServiceCount<kCallingServiceCount)
            ++_callingServiceCount;
    }
    
    if (_callingServiceCount != kCallingServiceCount)
        return;
    NSLog(@"_________________%@____________________%d",NSStringFromFMKMapCoord(mapCoord), [FMKLocationServiceManager shareLocationServiceManager].currentMapCoord.mapID);
    _locationMarker.hidden = YES;
    
    if ([macAddress isEqualToString:[[DataManager defaultInstance] getParameter].diviceId])
    {
        self.currentMapCoord = mapCoord;
        [self enableLocationInOutdoor];

//        if (self.mapID.intValue != mapCoord.mapID)
//        {
//            self.showChangeMap = YES;
//        }else
//        {
//            if (_displayGroupID.intValue != mapCoord.coord.storey)
//            {
//                self.displayGroupID = @(mapCoord.coord.storey).stringValue;
//                self.mapView.displayGids = @[@(mapCoord.coord.storey).stringValue];
//            }
//        }
    }
//    if (![macAddress  isEqualToString:[[DataManager defaultInstance] getParameter].diviceId] && self.mapID.intValue != mapCoord.mapID)
//    {
//        
//    }
}

//判断要设置的楼层ID和已经显示的楼层是否相同
- (BOOL)testDisplayGroupIsSameWithWillDisplayGroup:(NSString *)groupID
{
	for (NSString * gid in self.mapView.displayGids) {
		if ([gid isEqualToString:groupID]) {
			return YES;
		}
	}
	return NO;
}

- (void)mapViewDidFinishLoadingMap:(FMKMapView *)mapView
{
	[self resetModelLayerDelegate];
}
- (void)hideMavBar:(BOOL)hide
{
    // 双层导航栏的问题需要隐藏两个层
    for (UIViewController *VC in self.navigationController.viewControllers)
    {
        if ([VC isKindOfClass:[MapViewController class]])
        {
            MapViewController *mapVC = (MapViewController *)VC;
            [mapVC.centerVC.navigationController setNavigationBarHidden:hide animated:YES];
            mapVC.centerVC.title = [self setTitleByMapID:_mapID];
        }
    }
    [self.navigationController setNavigationBarHidden:hide animated:YES];
//    _enableLocateBtn.hidden = hide;
//    CGPoint showRect = CGPointMake(10, 74);
//    CGPoint moveRect = CGPointMake(10, 120);
//    self.mapView.compassOrigin = hide ? moveRect: showRect;
}
- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

#pragma  mark- switchMapInfoViewDelegate
- (void)switchMapInfoBtnClick
{
	FMKMapCoord currentMapCoord = [FMKLocationServiceManager shareLocationServiceManager].currentMapCoord;
	if (currentMapCoord.mapID == kOutdoorMapID)
	{
		[self.navigationController popViewControllerAnimated:YES];
	}
	else
	{
		[self switchToOtherIndoorByMapCoord:currentMapCoord];
		_naviConstraint = nil;
		[self naviConstraintWithMapCoord:currentMapCoord];
	}
	[self.switchMapInfoView hide];
	_lastSetupMapID = 0;
}


- (void)setupSwitchMapInfoWithCurrentMapCoord:(FMKMapCoord)mapCoord
{
	NSString * mapName = [self getMapNameWithMapCoord:mapCoord];
	NSString * otherMapInfo = [NSString stringWithFormat:@"准备切换到%@",mapName];
	self.switchMapInfoView.switchMapInfoLabel.text = otherMapInfo;
	
	if (mapCoord.mapID != self.mapID.intValue)
	{
		if (mapCoord.mapID != _lastSetupMapID)
		{
			[self.switchMapInfoView show];
			_lastSetupMapID = mapCoord.mapID;
		}
	}
	else
	{
		[self.switchMapInfoView hide];
		_lastSetupMapID = 0;
	}
}

- (NSString * )getMapNameWithMapCoord:(FMKMapCoord)mapCoord
{
	//获取地图名称
	NSString * mapName;
	switch (mapCoord.mapID) {
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
		case 79980:
			mapName = @"室外";
		default:
			break;
	}
	return mapName;
}

- (FMKMapCoord)getDefaultMapCoord
{
    FMKMapStorey mapStorey = 1;
    FMKMapPoint mapPoint = FMKMapPointMake(1.21884255544187E7, 2071275.90186538);
    FMKGeoCoord geoCoord = FMKGeoCoordMake(mapStorey, mapPoint);
    FMKMapCoord mapsCoord = FMKMapCoordMake(79980, geoCoord);
    return mapsCoord;
}

@end
