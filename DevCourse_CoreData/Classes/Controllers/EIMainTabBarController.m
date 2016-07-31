//
//  EIMainTabBarController.m
//  DevCourse_41_CoreData
//
//  Created by Евгений on 28.07.16.
//  Copyright © 2016 Евгений. All rights reserved.
//

#import "EIMainTabBarController.h"
#import "EIUsersViewController.h"
#import "EICoursesViewController.h"

@interface EIMainTabBarController ()

@end

@implementation EIMainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    EIUsersViewController* usersController = [[EIUsersViewController alloc] initWithNibName:@"EICoreDataController" bundle:nil];
    
    UINavigationController* usersNavContr = [[UINavigationController alloc] initWithRootViewController:usersController];
    
    usersNavContr.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Users" image:nil tag:0];
    
    EICoursesViewController* coursesController = [[EICoursesViewController alloc] initWithNibName:@"EICoreDataController" bundle:nil];
    
    UINavigationController* coursesNavContr = [[UINavigationController alloc] initWithRootViewController:coursesController];
    
    coursesNavContr.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Courses" image:nil tag:1];
    
    [self setViewControllers:@[usersNavContr, coursesNavContr]];
    [self setSelectedIndex:0];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
