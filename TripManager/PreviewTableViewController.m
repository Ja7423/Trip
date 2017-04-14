//
//  PreviewTableViewController.m
//  TripManager
//
//  Created by 何家瑋 on 2017/4/13.
//  Copyright © 2017年 何家瑋. All rights reserved.
//

#import "PreviewTableViewController.h"

@interface PreviewTableViewController ()
{
        TableViewDataSource * _tableViewDataSource;
        DataModel * _dataModel;
        FileManager * _fileManager;
        DataOperation * _dataOperation;
        DetailViewController * _detailVC;
}

@end

@implementation PreviewTableViewController

- (void)viewDidLoad {
        [super viewDidLoad];
        
        self.navigationItem.title = @"shared schedule";
        [self configureTableViewDataSource];
}

- (void)didReceiveMemoryWarning {
        [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}

#pragma mark - configure
- (void)configureTableViewDataSource
{
        _dataModel = [[DataModel alloc]initWithQueryData:[self sortDataByOrderIndex:[self loadFile]]];
        _tableViewDataSource = [[TableViewDataSource alloc]initWithDataModel:_dataModel CellIdentifier:@previewTableViewCellReuseIdentifier configureCellBlock:[self configureTableViewCellBlock]];
        
        self.tableView.dataSource = _tableViewDataSource;
        self.tableView.delegate = self;
}

- (TableViewCellConfigureBlock)configureTableViewCellBlock
{
        TableViewCellConfigureBlock cellBlock = ^(ScheduleTableViewCell * cell, DataItem * item) {
                
                [cell configureCell:item];
        };
        
        return cellBlock;
}

#pragma mark - data operation
- (NSArray *)loadFile
{
        _dataOperation = [[DataOperation alloc]init];
        _fileManager = [[FileManager alloc]init];
        NSArray * queryArray = [_fileManager readInboxFile:_fileName];
        
        return queryArray;
}

- (NSArray *)sortDataByOrderIndex:(NSArray *)data
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


#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        DataItem * didSelectItem = [_tableViewDataSource didSelectRowAtIndexPath:indexPath];
        
        // query detail data
        [_dataOperation queryScheduleFileData:@[didSelectItem] completion:^(NSArray *result) {
                
                _detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
                _detailVC.dataItem = result[0][0];
                _detailVC.dataItem.DataItemType = didSelectItem.DataItemType;
                _detailVC.dataItem.VisitTime = didSelectItem.VisitTime;
                _detailVC.dataItem.CustomRemarks = didSelectItem.CustomRemarks;
                _detailVC.delegate = _delegate;
                _detailVC.enableAddButton = YES;
                
                [self.navigationController pushViewController:_detailVC animated:YES];
        }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return tableView.frame.size.height / 5;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
