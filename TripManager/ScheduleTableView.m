//
//  ScheduleTableView.m
//  TripManager
//
//  Created by 何家瑋 on 2017/2/18.
//  Copyright © 2017年 何家瑋. All rights reserved.
//

#import "ScheduleTableView.h"

@interface ScheduleTableView ()
{
        UILongPressGestureRecognizer * _longPressGesture;
}

@end

@implementation ScheduleTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
        self = [super init];
        
        if (self)
        {
                _gestureMinPressDuration = 1.0;
                self.allowUserModifyCellOrder = YES;
        }
        
        return self;
}

- (void)setAllowUserModifyCellOrder:(BOOL)allowUserModifyCellOrder
{
        _allowUserModifyCellOrder = allowUserModifyCellOrder;
        
        if (_allowUserModifyCellOrder)
        {
                [self addGesture];
        }
        else
        {
                [self removeGesture];
        }
}

- (void)addGesture
{
        _longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
        _longPressGesture.minimumPressDuration = (_gestureMinPressDuration) ? _gestureMinPressDuration : 0.5;
        [self addGestureRecognizer:_longPressGesture];
}

- (void)removeGesture
{
        if (_longPressGesture)
        {
                [self removeGestureRecognizer:_longPressGesture];
        }
}

- (void)longPressAction:(UILongPressGestureRecognizer *)gesture
{
        if ([_gestureDelegate respondsToSelector:@selector(ScheduleTableView:didDetectGesture:)])
        {
                [_gestureDelegate ScheduleTableView:self didDetectGesture:gesture];
        }
}


@end
