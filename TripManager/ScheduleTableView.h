//
//  ScheduleTableView.h
//  TripManager
//
//  Created by 何家瑋 on 2017/2/18.
//  Copyright © 2017年 何家瑋. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScheduleTableView;
@protocol ScheduleTableViewGestureDelegate <NSObject>

@optional

- (void)ScheduleTableView:(ScheduleTableView *)tableView didDetectGesture:(UIGestureRecognizer *)gesture;

@end


@interface ScheduleTableView : UITableView

@property (nonatomic) BOOL allowUserModifyCellOrder;

@property (nonatomic) CFTimeInterval gestureMinPressDuration;

@property (weak) id <ScheduleTableViewGestureDelegate> gestureDelegate;

@end
