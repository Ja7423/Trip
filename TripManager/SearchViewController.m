//
//  SearchViewController.m
//  TripManager
//
//  Created by 何家瑋 on 2017/2/21.
//  Copyright © 2017年 何家瑋. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController () <UISearchBarDelegate, UISearchResultsUpdating, UITableViewDelegate>
{
        TableViewDataSource * _tableViewDataSource;
        DataOperation * _dataOperation;
        DataModel * _dataModel;
        
        DetailViewController * _detailVC;
}

@property (nonatomic) UISearchController * searchController;
@property (nonatomic) UITableView * resultTableView;
@property (nonatomic) UISegmentedControl * customizeSegmentedControl;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
        [self configureTableView];
        [self configureSegmentedControl];
        [self configureSearchController];
        
        _dataOperation = [[DataOperation alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureSegmentedControl
{
        DownloadSource * source = [[DownloadSource alloc]init];
        _customizeSegmentedControl = [[UISegmentedControl alloc]initWithItems:source.baseTable];
        _customizeSegmentedControl.selectedSegmentIndex = 0;
        [_customizeSegmentedControl sizeToFit];
        
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:_customizeSegmentedControl];
        self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)configureSearchController
{
        _searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
        _searchController.searchBar.placeholder = @"請輸入地點或名稱";
        _searchController.dimsBackgroundDuringPresentation = false;
        _searchController.searchResultsUpdater = self;
        _searchController.searchBar.delegate = self;
        [_searchController.searchBar sizeToFit];
        _resultTableView.tableHeaderView = _searchController.searchBar;
}

- (void)configureTableView
{
        _dataModel = [[DataModel alloc]init];
        _tableViewDataSource = [[TableViewDataSource alloc]initWithDataModel:_dataModel CellIdentifier:@searchTableViewCellReuseIdentifier configureCellBlock:[self configureTableViewCellBlock]];
        
        _resultTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _resultTableView.dataSource = _tableViewDataSource;
        _resultTableView.delegate = self;
        [_resultTableView registerClass:[SearchTableViewCell class] forCellReuseIdentifier:@searchTableViewCellReuseIdentifier];
        [self.view addSubview:_resultTableView];
}

- (TableViewCellConfigureBlock)configureTableViewCellBlock
{
        TableViewCellConfigureBlock cellBlock = ^(SearchTableViewCell * cell, DataItem * item) {
                
                cell.textLabel.text = item.Name;
        };
        
        return cellBlock;
}

#pragma mark - search bar delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
        NSString * searchText = searchBar.text;
        _searchController.active = NO;
        _searchController.searchBar.text = searchText;
        
        [self queryData:searchText];
}

#pragma mark - UISearchResultsUpdating delegate
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
        // not use right now
}

#pragma mark - data update
- (void)queryData:(NSString *)condition
{
        __weak typeof(self) weakSelf = self;
        [_dataOperation querySearchDataFromTable:[_customizeSegmentedControl titleForSegmentAtIndex:_customizeSegmentedControl.selectedSegmentIndex] where:@[@"Address", @"Name", @"Keyword"] value:condition completion:^(NSArray *result) {
                
                [weakSelf updateDataSource:result];
        }];
}

- (void)updateDataSource:(NSArray *)newData
{
        _dataModel = [[DataModel alloc]initWithQueryData:newData];
        [_tableViewDataSource updateTableView:_resultTableView fromNewDataModel:_dataModel];
}

#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        DataItem * didSelectItem = [_tableViewDataSource didSelectRowAtIndexPath:indexPath];
        
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        _detailVC = [storyBoard instantiateViewControllerWithIdentifier:@"DetailViewController"];
        _detailVC.delegate = _delegate;
        _detailVC.dataItem = didSelectItem;
        _detailVC.dataItem.DataItemType = [NSString stringWithFormat:@"%ld", (long)_customizeSegmentedControl.selectedSegmentIndex];
        _detailVC.enableAddButton = YES;
        [self.navigationController pushViewController:_detailVC animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
