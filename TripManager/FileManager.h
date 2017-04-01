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

- (void)removeFile:(NSURL *)fileLocation;

- (void)removeAllFile;

- (NSURL *)moveFile:(NSString *)Filename from:(NSURL *)fromURL;

- (NSURL *)checkCacheFile:(NSString *)fileName;

- (NSArray *)readJSONFile:(NSURL *)fileLocation;

@end
