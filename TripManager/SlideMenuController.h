//
//  SlideMenuController.h
//  slideMenu
//
//  Created by 何家瑋 on 2017/4/12.
//  Copyright © 2017年 何家瑋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlideMenuController : UINavigationController

typedef NS_ENUM(NSInteger, menuType)
{
        menuTypeLeft,
        menuTypeRight,
};

@property (nonatomic, strong) UIViewController * leftMenuController;
@property (nonatomic, strong) UIBarButtonItem * leftBarButtonItem;

@property (nonatomic, strong) UIViewController * rightMenuController;
@property (nonatomic, strong) UIBarButtonItem * rightBarButtonItem;

@property (nonatomic) UIViewAnimationOptions slideOptions;
@property (nonatomic) NSTimeInterval animateDuration;
@property (nonatomic) NSTimeInterval animateDelay;
@property (nonatomic) CGFloat slideOffset;

@property (nonatomic, assign) BOOL allowSwipeMenu;


+ (instancetype)sharedInstance;

- (void)clickBarButtonItem:(id)sender;
- (void)swipeMenu:(UIPanGestureRecognizer *)panRecognizer;

- (void)openMenu:(menuType)type;
- (void)closeMenu;

@end
