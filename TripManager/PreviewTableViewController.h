//
//  PreviewTableViewController.h
//  TripManager
//
//  Created by 何家瑋 on 2017/4/13.
//  Copyright © 2017年 何家瑋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"

@interface PreviewTableViewController : UITableViewController

@property (weak, nonatomic) id <CommunicateDelegate> delegate;

@property (nonatomic) NSString * fileName;

@end
