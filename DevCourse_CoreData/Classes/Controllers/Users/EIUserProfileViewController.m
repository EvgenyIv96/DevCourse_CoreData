//
//  EIUserProfileViewController.m
//  DevCourse_CoreData
//
//  Created by Евгений Иванов on 07.08.16.
//  Copyright © 2016 Евгений Иванов. All rights reserved.
//

#import "EIUserProfileViewController.h"
#import "EIUser.h"
#import "EICourse.h"
#import "EICoursesSection.h"
#import "EICourseCollectionCell.h"
#import "EICourseHeaderCollectionView.h"
#import "EIUserEditController.h"

@interface EIUserProfileViewController () <UICollectionViewDelegate, UICollectionViewDataSource, EIUserEditControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel* nameLabel;
@property (weak, nonatomic) IBOutlet UILabel* emailLabel;
@property (weak, nonatomic) IBOutlet UIImageView* avatarImageView;

@property (weak, nonatomic) IBOutlet UICollectionView* collectionView;

@property (strong, nonatomic) NSArray* coursesSectionsArray;

@end

@implementation EIUserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureView];
    [self configureNavigationBar];
    [self loadAllUserData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.coursesSectionsArray count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    EICoursesSection* coursesSection = [self.coursesSectionsArray objectAtIndex:section];
    
    return [coursesSection.coursesArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifier = @"Course Cell";
    
    [collectionView registerNib:[UINib nibWithNibName:@"EICourseCollectionCell"
                                               bundle:nil]
                                    forCellWithReuseIdentifier:identifier];
    
    EICourseCollectionCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    cell.titleLabel.text = [self getCourseNameAtIndexPath:indexPath];
    
    cell.layer.cornerRadius = 9;
    cell.layer.masksToBounds = YES;
    
    return cell;
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        static NSString* identifier = @"Header View";
        
        [collectionView registerNib:[UINib nibWithNibName:@"EICourseHeaderCollectionView" bundle:nil] forSupplementaryViewOfKind:kind withReuseIdentifier:identifier];
        
        EICourseHeaderCollectionView* headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifier forIndexPath:indexPath];
        
        EICoursesSection* section = [self.coursesSectionsArray objectAtIndex:indexPath.section];
        
        headerView.titleLabel.text = section.name;
        headerView.backgroundColor = collectionHeaderViewBackgroundColor;
        headerView.titleLabel.textColor = collectionHeaderLabelColor;
        
        headerView.layer.cornerRadius = 10;
        headerView.layer.masksToBounds = YES;
        
        return headerView;
        
    }
    
    return nil;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString* itemString = [self getCourseNameAtIndexPath:indexPath];
    
    CGSize stringSize = [itemString sizeWithAttributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:18.f] }];
    
    stringSize.height += 10;
    stringSize.width += 18;
    
    return stringSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    UIEdgeInsets edgeInsents = UIEdgeInsetsMake(5, 20, 15, 20);
    
    return edgeInsents;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    CGSize size = CGSizeMake(collectionView.bounds.size.width, 25);
    
    return size;
    
}

#pragma mark - EIUserEditControllerDelegate

- (void)userEditControllerDidFinishedWork:(EIUserEditController *)controller {
    
    [self loadAllUserData];
    
}

#pragma mark - Data managment

- (void)loadAllUserData {
    [self loadUserProperties];
    [self loadUserCourses];
}

- (void)loadUserProperties {
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", self.user.firstName, self.user.lastName];
    self.emailLabel.text = self.user.email;
}

- (void)loadUserCourses {
    
    [self loadStudiedCourses];
    [self loadTaughtCourses];
    
    [self.collectionView reloadData];
    
}

- (void)loadStudiedCourses {
    
    EICoursesSection* section = [[EICoursesSection alloc] init];
    section.name = @"Courses which studied";
    if ([self.user.studiedCourses count] > 0) {
        section.coursesArray = [self.user.studiedCourses allObjects];
    }
    [self addSectionToSectionsArray:section];
    
}

- (void)loadTaughtCourses {

    EICoursesSection* section = [[EICoursesSection alloc] init];
    section.name = @"Courses which leads";
    if ([self.user.taughtCourses count] > 0) {
        section.coursesArray = [self.user.taughtCourses allObjects];
    }
    [self addSectionToSectionsArray:section];
    
}

#pragma mark - Actions

- (void)editAction:(id)sender {
    
    EIUserEditController* vc = [[EIUserEditController alloc] initWithStyle:UITableViewStyleGrouped];
    vc.user = self.user;
    vc.delegate = self;
    
    UINavigationController* nc = [[UINavigationController alloc] initWithRootViewController:vc];
    nc.modalPresentationStyle = UIModalPresentationFullScreen;
    
    [self presentViewController:nc animated:YES completion:nil];
    
}

#pragma mark - Other

- (void)configureView {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}

- (void)configureNavigationBar {
    self.navigationItem.title = @"Profile";
    
    UIBarButtonItem* editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editAction:)];
    
    [self.navigationItem setRightBarButtonItem:editButton];
    
}

- (NSString *)getCourseNameAtIndexPath:(NSIndexPath *)indexPath {
    
    EICoursesSection* section = [self.coursesSectionsArray objectAtIndex:indexPath.section];
    
    EICourse* course = [section.coursesArray objectAtIndex:indexPath.row];
    
    return course.name;
    
}

- (void)addSectionToSectionsArray:(EICoursesSection *)section {
    
    BOOL isAdded = NO;
    
    for (EICoursesSection* sect in self.coursesSectionsArray) {
        
        if ([sect.name isEqualToString:section.name]) {
            
            if ([section.coursesArray count] > 0) {
                sect.coursesArray = [NSArray arrayWithArray:section.coursesArray];
            } else {
                NSMutableArray* tempCoursesArray = [NSMutableArray arrayWithArray:self.coursesSectionsArray];
                
                [tempCoursesArray removeObject:sect];
                
                self.coursesSectionsArray = tempCoursesArray;
            }
            
            isAdded = YES;
            break;
        }
        
    }
    
    if (!isAdded) {
        
        NSMutableArray* tempCoursesArray = [NSMutableArray arrayWithArray:self.coursesSectionsArray];
        if ([section.coursesArray count] > 0) {
            [tempCoursesArray addObject:section];
        }
        self.coursesSectionsArray = [NSArray arrayWithArray:tempCoursesArray
                                     ];
        
    }
    
}

@end