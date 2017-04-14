//
//  FileManager.h
//  TripManager
//
//  Created by 何家瑋 on 2017/3/6.
//  Copyright © 2017年 何家瑋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Header.h"

@interface FileManager : NSObject

#pragma mark - remove
- (void)removeFile:(NSURL *)fileLocation;
- (void)removeDownloadFile;
- (void)removeInboxFile;

#pragma mark - move
- (NSURL *)moveFile:(NSString *)Filename from:(NSURL *)fromURL;

#pragma mark - check
- (NSURL *)checkCacheFile:(NSString *)fileName;

#pragma mark - read
- (NSArray *)readJSONFile:(NSURL *)fileLocation;
- (NSArray *)readInboxList;
- (NSArray *)readInboxFile:(NSString *)fileName;

#pragma mark - write
- (NSURL *)wirteFileWithContent:(NSDictionary *)writeData;

@end
