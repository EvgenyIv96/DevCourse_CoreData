//
//  EICoursesSelectionController.m
//  DevCourse_CoreData
//
//  Created by Евгений Иванов on 01.08.16.
//  Copyright © 2016 Евгений Иванов. All rights reserved.
//

#import "EICoursesSelectionController.h"
#import "EICourse.h"

@interface EICoursesSelectionController ()

@end

@implementation EICoursesSelectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureCell:(UITableViewCell *)cell withObject:(id)object {
    
    if ([object isKindOfClass:[EICourse class]]) {
        
        EICourse* course = (EICourse *)object;
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@", course.name];
        
    }
    
}


@end
