//
//  EIMultipieSelectionController.h
//  DevCourse_CoreData
//
//  Created by Евгений Иванов on 01.08.16.
//  Copyright © 2016 Евгений Иванов. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol EIMultipieSelectionControllerDelegate;

@interface EIMultipieSelectionController : UITableViewController

@property (strong, nonatomic) NSArray* allObjects;
@property (strong, nonatomic) NSMutableArray* selectedObjects;

@property (strong, nonatomic) NSString* navigationTitle;

@property (weak, nonatomic) id <EIMultipieSelectionControllerDelegate> delegate;

@end

@protocol EIMultipieSelectionControllerDelegate <NSObject>

@optional
- (void)controller:(EIMultipieSelectionController *)controller didChangeSelectedObjects:(NSArray *)selectedObjects;

@end