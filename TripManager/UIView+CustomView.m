//
//  UIView+CustomView.m
//  TripManager
//
//  Created by 何家瑋 on 2017/2/18.
//  Copyright © 2017年 何家瑋. All rights reserved.
//

#import "UIView+CustomView.h"

@implementation UIView (CustomView)

+ (UIView *)snapshotViewWithInputView:(UIView *)inputView
{
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
        [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        UIView *snapshot = [[UIImageView alloc] initWithImage:image];
        return snapshot;
}

@end
