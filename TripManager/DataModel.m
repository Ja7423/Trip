//
//  DataModel.m
//  TripManager
//
//  Created by 何家瑋 on 2017/2/18.
//  Copyright © 2017年 何家瑋. All rights reserved.
//

#import "DataModel.h"

@interface DataModel ()
{
        NSMutableArray * _dataArray;
}

@end

@implementation DataModel

#pragma mark - init
- (instancetype)init
{
        self = [super init];
        
        if (self)
        {
                _dataArray = [NSMutableArray arrayWithObject:[NSMutableArray array]];
        }
        
        return self;
}

- (instancetype)initWithQueryData:(NSArray *)data
{
        self = [super init];
        
        if (self)
        {
                _dataArray = [NSMutableArray arrayWithArray:data];
        }
        
        return self;
}

#pragma mark - tableview data source
- (NSInteger)numberOfSection
{
        return _dataArray.count;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
        NSArray * data = [_dataArray objectAtIndex:section];
        return data.count;
}

- (id)dataForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return _dataArray[indexPath.section][indexPath.row];
}

- (NSMutableArray *)dataArray
{
        return _dataArray;
}

#pragma mark - data operation
- (void)insertData:(DataItem *)item To:(NSInteger)section
{
        NSMutableArray * sectionArray = _dataArray[section];
        item.OrderIndex = [NSString stringWithFormat:@"%lu", (unsigned long)sectionArray.count];
        [sectionArray addObject:item];
}

- (void)updateDataOrderFrom:(NSIndexPath *)oldIndexPath to:(NSIndexPath *)newIndexPath
{
        DataItem * oldItem = _dataArray[oldIndexPath.section][oldIndexPath.row];
        DataItem * newItem = _dataArray[newIndexPath.section][newIndexPath.row];
        
        oldItem.OrderIndex = [NSString stringWithFormat:@"%ld", (long)newIndexPath.row];
        newItem.OrderIndex = [NSString stringWithFormat:@"%ld", (long)oldIndexPath.row];
        
        _dataArray[newIndexPath.section][newIndexPath.row] = _dataArray[oldIndexPath.section][oldIndexPath.row];
        _dataArray[oldIndexPath.section][oldIndexPath.row] = newItem;
}

- (void)updateData:(DataItem *)item To:(NSIndexPath *)indexPath
{
        NSMutableArray * sectionArray = _dataArray[indexPath.section];
        [sectionArray replaceObjectAtIndex:indexPath.row withObject:item];
}

- (DataItem *)deleteDataAtIndexPath:(NSIndexPath *)indexPath
{
        NSMutableArray * sectionArray = _dataArray[indexPath.section];
        DataItem * shouldDeleteItem = sectionArray[indexPath.row];
        [sectionArray removeObjectAtIndex:indexPath.row];
        
        // update OrderIndex
        [sectionArray enumerateObjectsUsingBlock:^(DataItem * item, NSUInteger idx, BOOL * _Nonnull stop) {
                item.OrderIndex = [NSString stringWithFormat:@"%ld", (long)idx];
        }];
        
        return shouldDeleteItem;
}

@end
