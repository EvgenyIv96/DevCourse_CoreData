//
//  EIUserProfileViewController.m
//  DevCourse_CoreData
//
//  Created by Евгений Иванов on 07.08.16.
//  Copyright © 2016 Евгений Иванов. All rights reserved.
//

#import "EIUserProfileViewController.h"
#import "EIUser.h"

@interface EIUserProfileViewController ()

@property (weak, nonatomic) IBOutlet UILabel* nameLabel;
@property (weak, nonatomic) IBOutlet UILabel* emailLabel;
@property (weak, nonatomic) IBOutlet UIImageView* avatarImageView;

@end

@implementation EIUserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureView];
    [self configureNavigationBar];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Other

- (void)configureView {
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", self.user.firstName, self.user.lastName];
    self.emailLabel.text = self.user.email;
    
}

- (void)configureNavigationBar {
    self.navigationItem.title = @"Profile";
}

@end
