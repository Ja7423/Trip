//
//  define.h
//  TripManager
//
//  Created by 何家瑋 on 2017/2/24.
//  Copyright © 2017年 何家瑋. All rights reserved.
//

#ifndef define_h
#define define_h

#define customDateFormat "yyyy/MM/dd"
#define timePickFormat "HH:mm"

// cell Id
#define scheduleTableViewCellReuseIdentifier    "scheduleTableViewCell"
#define searchTableViewCellReuseIdentifier       "searchTableViewCell"

// userdefault key
#define lastUpdateDateKey       "lastUpdateDate"
#define hasLaunchedOnceKey    "hasLaunchedOnce"

typedef NS_ENUM(NSInteger, requestType)
{
        requestTypeDataBaseUpdate,
        requestTypeDataDownload,
};

typedef NS_ENUM(NSInteger, dataItemType)
{
        dataItemTypeScenicspot,
        dataItemTypeRestaurant,
        dataItemTypeHotel,
};

typedef void (^TableViewCellConfigureBlock)(id cell, id item);

#endif /* define_h */
