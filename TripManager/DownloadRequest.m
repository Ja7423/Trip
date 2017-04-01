//
//  DownloadRequest.m
//  TripManager
//
//  Created by 何家瑋 on 2017/2/22.
//  Copyright © 2017年 何家瑋. All rights reserved.
//

#import "DownloadRequest.h"

@implementation DownloadRequest

- (instancetype)init
{
        self = [super init];
        
        if (self)
        {
                _response = [[DownloadResponse alloc]init];
        }
        
        return self;
}

- (NSURLRequest *)request
{
        NSURL *url = [NSURL URLWithString:_downloadURL];
        _request = [NSMutableURLRequest requestWithURL:url];
        
        return _request;
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
        // avoid application crash
}

@end
