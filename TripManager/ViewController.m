//
//  ViewController.m
//  TripManager
//
//  Created by 何家瑋 on 2017/2/17.
//  Copyright © 2017年 何家瑋. All rights reserved.
//

#import "ViewController.h"
#import "Header.h"

@interface ViewController () <ScheduleTableViewGestureDelegate, UITableViewDelegate, FSCalendarDelegate, FSCalendarDataSource, CommunicateDelegate, CustomDataSourceDelegate>
{
        DataOperation * _dataOperation;
        TableViewDataSource * _tableViewDataSource;
        DataModel * _dataModel;
        SearchViewController * _searchVC;
        DetailViewController * _detailVC;
}

@property (nonatomic) BOOL showIndicator;
@property (nonatomic) NSIndexPath * didSelectIndexPath;

@property (nonatomic) FSCalendar * calendar;
@property (nonatomic) UIView * containerView;
@property (nonatomic) UIActivityIndicatorView * activityIndicatorView;

//@property (nonatomic) ScheduleTableView * scheduleTableView;
@property (weak, nonatomic) IBOutlet ScheduleTableView *scheduleTableView;

@end

@implementation ViewController

- (void)viewDidLoad {
        [super viewDidLoad];
        // Do any additional setup after loading the view, typically from a nib.

        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didFinishUpdateDatabase) name:@"finishUpdate" object:nil];
        
        [self configureNavigationController];
        [self configureNavigationItem];
        [self configureTableView];
        [self configureCalendar];
        [self updateNavigationTitle:[NSDate stringFromDate:[NSDate date]]];
        
        _dataOperation = [[DataOperation alloc]init];
        [_dataOperation startDownloadDataBase];
}

- (void)didReceiveMemoryWarning {
        [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
        [self updateScheduleTable];
}

#pragma mark - initialize
- (void)configureNavigationController
{
        // navigationBar setting
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
        self.navigationController.navigationBar.translucent = YES;
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)configureNavigationItem
{
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"calendar" style:UIBarButtonItemStylePlain target:self action:@selector(showCalendar)];
        
        _activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_activityIndicatorView sizeToFit];
        [_activityIndicatorView startAnimating];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_activityIndicatorView];
}

- (void)configureTableView
{
        _dataModel = [[DataModel alloc]init];
        _tableViewDataSource = [[TableViewDataSource alloc]initWithDataModel:_dataModel CellIdentifier:@scheduleTableViewCellReuseIdentifier configureCellBlock:[self configureTableViewCellBlock]];
        _tableViewDataSource.delegate = self;
        
        _scheduleTableView.allowUserModifyCellOrder = YES;
        _scheduleTableView.gestureDelegate = self;
        _scheduleTableView.dataSource = _tableViewDataSource;
        _scheduleTableView.delegate = self;
}

- (TableViewCellConfigureBlock)configureTableViewCellBlock
{
        TableViewCellConfigureBlock cellBlock = ^(ScheduleTableViewCell * cell, DataItem * item) {
                
                [cell configureCell:item];
        };
        
        return cellBlock;
}

- (void)configureCalendar
{
        _calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 300)];
        _calendar.dataSource = self;
        _calendar.delegate = self;
        _calendar.backgroundColor = [UIColor whiteColor];
        _calendar.appearance.headerMinimumDissolvedAlpha = 0;
        _calendar.placeholderType = FSCalendarPlaceholderTypeNone;
        _calendar.appearance.caseOptions = FSCalendarCaseOptionsHeaderUsesUpperCase;
        
        _containerView = [[UIView alloc]initWithFrame:self.view.frame];
        _containerView.alpha = 0.5;
        _containerView.backgroundColor = [UIColor grayColor];
}

#pragma mark - notification
- (void)didFinishUpdateDatabase
{
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        
        [self queryDataOnSpecificDate:[NSDate stringFromDate:[NSDate date]]];
}

#pragma mark - button Action
- (void)showCalendar
{
        if ([_calendar isDescendantOfView:self.view])
        {
                // close calendar view
                [_containerView removeFromSuperview];
                [_calendar removeFromSuperview];
        }
        else
        {
                // show calendar view
                [self.view addSubview:_containerView];
                [self.view addSubview:_calendar];
        }
}

- (void)search
{
        _searchVC = [[SearchViewController alloc]init];
        _searchVC.delegate = self;
        [self.navigationController pushViewController:_searchVC animated:YES];
}

#pragma mark - data operation
- (void)queryDataOnSpecificDate:(NSString *)stringDate
{
        // change right barButtonItem
        self.showIndicator = YES;
        
        __weak typeof(self) weakSelf = self;
        [_dataOperation queryScheduleDataFromTable:@"schedule" where:@"Date" value:stringDate completion:^(NSMutableArray *result) {
                
                [weakSelf updateDataSource:result];
                
                // change back
                self.showIndicator = NO;
        }];
}

- (void)updateDataSource:(NSMutableArray *)newData
{
        NSArray * sortArray = [self sortDataByOrderIndex:newData];
        _dataModel = [[DataModel alloc]initWithQueryData:sortArray];
        [_tableViewDataSource updateTableView:_scheduleTableView fromNewDataModel:_dataModel];
}

- (void)updateScheduleTable
{
        NSArray * tableViewData = [NSArray arrayWithArray:_tableViewDataSource.dataModel.dataArray];
        [_dataOperation updateData:tableViewData intoScheduleTable:@"schedule"];
}

- (void)insertScheduleTable:(DataItem *)item
{
        item.Date = self.navigationItem.title;
        [_dataOperation insertData:item intoScheduleTable:@"schedule"];
}

- (NSArray *)sortDataByOrderIndex:(NSMutableArray *)data
{
        NSMutableArray * sortArray = [NSMutableArray array];
        [data enumerateObjectsUsingBlock:^(NSMutableArray * sectionArray, NSUInteger idx, BOOL * _Nonnull stop) {
                
                for (NSInteger i = 0; i < sectionArray.count; i++)
                {
                        for (NSInteger j = 0; j < sectionArray.count - 1; j++)
                        {
                                DataItem * item = sectionArray[j];
                                DataItem * item2 = sectionArray[j + 1];
                                
                                if (item.OrderIndex.integerValue > item2.OrderIndex.integerValue)
                                {
                                        sectionArray[j] = item2;
                                        sectionArray[j + 1] = item;
                                }
                        }
                }
                
                [sortArray addObject:sectionArray];
        }];
        
        return sortArray;
}

#pragma mark - update Action
- (void)setShowIndicator:(BOOL)showIndicator
{
        _showIndicator = showIndicator;
        
        if (_showIndicator && !_activityIndicatorView)
        {
                [self updateNavigationRightBarButtonItemToActivityIndicator];
        }
        else if (!_showIndicator)
        {
                [self updateNavigationRightBarButtonItemToSearch];
        }
}

- (void)updateNavigationRightBarButtonItemToSearch
{
        NSLog(@"updateNavigationRightBarButtonItemToSearch");
        dispatch_async(dispatch_get_main_queue(), ^{
                
                [_activityIndicatorView removeFromSuperview];
                _activityIndicatorView = nil;
                [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(search)] animated:YES];
        });
}

- (void)updateNavigationRightBarButtonItemToActivityIndicator
{
        NSLog(@"updateNavigationRightBarButtonItemToActivityIndicator");
        dispatch_async(dispatch_get_main_queue(), ^{
                
                _activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                [_activityIndicatorView sizeToFit];
                [_activityIndicatorView startAnimating];
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_activityIndicatorView];
        });
}

- (void)updateNavigationTitle:(NSString *)title
{
        [self.navigationItem setTitle:title];
}

#pragma mark - ScheduleTableView delegate
- (void)ScheduleTableView:(ScheduleTableView *)tableView didDetectGesture:(UIGestureRecognizer *)gesture
{
        [_tableViewDataSource updateTableView:tableView cellOrderFromGesture:gesture];
}

#pragma mark - FSCalendarDelegate
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
        [_calendar removeFromSuperview];
        [_containerView removeFromSuperview];
        
        [self updateNavigationTitle:[NSDate stringFromDate:date]];
        
        // save data
        [self updateScheduleTable];
        
        // query next data
        [self queryDataOnSpecificDate:[NSDate stringFromDate:date]];
}

#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        _didSelectIndexPath = indexPath;
        DataItem * didSelectItem = [_tableViewDataSource didSelectRowAtIndexPath:_didSelectIndexPath];
        
        _detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
        _detailVC.dataItem = didSelectItem;
        _detailVC.delegate = self;
        _detailVC.enableAddButton = NO;
        
        NSLog(@"%@ (%@)", didSelectItem.Name, didSelectItem.OrderIndex);
        [self.navigationController pushViewController:_detailVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return tableView.frame.size.height / 5;
}

#pragma mark - CommunicateDelegate
- (void)viewController:(UIViewController *)viewController didInsertDataItem:(DataItem *)dataItem
{
        if ([_tableViewDataSource isContainThisData:dataItem])
        {
                // make sure no same dataItem in the same date
                NSLog(@"already exsist the same data in this date");
                return;
        }
        
        [_tableViewDataSource insertTableView:_scheduleTableView newDataItem:dataItem];
        
        [self insertScheduleTable:dataItem];
}

- (void)viewController:(UIViewController *)viewController didEditDataItem:(DataItem *)dataItem
{
        if ([_tableViewDataSource isContainThisData:dataItem])
        {
                [_tableViewDataSource updateTableView:_scheduleTableView newDataItem:dataItem atIndexPath:_didSelectIndexPath];
        }
}

#pragma mark - CustomDataSourceDelegate
- (BOOL)TableViewDataSource:(TableViewDataSource *)tableViewDataSource canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
        return YES;
}

- (void)TableViewDataSource:(TableViewDataSource *)tableViewDataSource commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forDataItem:(DataItem *)editItem
{
        [_dataOperation deleteData:editItem fromScheduleTable:@"schedule"];
        
        [self updateScheduleTable];
}

@end
