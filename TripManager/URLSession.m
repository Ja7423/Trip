//
//  URLSession.m
//  TripManager
//
//  Created by 何家瑋 on 2017/2/22.
//  Copyright © 2017年 何家瑋. All rights reserved.
//

#import "URLSession.h"

@implementation URLSession

- (NSURLSessionConfiguration *)backgroundSessionConfigureation
{
        __block NSURLSessionConfiguration * sessionConfiguration;
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                sessionConfiguration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.TripManager.networking.background"];
        });
        
        return sessionConfiguration;
}

- (NSOperationQueue *)operationQueue
{
        return [NSOperationQueue currentQueue];
}

- (NSURLSession *)backgroundSessionWithDelegate:(id <NSURLSessionDelegate>)delegate
{
        return [NSURLSession sessionWithConfiguration:[self backgroundSessionConfigureation] delegate:delegate delegateQueue:[self operationQueue]];
}

@end
