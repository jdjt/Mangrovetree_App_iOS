//
//  RouteDisplayView.m
//  mgmanager
//
//  Created by fengmap on 16/8/14.
//  Copyright © 2016年 Beijing Century Union. All rights reserved.
//

#import "RouteDisplayView.h"
#import "NumberLineView.h"
#import "FMKGeometry.h"


@interface RouteDisplayView()<NumberLineViewDelegate>

@property (nonatomic, strong) UIButton * selectedBtn;
@property (nonatomic, strong) NSMutableArray * displayViews;
@property (nonatomic, strong) NSMutableArray *numLineBtns;
@property (nonatomic, strong) NSArray * ativities;
@property (nonatomic, strong) UIButton * selectedNumBtn;
@property (nonatomic, strong) UILabel * selectedNumLabel;

@end

@implementation RouteDisplayView

+ (instancetype)routeDisplayView
{
	RouteDisplayView * view = [[NSBundle mainBundle] loadNibNamed:@"RouteDisplayView" owner:nil options:nil][0];
	view.displayViews = [NSMutableArray array];
	view.numLineBtns = [NSMutableArray array];
	view.alpha = 0.0f;
	return view;
}
- (IBAction)topLeftBtnClick:(id)sender {
}
- (IBAction)topRightBtnClick:(id)sender {
}
- (IBAction)bottomLeftBtnClick:(id)sender {
}
- (IBAction)bottomRightBtnClick:(id)sender {
}
- (IBAction)selecteLineBtnClick:(id)sender {
	
	UIButton * button = (UIButton *)sender;
	button.selected = !button.selected;
	
	if (_selectedBtn != button) {
		_selectedBtn.selected = NO;
		_selectedBtn.backgroundColor = [UIColor colorWithRed:81/255.0 green:161/255.0 blue:113/255.0 alpha:1.0f];
	}
	
	if (button.selected) {
		_selectedBtn = button;
		button.backgroundColor = [UIColor colorWithRed:81/255.0 green:161/255.0 blue:113/255.0 alpha:1.0f];
		[self addNumberLineViewByButtonTag:button.tag];
//		self.routeSelectedBlock();
	}
	else
	{
		button.backgroundColor = [UIColor colorWithRed:81/255.0 green:161/255.0 blue:113/255.0 alpha:1.0f];
	}
	
	
	
}

- (void)addNumberLineViewByButtonTag:(NSInteger)buttonTag
{
	
	switch (buttonTag) {
		case 500:
//			routeAcvtivity = [ParserJsondata parserRouteShop1];
			break;
		case 501:
//			routeAcvtivity = [ParserJsondata parserRouteFood1];
			break;
		case 502:
//			routeAcvtivity = [ParserJsondata parserRouteRelax1];
			break;
		case 503:
			
			break;
		case 504:
			
			break;
		case 505:
			
			break;
		default:
			break;
	}

//	[self clearNumberLineView];

}

/*
- (void)routeNaviByRouteActivity:(RouteActivity *)routeActivity
{
	if (!routeActivity) return;
	
	NSArray * acts = [ParserJsondata parserActivities];
	
	NaviAnalyserTool * tool = [NaviAnalyserTool shareNaviAnalyserTool];
	NSMutableArray * routeNaviResult = [NSMutableArray array];
	NSMutableArray * points = [NSMutableArray array];
	
	for (int i = 0; i<routeActivity.route_points.count/2-1; i++) {
		double startX = [routeActivity.route_points[i*2] doubleValue];
		double startY = [routeActivity.route_points[i*2+1] doubleValue];
		FMKGeoCoord startCoord = FMKGeoCoordMake(1, FMKMapPointMake(startX, startY));
		
		double endX = [routeActivity.route_points[i*2+2] doubleValue];
		double endY = [routeActivity.route_points[i*2+3] doubleValue];
		FMKGeoCoord endCoord= FMKGeoCoordMake(1, FMKMapPointMake(endX, endY));
		
		NSArray * result = [tool outdoorMapRouteFuncNaviByStartCoord:startCoord endCoord:endCoord];
		[routeNaviResult addObjectsFromArray:result];
	}
	
	for (NSString * act_code in routeActivity.activity_code_list) {
		for (Activity * act in acts) {
			if ([act_code isEqualToString:act.activity_code] && act.activity_position.count>0) {
				FMKMapPoint mapPoint = FMKMapPointMake([act.activity_position[0] doubleValue], [act.activity_position[1] doubleValue]);
				NSValue * pointValue = [NSValue valueWithFMKMapPoint:mapPoint];
				[points addObject:pointValue];
			}
		}
	}
	
	self.returnRouteNaviResult(routeNaviResult, points);
}
 
- (void)addNumberLineViewByRouteAcvtivity:(RouteActivity *)routeActivity
{
	if (!routeActivity) return;
	
	__weak RouteDisplayView * wSelf = self;
	
	NSArray * acts = [ParserJsondata parserActivities];
	
	for (int i = 1; i<routeActivity.activity_code_list.count+1; i++) {
		NumberLineView * view = [NumberLineView numberLineView];
		
		view.delegate = self;
		
		[self.displayViews addObject:view];
		
		view.frame = CGRectMake((i-1)*50-8, 7, 50, self.frame.size.height/3*2);
		if (i == 1) {
			view.leftView.hidden = YES;
		}
		if (i == routeActivity.activity_code_list.count)
		{
			view.rightView.hidden = YES;
		}
		view.numLabel.text = @(i).stringValue;
		[self.bottomView addSubview:view];
		
		NSString * pointName;
		for (Activity * act in acts) {
			if ([act.activity_code isEqualToString:routeActivity.activity_code_list[i-1]]) {
				pointName = act.activity_name;
			}
		}
		NSString * name = [self addLineBreakWithText:pointName];
		[view.numPointBtn setTitle:name forState:UIControlStateNormal];
		view.numPointBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
		view.numPointBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
		view.numPointBtn.titleLabel.numberOfLines = 0;
		[view.numPointBtn sizeToFit];
		
		view.buttonClick = ^(UIButton * button,UILabel * label){
			if (wSelf.selectedNumBtn != button) {
				wSelf.selectedNumBtn.selected = NO;
				wSelf.selectedNumLabel.backgroundColor = SETCOLOR(79, 72, 75);
				label.backgroundColor = SETCOLOR(65, 125, 86);
				wSelf.selectedNumBtn.backgroundColor = [UIColor whiteColor];
				wSelf.selectedNumBtn = button;
				wSelf.selectedNumLabel = label;
			}
		};
		
	}
}

- (void)clearNumberLineView
{
	for (NumberLineView * view in self.displayViews) {
		[view removeFromSuperview];
	}
	[self.displayViews removeAllObjects];
}



- (void)updateConstraints
{
	[super updateConstraints];
	NumberLineView * view = self.displayViews.lastObject;
	self.bottomViewWidth.constant = view.frame.origin.x+view.frame.size.width;
	
	for (NumberLineView * view in self.displayViews) {
		[view.numPointBtn sizeToFit];
	}
}
*/

- (void)numberLineBtnClick:(NumberLineView *)view
{
	int index = (int)[self.displayViews indexOfObject:view];
	self.selectedPointIndex(index);
}

- (void)addNumberLineViewByActivityNames:(NSArray *)names
{
	__weak RouteDisplayView * wSelf = self;
	
	for (int i = 1; i<names.count+1; i++) {
		NumberLineView * view = [NumberLineView numberLineView];
		view.delegate = self;
		[self.displayViews addObject:view];
		
		view.frame = CGRectMake((i-1)*50-8, 7, 50, self.frame.size.height/3*2);
		if (i == 1) {
			view.leftView.hidden = YES;
		}
		if (i == names.count)
		{
			view.rightView.hidden = YES;
		}
		view.numLabel.text = @(i).stringValue;
		[self.bottomView addSubview:view];
		
		NSString * pointName = names[i-1];
		
		NSString * name = [self addLineBreakWithText:pointName];
		[view.numPointBtn setTitle:name forState:UIControlStateNormal];
		view.numPointBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
		view.numPointBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
		view.numPointBtn.titleLabel.numberOfLines = 0;
		[view.numPointBtn sizeToFit];
		
		view.buttonClick = ^(UIButton * button,UILabel * label){
			if (wSelf.selectedNumBtn != button) {
				wSelf.selectedNumBtn.selected = NO;
				wSelf.selectedNumLabel.backgroundColor = SETCOLOR(79, 72, 75);
				label.backgroundColor = SETCOLOR(65, 125, 86);
				wSelf.selectedNumBtn.backgroundColor = [UIColor whiteColor];
				wSelf.selectedNumBtn = button;
				wSelf.selectedNumLabel = label;
			}
		};
		
	}

}

- (NSString *)addLineBreakWithText:(NSString *)text
{
	NSMutableString * str = [NSMutableString string];
	for (int i = 0; i<text.length; i++) {
		NSRange range = NSMakeRange(i, 1);
		NSString * string =[text substringWithRange:range];
		[str appendFormat:@"%@\n",string];
	}
	return str;
}

- (void)dealloc
{
	NSLog(@"routeDisplayView dealloc");
}

@end
