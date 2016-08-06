//
//  EIMultipieSelectionController.m
//  DevCourse_CoreData
//
//  Created by Евгений Иванов on 01.08.16.
//  Copyright © 2016 Евгений Иванов. All rights reserved.
//

#import "EIMultipieSelectionController.h"

@interface EIMultipieSelectionController ()

@end

@implementation EIMultipieSelectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.navigationTitle;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.allObjects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
    }
    
    if ([self isSelectedCell:cell atIndexPath:indexPath]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    [self configureCell:cell withObject:[self.allObjects objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([self isSelectedCell:cell atIndexPath:indexPath]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.selectedObjects removeObject:[self.allObjects objectAtIndex:indexPath.row]];
    } else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.selectedObjects addObject:[self.allObjects objectAtIndex:indexPath.row]];
    }
    
    [self.delegate controller:self didChangeSelectedObjects:self.selectedObjects];
    
    [self.tableView reloadData];
    
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView* zeroView = [[UIView alloc] initWithFrame:CGRectZero];
    
    return zeroView;
    
}

#pragma mark - Other

- (BOOL)isSelectedCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    BOOL isSelected = NO;
    
    if ([self.selectedObjects containsObject:[self.allObjects objectAtIndex:indexPath.row]]) {
        isSelected = YES;
    }
    
    return isSelected;
    
}

- (void)configureCell:(UITableViewCell *)cell withObject:(id)object {
    
}

@end
