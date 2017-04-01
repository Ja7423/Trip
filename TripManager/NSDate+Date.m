//
//  NSDate+Date.m
//  TripManager
//
//  Created by 何家瑋 on 2017/3/20.
//  Copyright © 2017年 何家瑋. All rights reserved.
//

#import "NSDate+Date.h"

@implementation NSDate (Date)

+ (NSString *)stringFromDate:(NSDate *)date
{
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @customDateFormat;
        NSString * stringDate = [dateFormatter stringFromDate:date];
        
        return stringDate;
}

+ (NSString *)stringFromTime:(NSDate *)time
{
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @timePickFormat;
        NSString * stringDate = [dateFormatter stringFromDate:time];
        
        return stringDate;
}

+ (NSDate *)timeFromString:(NSString *)timeString
{
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
        timeFormatter.dateFormat = @timePickFormat;
        NSDate * date = [timeFormatter dateFromString:timeString];
        
        return date;
}

@end
