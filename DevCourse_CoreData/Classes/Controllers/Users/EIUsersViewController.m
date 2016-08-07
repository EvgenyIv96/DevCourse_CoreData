//
//  EIUsersViewController.m
//  DevCourse_41_CoreData
//
//  Created by Евгений on 28.07.16.
//  Copyright © 2016 Евгений. All rights reserved.
//

#import "EIUsersViewController.h"
#import "EIDataManager.h"
#import "EIUser.h"
#import "EIUserEditController.h"
#import "EIUserProfileViewController.h"

@interface EIUsersViewController ()

@end

@implementation EIUsersViewController
@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [[EIDataManager sharedManager] generateGeekbrainsPortal];
//    [[EIDataManager sharedManager] saveContext];
    
    [self configureNavigationBar];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EIUser* user = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [self pushProfileControllerForUser:user];
}

#pragma mark - fetchedResultsController

- (NSFetchedResultsController *)fetchedResultsController {
    
        if (_fetchedResultsController != nil) {
    
            return _fetchedResultsController;
    
        }
    
            NSFetchRequest* request = [[NSFetchRequest alloc] init];
    
            NSEntityDescription* description = [NSEntityDescription entityForName:@"EIUser" inManagedObjectContext:self.managedObjectContext];
    
            NSSortDescriptor* firtsNameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES];
    
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
    
    if ([object isKindOfClass:[EIUser class]]) {
        
        EIUser* user = (EIUser *)object;
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
        
    }
    
}


#pragma mark - Navigation Bar setup

- (void) configureNavigationBar {
    
    self.navigationItem.title = @"Users";
    
    UIBarButtonItem* addUserButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAction:)];
    
    [self.navigationItem setRightBarButtonItem:addUserButton];
}

#pragma mark - Actions

- (void) addAction:(id) sender {
    
    EIUserEditController* vc = [[EIUserEditController alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController* nc = [[UINavigationController alloc] initWithRootViewController:vc];
    
    nc.modalPresentationStyle = UIModalPresentationPopover;
    
    [self presentViewController:nc animated:YES completion:nil];
}

#pragma mark - SWTableViewCell actions

- (void)editButtonActionforCell:(SWTableViewCell *)cell {
    
    EIUserEditController* vc = [[EIUserEditController alloc] initWithStyle:UITableViewStyleGrouped];
    
    vc.user = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForCell:cell]];
    
    UINavigationController* nc = [[UINavigationController alloc] initWithRootViewController:vc];
    
    nc.modalPresentationStyle = UIModalPresentationPopover;
    
    [self presentViewController:nc animated:YES completion:nil];
    
    [cell hideUtilityButtonsAnimated:YES];
    
}

#pragma mark - Other

- (void)pushProfileControllerForUser:(EIUser *)user {
    
    EIUserProfileViewController* vc = [[EIUserProfileViewController alloc] initWithNibName:@"EIProfileViewController" bundle:nil];
    
    vc.user = user;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
