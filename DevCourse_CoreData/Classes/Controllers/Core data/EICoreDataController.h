//
//  EICoreDataController.h
//  DevCourse_41_CoreData
//
//  Created by Евгений on 28.07.16.
//  Copyright © 2016 Евгений. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <CoreData/Coredata.h>
#import "SWTableViewCell.h"

@interface EICoreDataController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, SWTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView* tableView;

@property (strong, nonatomic) NSFetchedResultsController* fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
