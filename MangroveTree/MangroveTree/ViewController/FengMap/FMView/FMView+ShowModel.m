//
//  FMView+ShowModel.m
//  mgmanager
//
//  Created by fengmap on 16/7/5.
//  Copyright © 2016年 Beijing Century Union. All rights reserved.
//

#import "FMView+ShowModel.h"
#import "ParserJsondata.h"
#import "FMKExternalModel.h"
#import "FMKExternalModelLayer.h"
#import "FMKMap.h"
#import "FMActivity.h"
#import "FMRoute.h"
#import "FMZone.h"

NSString *const kGroup_ID = @"1";

@implementation FMView (ShowModel)


- (void)showExternalModel
{
		
	NSArray * activities = [self getModelFidsByButtonType:self.type];
	FMKExternalModelLayer * modelLayer = [self.fengMapView.map getExternalModelLayerWithGroupID:kGroup_ID];
	
	for (FMKExternalModel * model in modelLayer.subNodes) {
//		[self.nodeAssociation setMaskByExternalModel:model mask:NO];
//		[self.nodeAssociation setHighlightByExternalModel:model highlight:NO];
	}
	
	[self.showList removeAllObjects];
	
	for (FMActivity * activity in activities) {
		for (FMKExternalModel * model in modelLayer.subNodes) {
			if ([activity.fmap_fid isEqualToString:model.fid] && (![self.showList containsObject:model])) {
				[self.showList addObject:model];
			}
		}
	}
	for (FMKExternalModel * model in self.showList) {
		
//		[self.nodeAssociation setMaskByExternalModel:model mask:YES];
	}
}


- (NSArray *)getModelFidsByButtonType:(ButtonType)type
{
	FMZone * zoneActivity;
	switch (type) {
		case ButtonType_SERVICE:
		{
//			zoneActivity = [ParserJsondata parserFacility];
		}
			break;
		case ButtonType_SHOP:
		{
//			zoneActivity = [ParserJsondata parserShop];
		}
			break;
		case ButtonType_FOOD:
		{
//			zoneActivity = [ParserJsondata parserFood];
		}
			break;
		case ButtonType_ROUTE_FOOD1:
		{
//			zoneActivity = [ParserJsondata parserRouteFood1];
		}
			break;
		case ButtonType_ROUTE_RELAX1:
		{
//			zoneActivity = [ParserJsondata parserRouteRelax1];
		}
			break;
		case ButtonType_NOTFOUND:
			[self resetStandardStatus];
			break;
		default:
			break;
	}
		return [self getActivitiesByZoneActivity:zoneActivity];
}

- (NSArray * )getActivitiesByZoneActivity:(FMZone *)zoneActivity
{
//	NSArray * pois = [ParserJsondata parserActivities];
//	NSMutableArray * activites = [NSMutableArray array];
//	for (FMActivity * ac in pois) {
//		for (NSString * activity_code in zoneActivity.activity_code_list) {
//			if ([ac.activity_code isEqualToString:activity_code]) {
//				[activites addObject:ac];
//				break;
//			}
//		}
//	}
//	return activites;
	return nil;
}


//将所有的model设为初始状态
- (void)resetStandardStatus
{
	FMKExternalModelLayer * layer = [self.fengMapView.map getExternalModelLayerWithGroupID:@"1"];
	for (FMKExternalModel * model in layer.subNodes) {
		model.maskMode = YES;
		model.highlight = NO;
	}
	[self.showList removeAllObjects];
}

- (NSArray *)getPoisByModel:(FMKExternalModel *)model
{
	NSMutableArray * poiNames = [NSMutableArray array];
	NSArray * activitys = [self getModelFidsByButtonType:self.type];
	
	for (FMActivity * activity in activitys) {
		if ([activity.fmap_fid isEqualToString:model.fid]) {
			[poiNames addObject:activity.activity_name];
		}
	}
	return poiNames;
}

@end
