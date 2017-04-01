//
//  AppDelegate.h
//  TripManager
//
//  Created by 何家瑋 on 2017/2/17.
//  Copyright © 2017年 何家瑋. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (copy) void (^backgroundSessionCompletionHandle)();

- (void)notificationAuthStatus:(void (^) (BOOL notificationEnable))completion;

@end

