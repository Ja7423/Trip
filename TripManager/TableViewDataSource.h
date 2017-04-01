//
//  TableViewDataSource.h
//  TripManager
//
//  Created by 何家瑋 on 2017/3/8.
//  Copyright © 2017年 何家瑋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Header.h"

@class TableViewDataSource;
@protocol CustomDataSourceDelegate <NSObject>

@required
- (BOOL)TableViewDataSource:(TableViewDataSource *)tableViewDataSource canEditRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)TableViewDataSource:(TableViewDataSource *)tableViewDataSource commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forDataItem:(DataItem *)editItem;

@end


@class DataModel;
@interface TableViewDataSource : NSObject <UITableViewDataSource>

@property (weak, nonatomic) id <CustomDataSourceDelegate> delegate;

@property (nonatomic) DataModel * dataModel;

#pragma mark - public
- (instancetype)initWithDataModel:(DataModel *)dataModel CellIdentifier:(NSString *)identifier configureCellBlock:(TableViewCellConfigureBlock)configureCellBlock;

- (id)didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

- (BOOL)isContainThisData:(DataItem *)item;

#pragma mark - update
- (void)updateTableView:(UITableView *)tableView cellOrderFromGesture:(UIGestureRecognizer *)gesture;

- (void)updateTableView:(UITableView *)tableView fromNewDataModel:(DataModel *)newDataModel;

- (void)insertTableView:(UITableView *)tableView newDataItem:(DataItem *)newItem;

- (void)updateTableView:(UITableView *)tableView newDataItem:(DataItem *)newItem atIndexPath:(NSIndexPath *)indexPath;

- (DataItem *)deleteTableView:(UITableView *)tableView dataItemAtIndexPath:(NSIndexPath *)indexPath;

@end
