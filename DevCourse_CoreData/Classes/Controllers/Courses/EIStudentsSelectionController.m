//
//  EIStudentsSelectionController.m
//  DevCourse_CoreData
//
//  Created by Евгений Иванов on 03.08.16.
//  Copyright © 2016 Евгений Иванов. All rights reserved.
//

#import "EIStudentsSelectionController.h"
#import "EIUser.h"

@interface EIStudentsSelectionController ()

@end

@implementation EIStudentsSelectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[[UINavigationBar appearance] setBarTintColor:headColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureCell:(UITableViewCell *)cell withObject:(id)object {
    
    if ([object isKindOfClass:[EIUser class]]) {
        
        EIUser* student = (EIUser *)object;
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", student.firstName, student.lastName];
        
    }
    
}

@end
