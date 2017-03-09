//
//  FMIndoorView.m
//  mgmanager
//
//  Created by fengmap on 16/8/10.
//  Copyright © 2016年 Beijing Century Union. All rights reserved.
//

#import "FMIndoorView.h"
#import "ChooseFloorScrollView.h"

@interface FMIndoorView()<FMKMapViewDelegate>

@end

@implementation FMIndoorView

- (instancetype)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
		[self createMapView];
	}
	return self;
}

- (void)createMapView
{
	self.mapView = [[FMKMapView alloc] initWithFrame:self.frame path:self.mapPath delegate:self];
	[self addSubview:self.mapView];
}

- (void)dealloc
{
	self.mapView.delegate = nil;
}

@end
