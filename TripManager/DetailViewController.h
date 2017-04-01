//
//  DetailViewController.h
//  TripManager
//
//  Created by 何家瑋 on 2017/3/13.
//  Copyright © 2017年 何家瑋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"

@interface DetailViewController : UIViewController

@property (nonatomic) BOOL enableAddButton;
@property (nonatomic) DataItem * dataItem;
@property (nonatomic, weak) id<CommunicateDelegate> delegate;

@end
