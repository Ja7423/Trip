//
//  DataModel.h
//  TripManager
//
//  Created by 何家瑋 on 2017/2/18.
//  Copyright © 2017年 何家瑋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Header.h"

@interface DataModel : NSObject

- (instancetype)initWithQueryData:(NSArray *)data;

- (NSInteger)numberOfSection;

- (NSInteger)numberOfRowsInSection:(NSInteger)section;

- (id)dataForRowAtIndexPath:(NSIndexPath *)indexPath;

- (NSMutableArray *)dataArray;

- (void)updateDataOrderFrom:(NSIndexPath *)oldIndexPath to:(NSIndexPath *)newIndexPath;

- (void)insertData:(DataItem *)item To:(NSInteger)section;

- (void)updateData:(DataItem *)item To:(NSIndexPath *)indexPath;

- (DataItem *)deleteDataAtIndexPath:(NSIndexPath *)indexPath;

@end
