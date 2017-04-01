//
//  DownloadRequest.h
//  TripManager
//
//  Created by 何家瑋 on 2017/2/22.
//  Copyright © 2017年 何家瑋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Header.h"
#import "DownloadResponse.h"

@interface DownloadRequest : NSObject

@property (nonatomic) requestType type;

@property (nonatomic) DownloadResponse * response;

@property (nonatomic) NSString * downloadURL;

@property (nonatomic) NSMutableURLRequest * request;

@property (nonatomic) NSURLSessionDownloadTask * downloadTask;

@property (nonatomic) NSString * fileName;

@property (nonatomic) NSString * tableName;

@end
