//
//  DataOperation.m
//  TripManager
//
//  Created by 何家瑋 on 2017/3/2.
//  Copyright © 2017年 何家瑋. All rights reserved.
//

#import "DataOperation.h"

@interface DataOperation () <DownloadManagerDelegate>
{
        DownloadManager * _downloadManager;
        DownloadSource * _downloadSource;
        FileManager * _fileManager;
        
        NSMutableArray<DownloadRequest *> * _downloadRequest;
}

@end

@implementation DataOperation

- (instancetype)init
{
        self = [super init];
        
        if (self)
        {
                _downloadSource = [[DownloadSource alloc]init];
                _fileManager = [[FileManager alloc]init];
                _downloadManager = [[DownloadManager alloc]init];
                _downloadManager.delegate = self;
        }
        
        return self;
}

#pragma mark - public
- (void)startDownloadDataBase
{
        // check if need download
        [self isNeedUpdateDatabase:^(BOOL needUpdate) {
                
                if (needUpdate)
                {
                        NSLog(@"startDownloadDataBase");
                        _downloadManager.requests = [_downloadManager prepareDownloadRequest:_downloadSource.downloadList];
                        [_downloadManager startDownload];
                }
                else
                {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"finishUpdate" object:nil];
                }
        }];
}

- (void)startDownloadDataBaseWhenReceiveNotification
{
        // check if need download
        [self isNeedUpdateDatabaseWhenReceiveNotification:^(BOOL needUpdate) {
                
                if (needUpdate)
                {
                        NSLog(@"startDownloadDataBase");
                        _downloadManager.requests = [_downloadManager prepareDownloadRequest:_downloadSource.downloadList];
                        [_downloadManager startDownload];
                }
        }];
}

#pragma mark search
- (void)querySearchDataFromTable:(NSString *)table where:(NSArray *)columns value:(NSString *)condition completion:(void (^) (NSArray *))completion
{
        NSMutableArray * tempArray = [NSMutableArray array];
        NSMutableArray * data = [NSMutableArray array];
        [[DataBase sharedDataBase] querySearchDataFromTable:table where:columns value:condition completion:^(FMResultSet *resultSet) {
                
                while ([resultSet next])
                {
                        [tempArray addObject:[self processQueryResult:resultSet]];
                }
                
                if (completion)
                {
                        [data addObject:tempArray];
                        completion(data);
                }
        }];
}

#pragma mark schedule
- (void)queryScheduleDataFromTable:(NSString *)table where:(NSString *)column value:(NSString *)condition completion:(void (^) (NSArray *))completion
{
        NSMutableArray * tempArray = [NSMutableArray array];
        NSMutableArray * data = [NSMutableArray array];
        NSArray * dataBaseTable = [DownloadSource new].baseTable;
        NSMutableArray * tableConditions = [NSMutableArray array];
        NSMutableArray * dataBaseTableConditions = [NSMutableArray array];
        [dataBaseTable enumerateObjectsUsingBlock:^(NSString * baseTable, NSUInteger idx, BOOL * _Nonnull stop) {
                
                NSString * tableCondition = [NSString stringWithFormat:@"%@.Id", table];
                [tableConditions addObject:tableCondition];
                
                NSString * dataBaseTableCondition = [NSString stringWithFormat:@"%@.Id", baseTable];
                [dataBaseTableConditions addObject:dataBaseTableCondition];
        }];
        
        [[DataBase sharedDataBase] queryScheduleDataFromTable:table innerJoin:dataBaseTable on:tableConditions equalTo:dataBaseTableConditions where:column equalValue:condition completion:^(NSArray *resultSets) {
                
                [resultSets enumerateObjectsUsingBlock:^(FMResultSet * resultSet, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        while ([resultSet next])
                        {
                                [tempArray addObject:[self processQueryResult:resultSet]];
                        }
                }];
                
                if (completion)
                {
                        [data addObject:tempArray];
                        completion(data);
                }
        }];
}

- (void)queryScheduleFileData:(NSArray *)queryDatas completion:(void (^) (NSArray *))completion
{
        NSMutableArray * tempArray = [NSMutableArray array];
        NSMutableArray * data = [NSMutableArray array];
        NSArray * queryTables = [[DownloadSource alloc]init].baseTable;
        
        [[DataBase sharedDataBase] queryScheduleFileData:queryDatas FromTable:queryTables completion:^(NSArray *resultSets) {
                
                [resultSets enumerateObjectsUsingBlock:^(FMResultSet * resultSet, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        while ([resultSet next])
                        {
                                [tempArray addObject:[self processQueryResult:resultSet]];
                        }
                }];
                
                if (completion)
                {
                        [data addObject:tempArray];
                        completion(data);
                }
        }];
}

- (void)insertData:(DataItem *)items intoScheduleTable:(NSString *)table
{
        [[DataBase sharedDataBase] insertData:items intoScheduleTable:table];
}

- (void)updateData:(NSArray *)items intoScheduleTable:(NSString *)table
{
        [[DataBase sharedDataBase] updateData:items intoScheduleTable:table];
}

- (void)deleteData:(DataItem *)item fromScheduleTable:(NSString *)table
{
        [[DataBase sharedDataBase] deleteData:item fromScheduleTable:table];
}


#pragma mark - private
- (void)isNeedUpdateDatabase:(void (^) (BOOL needUpdate))completion
{
        AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        NSString * currentDate = [NSDate stringFromDate:[NSDate date]];
        NSString * lastUpdateDate = [[NSUserDefaults standardUserDefaults]objectForKey:@lastUpdateDateKey];
        __block BOOL needUpdate = YES;
        
        // for first time launch
        if (![[NSUserDefaults standardUserDefaults]boolForKey:@hasLaunchedOnceKey])
        {
                if (completion)
                {
                        completion(needUpdate);
                }
        }
        else
        {
                // if not first time launch and notification is unable
                [appDelegate notificationAuthStatus:^(BOOL notificationEnable) {
                        
                        if (![currentDate isEqualToString:lastUpdateDate] && !notificationEnable)
                        {
                                needUpdate = YES;
                        }
                        else
                        {
                                needUpdate = NO;
                        }
                        
                        if (completion)
                        {
                                completion(needUpdate);
                        }
                }];
        }
}

- (void)isNeedUpdateDatabaseWhenReceiveNotification:(void (^) (BOOL needUpdate))completion
{
        NSString * currentDate = [NSDate stringFromDate:[NSDate date]];
        NSString * lastUpdateDate = [[NSUserDefaults standardUserDefaults]objectForKey:@lastUpdateDateKey];
        BOOL needUpdate = YES;
        
        if ([currentDate isEqualToString:lastUpdateDate])
        {
                needUpdate = NO;
        }
        else
        {
                needUpdate = YES;
        }
        
        if (completion)
        {
                completion(needUpdate);
        }
}

- (DataItem *)processQueryResult:(FMResultSet *)result
{
        DataItem * item = [[DataItem alloc]init];
        
        for (int index = 0; index < result.columnCount; index++) {
                NSString * columnName = [result columnNameForIndex:index];
                NSString * columnValue = [result stringForColumn:columnName];
                
                [item setValue:columnValue forKey:columnName];
        }
        
        return item;
}

#pragma mark - DownloadManagerDelegate
- (void)downloadManager:(DownloadManager *)manager didFinishDownload:(NSArray<DownloadRequest *> *)requests
{
        [[DataBase sharedDataBase] updateDataBaseWithRequests:requests];
        
        NSString * updateDate = [NSDate stringFromDate:[NSDate date]];
        [[NSUserDefaults standardUserDefaults] setObject:updateDate forKey:@lastUpdateDateKey];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@hasLaunchedOnceKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"finishUpdate" object:nil];
}

@end
