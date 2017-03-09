//
//  BaseCollectionView.m
//  FeiFanWandaDemo
//
//  Created by Haoyu Wang on 16/6/27.
//  Copyright © 2016年 fengmap. All rights reserved.
//

#import "BaseCollectionView.h"
#import "BaseCollectionViewCell.h"
#import "CollCellModel.h"

#define CollCellID @"BaseCollectionViewCell"

const int kPerRowItemNum = 4;

@interface BaseCollectionView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSArray *contentArray;
@end

@implementation BaseCollectionView

+ (instancetype)baseCollectionViewContentArray:(NSArray *)contentArray {
	// 每行的数量
	NSInteger rowNum = kPerRowItemNum;
    // 行数
    NSInteger rows = ceilf(contentArray.count / rowNum);
		
    CGFloat cellW = [[UIScreen mainScreen] bounds].size.width / rowNum;
	CGFloat cellH = 78;
	
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    BaseCollectionView *collView = [[BaseCollectionView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, rows*cellH) collectionViewLayout:layout];
    collView.backgroundColor = [UIColor whiteColor];
    // 注册UICollectionView使用的cell类型
    [collView registerNib:[UINib nibWithNibName:@"BaseCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:CollCellID];
    collView.dataSource = collView;
    collView.delegate = collView;
    
    layout.itemSize = CGSizeMake(cellW, cellH);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    
    collView.contentArray = contentArray;
	
    return collView;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.contentArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BaseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollCellID forIndexPath:indexPath];
    CollCellModel *model = [CollCellModel collCellModelWithDict:self.contentArray[indexPath.row]];
    [cell setImage:[UIImage imageNamed:model.image] andLabelText:model.text];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegateColl respondsToSelector:@selector(baseCollectionView:didSelectedItemAtIndexPath:)]) {
        [self.delegateColl baseCollectionView:self didSelectedItemAtIndexPath:indexPath];
    }
}


@end
