//
//  FileManager.m
//  TripManager
//
//  Created by 何家瑋 on 2017/3/6.
//  Copyright © 2017年 何家瑋. All rights reserved.
//

#import "FileManager.h"

@implementation FileManager

#pragma mark - path
- (NSURL *)temporarySavePath
{
        NSFileManager *manager = [NSFileManager defaultManager];
        
        return [[manager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask]firstObject];
}

- (NSURL *)inboxSavePath
{
        // /Documents/Inbox
        return [[self temporarySavePath] URLByAppendingPathComponent:@"Inbox"];
}

#pragma mark - remove
- (void)removeFile:(NSURL *)fileLocation
{
        NSError *error = nil;
        
        NSFileManager *manager = [NSFileManager defaultManager];
        [manager removeItemAtURL:fileLocation error:&error];
}

- (void)removeDownloadFile
{
        NSFileManager * manager = [NSFileManager defaultManager];
        NSError * error = nil;
        NSArray * contents = [manager contentsOfDirectoryAtURL:[self temporarySavePath] includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles error:&error];
        
        __weak typeof (self) weakSelf = self;
        [contents enumerateObjectsUsingBlock:^(NSURL * url, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if (![url.lastPathComponent isEqualToString:@"database.sqlite"] && ![url.lastPathComponent isEqualToString:@"Inbox"])
                {
                        [weakSelf removeFile:url];
                }
        }];
}

- (void)removeInboxFile
{
        NSFileManager * manager = [NSFileManager defaultManager];
        NSError * error = nil;
        NSArray * contents = [manager contentsOfDirectoryAtURL:[self inboxSavePath] includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles error:&error];
        
        __weak typeof (self) weakSelf = self;
        [contents enumerateObjectsUsingBlock:^(NSURL * url, NSUInteger idx, BOOL * _Nonnull stop) {
                
                [weakSelf removeFile:url];
        }];
}

#pragma mark - move
- (NSURL *)moveFile:(NSString *)fileName from:(NSURL *)fromURL
{
        NSError *error = nil;
        NSURL *toURL = [[self temporarySavePath] URLByAppendingPathComponent:fileName];
        
        [self removeFile:toURL];
        
        NSFileManager *manager = [NSFileManager defaultManager];
        
        if ([manager moveItemAtURL:fromURL toURL:toURL error:&error])
        {
                return toURL;
        }
        else
        {
                return nil;
        }
}

#pragma mark - check
- (NSURL *)checkCacheFile:(NSString *)fileName
{
        NSFileManager *manager = [NSFileManager defaultManager];
        NSURL *fileURL = [[self temporarySavePath] URLByAppendingPathComponent:fileName];
        
        if ([manager fileExistsAtPath:fileURL.path])
        {
                return fileURL;
        }
        else
        {
                return nil;
        }
}

#pragma mark - read
- (NSArray *)readJSONFile:(NSURL *)fileLocation
{
        NSMutableArray * dataArray = [NSMutableArray array];
        NSData * data = [NSData dataWithContentsOfURL:fileLocation];
        NSDictionary * json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSArray * array = json[@"Infos"][@"Info"];
        
        [array enumerateObjectsUsingBlock:^(NSDictionary * item, NSUInteger idx, BOOL * _Nonnull stop) {
                
                DataItem * _dataItem = [[DataItem alloc]init];
                
                for (id key in item.allKeys)
                {
                        id value = item[key];
                        [_dataItem setValue:value forKey:key];
                }
                
                [dataArray addObject:_dataItem];
        }];
        
        return dataArray;
}

- (NSArray *)readInboxList
{
        NSFileManager * manager = [NSFileManager defaultManager];
        NSError * error = nil;
        NSArray * contentList = [manager contentsOfDirectoryAtURL:[self inboxSavePath] includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles error:&error];
        
        return contentList;
}

- (NSArray *)readInboxFile:(NSString *)fileName
{
        NSMutableArray * dataArray = [NSMutableArray array];
        NSURL * fileLocation = [[self inboxSavePath] URLByAppendingPathComponent:fileName];
        NSData * data = [NSData dataWithContentsOfURL:fileLocation];
        NSDictionary * json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        // only one key right now
        NSString * key = json.allKeys[0];
        NSArray * array = json[key];
        
        [array enumerateObjectsUsingBlock:^(NSArray * items, NSUInteger idx, BOOL * _Nonnull stop) {
                
                NSMutableArray * sectionArray = [NSMutableArray array];
                [items enumerateObjectsUsingBlock:^(NSDictionary * item, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        DataItem * _dataItem = [[DataItem alloc]init];
                        
                        for (id key in item.allKeys)
                        {
                                id value = item[key];
                                [_dataItem setValue:value forKey:key];
                        }
                        
                        [sectionArray addObject:_dataItem];
                }];
                
                [dataArray addObject:sectionArray];
        }];
        
        return dataArray;
}

#pragma mark - write
- (NSURL *)wirteFileWithContent:(NSDictionary *)writeData
{
        NSError * error = nil;
        NSString *uniqueID = [[NSUUID new] UUIDString];
        NSString * fileName = [NSString stringWithFormat:@"%@.json", uniqueID];
        NSURL * fileURL = [[self temporarySavePath] URLByAppendingPathComponent:fileName];
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:writeData options:NSJSONWritingPrettyPrinted error:&error];
        
        if ([jsonData writeToURL:fileURL atomically:YES])
        {
                return fileURL;
        }
        else
        {
                return nil;
        }
}

@end
