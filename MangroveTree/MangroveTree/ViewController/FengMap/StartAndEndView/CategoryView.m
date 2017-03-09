//
//  CategoryView.m
//  FMMangroveMapView
//
//  Created by fengmap on 16/9/21.
//  Copyright © 2016年 FengMap. All rights reserved.
//

#import "CategoryView.h"

/**
 * @abstract 选择的功能区
 */
typedef NS_ENUM(NSInteger,FilterType)
{
	FILTERTYPE_SERVICE        = 1,
	FILTERTYPE_SHOP           = 2,
	FILTERTYPE_FOOD           = 3,
	FILTERTYPE_ROUTE		  = 4,
	FILTERTYPE_ZONE			  = 5,
};

@interface CategoryView()

@property (nonatomic, assign) FilterType type;
@property (nonatomic, strong) UIButton * selectedBtn;

@end

@implementation CategoryView


+ (instancetype)categoryView
{
	CategoryView * view = [[NSBundle mainBundle] loadNibNamed:@"CategoryView" owner:nil options:nil][0];
	view.type = NSNotFound;
    return view;
}

- (IBAction)categoryBtnClick:(id)sender {
	UIButton * button = (UIButton *)sender;
	button.selected = !button.selected;

    if (button.selected)
    {
		if (self.selectedBtn != button) {
			self.selectedBtn.selected = NO;
			self.selectedBtn = button;
		}
        switch (button.tag) {
            case 100:
                self.type = FILTERTYPE_SERVICE;
                break;
            case 101:
                self.type = FILTERTYPE_SHOP;
                break;
            case 102:
                self.type = FILTERTYPE_FOOD;
                break;
            case 103:
                self.type = FILTERTYPE_ROUTE;
                break;
			case 104:
				self.type = FILTERTYPE_ZONE;
				break;
            default:
                break;
        }

    }
    else
    {
        self.type = NSNotFound;
    }
    self.categoryBtnClickBlock(button.tag,button.selected);

}

- (void)setType:(FilterType)type
{
	_type = type;
	UIColor *colorSelected = [UIColor colorWithRed:12.0/256 green:100.0/256 blue:3.0/256 alpha:1];
	UIColor *colorUnselected = [UIColor colorWithRed:81.0/256 green:150.0/256 blue:109.0/256 alpha:1];
	self.serviceView.backgroundColor = _type == FILTERTYPE_SERVICE ? colorSelected:colorUnselected;
	self.shopView.backgroundColor = _type == FILTERTYPE_SHOP ? colorSelected:colorUnselected;
	self.foodView.backgroundColor = _type == FILTERTYPE_FOOD ? colorSelected:colorUnselected;
	self.routeView.backgroundColor = _type == FILTERTYPE_ROUTE ? colorSelected:colorUnselected;
	self.zoneView.backgroundColor = _type == FILTERTYPE_ZONE ? colorSelected:colorUnselected;
	
	[self.serviceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[self.serviceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
	
	[self.shopBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[self.shopBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
	
	[self.foodBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[self.foodBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
	
	[self.routeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[self.routeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
	
	[self.zoneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[self.zoneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
	
}


- (void)dealloc
{
	NSLog(@"categoryview dealloc");
}

@end
