//
//  EIConstants.h
//  DevCourse_CoreData
//
//  Created by Евгений Иванов on 04.08.16.
//  Copyright © 2016 Евгений Иванов. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kXYMySitBaseURL;

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define tableViewBackgroundColor [UIColor whiteColor]
#define tableViewSeparatorColor [UIColor clearColor]
#define tableViewCellColor [UIColor clearColor]
#define tableViewCellTextColor [UIColor colorWithRed:35.f/255.f green:42.f/255.f blue:55.f/255.f alpha:1.0f]

#define navigationBarTintColor [UIColor colorWithRed:35.f/255.f green:40.f/255.f blue:55.f/255.f alpha:1.0f]
#define navigationBarTextColor [UIColor whiteColor]
@interface EIConstants : NSObject

@end
