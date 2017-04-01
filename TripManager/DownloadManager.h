//
//  DownloadManager.h
//  TripManager
//
//  Created by 何家瑋 on 2017/2/22.
//  Copyright © 2017年 何家瑋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Header.h"

@class DownloadManager;
@class DownloadRequest;
@protocol DownloadManagerDelegate <NSObject>

@optional

- (void)downloadManager:(DownloadManager *)manager didFinishDownload:( NSArray <DownloadRequest *>*)requests;

@end


@interface DownloadManager : NSObject

@property (weak, nonatomic) id <DownloadManagerDelegate> delegate;

@property (nonatomic) NSArray <DownloadRequest *> * requests;

#pragma mark - configure

- (NSArray *)prepareDownloadRequest:(NSArray *)source;

#pragma mark - start action

- (void)startDownload;

@end
