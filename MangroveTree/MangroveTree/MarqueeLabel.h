//
//  MarqueeLabel.h
//  MangroveTree
//
//  Created by 伊舞寻风 on 2017/4/14.
//  Copyright © 2017年 luoyu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NUM_LABELS 2

enum AutoScrollDirection {
    AUTOSCROLL_SCROLL_RIGHT,
    AUTOSCROLL_SCROLL_LEFT,
};

@interface MarqueeLabel : UIScrollView <UIScrollViewDelegate>{
    UILabel *label[NUM_LABELS];
    enum AutoScrollDirection scrollDirection;
    float scrollSpeed;
    NSTimeInterval pauseInterval;
    int bufferSpaceBetweenLabels;
    bool isScrolling;
}
@property(nonatomic) enum AutoScrollDirection scrollDirection;
@property(nonatomic) float scrollSpeed;
@property(nonatomic) NSTimeInterval pauseInterval;
@property(nonatomic) int bufferSpaceBetweenLabels;

@property(nonatomic,retain) UIColor *textColor;
@property(nonatomic, retain) UIFont *font;

- (void) readjustLabels;
- (void) setText: (NSString *) text;
- (NSString *) text;
- (void) scroll;


@end
