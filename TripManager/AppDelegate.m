//
//  AppDelegate.m
//  TripManager
//
//  Created by 何家瑋 on 2017/2/17.
//  Copyright © 2017年 何家瑋. All rights reserved.
//

#import "AppDelegate.h"
#import "Header.h"

@interface AppDelegate () <UNUserNotificationCenterDelegate, FIRMessagingDelegate>
{
        DataOperation * _dataOperation;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
        // Override point for customization after application launch.
        
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
        UNAuthorizationOptions authOptions = UNAuthorizationOptionAlert
                                                                | UNAuthorizationOptionSound
                                                                | UNAuthorizationOptionBadge;
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:authOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {
                
        }];
        
        [FIRMessaging messaging].remoteMessageDelegate = self;
        
        // regist remote notification
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
        
        // start configure firebase
        [FIRApp configure];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenRefreshNotification:)
                                                     name:kFIRInstanceIDTokenRefreshNotification object:nil];
        
        return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
        [[FIRInstanceID instanceID] setAPNSToken:deviceToken type:FIRInstanceIDAPNSTokenTypeUnknown];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
        NSLog(@"didFailToRegisterForRemoteNotificationsWithError : %@", error.description);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
{
        /*! This delegate method offers an opportunity for applications with the "remote-notification" background mode to fetch appropriate new data in response to an incoming remote notification. You should call the fetchCompletionHandler as soon as you're finished performing that operation, so the system can accurately estimate its power and data cost.
         
         This method will be invoked even if the application was launched or resumed because of the remote notification. The respective delegate methods will be invoked first. Note that this behavior is in contrast to application:didReceiveRemoteNotification:, which is not called in those cases, and which will not be invoked if this method is implemented. !*/
        
        NSLog(@"applecation delegate didReceiveRemoteNotification");
        NSLog(@"userInfo : %@", userInfo);
        
        switch (application.applicationState) {
                case UIApplicationStateActive:
                case UIApplicationStateBackground:
                        [self startUpate];
                        break;
                default:
                        break;
        }
        
        completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark UNUserNotificationCenterDelegate
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler
{
        /*
         When the user responds to a notification, the system calls this method with the results. At the end of your implementation, you must call the completion​Handler block to let the system know that you are done processing the notification.
         */
        
        NSLog(@"UNUserNotificationCenterDelegate didReceiveNotificationResponse");
        
        completionHandler();
}

#pragma mark FIRMessagingDelegate
- (void)applicationReceivedRemoteMessage:(nonnull FIRMessagingRemoteMessage *)remoteMessage
{
        NSLog(@"applicationReceivedRemoteMessage:(nonnull FIRMessagingRemoteMessage *)remoteMessage");
        [self startUpate];
}

#pragma mark BackgroundURLSession
- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler
{
        self.backgroundSessionCompletionHandle = completionHandler;
}

#pragma mark - UIApplicationDelegate
- (void)applicationWillTerminate:(UIApplication *)application {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        // TODO: Clean all download file in DocumentDirectory
        FileManager * manager = [[FileManager alloc]init];
        [manager removeAllFile];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        //TODO: disconnect
        [[FIRMessaging messaging] disconnect];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        // Transitioning to the foreground
        
        //TODO: connect
        [self connectToFirebase];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillResignActive:(UIApplication *)application {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)tokenRefreshNotification:(NSNotification *)notification {
        // Note that this callback will be fired everytime a new token is generated, including the first
        // time. So if you need to retrieve the token as soon as it is available this is where that
        // should be done.
        NSString *refreshedToken = [[FIRInstanceID instanceID] token];
        NSLog(@"tokenRefreshNotification token: %@", refreshedToken);
        
        // Connect to FCM since connection may have failed when attempted before having a token.
        [self connectToFirebase];
}

- (void)connectToFirebase
{
        NSString *token = [[FIRInstanceID instanceID] token];
        
        if (!token)
        {
                return;
        }
        
        // disconnect first
        [[FIRMessaging messaging] disconnect];
        
        [[FIRMessaging messaging] connectWithCompletion:^(NSError * _Nullable error) {
           
                NSLog(@"connectWithError:(%@)", error.description);
                
        }];
}

- (void)startUpate
{
        _dataOperation = [[DataOperation alloc]init];
        [_dataOperation startDownloadDataBaseWhenReceiveNotification];
}

- (void)notificationAuthStatus:(void (^) (BOOL notificationEnable))completion
{
        [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                
                BOOL isRegisterRemoteNotifications = [[UIApplication sharedApplication] isRegisteredForRemoteNotifications];
                BOOL isAuth = (settings.authorizationStatus == UNAuthorizationStatusAuthorized) ? YES : NO;
                
                if (completion)
                {
                        completion(isRegisterRemoteNotifications & isAuth);
                }
        }];
}

@end
