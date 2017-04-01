//
//  MapViewController.m
//  mgmanager
//
//  Created by chao liu on 16/11/24.
//  Copyright © 2016年 Beijing Century Union. All rights reserved.
//

#import "MapViewController.h"
#import "FMView.h"
#import "FrameViewController.h"
#import "FMNaviAnalyserTool.h"

@interface MapViewController ()

@property (weak, nonatomic) IBOutlet UIButton *mangroveicon;
@property (weak, nonatomic) IBOutlet UILabel *scalingLabel;

@property (nonatomic, assign)BOOL isScaling;


@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.isScaling = YES;
    self.scalingLabel.layer.cornerRadius = 32/2;
    self.scalingLabel.layer.masksToBounds = YES;
    self.scalingLabel.layer.borderColor = [[UIColor blackColor]CGColor];
    self.scalingLabel.layer.borderWidth = 0.1f;
    self.scalingLabel.adjustsFontSizeToFitWidth = YES;
    
    self.view.backgroundColor = [UIColor colorWithRed:177 / 255.0f green:177 / 255.0f blue:177 / 255.0f alpha:1];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adddelegateToMap) name:@"AddDelegateToMap" object:nil];
    [self.navigationController.navigationBar setBackgroundImage:[Util createImageWithColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1]] forBarMetrics:UIBarMetricsDefault];
}

- (void)adddelegateToMap
{
    [FMKLocationServiceManager shareLocationServiceManager].delegate = self.fmView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:NotiChangeStatusBar object:@"1"];
	FMKMapCoord currentMapCoord = [FMKLocationServiceManager shareLocationServiceManager].currentMapCoord;
	if (currentMapCoord.mapID == kOutdoorMapID) {
		[FMKLocationServiceManager shareLocationServiceManager].delegate = self.fmView;
	}
     [self.fmView hideNaviBar:[FMNaviAnalyserTool shareNaviAnalyserTool].hasStartNavi];
    self.centerVC.title = @"红树林导航";
    self.centerVC.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 检查是否登录
    BOOL login = [[DataManager defaultInstance] findLocationUserPersonalInformation];
    // 在这里开始发送网络请求
    if (login == YES)
    {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            [self loadMap];
        });
    }

    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"inDoorMap"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:NotiChangeStatusBar object:@"1"];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [FMKLocationServiceManager shareLocationServiceManager].delegate = nil;
    [self.fmView hideNavView];
    self.dbModel = nil;
//    [self.fmView.switchMapInfoView ];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
//    [self.fmView.fengMapView resetMapViewFrameWithWidth:kScreenWidth height:kScreenHeight];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"+++++++++++++++++++++++InOut  dealloc");
}

- (void)loadMap
{
    if (!self.fmView)
    {
        NSLog(@"%@",[NSThread currentThread]);
        self.fmView = [[FMView alloc] initWithFrame:self.view.bounds];
        [self.fmView addFengMapView];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view  insertSubview:self.fmView belowSubview:self.scalingLabel];
            NSLog(@"%@",[NSThread currentThread]);
        });
    }
    NSLog(@"%@",[NSThread currentThread]);
    // 默认回到地图 把自己的坐标位置移动到屏幕中央
    // 定位模式下 导航防止多次跳转室内地图
//    self.fmView.inDoorMap = YES;
    //重新设置室外地图的主题
    [self.fmView resetTheme];

    [self.fmView addLocationDelegate];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.fmView planNaviAct];
    });
    

    self.fmView.isFirstLocate = YES;

    if ([FMNaviAnalyserTool shareNaviAnalyserTool].hasStartNavi)
    {
        [self.fmView mapEnterNaviMode];
    }
    [[FMLocationManager shareLocationManager] setMapView:nil];
    [[FMLocationManager shareLocationManager] setMapView:_fmView.fengMapView];
}

- (void)showMangroveIcon:(BOOL)show
{
    self.mangroveicon.hidden = !show;
    if (show == YES)
    {
        self.mangroveicon.frame = CGRectMake(self.mangroveicon.frame.origin.x, 64+13, 35, 35);
    }
}

- (IBAction)scalingLabelAction:(id)sender
{
    NSLog(@"伸缩label");
    if (self.isScaling)
    {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect rect = self.mangroveicon.frame;
            rect.origin.x = rect.origin.x - 175;
            self.mangroveicon.frame = rect;
            
            CGRect rect1 = self.scalingLabel.frame;
            rect1.origin.x = rect.origin.x ;
            rect1.size.width = 175+35;
            self.scalingLabel.frame = rect1;
            
        }];
        self.isScaling = NO;
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect rect = self.mangroveicon.frame;
            rect.origin.x = rect.origin.x + 175;
            self.mangroveicon.frame = rect;
            
            CGRect rect1 = self.scalingLabel.frame;
            rect1.origin.x = kScreenWidth-12-35;
            rect1.size.width = 35;
            self.scalingLabel.frame = rect1;
        }];
        self.isScaling = YES;
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
