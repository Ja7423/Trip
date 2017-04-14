//
//  SlideMenuController.m
//  slideMenu
//
//  Created by 何家瑋 on 2017/4/12.
//  Copyright © 2017年 何家瑋. All rights reserved.
//

#import "SlideMenuController.h"

@interface SlideMenuController ()

@property (nonatomic, assign) CGPoint lastDraggingPoint;

@end

static SlideMenuController * _slideMenuControllerInstance = nil;

@implementation SlideMenuController

+ (instancetype)sharedInstance
{
        return _slideMenuControllerInstance;
}

#pragma mark - init
- (instancetype)init
{
        self = [super init];
        
        if (self)
        {
                [self setup];
        }
        
        return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
        self = [super initWithCoder:aDecoder];
        
        if (self)
        {
                [self setup];
        }
        
        return self;
}

#pragma mark - setting
- (void)setup
{
        _slideMenuControllerInstance = self;
        
        _animateDuration = 0.2;
        _animateDelay = 0.0;
        _slideOffset = self.view.frame.size.width / 3 * 2;
        _slideOptions = UIViewAnimationOptionCurveEaseInOut;
        _allowSwipeMenu = YES;
}

- (CGFloat)minX
{
        return _slideOffset * -1;
}

- (CGFloat)maxX
{
        return _slideOffset;
}

- (void)viewDidLoad {
        [super viewDidLoad];
        // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
        [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}

#pragma mark - public
#pragma mark  barButton
- (void)clickBarButtonItem:(id)sender
{
        if (sender == _leftBarButtonItem)
        {
                NSLog(@"click leftBarButtonItem");
                [self slideMenu:menuTypeLeft];
        }
        else if (sender == _rightBarButtonItem)
        {
                NSLog(@"click rightBarButtonItem");
                [self slideMenu:menuTypeRight];
        }
}

#pragma mark  gesture
- (void)swipeMenu:(UIPanGestureRecognizer *)panRecognizer
{
        if (!_allowSwipeMenu)
        {
                return;
        }
        
        CGPoint translation = [panRecognizer translationInView:panRecognizer.view];
        menuType currentMenu;
        
        if (self.view.frame.origin.x > 0)
                currentMenu = menuTypeLeft;
        else if (self.view.frame.origin.x < 0)
                currentMenu = menuTypeRight;
        else
                currentMenu = (translation.x > 0) ? menuTypeLeft : menuTypeRight;
        
        if (![self checkSlideMenuIsNotNil:currentMenu])
        {
                return;
        }
        
        [self prepareSlideMenu:currentMenu];
        
        if (panRecognizer.state == UIGestureRecognizerStateBegan)
        {
                self.lastDraggingPoint = translation;
        }
        else if (panRecognizer.state == UIGestureRecognizerStateChanged)
        {
                NSInteger movement = translation.x - self.lastDraggingPoint.x;
                CGFloat newXLocation = self.view.frame.origin.x + movement;
                
                if (newXLocation >= [self minX] && newXLocation <= [self maxX])
                {
                        CGRect rect = self.view.frame;
                        rect.origin.x = newXLocation;
                        self.view.frame = rect;
                }
                
                self.lastDraggingPoint = translation;
        }
        else if (panRecognizer.state == UIGestureRecognizerStateEnded)
        {
                NSInteger currentX = self.view.frame.origin.x;
                NSInteger currentXOffset = (currentX > 0) ? currentX : currentX * -1;
                
                if (currentXOffset < (self.slideOffset) / 2)
                        [self closeMenu];
                else
                        [self openMenu:currentMenu];
        }
}


#pragma mark - private
- (void)slideMenu:(menuType)type
{
        if ([self isMenuOpen])
        {
                [self closeMenu];
        }
        else
        {
                [self openMenu:type];
        }
}

#pragma mark check
- (BOOL)isMenuOpen
{
        return ( self.view.frame.origin.x == 0 ) ? NO : YES;
}

- (BOOL)checkSlideMenuIsNotNil:(menuType)type
{
        UIViewController * slideViewController = (type == menuTypeLeft) ? _leftMenuController : _rightMenuController;
        
        if (slideViewController)
        {
                return YES;
        }
        else
        {
                return NO;
        }
}

#pragma mark prepare
- (void)prepareSlideMenu:(menuType)type
{
        UIViewController * slideViewController = (type == menuTypeLeft) ? _leftMenuController : _rightMenuController;
        slideViewController.view.frame = self.view.bounds;
        slideViewController.view.transform = self.view.transform;
        [self clearSlideMenu:type];
        [self.view.window insertSubview:slideViewController.view atIndex:0];
}

- (void)clearSlideMenu:(menuType)type
{
        UIViewController * clearViewController = (type == menuTypeLeft) ? _rightMenuController : _leftMenuController;
        [clearViewController.view removeFromSuperview];
}

#pragma mark action
- (void)openMenu:(menuType)type
{
        if (![self checkSlideMenuIsNotNil:type])
        {
                return;
        }
        
        [self prepareSlideMenu:type];
        
        CGFloat offsetX = (type == menuTypeLeft) ? (_slideOffset) : ((_slideOffset )* -1);
        
        [UIView animateWithDuration:_animateDuration delay:_animateDelay options:_slideOptions animations:^{
                
                CGRect rect = self.view.frame;
                rect.origin.x = offsetX;
                self.view.frame = rect;
                
        } completion:^(BOOL finished) {
                NSLog(@"openMenu");
        }];
}

- (void)closeMenu
{
        if (![self isMenuOpen])
        {
                return;
        }
        
        [UIView animateWithDuration:_animateDuration delay:_animateDelay options:_slideOptions animations:^{
                
                CGRect rect = self.view.frame;
                rect.origin.x = 0;
                self.view.frame = rect;
                
        } completion:^(BOOL finished) {
                NSLog(@"closeMenu");
        }];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
