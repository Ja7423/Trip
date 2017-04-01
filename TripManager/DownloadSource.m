//
//  DownloadSource.m
//  TripManager
//
//  Created by 何家瑋 on 2017/2/22.
//  Copyright © 2017年 何家瑋. All rights reserved.
//

#import "DownloadSource.h"

@interface DownloadSource ()

@property (nonatomic) NSArray * list;

@end

@implementation DownloadSource

- (instancetype)init
{
        self = [super init];
        
        if (self)
        {
                [self initialize];
        }
        
        return self;
}

- (void)initialize
{
        _list = [NSArray arrayWithObjects:
                        @{@"downloadURL" : @"http://gis.taiwan.net.tw/XMLReleaseALL_public/scenic_spot_C_f.json",
                            @"fileName" : @"scenic_spot_C_f.json",
                            @"tableName" : @"scenicspot"},
                        @{@"downloadURL" : @"http://gis.taiwan.net.tw/XMLReleaseALL_public/restaurant_C_f.json",
                            @"fileName" : @"restaurant_C_f.json",
                            @"tableName" : @"restaurant"},
                        @{@"downloadURL" : @"http://gis.taiwan.net.tw/XMLReleaseALL_public/hotel_C_f.json",
                            @"fileName" : @"hotel_C_f.json",
                            @"tableName" : @"hotel"},
                        nil];
}

- (NSArray *)downloadList
{
        return _list;
}

- (NSArray *)baseTable
{
        NSMutableArray * tables = [NSMutableArray array];
        for (NSDictionary * dictionary in _list) {
                [tables addObject:dictionary[@"tableName"]];
        }
        
        return tables;
}


@end
