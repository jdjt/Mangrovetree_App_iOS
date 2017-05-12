//
//  ChooseFloorScrollView.m
//  HuaCeUniversalDemo
//
//  Created by fengmap on 16/3/30.
//  Copyright © 2016年 fengmap. All rights reserved.
//

#import "ChooseFloorScrollView.h"
#import "Const.h"

#define kButtonStartX ([UIScreen mainScreen].bounds.size.width/2 - kFloorButtonWidth/2)
#define BBColor(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0f]
#define BBColorTransparent(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:0.8f]
#define kNaviBarHeight 64

/** 用于当前页面计算页数时使用， 10000代表页数未知 */
static NSInteger const FMCurrentPgaeUnknown = 10000;

@interface ChooseFloorScrollView()<UIScrollViewDelegate>
{
    UIScrollView *scrollView;
}


@property (nonatomic) NSInteger currentPage;


@end

@implementation ChooseFloorScrollView

- (instancetype)initWithGids:(NSArray *)gids
{
    self = [super init];
    self.frame = CGRectMake(0, kNaviBarHeight, kScreenWidth, kFloorButtonHeight);
	
	self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Floor navigation1"]];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"fun_icon_floor"]];
    imageView.frame = CGRectMake(0, 0, 57.6, kFloorButtonHeight+3);
    imageView.center = CGPointMake(self.frame.size.width/2, (kFloorButtonHeight+6)/2);
    [self addSubview:imageView];
    [self createScrollView:gids];
    return self;
}

- (void)createScrollView:(NSArray *)gids
{
	if (scrollView) {
		[self clearBtnsOnScrollView];
		[self.tagButtons  removeAllObjects];
	}
    self.tagButtons = [NSMutableArray array];
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width,self.frame.size.height )];
    scrollView.contentSize = CGSizeMake((gids.count-1) *kFloorButtonWidth+kScreenWidth, kFloorButtonHeight);
    scrollView.delegate = self;
    scrollView.backgroundColor = [UIColor clearColor];
	scrollView.showsVerticalScrollIndicator = NO;
	scrollView.showsHorizontalScrollIndicator = NO;
	scrollView.alwaysBounceVertical = NO;
    [self addSubview:scrollView];
	
	NSMutableArray * oriArr = [NSMutableArray arrayWithArray:gids];
	
	for (int i = 0; i<oriArr.count; i++) {
		for (int j = (int)oriArr.count-1; j>i; j--) {
			NSString * groupID1 = oriArr[j];
			NSString * groupID2 = oriArr[j-1];
			NSString * id1 = [groupID1 substringFromIndex:1];
			NSString * id2 = [groupID2 substringFromIndex:1];
			int index1 = (int)[oriArr indexOfObject:groupID1];
			int index2 = (int)[oriArr indexOfObject:groupID2];
			if (id1.intValue<id2.intValue) {
				[oriArr exchangeObjectAtIndex:index1 withObjectAtIndex:index2];
			}
		}
	}
	
	for (int i = 0; i<oriArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 100+i;
        button.frame = CGRectMake(kFloorButtonWidth*i + kButtonStartX, 0, kFloorButtonWidth, kFloorButtonHeight);
        button.backgroundColor = [UIColor clearColor];
        [button setTitle: [oriArr[i] uppercaseString] forState: UIControlStateNormal];
        
        [button setTitleColor:BBColor(237, 130, 86) forState: UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [button addTarget:self action:@selector(changeFloorNum:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:button];
        [self.tagButtons addObject:button];
        
        if (i == 0) {
            [button setTitleColor:[UIColor whiteColor] forState: UIControlStateNormal];
            button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        }
    }
}

//清除滚动视图上的按钮
- (void)clearBtnsOnScrollView
{
	for (int i = (int)scrollView.subviews.count-1; i>-1; i--) {
		UIView * view = scrollView.subviews[i];
		if ([view isKindOfClass:[UIButton class]]) {
			[view removeFromSuperview];
		}
	}
}

- (void)changeFloorNum:(UIButton *)sender
{
    [self updateScrollViewContentOffsetWithPgae:sender.tag-100];
}

#pragma mark --UIScrollViewDelegate
#pragma mark 停止退拽
- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (decelerate) return; // 如果将要减速, 则返回。
    [self updateScrollViewContentOffsetWithPgae: FMCurrentPgaeUnknown];
}
#pragma mark 停止减速
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self updateScrollViewContentOffsetWithPgae: FMCurrentPgaeUnknown];
}
- (void)updateScrollViewContentOffsetWithPgae:(NSInteger)page
{
    self.currentPage = page;
    
    if (self.currentPage == FMCurrentPgaeUnknown) {
        self.currentPage = (scrollView.contentOffset.x+kFloorButtonWidth/2) / kFloorButtonWidth;
    }
    
    [scrollView setContentOffset: CGPointMake(self.currentPage * kFloorButtonWidth, 0) animated: YES];
	if ([self.delegate respondsToSelector:@selector(buttonClick:)]) {
			[self.delegate buttonClick:self.currentPage];
	}
}

- (void)updateScrollViewContentOffsetByIndex:(NSInteger)index
{
	self.currentPage = index;
	
	if (self.currentPage == FMCurrentPgaeUnknown) {
		self.currentPage = (scrollView.contentOffset.x+kFloorButtonWidth/2) / kFloorButtonWidth;
	}
	
	[scrollView setContentOffset: CGPointMake(self.currentPage * kFloorButtonWidth, 0) animated: YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView1 {
    
    
    // 1. 获取当前滚动到得页数
    //    NSInteger page = (self.buttonScrollView.contentOffset.x+kFloorButtonWidth/2) / kFloorButtonWidth;
    
    // 2. 获取高亮显示文字的位置
    CGRect highlightFrame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 5, 0, 10, 10);
    
    //  3. 设置按钮高亮效果
    for (UIButton *button in self.tagButtons) {
        CGRect frame = [scrollView1 convertRect:button.frame toView:self];
        if (CGRectIntersectsRect(highlightFrame, frame)) {
            button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
            [button setTitleColor:[UIColor whiteColor] forState: UIControlStateNormal];
        }
        else {
            button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
            [button setTitleColor:BBColor(237, 130, 86) forState: UIControlStateNormal];
        }
    }
}


@end
