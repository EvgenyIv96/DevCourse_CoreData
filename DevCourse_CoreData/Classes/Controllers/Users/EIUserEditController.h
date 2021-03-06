//
//  EIUserEditController.h
//  DevCourse_CoreData
//
//  Created by Евгений Иванов on 01.08.16.
//  Copyright © 2016 Евгений Иванов. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EIUser;
@protocol EIUserEditControllerDelegate;

@interface EIUserEditController : UITableViewController

@property (strong, nonatomic) EIUser* user;
@property (weak, nonatomic) id <EIUserEditControllerDelegate> delegate;

@end

@protocol EIUserEditControllerDelegate <NSObject>

@optional
- (void)userEditControllerDidFinishedWork:(EIUserEditController *)controller;

@end
