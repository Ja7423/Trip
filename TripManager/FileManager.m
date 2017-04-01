//
//  FileManager.m
//  TripManager
//
//  Created by 何家瑋 on 2017/3/6.
//  Copyright © 2017年 何家瑋. All rights reserved.
//

#import "FileManager.h"

@implementation FileManager

- (NSURL *)temporarySavePath
{
        NSFileManager *manager = [NSFileManager defaultManager];
        
        return [[manager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask]firstObject];
}

- (void)removeFile:(NSURL *)fileLocation
{
        NSError *error = nil;
        
        NSFileManager *manager = [NSFileManager defaultManager];
        [manager removeItemAtURL:fileLocation error:&error];
}

- (void)removeAllFile
{
        NSFileManager * manager = [NSFileManager defaultManager];
        NSError * error = nil;
        NSArray * contents = [manager contentsOfDirectoryAtURL:[self temporarySavePath] includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles error:&error];
        
        __weak typeof (self) weakSelf = self;
        [contents enumerateObjectsUsingBlock:^(NSURL * url, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if (![url.lastPathComponent isEqualToString:@"database.sqlite"])
                {
                        [weakSelf removeFile:url];
                }
        }];
}

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

@end
