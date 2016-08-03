//
//  EITeachersViewController.m
//  DevCourse_CoreData
//
//  Created by Евгений Иванов on 02.08.16.
//  Copyright © 2016 Евгений Иванов. All rights reserved.
//

#import "EITeachersViewController.h"
#import "EIUser.h"
#import "EICourse.h"

@interface EITeachersViewController ()

@end

@implementation EITeachersViewController
@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - fetchedResultsController

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        
        return _fetchedResultsController;
        
    }
    
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription* description = [NSEntityDescription entityForName:@"EICourse" inManagedObjectContext:self.managedObjectContext];
    
    NSSortDescriptor* nameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"teacher!=nil"];
    
    [request setSortDescriptors:@[nameDescriptor]];
    [request setEntity:description];
    [request setFetchBatchSize:20];
    [request setPredicate:predicate];
    [request setRelationshipKeyPathsForPrefetching:@[@"teacher"]];
    
    NSFetchedResultsController* aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"subject" cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
    
}

#pragma mark - UITableViewDataSource

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    
    return [sectionInfo name];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifier = @"Cell";
    
    UITableViewCell* cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        
    }
    
    NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    
    [self configureCell:cell withObject:object];
    
    return cell;
    
}


#pragma mark - Table view cell

-(void) configureCell:(UITableViewCell *)cell withObject: (id) object {
    
    if ([object isKindOfClass:[EICourse class]]) {
     
    EICourse* course = (EICourse *)object;
        
     EIUser* teacher = course.teacher;
     
     cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", teacher.firstName, teacher.lastName];
     cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu", [teacher.taughtCourses count]];
     
     cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
     }
    
}

@end