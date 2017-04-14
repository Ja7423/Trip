//
//  DataBase.h
//  TripManager
//
//  Created by 何家瑋 on 2017/2/23.
//  Copyright © 2017年 何家瑋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Header.h"
#import <FMDB.h>

@interface DataBase : NSObject

+ (DataBase *)sharedDataBase;

#pragma mark - update data base
- (void)updateDataBaseWithRequests:(NSArray *)requests;

#pragma mark - search query 
- (void)querySearchDataFromTable:(NSString *)table where:(NSArray *)columns value:(NSString *)condition completion:(void (^) (FMResultSet * resultSet))completion;

#pragma mark - schedule table
- (void)queryScheduleDataFromTable:(NSString *)table innerJoin:(NSArray *)dataBaseTables on:(NSArray *)tableConditions equalTo:(NSArray *)dataBaseTableConditions where:(NSString *)column equalValue:(NSString *)condition completion:(void (^) (NSArray * resultSets))completion;

- (void)queryScheduleFileData:(NSArray *)queryDatas FromTable:(NSArray *)tables completion:(void (^) (NSArray * resultSets))completion;

- (void)insertData:(DataItem *)item intoScheduleTable:(NSString *)table;

- (void)updateData:(NSArray *)items intoScheduleTable:(NSString *)table;

- (void)deleteData:(DataItem *)item fromScheduleTable:(NSString *)table;

@end
