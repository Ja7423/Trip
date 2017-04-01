//
//  DataOperation.h
//  TripManager
//
//  Created by 何家瑋 on 2017/3/2.
//  Copyright © 2017年 何家瑋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Header.h"

@interface DataOperation : NSObject

- (void)startDownloadDataBase;
- (void)startDownloadDataBaseWhenReceiveNotification;

#pragma mark - search search
- (void)querySearchDataFromTable:(NSString *)table where:(NSArray *)columns value:(NSString *)condition completion:(void (^) (NSArray * result))completion;

#pragma mark - schedule table
- (void)queryScheduleDataFromTable:(NSString *)table where:(NSString *)column value:(NSString *)condition completion:(void (^) (NSMutableArray * result))completion;

- (void)insertData:(DataItem *)items intoScheduleTable:(NSString *)table;

- (void)updateData:(NSArray *)items intoScheduleTable:(NSString *)table;

- (void)deleteData:(DataItem *)item fromScheduleTable:(NSString *)table;

@end
