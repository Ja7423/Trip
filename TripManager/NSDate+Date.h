//
//  NSDate+Date.h
//  TripManager
//
//  Created by 何家瑋 on 2017/3/20.
//  Copyright © 2017年 何家瑋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Header.h"

@interface NSDate (Date)

//convert date to string
+ (NSString *)stringFromDate:(NSDate *)date;

// convert time to string
+ (NSString *)stringFromTime:(NSDate *)time;

// convert string to time
+ (NSDate *)timeFromString:(NSString *)timeString;

@end
