//
//  DataItem.m
//  TripManager
//
//  Created by 何家瑋 on 2017/2/21.
//  Copyright © 2017年 何家瑋. All rights reserved.
//

#import "DataItem.h"

@implementation DataItem

- (void)setValue:(id)value forKey:(NSString *)key
{
        [super setValue:value forKey:key];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{        
        if ([key isEqualToString:@"Address"])
        {
                [self setValue:value forKey:@"Add"];
        }
}

@end
