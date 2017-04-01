//
//  DownloadManager.m
//  TripManager
//
//  Created by 何家瑋 on 2017/2/22.
//  Copyright © 2017年 何家瑋. All rights reserved.
//

#import "DownloadManager.h"

@interface DownloadManager () <NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate, NSURLSessionDownloadDelegate>
{
        URLSession * _urlSession;
        
        dispatch_queue_t sessionQueue;
        
        NSURLSession * _backgroundSession;
        NSInteger _didFinishRequestCount;
        NSInteger _taskCount;
}

@property (copy) void (^backgroundSessionCompletionHandle)();

@end

@implementation DownloadManager

#pragma mark - configure
- (instancetype)init
{
        self = [super init];
        
        if (self)
        {
                _didFinishRequestCount = 0;
                _urlSession = [[URLSession alloc]init];
                sessionQueue = dispatch_queue_create("downloadManager.sessionQueue", NULL);
        }
        
        return self;
}

- (void)setRequests:(NSArray<DownloadRequest *> *)requests
{
        _requests = requests;
        _taskCount = _requests.count;
}

- (NSArray *)prepareDownloadRequest:(NSArray *)source
{
        NSMutableArray * downloadRequest = [NSMutableArray array];
        [source enumerateObjectsUsingBlock:^(NSDictionary * dictionary, NSUInteger idx, BOOL * _Nonnull stop) {
                
                DownloadRequest * request = [[DownloadRequest alloc]init];
                
                for (id key in dictionary.allKeys)
                {
                        id value = dictionary[key];
                        [request setValue:value forKey:key];
                }
                
                [downloadRequest addObject:request];
        }];
        
        return downloadRequest;
}

#pragma mark - start action
- (void)startDownload
{
        [_requests enumerateObjectsUsingBlock:^(DownloadRequest * request, NSUInteger idx, BOOL * _Nonnull stop) {
                
                dispatch_async(sessionQueue, ^{

                        _backgroundSession = [_urlSession backgroundSessionWithDelegate:self];
                        request.downloadTask = [_backgroundSession downloadTaskWithRequest:request.request];
                        [request.downloadTask resume];
                });
                
        }];
}

#pragma mark - NSURLSessionDelegate
- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session
{
        AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        
        if (appDelegate.backgroundSessionCompletionHandle)
        {
                self.backgroundSessionCompletionHandle = appDelegate.backgroundSessionCompletionHandle;
                
                appDelegate.backgroundSessionCompletionHandle = nil;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                        self.backgroundSessionCompletionHandle();
                });
        }
}

#pragma mark - NSURLSessionDownloadDelegate
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
        /*
         Important: Before this method returns, it must either open the file for reading or move it to a permanent
         location. When this method returns, the temporary file is deleted if it still exists at its original location.
         */
        
        // need update file location
        [_requests enumerateObjectsUsingBlock:^(DownloadRequest *  request, NSUInteger idx, BOOL * _Nonnull stop) {

                if (request.downloadTask == downloadTask)
                {
                        if (!request.fileName)
                        {
                                request.fileName = [request.downloadURL lastPathComponent];
                        }
                        
                        FileManager * manager = [[FileManager alloc]init];
                        request.response.fileURL = [manager moveFile:request.fileName from:location];
                }
        }];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
//        NSLog(@"bytesWritten %lld", bytesWritten);
//        NSLog(@"totalBytesWritten %lld", totalBytesWritten);
//        NSLog(@"totalBytesExpectedToWrite %lld", totalBytesExpectedToWrite);

        if (totalBytesWritten == totalBytesExpectedToWrite)
        {
                NSLog(@"===========================================");
                NSLog(@"FINISH : %@", downloadTask.currentRequest.URL);
                NSLog(@"===========================================");
        }
}

#pragma mark - NSURLSessionTaskDelegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error
{
        [_requests enumerateObjectsUsingBlock:^(DownloadRequest *  request, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if (request.downloadTask == task)
                {
                        request.response.downloadError = error;
                }
        }];
        
        _taskCount --;
        if (_taskCount == 0)
        {
                if ([_delegate respondsToSelector:@selector(downloadManager:didFinishDownload:)])
                {
                        [_delegate downloadManager:self didFinishDownload:_requests];
                }
        }
}


@end
