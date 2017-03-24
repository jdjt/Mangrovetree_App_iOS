//
//  SearchViewController.m
//  MangroveTree
//
//  Created by 伊舞寻风 on 2017/3/16.
//  Copyright © 2017年 luoyu. All rights reserved.
//

#import "SearchViewController.h"
#import "MapViewController.h"
#import "FrameViewController.h"
#import "SearchTypeCell.h"
#import "SearchHeaderView.h"
#import "SearchResultCell.h"
#import "DBSearchTool.h"
#import "FMIndoorMapVC.h"

@interface SearchViewController () <UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *searchResultButton;
@property (weak, nonatomic) IBOutlet UIScrollView *bottomScroll;
@property (weak, nonatomic) IBOutlet UIView *segmentView;
@property (weak, nonatomic) IBOutlet UIView *segmentBackground;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *leftCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *rightCollectionView;
@property (weak, nonatomic) IBOutlet UITableView *searchTableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;

@property (nonatomic, assign) BOOL segmentSelect;
@property (nonatomic, assign) BOOL tableViewShow;

// 测试数据
@property (nonatomic, strong) NSMutableArray * titleArray;
@property (nonatomic, strong) NSMutableArray * subTitleArray;
@property (nonatomic, strong) NSMutableArray * rightArray;
@property (nonatomic, strong) NSMutableArray * searchResult;
@property (nonatomic, strong) NSMutableArray * displayResult;


@end

@implementation SearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.segmentSelect = YES;
    self.tableViewShow = NO;
    self.searchResult = [NSMutableArray array];
    self.displayResult = [NSMutableArray array];
    [self.searchTextFlied setValue:[UIColor colorWithRed:247 / 255.0f green:247 / 255.0f blue:247 / 255.0f alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    [self.searchTextFlied setValue:[UIFont boldSystemFontOfSize:14.5] forKeyPath:@"_placeholderLabel.font"];
    
    self.segmentView.layer.borderColor = [UIColor colorWithRed:237 / 255.0f green:130 / 255.0f blue:86 / 255.0f alpha:1].CGColor;
    self.segmentView.layer.borderWidth = 1.0f;
    self.segmentView.clipsToBounds = YES;
    self.segmentView.layer.cornerRadius = 3.0f;
    
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.leftLabel addGestureRecognizer: tap1];
    [self.rightLabel addGestureRecognizer:tap2];
    
    UITapGestureRecognizer * tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    UITapGestureRecognizer * tap4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.leftCollectionView addGestureRecognizer:tap3];
    [self.rightCollectionView addGestureRecognizer:tap4];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    __weak typeof(self)wSelf = self;

    [self.searchTableView addLegendFooterWithRefreshingBlock:^{
        [wSelf updateData];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    for (UIViewController *viewController in self.navigationController.viewControllers)
    {
        if ([viewController isKindOfClass:[MapViewController class]])
        {
            MapViewController *map = (MapViewController *)viewController;
            [map.centerVC.navigationController setNavigationBarHidden:YES animated:YES];
            [self.navigationController setNavigationBarHidden:YES animated:YES];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:NotiChangeStatusBar object:@"0"];
    [[NSNotificationCenter defaultCenter] postNotificationName:NotiHideCallView object:@(YES)];
}

- (void)viewWillDisappear:(BOOL)animated
{
    for (UIViewController *viewController in self.navigationController.viewControllers)
    {
        if ([viewController isKindOfClass:[MapViewController class]])
        {
            MapViewController *map = (MapViewController *)viewController;
            [map.centerVC.navigationController setNavigationBarHidden:NO animated:YES];
        }
    }
    [super viewWillDisappear:animated];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.collectionWidth.constant = kScreenWidth;
}

- (NSMutableArray *)titleArray
{
    if (_titleArray == nil)
    {
        _titleArray = [NSMutableArray arrayWithArray:[Util analysisJsonByfileName:@"vacation" fileType:@".json"]];
    }
    return _titleArray;
}

- (NSMutableArray *)subTitleArray
{
    if (_subTitleArray == nil)
    {
        _subTitleArray = [NSMutableArray array];
        for (NSDictionary * dic in self.titleArray)
        {
            if (![dic[@"title_code"] isEqualToString:@"0"])
            {
                NSArray * array = [dic[@"items"] componentsSeparatedByString:@","];
                [_subTitleArray addObject:array];
            }
        }
    }
    return _subTitleArray;
}

- (NSMutableArray *)rightArray
{
    if (_rightArray == nil)
    {
        _rightArray = [NSMutableArray arrayWithArray:[self.titleArray[0][@"items"] componentsSeparatedByString:@","]];
    }
    return _rightArray;
}

#pragma action

- (IBAction)backToMap:(id)sender
{
    for (UIViewController *viewController in self.navigationController.viewControllers)
    {
        if ([viewController isKindOfClass:[MapViewController class]])
        {
            MapViewController *map = (MapViewController *)viewController;
            [map.centerVC showBottomView:Segment_none];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)tapSearch:(id)sender
{
    if (self.searchTextFlied.text.length <= 0)
    {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入地点的关键字" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        self.searchResultButton.hidden = YES;
        [self.searchTextFlied resignFirstResponder];
        [self toSearchByText:self.searchTextFlied.text];
    }
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    if (tap.view == self.leftLabel)
    {
        [self changeSegmentBackgroundTextColor:YES];
    }
    else if (tap.view == self.rightLabel)
    {
        [self changeSegmentBackgroundTextColor:NO];
    }
    else if (tap.view == self.leftCollectionView)
    {
        CGPoint point = [tap locationInView:self.leftCollectionView];
        NSIndexPath * indexPath = [self.leftCollectionView indexPathForItemAtPoint:point];
        if (indexPath != nil)
        {
            [self collectionView:self.leftCollectionView didSelectItemAtIndexPath:indexPath];
        }
        [self.view endEditing:YES];
    }
    else
    {
        CGPoint point = [tap locationInView:self.rightCollectionView];
        NSIndexPath * indexPath = [self.rightCollectionView indexPathForItemAtPoint:point];
        if (indexPath != nil)
        {
            [self collectionView:self.rightCollectionView didSelectItemAtIndexPath:indexPath];
        }
        [self.view endEditing:YES];
    }
}

- (void)changeSegmentBackgroundTextColor:(BOOL)change
{
    if (change)
    {
        if (self.segmentSelect == YES)
            return;
        self.segmentSelect = YES;
        [self.bottomScroll scrollRectToVisible:CGRectMake(0,self.bottomScroll.frame.origin.y , kScreenWidth, self.bottomScroll.frame.size.height) animated:YES];
    }
    else
    {
        if (self.segmentSelect == NO)
            return;
        self.segmentSelect = NO;
        [self.bottomScroll scrollRectToVisible:CGRectMake(kScreenWidth, self.bottomScroll.frame.origin.y, kScreenWidth, self.bottomScroll.frame.size.height) animated:YES];
    }
}

#pragma mark - scrollDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.bottomScroll)
    {
        CGRect rect = self.segmentBackground.frame;
        rect.origin.x = (scrollView.contentOffset.x / kScreenWidth) * rect.size.width;
        self.leftLabel.textColor = [UIColor colorWithRed:(255 - (172 * (scrollView.contentOffset.x / kScreenWidth))) / 255.0f green:(255 - (172 * (scrollView.contentOffset.x / kScreenWidth))) / 255.0f blue:(255 - (172 * (scrollView.contentOffset.x / kScreenWidth))) / 255.0f alpha:1];
        self.rightLabel.textColor = [UIColor colorWithRed:(83 + (172 * (scrollView.contentOffset.x / kScreenWidth))) / 255.0f green:(83 + (172 * (scrollView.contentOffset.x / kScreenWidth))) / 255.0f blue:(83 + (172 * (scrollView.contentOffset.x / kScreenWidth))) / 255.0f alpha:1];
        self.segmentBackground.frame = rect;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.bottomScroll)
    {
        [scrollView setContentOffset:CGPointMake((int)(scrollView.contentOffset.x / kScreenWidth) * kScreenWidth,0)];
        [self changeSegmentBackgroundTextColor:(int)(scrollView.contentOffset.x / kScreenWidth) > 0 ? NO : YES];
    }
    
}

#pragma mark - collectionDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == self.leftCollectionView)
    {
        return [self.subTitleArray[section] count];
    }
    else
    {
        return self.rightArray.count;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (collectionView == self.leftCollectionView)
    {
        return self.titleArray.count - 1;
    }
    else
    {
        return 1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SearchTypeCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"searchType" forIndexPath:indexPath];
    
    if (collectionView == self.leftCollectionView)
    {
        [cell.searchType setTitle:self.subTitleArray[indexPath.section][indexPath.row] forState:UIControlStateNormal];
    }
    else
    {
        [cell.searchType setTitle:self.rightArray[indexPath.row] forState:UIControlStateNormal];
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.leftCollectionView)
    {
        if([kind isEqualToString:UICollectionElementKindSectionHeader])
        {
            SearchHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"collectionHeader" forIndexPath:indexPath];
            headerView.titleLabel.text = self.titleArray[indexPath.section + 1][@"title_name"];
            return headerView;
        }
        else if([kind isEqualToString:UICollectionElementKindSectionFooter])
        {
            UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"collectionFooter" forIndexPath:indexPath];
            return footerView;
        }
    }
    else
    {
        if([kind isEqualToString:UICollectionElementKindSectionHeader])
        {
            UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Header" forIndexPath:indexPath];
            return headerView;
        }
        else if([kind isEqualToString:UICollectionElementKindSectionFooter])
        {
            UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Footer" forIndexPath:indexPath];
            return footerView;
        }
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((kScreenWidth - 33 * 3 - 17 * 2) / 4, 20.5);
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (collectionView == self.leftCollectionView)
    {
        return UIEdgeInsetsMake(7, 17, 12, 17);
    }
    else
    {
        return UIEdgeInsetsMake(19, 17, 12, 17);
    }
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0f;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 33.0f;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (collectionView == self.leftCollectionView)
    {
        return CGSizeMake(kScreenWidth, 17);
    }
    else
    {
        return CGSizeMake(0, 0);
    }
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (collectionView == self.leftCollectionView)
    {
        return CGSizeMake(kScreenWidth, 9);
    }
    else
    {
        return CGSizeMake(0, 0);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * text = nil;
    if (collectionView == self.leftCollectionView)
    {
        text = self.subTitleArray[indexPath.section][indexPath.row];
    }
    else
    {
        text = self.rightArray[indexPath.row];
    }
    
    [self queryBySubTypeName:text];
    [self searchTableShow:YES];
    [self showSearchResultButtonBytapCollectionItemWithTitle:text];
}

#pragma  mark - textflied delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    [textField resignFirstResponder];
    textField.text = @"";
    [self searchTableShow:NO];
    [_searchResult removeAllObjects];
    [_displayResult removeAllObjects];
    return NO;
}
- (void)textFieldTextDidChange:(NSNotification *)noti
{
    UITextField * textField = (UITextField *)noti.object;
    if (textField.text.length>0)
    {
        [self queryModelByText:textField.text];
        [self searchTableShow:YES];
    }
    else
    {
        [_searchResult removeAllObjects];
        [_displayResult removeAllObjects];
        [self.searchTableView reloadData];
        [self searchTableShow:NO];
        [textField resignFirstResponder];
    }
}

#pragma  mark - tableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _displayResult.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchResultCell * cell = [tableView dequeueReusableCellWithIdentifier:@"searchResult"];
    QueryDBModel * model = _displayResult[indexPath.row];
    cell.subTitleLabel.text = model.name;
    cell.detailLocationLabel.text = [NSString stringWithFormat:@"%@·%@",model.typeName,model.address];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    QueryDBModel * model = _displayResult[indexPath.row];
    [self didSelectedCellToMapViewByModel:model];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - Fun

//加载更多
- (void)updateData
{
    [_displayResult removeAllObjects];
    [_displayResult addObjectsFromArray:_searchResult];
    [self.searchTableView.legendFooter noticeNoMoreData];
    [self.searchTableView reloadData];
}

- (void)didSelectedCellToMapViewByModel:(QueryDBModel *)model;
{
    __weak typeof(self)wSelf = self;
    if ([model.mid isEqualToString:@(kOutdoorMapID).stringValue]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"postSelectedPoi" object:model];
        for (UIViewController * outdoorVC in wSelf.navigationController.viewControllers) {
            if ([outdoorVC isKindOfClass:[MapViewController class]])
            {
                [self.navigationController popToViewController:outdoorVC animated:YES];
                break;
            }
        }
    }
    else
    {
        [wSelf testIndoorIsExistByDBModel:model];
    }
}

//判断室内地图是否存在  跳转室内地图 插标
- (void)testIndoorIsExistByDBModel:(QueryDBModel *)model
{
    __weak typeof(self)wSelf = self;
    BOOL indoorMapVCExist = NO;
    BOOL isNeedLocate  = NO;
    if ([FMKLocationServiceManager shareLocationServiceManager].currentMapCoord.mapID == model.mid.intValue)
        isNeedLocate = YES;
    else
        isNeedLocate = NO;
    
    for (UIViewController * viewController in wSelf.navigationController.viewControllers)
    {
        if ([viewController isKindOfClass:[FMIndoorMapVC class]])
        {
            FMIndoorMapVC * VC = (FMIndoorMapVC *)viewController;
            VC.dbModel = model;
            VC.isNeedLocate = isNeedLocate;
            indoorMapVCExist = YES;
            MBProgressHUD *HUD =[MBProgressHUD showHUDAddedTo:[AppDelegate sharedDelegate].window animated:YES];
            HUD.labelText = @"正在加载地图，请稍等";
            [HUD show:YES];
            [wSelf.navigationController popToViewController:VC animated:YES];
        }
    }
    if (!indoorMapVCExist) {
        FMIndoorMapVC * vc = [[FMIndoorMapVC alloc] initWithMapID:model.mid];
        vc.dbModel = model;
        vc.isNeedLocate = isNeedLocate;
        MBProgressHUD *HUD =[MBProgressHUD showHUDAddedTo:[AppDelegate sharedDelegate].window animated:YES];
        HUD.labelText = @"正在加载地图，请稍等";
        [HUD show:YES];
        [wSelf.navigationController pushViewController:vc animated:YES];
    }
}

- (void)toSearchByText:(NSString *)text
{
    [self queryModelByText:text];
    [self searchTableShow:YES];
}

- (IBAction)cancelSearchStatus:(id)sender
{
    [self.searchTextFlied resignFirstResponder];
    [self searchTableShow:NO];
}

- (void)searchTableShow:(BOOL)show
{
    if (show == self.tableViewShow)
        return;
    self.searchResultButton.hidden = YES;
    CGRect rect = self.searchTableView.frame;
    if (show)
    {
        rect.size.height = kScreenHeight - 76 - 49;
        [UIView animateWithDuration:0.2 animations:^{
            self.searchTableView.frame = rect;
            self.tableViewHeight.constant = rect.size.height;
        }];
    }
    else
    {
        rect.size.height = 0;
        [UIView animateWithDuration:0.2 animations:^{
            self.searchTableView.frame = rect;
            self.tableViewHeight.constant = rect.size.height;
        }];
    }
    self.tableViewShow = show;
}

- (void)showSearchResultButtonBytapCollectionItemWithTitle:(NSString *)text
{
    [self.searchResultButton setTitle:text forState:UIControlStateNormal];
    self.searchResultButton.hidden = NO;
    self.searchTextFlied.placeholder = @"";
    self.searchTextFlied.text = @"";
    CGRect rect = self.searchResultButton.frame;
    rect.size.width = [text sizeWithAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:11]}].width + 6 + 16;
    self.searchResultButton.frame = rect;
    self.searchResultButton.titleEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 16);
    self.searchResultButton.imageEdgeInsets = UIEdgeInsetsMake(0, rect.size.width - 16, 0, 6);
}
//根据搜索框内容搜索
- (void)queryModelByText:(NSString *)text
{
    NSArray * arr = [[DBSearchTool shareDBSearchTool] queryByKeyWord:text];
    [_searchResult removeAllObjects];
    [_displayResult removeAllObjects];
    arr = [self sortBySerachResult:arr];
    [_displayResult addObjectsFromArray:arr];
    if (_searchResult.count > 10) {
        for (int i = 0; i < 10; i++) {
            [_displayResult addObject:_searchResult[i]];
        }
    }
    else
    {
        [_displayResult addObjectsFromArray:arr];
    }
    if (_searchResult.count <= 10)
        [self.searchTableView.legendFooter noticeNoMoreData];
    else
        [self.searchTableView.legendFooter resetNoMoreData];
    [self.searchTableView reloadData];
}
//根据typeName搜索
- (void)queryByTypeName:(NSString *)typeName
{
    NSArray * results = [[DBSearchTool shareDBSearchTool] queryByTypeName:typeName];
    [_searchResult removeAllObjects];
    [_displayResult removeAllObjects];

    results = [self sortBySerachResult:results];
    [_searchResult addObjectsFromArray:results];
    if (_searchResult.count > 10) {
        for (int i = 0; i < 10; i++) {
            [_displayResult addObject:_searchResult[i]];
        }
    }
    else
    {
        [_displayResult addObjectsFromArray:results];
    }
    if (_searchResult.count <= 10)
        [self.searchTableView.legendFooter noticeNoMoreData];
    else
        [self.searchTableView.legendFooter resetNoMoreData];
    [self.searchTableView reloadData];
}
- (void)queryBySubTypeName:(NSString *)subTypeName
{
    NSArray * results = [[DBSearchTool shareDBSearchTool] queryBySubTypeName:subTypeName];
    [_searchResult removeAllObjects];
    [_displayResult removeAllObjects];
    results = [self sortBySerachResult:results];
    [_searchResult addObjectsFromArray:results];
    if (_searchResult.count > 10) {
        for (int i = 0; i < 10; i++) {
            [_displayResult addObject:_searchResult[i]];
        }
    }
    else
    {
        [_displayResult addObjectsFromArray:results];
    }
    if (_searchResult.count <= 10)
        [self.searchTableView.legendFooter noticeNoMoreData];
    else
        [self.searchTableView.legendFooter resetNoMoreData];
    [self.searchTableView reloadData];

}
//对搜索结果按照mid进行排序
- (NSArray *)sortBySerachResult:(NSArray *)result
{
    int mapID = [FMKLocationServiceManager shareLocationServiceManager].currentMapCoord.mapID;
    NSArray * sortArr = [result sortedArrayUsingComparator:^NSComparisonResult(QueryDBModel * model1, QueryDBModel * model2) {
        int differentValue1 = model1.mid.intValue - mapID;
        int differentValue2 = model2.mid.intValue - mapID;
        if (differentValue1>differentValue2) {
            return NSOrderedDescending;
        }
        else
            return NSOrderedAscending;
    }];
    
    return sortArr;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
