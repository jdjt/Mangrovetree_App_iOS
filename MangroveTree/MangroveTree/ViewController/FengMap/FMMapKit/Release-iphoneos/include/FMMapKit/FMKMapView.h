//
//  FMKGLKView.h
//  FMMapKit
//
//  Created by FengMap on 15/6/25.
//  Copyright (c) 2015年 FengMap. All rights reserved.
//

#import <GLKit/GLKit.h>
#import "FMKGeometry.h"

//node
@class FMKNode;
@class FMKModel;
@class FMKFacility;
@class FMKImageMarker;

@class FMKMap;

@class FMKAnimatorEnableController;
@class FMKMapGestureEnableController;


/**
 *  地图透视模式
 */
typedef NS_ENUM(NSInteger, FMKProjectionMode){
    
    FMKMAPVIEW_PERSPECTIVE = 0,
    
    FMKMAPVIEW_ORTHO,
    
    FMKMAPVIEW_PROJECTIONNUM
};

/**
 *  定义地图中绘制元素的Z值的枚举类型。在地图坐标转屏幕坐标时，需要使用这里面的值。
 */
typedef NS_ENUM(NSInteger, FMKMapCoordZType){
    /**
     *  POI对应的Z值
     */
    FMKMAPCOORDZ_POI = 0,
    /**
     *  标注物在模型上时的Z值
     */
    FMKMAPCOORDZ_POINTIMAGE_MODEL,
    /**
     *  标注物在地面上时的Z值
     */
    FMKMAPCOORDZ_POINTIMAGE_EXTENT,
    /**
     *  公共实施在地面上时的Z值
     */
    FMKMAPCOORDZ_FACILITY,
    /**
     *  模型的Z值
     */
    FMKMAPCOORDZ_MODEL,
    /**
     *  地面的Z值
     */
    FMKMAPCOORDZ_EXTENT,
    /**
     *  线标注物的Z值
     */
    FMKMAPCOORDZ_LINE,
    /**
     *  定位标注物的Z值
     */
    FMKMAPCOORDZ_LOCATION
};

@protocol FMKMapViewDelegate;

/**
 * @brief 地图View
 */
@interface FMKMapView : GLKView

/**
 *初始化地图,地图ID需通过蜂鸟官网获取
 *详情请见：http://developers.fengmap.com/map_data.html
 @brief
 @param frame   地图区域
 @param mapID   地图ID
 @param target  地图的代理
 */
- (instancetype)initWithFrame:(CGRect)frame ID:(NSString *)mapID
                     delegate:(id<FMKMapViewDelegate>)target;


/**
 *  初始化地图,通过保存在本地的地图数据加载
 *
 *  @param frame    区域
 *  @param dataPath 地图数据存储位置
 *  @param target   地图代理
 */
- (instancetype)initWithFrame:(CGRect)frame path:(NSString *)dataPath
                     delegate:(id<FMKMapViewDelegate>)target;


/**
 *  地图代理
 */
@property (nonatomic,weak) id<FMKMapViewDelegate> mapDelegate;

@property (nonatomic, readonly) FMKMapPoint mapViewCenter;

/**
 * 切换新地图，通过ID切换
 */
- (void)transformMapWithID:(NSString *)mapID;

/**
 *  通过地图数据路径切换地图
 *
 *  @param dataPath 地图数据存储路径
 */
- (void)transformMapWithDataPath:(NSString *)dataPath;

/**
 *  当前加载的地图节点
 *  地图节点用于管理层节点等子项
 *  通过该节点可以进行子节点管理
 *  该节点为只读对象，不支持创建
 */
@property (nonatomic,readonly) FMKMap* map;

/**
 *  当前使用的主题路径
 */
@property (nonatomic, copy) NSString * currentThemePath;

/**
 @brief 是否显示指北针
 */
@property (nonatomic,assign) BOOL showCompass;
/**
 *  楼层id的数组
 */
@property (nonatomic,strong) NSArray* displayGids;

/**
 *  地图所有楼层ID
 */
@property (nonatomic,readonly)NSArray * groupIDs;


/**
 *  设置焦点层
 *
 *  @param groupID  焦点层ID
 *  @param animated 是否有动画
 */
- (void)setFocusByGroupID:(NSString *)groupID animated:(BOOL)animated;

/**
 *  获取焦点层ID
 *
 *  @return 楼层ID
 */
- (NSString *)getFocusGroupID;

/**
 *  设置当前地图显示楼层的alpha
 *
 *  @param alphas alpha数组 只能存放NSNumber对象
 */
- (void)setGroupsAlpha:(NSArray <NSNumber*>*)alphas;

/**
 *  取消地图焦点
 */
- (void)cancelFocusFloor;

/**
 *  重新设置地图视图的frame
 *
 *  @param width  宽
 *  @param height 高
 */
- (void)resetMapViewFrameWithWidth:(CGFloat)width height:(CGFloat)height;

/**
 *  通过主题ID设置主题
 *
 *  @param themeID 主题ID，从蜂鸟服务器获取
 */
- (void)setThemeWithID:(NSString *)themeID;

/**
 *  设置地图主题
 *
 *  @param path 地图主题数据路径
 */
- (void)setThemeWithLocalPath:(NSString *)path;

/**
 *  是否3D显示
 */
@property (nonatomic,assign) BOOL enable3D;

/**
 *  倾斜手势开关
 */
@property (nonatomic,assign) BOOL inclineEnable;

/**
 *  设置背景色,背景色为RGB颜色，暂不支持图片渲染颜色
 */
@property (nonatomic,copy) UIColor* backgroundColor;

/**
 *  地图透视模式
 */
@property (nonatomic,assign) FMKProjectionMode mode;

/**
 *  地图手势控制器
 */
@property (nonatomic,strong) FMKMapGestureEnableController * gestureEnableController;
/**
 *  设置动画管理对象
 */
@property (nonatomic,strong) FMKAnimatorEnableController * animatorController;

/**
 *  缩放地图
 *
 *  @param scale 地图缩放，默认为1.0
 */
- (void)zoomWithScale:(float)scale;

/**
 * 地图倾斜角度
 */
@property (nonatomic,readonly) float dipAngle;

/**
 *  地图旋转角度
 */
@property (nonatomic,readonly) float  rotateAngle;

/**
 *  地图缩放比例
 */
@property (nonatomic,readonly) float zoomScale;


/**
 *  调整倾斜角度
 *
 *  @param angle 倾斜角度 单位：度
 */
- (void)inclineWithAngle:(float)angle;

/**
 *  设置倾角
 *
 *  @param angle 倾角  单位：度
 */
- (void)setInclineAngle:(float)angle;

- (void)move:(FMKMapPoint)mapPoint;

/**
 * 旋转
 * @prarm angle 旋转角度
 */
- (void)rotateWithAngle:(float)angle;

/**
 设定地图旋转角度

 @param angle 旋转角度
 */
- (void)setRotateWithAngle:(float)angle;

/**
 
 全屏显示
 @param min     最小点
 @param max     最大点
 @param groupID 楼层ID
 */
- (void)fullScreenDisplayByMinMapPoint:(FMKMapPoint)min max:(FMKMapPoint)max groupID:(NSString *)groupID;

/**
 重新显示地图的范围

 @param mapPoints 点集合
 @param groupID   楼层ID
 */
- (void)refreshViewRangeByMapPoints:(NSArray *)mapPoints onGroup:(NSString *)groupID;
/**
 *  移动地图
 *
 *  @param startPoint 起点坐标
 *  @param endPoint   终点坐标
 */
- (void)move:(CGPoint)startPoint  withEndPoint:(CGPoint)endPoint;

/**
 *  将地图上某个位置移动到屏幕中央
 *
 *  @param mapCoord 地图坐标
 */
- (void)moveToViewCenterByMapCoord:(FMKGeoCoord)mapCoord;


/**
 *  屏幕坐标转换为地理坐标
 *
 *  @param point 屏幕点坐标
 *
 *  @return 蜂鸟地理坐标，包含楼层和地理坐标值
 */
- (FMKGeoCoord)coverPoint:(CGPoint)point;

/**
 *  地理坐标转换为屏幕坐标
 *
 *  @param coord 蜂鸟地图坐标
 *  @param type  该参数为转换坐标时的Z值
 *
 *  @return 返回屏幕点坐标
 */
- (CGPoint)coverCoord:(FMKGeoCoord)coord zType:(FMKMapCoordZType)type;

- (FMKMapPoint)coverImagePixToMapWithLeftTop:(FMKMapPoint)leftTop
                                    rightTop:(FMKMapPoint)rightTop
                                  leftBottom:(FMKMapPoint)leftBottom
                                   imageSize:(CGSize)imageSize
                                  imagePoint:(CGPoint)imagePoint;

/**
 * 设置标注图片资源路径，默认为空;
 * 自定义图片存放目录；若设置了该路径，刚添加的图片标注会引用该路径下的资源
 * 若不设置图片将从mainBundle中读取；
 *  @param path 路径
 */
- (void)setImageMarkerResourcePath:(NSString *)path;

/**
 *  更新地图
 */
- (void)updateMap;

- (void)addAllLineByMapPath:(NSString *)mapPath groupID:(NSString *)groupID;

@end

/**
 *  地图的协议方法
 */
@protocol FMKMapViewDelegate <NSObject>

@required


@optional

/*!
 @brief 当地图将要加载
 @param mapview 地图View对象
 */
- (void)mapViewWillStartLoadingMap:(FMKMapView *)mapView;

/*!
 @brief 地图加载完成
 @param mapview 地图View对象
 */
- (void)mapViewDidFinishLoadingMap:(FMKMapView *)mapView;


/*!
 @brief 地图加载失败
 @param mapView 地图View
 @param error 错误信息
 */
- (void)mapViewDidFailLoadingMap:(FMKMapView *)mapView withError:(NSError *)error;

#pragma gesture

/**
 *  当单击地图时
 *
 *  @param mapView mapView
 *  @param point   单击点
 */
- (void)mapView:(FMKMapView *)mapView didSingleTapWithPoint:(CGPoint)point;

/**
 *  当双击地图时
 *
 *  @param mapView mapView
 */
- (void)mapView:(FMKMapView *)mapView didDoubleTapWithPoint:(CGPoint)point;

/**
 *  长按地图时
 *
 *  @param mapView mapView
 */
- (void)mapView:(FMKMapView *)mapView didLongPressWithPoint:(CGPoint)point;

/**
 *  当移动地图时
 *
 *  @param mapView mapView
 */
- (void)mapView:(FMKMapView *)mapView didMovedWithPoint:(CGPoint)point;

/**
 *  地图更新时
 *
 *  @param mapView mapView
 */
- (void)mapViewDidUpdate:(FMKMapView *)mapView;

/**
 *  手势将要单击屏幕时，默认返回NO
 *
 *  @param tapGestureRecognize 手势
 *  @param mapView             获取手势的mapView
 *
 *  @return 返回YES，地图元素的拾取方法和单击方法都会执行;返回NO,拾取事件与地图单击事件互斥
 */
- (BOOL)gestureRecognizer:(UITapGestureRecognizer *)tapGestureRecognize shouldSingleTapOnView:(FMKMapView *)mapView;

@end

