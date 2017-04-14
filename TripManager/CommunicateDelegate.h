//
//  CommunicateDelegate.h
//  TripManager
//
//  Created by 何家瑋 on 2017/3/13.
//  Copyright © 2017年 何家瑋. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DataItem;
@protocol CommunicateDelegate <NSObject>

@optional
- (void)viewController:(UIViewController *)viewController didInsertDataItem:(DataItem *)dataItem;

- (void)viewController:(UIViewController *)viewController didEditDataItem:(DataItem *)dataItem;

- (void)viewController:(UIViewController *)viewController shouldPresentViewController:(UIViewController *)presentViewController;

@end
