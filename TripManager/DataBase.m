//
//  DataBase.m
//  TripManager
//
//  Created by 何家瑋 on 2017/2/23.
//  Copyright © 2017年 何家瑋. All rights reserved.
//

#import "DataBase.h"

@interface DataBase ()
{
        FMDatabaseQueue * _dataBaseQueue;
}


@end

static DataBase * _dataBase = nil;

@implementation DataBase

+ (DataBase *)sharedDataBase
{
        if (!_dataBase)
        {
                _dataBase = [[DataBase alloc]init];
        }
        
        return _dataBase;
}

- (instancetype)init
{
        self = [super init];
        
        if (self)
        {
                [self loadDataBase];
        }
        
        return self;
}

#pragma mark - public
- (void)updateDataBaseWithRequests:(NSArray *)requests
{
        FileManager * _fileManager = [[FileManager alloc]init];
        __weak typeof(self) weakSelf = self;
        
        NSLog(@"====== updateDataBaseWithRequests5 ======");
        [_dataBaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
                NSLog(@"start transaction (%@)", [NSThread currentThread]);
                for (DownloadRequest * request in requests)
                {
                        NSLog(@"file : %@", request.fileName);
                        NSArray * dataItems = [_fileManager readJSONFile:request.response.fileURL];
                        
                        [weakSelf DB:db dropTableIfExisit:request.tableName];
                        [weakSelf DB:db createTableIfNotExisit:request.tableName];
                        [weakSelf DB:db tableCount:request.tableName];
                        
                        [dataItems enumerateObjectsUsingBlock:^(DataItem * item, NSUInteger idx, BOOL * _Nonnull stop) {
                                
                                [weakSelf DB:db insert:item intoTable:request.tableName];
                        }];
                        
                        [weakSelf DB:db tableCount:request.tableName];
                }
                
        }];
        
        NSLog(@"====== end updateDataBaseWithRequests5 ======");
}


#pragma mark search
- (void)querySearchDataFromTable:(NSString *)table where:(NSArray *)columns value:(NSString *)condition completion:(void (^) (FMResultSet *))completion
{
        __weak typeof(self) weakSelf = self;
        [_dataBaseQueue inDatabase:^(FMDatabase *db) {
                NSLog(@"querySearchDataFromTable (%@)", [NSThread currentThread]);
                FMResultSet * result = [weakSelf DB:db selectFrom:table where:columns like:condition];
                
                if (completion && result)
                {
                        completion(result);
                }
        }];
}



#pragma mark schedule
- (void)queryScheduleDataFromTable:(NSString *)table innerJoin:(NSArray *)dataBaseTables on:(NSArray *)tableConditions equalTo:(NSArray *)dataBaseTableConditions where:(NSString *)column equalValue:(NSString *)condition completion:(void (^) (NSArray *))completion
{
        NSMutableArray * resultSets = [NSMutableArray array];
        __weak typeof(self) weakSelf = self;
        [_dataBaseQueue inDatabase:^(FMDatabase *db) {
                NSLog(@"queryScheduleDataFromTable (%@)", [NSThread currentThread]);
                [dataBaseTables enumerateObjectsUsingBlock:^(NSString * baseTable, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        FMResultSet * result = [weakSelf DB:db selectFrom:table innerJoin:baseTable  on:tableConditions[idx] equalTo:dataBaseTableConditions[idx] where:column equalValue:condition];
                        
                        [resultSets addObject:result];
                }];
                
                if (completion)
                {
                        completion(resultSets);
                }
        }];
}

- (void)insertData:(DataItem *)item intoScheduleTable:(NSString *)table
{
        __weak typeof(self) weakSelf = self;
        [_dataBaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
                
                [weakSelf DB:db insert:item intoScheduleTable:table];
        }];
}

- (void)updateData:(NSArray *)items intoScheduleTable:(NSString *)table
{
        __weak typeof(self) weakSelf = self;
        [_dataBaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
                
                [items enumerateObjectsUsingBlock:^(NSArray * sectionArray, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        [sectionArray enumerateObjectsUsingBlock:^(DataItem * item, NSUInteger idx, BOOL * _Nonnull stop) {
                                
                                [weakSelf DB:db update:item intoScheduleTable:table where:item.Id];
                        }];
                }];
        }];
}

- (void)deleteData:(DataItem *)item fromScheduleTable:(NSString *)table
{
        __weak typeof(self) weakSelf = self;
        [_dataBaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
                
                [weakSelf DB:db deleteFrom:table where:@"Id" equalValue:item.Id and:@"Date" equalValue:item.Date];
        }];
}

#pragma mark - private
- (void)loadDataBase
{
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
        
        NSString *dbPath = [documentPath stringByAppendingPathComponent:@"database.sqlite"];
        
        _dataBaseQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
        
        if (_dataBaseQueue.openFlags)
        {
                [self createBaseTable];
        }
}

- (void)createBaseTable
{
        __weak typeof(self) weakSelf = self;
        DownloadSource * _downloadSource = [[DownloadSource alloc]init];
        NSArray * tables = _downloadSource.baseTable;
        
        [_dataBaseQueue inDatabase:^(FMDatabase *db) {
            
                [tables enumerateObjectsUsingBlock:^(NSString * table, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        [weakSelf DB:db createTableIfNotExisit:table];
                }];
                
                [weakSelf DB:db createScheduleTableIfNotExisit:@"schedule"];
        }];
}


#pragma mark - DB Action
- (BOOL)DB:(FMDatabase *)db checkId:(NSString *)Id fromTable:(NSString *)table
{
        FMResultSet *result = [self DB:db selectFrom:table where:@"Id" isEqualValue:Id];
        
        while ([result next]) {
                return YES;
        }
        
        return NO;
}

#pragma mark table
- (void)DB:(FMDatabase *)db createTableIfNotExisit:(NSString *)table
{
        NSString * syntax = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (Address text, Class text, Class1 text, Class2 text, Class3 text, Description text, Id text, Keyword text, Name text, Opentime text, Picture1 text, Picture2 text, Picture3 text, Px text, Py text, Tel text, Ticketinfo text, Serviceinfo text, Travellinginfo text, Website text);", table];

        BOOL result = [db executeUpdate:syntax];
        
        if (!result)
                NSLog(@"create table(%@) error (%@)", table, db.lastError.description);
}

- (void)DB:(FMDatabase *)db createScheduleTableIfNotExisit:(NSString *)table
{
        NSString * syntax = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (Id text, Date text, OrderIndex text, CustomRemarks text, VisitTime text, DataItemType text);", table];
        
        BOOL result = [db executeUpdate:syntax];
        
        if (!result)
                NSLog(@"create table(%@) error (%@)", table, db.lastError.description);
}

- (void)DB:(FMDatabase *)db dropTableIfExisit:(NSString *)table
{
        NSString * syntax = [NSString stringWithFormat:@"DROP TABLE %@", table];
        
        BOOL result = [db executeUpdate:syntax];
        
        if (!result)
                NSLog(@"drop table(%@) error (%@)", table, db.lastError.description);
}

#pragma mark select
- (FMResultSet *)DB:(FMDatabase *)db selectFrom:(NSString *)table where:(NSString *)column isEqualValue:(NSString *)value
{
        // SELECT * FROM table WHERE column = ?
        NSString * syntax = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ?", table, column];
        return [db executeQuery:syntax, value];
}

- (FMResultSet *)DB:(FMDatabase *)db selectFrom:(NSString *)table where:(NSArray *)columns like:(NSString *)value
{
        // SELECT * FROM table WHERE (column1 LIKE ? OR column2 LIKE ? ...)
        NSString * likeValue = [NSString stringWithFormat:@"%%%@%%", value];
        NSMutableArray * argumentArray = [NSMutableArray array];
        __block NSMutableString * querySyntax = [NSMutableString stringWithFormat:@"SELECT * FROM %@ WHERE", table];
        
        [columns enumerateObjectsUsingBlock:^(NSString * column, NSUInteger idx, BOOL * _Nonnull stop) {
                
                NSString * appendingString = [NSString stringWithFormat:@" %@ LIKE ?", column];
                querySyntax = (NSMutableString *)[querySyntax stringByAppendingString:appendingString];
                
                if ((idx + 1) != columns.count)
                {
                        querySyntax = (NSMutableString *)[querySyntax stringByAppendingString:@" OR"];
                }
                
                [argumentArray addObject:likeValue];
        }];
        
        return [db executeQuery:querySyntax withArgumentsInArray:argumentArray];
}

- (FMResultSet *)DB:(FMDatabase *)db selectFrom:(NSString *)table innerJoin:(NSString *)dataBaseTable on:(NSString *)tableCondition equalTo:(NSString *)dataBaseTableCondition where:(NSString *)column equalValue:(NSString *)value
{
        // SELECT * FROM schedule INNER JOIN scenicspot ON schedule.Id = scenicspot.Id WHERE schedule.date = ? ORDER BY schedule.Order
        NSString * selectSyntax = [NSString stringWithFormat:@"SELECT * FROM %@ INNER JOIN %@ ON %@ = %@ WHERE %@ = ?", table, dataBaseTable, tableCondition, dataBaseTableCondition, column];
        return [db executeQuery:selectSyntax, value];
}

#pragma mark insert
- (BOOL)DB:(FMDatabase *)db insert:(DataItem *)item intoTable:(NSString *)table
{
        NSString * syntax = [NSString stringWithFormat:@"INSERT INTO %@ (Address, Class, Class1, Class2, Class3, Description, Id, Keyword, Name, Opentime, Picture1, Picture2, Picture3, Px, Py, Tel, Ticketinfo, Serviceinfo, Travellinginfo, Website) values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", table];
        return [db executeUpdate:syntax, item.Add, item.Class, item.Class1, item.Class2, item.Class3, item.Description, item.Id, item.Keyword, item.Name, item.Opentime, item.Picture1, item.Picture2, item.Picture3, item.Px, item.Py, item.Tel, item.Ticketinfo, item.Serviceinfo, item.Travellinginfo, item.Website];
}

- (BOOL)DB:(FMDatabase *)db insert:(DataItem *)item intoScheduleTable:(NSString *)table
{
        NSString * syntax = [NSString stringWithFormat:@"INSERT INTO %@ (Id, Date, OrderIndex, CustomRemarks, VisitTime, DataItemType) values(?, ?, ?, ?, ?, ?)", table];
        return [db executeUpdate:syntax, item.Id, item.Date, item.OrderIndex, item.CustomRemarks, item.VisitTime, item.DataItemType];
}

#pragma mark update
- (BOOL)DB:(FMDatabase *)db update:(DataItem *)item intoTable:(NSString *)table where:(NSString *)Id
{
        NSString * syntax = [NSString stringWithFormat:@"UPDATE %@ SET Address = ?, Class = ?, Class1 = ?, Class2 = ?, Class3 = ?, Description = ?, Id = ?, Keyword = ?, Name = ?, Opentime = ?, Picture1 = ?, Picture2 = ?, Picture3 = ?, Px = ?, Py = ?, Tel = ?, Ticketinfo = ?, Serviceinfo = ?, Travellinginfo = ?, Website = ? WHERE Id = ?", table];
        return [db executeUpdate:syntax, item.Add, item.Class, item.Class1, item.Class2, item.Class3, item.Description, item.Id, item.Keyword, item.Name, item.Opentime, item.Picture1, item.Picture2, item.Picture3, item.Px, item.Py, item.Tel, item.Ticketinfo, item.Serviceinfo, item.Travellinginfo, item.Website, Id];
}

- (BOOL)DB:(FMDatabase *)db update:(DataItem *)item intoScheduleTable:(NSString *)table where:(NSString *)Id
{
        NSString * syntax = [NSString stringWithFormat:@"UPDATE %@ SET Id = ?, Date = ?, OrderIndex = ?, CustomRemarks = ?, VisitTime = ?, DataItemType = ? WHERE Id = ?", table];
        return [db executeUpdate:syntax, item.Id, item.Date, item.OrderIndex, item.CustomRemarks, item.VisitTime, item.DataItemType, Id];
}

#pragma mark delete
- (BOOL)DB:(FMDatabase *)db deleteFrom:(NSString *)table where:(NSString *)column equalValue:(NSString *)value and:(NSString *)column2 equalValue:(NSString *)value2
{
        NSMutableString * syntax = [NSMutableString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ?", table, column];
        NSMutableArray * arguments = [NSMutableArray arrayWithObject:value];
        
        if (column2)
        {
                [syntax stringByAppendingString:[NSString stringWithFormat:@" AND %@ = ?", column2]];
                [arguments addObject:value2];
        }

        return [db executeUpdate:syntax withArgumentsInArray:arguments];
}

#pragma mark - count
- (void)tableCount:(NSString *)table
{
        int count = 0;
        __block FMResultSet * result;
        NSString * syntax = [NSString stringWithFormat:@"SELECT COUNT (Id) FROM %@", table];
        [_dataBaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
                
                result = [db executeQuery:syntax];
        }];
        
        while ([result next]) {
                
                count = [result intForColumnIndex:0];
        }
        
        NSLog(@"table (%@) total count : %d", table, count);
}

- (void)DB:(FMDatabase *)db tableCount:(NSString *)table
{
        int count = 0;
        __block FMResultSet * result;
        NSString * syntax = [NSString stringWithFormat:@"SELECT COUNT (Id) FROM %@", table];
        
        result = [db executeQuery:syntax];
        
        while ([result next]) {
                
                count = [result intForColumnIndex:0];
        }
        
        NSLog(@"DB table (%@) total count : %d", table, count);
}

@end
