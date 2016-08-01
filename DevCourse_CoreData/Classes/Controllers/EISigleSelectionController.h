//
//  EISigleSelectionController.h
//  DevCourse_CoreData
//
//  Created by Евгений Иванов on 01.08.16.
//  Copyright © 2016 Евгений Иванов. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EISigleSelectionControllerDelegate;

@interface EISigleSelectionController : UITableViewController

@property (strong, nonatomic) NSArray* allObjects;
@property (strong, nonatomic) NSObject* selectedObject;

@property (strong, nonatomic) NSString* navigationTitle;

@property (weak, nonatomic) id <EISigleSelectionControllerDelegate> delegate;

@end

@protocol EISigleSelectionControllerDelegate <NSObject>

@optional
- (void)controller:(EISigleSelectionController *)controller didChangeSelectedObject:(id)newSelectedObject;

@end