//
//  URLSession.h
//  TripManager
//
//  Created by 何家瑋 on 2017/2/22.
//  Copyright © 2017年 何家瑋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLSession : NSObject

- (NSURLSession *)backgroundSessionWithDelegate:(id <NSURLSessionDelegate>)delegate;

@end
