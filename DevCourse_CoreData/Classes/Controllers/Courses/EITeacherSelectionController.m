//
//  EITeacherSelectionController.m
//  DevCourse_CoreData
//
//  Created by Евгений Иванов on 03.08.16.
//  Copyright © 2016 Евгений Иванов. All rights reserved.
//

#import "EITeacherSelectionController.h"
#import "EIUser.h"

@interface EITeacherSelectionController ()

@end

@implementation EITeacherSelectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureCell:(UITableViewCell *)cell withObject:(id)object {
    
    if ([object isKindOfClass:[EIUser class]]) {
        
        EIUser* teacher = (EIUser *)object;
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", teacher.firstName, teacher.lastName];
        
    }
    
}

@end
