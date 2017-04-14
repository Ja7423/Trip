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
#define timePickFormat       "HH:mm"

// cell Id
#define scheduleTableViewCellReuseIdentifier    "scheduleTableViewCell"
#define searchTableViewCellReuseIdentifier       "searchTableViewCell"
#define menuTableViewCellReuseIdentifier         "menuCell"
#define previewTableViewCellReuseIdentifier      "previewCell"

// userdefault key
#define lastUpdateDateKey       "lastUpdateDate"
#define hasLaunchedOnceKey    "hasLaunchedOnce"
#define directionAppKey            "directionApp"

// support direction app
#define googleMap        "google map"
#define appleMap          "apple map"


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

typedef NS_ENUM(NSInteger, dataSourceType)
{
        dataSourceTypeSQLite,
        dataSourceTypeLocalFile,
};

typedef void (^TableViewCellConfigureBlock)(id cell, id item);

#endif /* define_h */
