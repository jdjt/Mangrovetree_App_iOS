//
//  FMIndoorView.h
//  mgmanager
//
//  Created by fengmap on 16/8/10.
//  Copyright © 2016年 Beijing Century Union. All rights reserved.
//

#import "FMBaseView.h"

@interface FMIndoorView : FMBaseView

@property (nonatomic, copy) NSString * mapPath;

@property (nonatomic, strong) FMKMapView * mapView;

@end
