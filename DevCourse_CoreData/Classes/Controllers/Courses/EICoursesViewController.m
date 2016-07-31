//
//  EICoursesViewController.m
//  DevCourse_41_CoreData
//
//  Created by Евгений on 29.07.16.
//  Copyright © 2016 Евгений. All rights reserved.
//

#import "EICoursesViewController.h"
//#import "EIEditCourseController.h"
#import "EICourse.h"

@implementation EICoursesViewController
@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self configureNavigationBar];
    
}

#pragma mark - fetchedResultsController

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        
        return _fetchedResultsController;
        
    }
    
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription* description = [NSEntityDescription entityForName:@"EICourse" inManagedObjectContext:self.managedObjectContext];
    
    NSSortDescriptor* firtsNameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    
    [request setSortDescriptors:@[firtsNameDescriptor]];
    [request setEntity:description];
    [request setFetchBatchSize:20];
    
    NSFetchedResultsController* aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
    
}

#pragma mark - Table view cell

-(void) configureCell:(UITableViewCell *)cell withObject: (id) object {
    
    if ([object isKindOfClass:[EICourse class]]) {
        
        EICourse* course = (EICourse *)object;
        
        cell.textLabel.text = [NSString stringWithFormat:@"Course %@", course.name];
        
    }
    
}

#pragma mark - Navigation Bar setup

- (void) configureNavigationBar {
    
    self.navigationItem.title = @"Courses";
    
    UIBarButtonItem* addUserButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAction:)];
    
    [self.navigationItem setRightBarButtonItem:addUserButton];
}

#pragma mark - Actions

- (void) addAction:(id) sender {
    
  /*  EIEditCourseController* vc = [[EIEditCourseController alloc] initWithNibName:@"EIEditCourseController" bundle:nil];
    
    UINavigationController* nc = [[UINavigationController alloc] initWithRootViewController:vc];
    
    nc.modalPresentationStyle = UIModalPresentationPopover;
    
    [self presentViewController:nc animated:YES completion:nil]; */
}


#pragma mark - SWTableViewCell actions

- (void)editButtonActionforCell:(SWTableViewCell *)cell {
    /*
    EIEditCourseController* vc = [[EIEditCourseController alloc] initWithNibName:@"EIEditCourseController" bundle:nil];
    
    vc.course = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForCell:cell]];
    
    UINavigationController* nc = [[UINavigationController alloc] initWithRootViewController:vc];
    
    nc.modalPresentationStyle = UIModalPresentationPopover;
    
    [cell hideUtilityButtonsAnimated:YES];
    
    [self presentViewController:nc animated:YES completion:nil];*/
    
}

@end
