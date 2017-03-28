//
//  MapSearchViewController.m
//  search
//
//  Created by Haoyu Wang on 16/6/27.
//  Copyright © 2016年 fengmap. All rights reserved.
//

#import "MapSearchViewController.h"
#import "FMMapKit.h"
#import "BaseCollectionView.h"
#import "HeadView.h"
#import "HistoryRecordCell.h"

#import "FMIndoorMapVC.h"

#import "Const.h"

#import "DBSearchTool.h"
#import "QueryDBModel.h"
#import "FMNaviAnalyserTool.h"

#import "MapViewController.h"
#import "FrameViewController.h"

#import "UIView+TransitionAnimation.h"

NSString * const recordKey = @"searchRecordKey";
const int kDisplayCount = 4;

@interface MapSearchViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, BaseCollectionViewDelegate>
{
	NSMutableArray * _historyRecord;//搜索历史纪录
	NSMutableArray * _searchResult;//搜索结果
	NSMutableArray * _displayResult;//实时搜索展现列表数据
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITableView * historyTableView;
//实时搜索结果的列表
@property (nonatomic, strong) UITableView * searchResultTabelView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) NSArray *typeArray;
//搜索到的数据
@property (nonatomic, strong) NSMutableArray *muResultArray;

@end

@implementation MapSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
		
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = NO;

	[self initDataSourceArr];
	[self getSearchHistory];
    [self setupNav];
    [self createTableView];//创建选项列表
	[self createhistoryTableView];//创建历史纪录列表
	[self createSearchResultTableView];//创建搜索结果表
    
}

- (void)initDataSourceArr
{
	_historyRecord = [NSMutableArray array];
	_searchResult = [NSMutableArray array];
	_displayResult = [NSMutableArray array];
}

- (void)getSearchHistory
{
	[[DBSearchTool shareDBSearchTool] createOrOpenSearchHistoryRecordDB];
	NSArray * arr = [[DBSearchTool shareDBSearchTool] getAllSearchRecord];
	NSArray * arr1 = [[DBSearchTool shareDBSearchTool] getAllSearchModel];
	if (arr) {
		[_historyRecord addObjectsFromArray:arr];
	}
	if (arr1) {
		[_historyRecord addObjectsFromArray:arr1];
	}
}

- (void)setupNav
{
    // 添加搜索框
    CGFloat seaViewH = 35;
    UIView *seaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, seaViewH)];
    seaView.backgroundColor = [UIColor whiteColor];
    seaView.layer.cornerRadius = 5;
    seaView.layer.masksToBounds = YES;
    self.navigationItem.titleView = seaView;
	
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, seaViewH-8*2, seaViewH-8*2)];
    imgView.image = [UIImage imageNamed:@"search"];
    [seaView addSubview:imgView];
	
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(seaViewH, 0, 240-seaViewH, seaViewH)];
    tf.placeholder = @"搜索";
    tf.clearButtonMode = UITextFieldViewModeAlways;
	tf.delegate = self;
    // 设置文本框光标颜色
    tf.tintColor = [UIColor blueColor];
    tf.returnKeyType = UIReturnKeyDone;
    [seaView addSubview:tf];
    self.textField = tf;
	
	//文本框监听
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:tf];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidEndEditing:) name:UITextFieldTextDidEndEditingNotification object:tf];
}

- (void)createTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kTableViewHeight) style:UITableViewStylePlain];
    [self.view addSubview:tableView];
	
	tableView.scrollEnabled = NO;
	
    self.tableView = tableView;
    tableView.dataSource = self;
    tableView.delegate = self;
	tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	UIView * view = [[UIView alloc] initWithFrame:CGRectZero];
	[self.tableView setTableFooterView:view];
}

- (void)createhistoryTableView
{
	UITableView * historyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.tableView.frame.origin.y+self.tableView.frame.size.height, kScreenWidth, kScreenHeight-self.tableView.frame.size.height) style:UITableViewStyleGrouped];
	[self.view addSubview:historyTableView];
	self.historyTableView = historyTableView;
	self.historyTableView.hidden = NO;
	
	[self.historyTableView registerNib:[UINib nibWithNibName:@"HistoryRecordCell" bundle:nil] forCellReuseIdentifier:@"historyRecordCell"];
	
	historyTableView.dataSource = self;
	historyTableView.delegate = self;
	
	if ([self.historyTableView respondsToSelector:@selector(setSeparatorInset:)])
	{
		[self.historyTableView setSeparatorInset: UIEdgeInsetsZero];
	}
	if ([self.historyTableView respondsToSelector:@selector(setLayoutMargins:)])
	{
		[self.historyTableView setLayoutMargins: UIEdgeInsetsZero];
	}
	
	if (_historyRecord.count == 0)
	{
		UIView * view = [[UIView alloc] initWithFrame:CGRectZero];
		[self.historyTableView setTableFooterView:view];
	}
}

- (void)createSearchResultTableView
{
	self.searchResultTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNaviHeight, kScreenWidth, kScreenHeight-kNaviHeight) style:UITableViewStylePlain];
	[UIView hideWithView:self.searchResultTabelView];
	[self.view addSubview:self.searchResultTabelView];
	self.searchResultTabelView.dataSource = self;
	self.searchResultTabelView.delegate = self;
	[self.searchResultTabelView registerNib:[UINib nibWithNibName:@"HistoryRecordCell" bundle:nil] forCellReuseIdentifier:@"historyRecordCell"];
	UIView * view = [[UIView alloc] initWithFrame:CGRectZero];
	[self.searchResultTabelView setTableFooterView:view];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
	
    return YES;
}

- (void)textFieldTextDidChange:(NSNotification *)noti
{
	UITextField * textField = (UITextField *)noti.object;
	if (textField.text.length>0) {
		[self queryModelByText:textField.text];
	}
	else
	{
		[_searchResult removeAllObjects];
		[_displayResult removeAllObjects];
		[self.searchResultTabelView reloadData];
		[UIView hideWithView:self.searchResultTabelView];
		[textField resignFirstResponder];
	}
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	[UIView showWithView:self.searchResultTabelView];
	return YES;
}

- (void)textFieldTextDidEndEditing:(NSNotification *)noti
{
	UITextField * textField = (UITextField *)noti.object;
	if ([textField.text isEqualToString:@""]) {
		return;
	}
	[self addSearchRecord:textField.text];
}
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
	[_searchResult removeAllObjects];
	[_displayResult removeAllObjects];
	[self.searchResultTabelView reloadData];
	[UIView hideWithView:self.searchResultTabelView];
	[textField resignFirstResponder];
	textField.text = nil;
	return NO;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return 1;
    }
	else if(tableView == self.historyTableView)
	{
		return _historyRecord.count;
	}
	else if(tableView == self.searchResultTabelView)
	{
		return _displayResult.count;
	}
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView)
    {
        NSString *ID = @"MapSearchViewTableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
		}
		
        if (indexPath.section == 0) {
			self.typeArray = @[@{@"text" : @"美食", @"image" : @"position_icon_food"},
							   @{@"text" : @"酒店", @"image" : @"position_icon_hotel"},
							   @{@"text" : @"购物", @"image" : @"position_icon_shopping"},
							   @{@"text" : @"休闲", @"image" : @"position_icon_par"},
							   @{@"text" : @"服务台", @"image" : @"position_icon_ser"},
							   @{@"text" : @"卫生间", @"image" : @"position_icon_wc"},
							   @{@"text" : @"ATM", @"image" : @"ATM"},
							   @{@"text" : @"电梯", @"image" : @"position_icon_ele"}
							   ];
            BaseCollectionView *collOne = [BaseCollectionView baseCollectionViewContentArray:self.typeArray];
            collOne.delegateColl = self;
            collOne.tag = 0;
            [cell.contentView insertSubview:collOne atIndex:0];
        }
		return cell;
    }
   	else if(tableView == _historyTableView)
	{
		static NSString * identifier = @"history";
		static NSString * cellIdentifier = @"cellHistory";
		UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:identifier];
		HistoryRecordCell  * cell;
		cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
		if ([_historyRecord[indexPath.row] isKindOfClass:[NSString class]]) {
			if (!cell1) {
				cell1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
				cell1.textLabel.text = _historyRecord[indexPath.row];
				cell1.imageView.image = [UIImage imageNamed:@"search"];
			}
			return cell1;
		}
		else
		{
			if (!cell) {
				cell = [[NSBundle mainBundle] loadNibNamed:@"HistoryRecordCell" owner:nil options:nil][0];
			}
			QueryDBModel * model = _historyRecord[indexPath.row];
//			cell.titleLabel.text = model.name;
			[self resetSizeWithCellTypeNameLabel:cell.typeNameLabel withContent:model.name];
			cell.typeNameLabel.text = model.typeName;
			cell.positionLabel.text = [NSString stringWithFormat:@" · %@",model.address];
			
			FMNaviAnalyserTool * naviTool = [FMNaviAnalyserTool shareNaviAnalyserTool];
            __block MapSearchViewController *myself = self;
			cell.goHereBlock = ^{
				FMKMapCoord startMapCoord = [FMKLocationServiceManager shareLocationServiceManager].currentMapCoord;
				FMKMapCoord endMapCoord = FMKMapCoordMake(model.mid.intValue, FMKGeoCoordMake(model.gid, FMKMapPointMake(model.x, model.y)));
				BOOL result = [naviTool naviAnalyseByStartMapCoord:startMapCoord endMapCoord:endMapCoord];
                if (!result) return;
//				naviTool.planNavi = YES;
				naviTool.endName = model.name;
				
				if ([model.mid isEqualToString:@(kOutdoorMapID).stringValue])
				{
					for (UIViewController * mapVC in myself.navigationController.viewControllers)
					{
						if ([mapVC isKindOfClass:[MapViewController class]])
						{
							[myself.navigationController popToViewController:mapVC animated:YES];
							break;
						}
					}
				}
				else
				{
					[myself testIndoorIsExistByDBModel:model];
				}
			};
			return cell;
		}
	}
	else if (tableView == self.searchResultTabelView)
	{
		static NSString * identifier = @"searchResult";
		HistoryRecordCell  * cell;
		cell = [tableView dequeueReusableCellWithIdentifier:identifier];
		if (!cell) {
			cell = [[NSBundle mainBundle] loadNibNamed:@"HistoryRecordCell" owner:nil options:nil][0];
		}
		QueryDBModel * model = _displayResult[indexPath.row];
		cell.titleLabel.text = model.name;
		[self resetSizeWithCellTypeNameLabel:cell.typeNameLabel withContent:model.name];
		cell.typeNameLabel.text = model.typeName;
		cell.positionLabel.text = [NSString stringWithFormat:@"·%@",model.address];
		cell.goHereButton.hidden = YES;
		return cell;
	}
	return nil;
}

- (void)resetSizeWithCellTypeNameLabel:(UILabel *)label withContent:(NSString *)content
{
	NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:13]};
	CGRect rect = label.frame;
	CGSize size = [content sizeWithAttributes:attrs];
	label.frame = CGRectMake(rect.origin.x, rect.origin.y, size.width+2, rect.size.height);
	label.text = content;
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
#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	if (tableView == self.tableView) {
		HeadView * view = [HeadView headView];
		view.frame = CGRectMake(0, 0, kScreenWidth, 50);
		return view;
	}
	return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	if (tableView == self.tableView) {
		return 0;
	}
	return 0.000001f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return 0.0f;
    }
    else if(tableView == self.historyTableView)
	{
		if (_historyRecord.count>0) {
			return kFooterViewHeight;
		}
        return 0;
    }
	else if (tableView == self.searchResultTabelView)
	{
		if (_searchResult.count>_displayResult.count) {
			return kFooterViewHeight;
		}
	}
	return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) {
        return kCellHeight;
    }
    else
	{
        return kHistoryCellHeight;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	if (tableView == self.historyTableView) {
		if ([_historyRecord[indexPath.row] isKindOfClass:[NSString class]]) {
			
			[UIView showWithView:self.searchResultTabelView];
			
			NSString * searchText = _historyRecord[indexPath.row];
			
			[self queryModelByText:searchText];
		}
		else
		{
			QueryDBModel * model = _historyRecord[indexPath.row];
			[self addSelectedRecord:model];
			[self didSelectedCellToMapViewByModel:model];
		}
	}
	else if (tableView == self.searchResultTabelView)
	{
		QueryDBModel * model = _displayResult[indexPath.row];
		[self addSelectedRecord:model];
		[self didSelectedCellToMapViewByModel:model];
	}
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
	if (tableView == self.historyTableView) {
		if (_historyRecord.count>0) {
			UIButton * clearAll = [UIButton buttonWithType:UIButtonTypeCustom];
			clearAll.frame = CGRectMake(0, 0, 100, 30);
			[clearAll setTitle:@"清除历史记录" forState:UIControlStateNormal];
			[clearAll setTitleColor:[UIColor colorWithRed:135/255.0 green:191/255.0 blue:163/255.0 alpha:1.0] forState:UIControlStateNormal];
			[clearAll addTarget:self action:@selector(clearAll:) forControlEvents:UIControlEventTouchUpInside];
			return clearAll;
		}
	}
	else if (tableView == self.searchResultTabelView)
	{
		if (_searchResult.count>_displayResult.count) {
			UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
			button.frame = CGRectMake(0, 0, kScreenWidth, 30);
			[button setTitle:@"查看更多搜索结果" forState:UIControlStateNormal];
			UIColor * textColor = [UIColor colorWithRed:88/255.0 green:168/255.0 blue:117/255.0 alpha:1.0f];
			[button setTitleColor:textColor forState:UIControlStateNormal];
			[button addTarget:self action:@selector(updateData) forControlEvents:UIControlEventTouchUpInside];
			return button;
		}
		return nil;
	}
	return nil;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.textField endEditing:YES];
	
	UITableView *tableview = (UITableView *)scrollView;
	if (tableview == self.historyTableView) {
		CGFloat sectionHeaderHeight = 0;
		CGFloat sectionFooterHeight = kFooterViewHeight;
		CGFloat offsetY = tableview.contentOffset.y;
		if (offsetY >= 0 && offsetY <= sectionHeaderHeight)
		{
			tableview.contentInset = UIEdgeInsetsMake(-offsetY, 0, -sectionFooterHeight, 0);
		}else if (offsetY >= sectionHeaderHeight && offsetY <= tableview.contentSize.height - tableview.frame.size.height - sectionFooterHeight)
		{
			tableview.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, -sectionFooterHeight, 0);
		}else if (offsetY >= tableview.contentSize.height - tableview.frame.size.height - sectionFooterHeight && offsetY <= tableview.contentSize.height - tableview.frame.size.height)
		{
			tableview.contentInset = UIEdgeInsetsMake(-offsetY, 0, -(tableview.contentSize.height - tableview.frame.size.height - sectionFooterHeight), 0);
		}
	}
}

#pragma mark - BaseCollectionViewDelegate
- (void)baseCollectionView:(BaseCollectionView *)collectionView didSelectedItemAtIndexPath:(NSIndexPath *)indexPath {
	NSDictionary * content = self.typeArray[indexPath.row];
	NSString * typeName = content[@"text"];
	[self queryByTypeName:typeName];
	[UIView showWithView:self.searchResultTabelView];
}

- (void)getSearchResult:(NSArray *)resultArray {
	for (FMKExternalModelSearchResult* result in resultArray) {
		if (![self.muResultArray containsObject:resultArray]) {
			[self.muResultArray addObject:result];
		}
	}
	
    [self.historyTableView reloadData];
}

//清除历史记录
- (void)clearAll:(UIButton *)button
{
	[_historyRecord removeAllObjects];
	
	[[DBSearchTool shareDBSearchTool] deleteAllHistory];
	
	self.historyTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
	
	[self.historyTableView reloadData];
}

#pragma  block
//增加搜索记录
- (void)addSearchRecord:(NSString *)text
{
	if(![[DBSearchTool shareDBSearchTool] containSearchRecord:text])
	{
		[[DBSearchTool shareDBSearchTool] insertSearchHistory:text];
	}
	[self updateDataSource];
}
//增加选中模型记录
- (void)addSelectedRecord:(QueryDBModel *)result
{
	if (![[DBSearchTool shareDBSearchTool] containModel:result]) {
		[[DBSearchTool shareDBSearchTool] insertHistoryRecord:result];
	}
	[self updateDataSource];
}

//更新dataSource
- (void)updateDataSource
{
	[_historyRecord removeAllObjects];
	
	NSArray * arr = [[DBSearchTool shareDBSearchTool] getAllSearchRecord];
	NSArray * arr1 = [[DBSearchTool shareDBSearchTool] getAllSearchModel];
	if (arr) {
		[_historyRecord addObjectsFromArray:arr];
	}
	if (arr1) {
		[_historyRecord addObjectsFromArray:arr1];
	}
	
	[self.historyTableView reloadData];
}
//根据搜索框内容搜索
- (void)queryModelByText:(NSString *)text
{
	NSArray * arr = [[DBSearchTool shareDBSearchTool] queryByKeyWord:text];
	[_searchResult removeAllObjects];
	arr = [self sortBySerachResult:arr];
	[_searchResult addObjectsFromArray:arr];

	if (_searchResult.count>kDisplayCount) {
		for (int i = 0; i<kDisplayCount; i++) {
			[_displayResult addObject:_searchResult[i]];
		}
	}
	else
	{
		[_displayResult addObjectsFromArray:arr];
	}
	[self.searchResultTabelView reloadData];
}
//根据typeName搜索
- (void)queryByTypeName:(NSString *)typeName
{
	NSArray * results = [[DBSearchTool shareDBSearchTool] queryByTypeName:typeName];
	[_searchResult removeAllObjects];
	results = [self sortBySerachResult:results];
	[_searchResult addObjectsFromArray:results];
	if (_searchResult.count>kDisplayCount) {
		[_displayResult removeAllObjects];
		for (int i = 0; i<kDisplayCount; i++) {
			[_displayResult addObject:_searchResult[i]];
		}
	}
	else
	{
		[_displayResult addObjectsFromArray:results];
	}
	self.textField.text = typeName;
	
	[self.searchResultTabelView reloadData];
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

//加载更多
- (void)updateData
{
	[_displayResult removeAllObjects];
	[_displayResult addObjectsFromArray:_searchResult];
	[self clearFooterView];
	[self.searchResultTabelView reloadData];
}
- (void)clearFooterView
{
	UIView * view = [[UIView alloc] init];
	view.backgroundColor = [UIColor clearColor];
	self.searchResultTabelView.tableFooterView = view;
}
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self updateDataSource];
	[[FMLocationManager shareLocationManager] setMapView:nil];
    for (UIViewController *viewController in self.navigationController.viewControllers)
    {
        if ([viewController isKindOfClass:[MapViewController class]])
        {
            MapViewController *map = (MapViewController *)viewController;
            [map.centerVC.navigationController setNavigationBarHidden:YES animated:YES];
            [self.navigationController setNavigationBarHidden:NO animated:YES];
        }
    }
}
- (void)viewWillDisappear:(BOOL)animated {
//	[self.navigationController setNavigationBarHidden:YES animated:NO];
	[super viewWillDisappear:animated];
	[self resignFirstResponder];
}
//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    BOOL hideNav = NO;
//    if ([viewController isKindOfClass:[self class]])
//    {
//        hideNav = YES;
//    }
//    else
//    {
//        hideNav = NO;
//    }
//    
//    for (UIViewController *viewController in navigationController.viewControllers)
//    {
//        if ([viewController isKindOfClass:[MapViewController class]])
//        {
//            MapViewController *map = (MapViewController *)viewController;
//            [map.centerVC.navigationController setNavigationBarHidden:hideNav animated:YES];
//            map.centerVC.hotelNameButton.hidden = hideNav;
//            [self.navigationController setNavigationBarHidden:NO animated:YES];
//        }
//    }
//}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}
@end
