//
//  EIBranchSelectionController.m
//  DevCourse_CoreData
//
//  Created by Евгений Иванов on 04.08.16.
//  Copyright © 2016 Евгений Иванов. All rights reserved.
//

#import "EIBranchSelectionController.h"

@interface EIBranchSelectionController ()

@end

@implementation EIBranchSelectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureCell:(UITableViewCell *)cell withObject:(id)object {
    
    cell.textLabel.text = object;
    
}

@end
