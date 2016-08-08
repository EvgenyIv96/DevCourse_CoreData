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

@interface EIUserProfileViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

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
    [self loadUserCourses];
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



#pragma mark - Data managment

- (void)loadUserCourses {
    
    [self loadStudiedCourses];
    [self loadTaughtCourses];
    
    [self.collectionView reloadData];
    
}

- (void)loadStudiedCourses {
    
    if ([self.user.studiedCourses count] > 0) {
        NSMutableArray* tempArray = [NSMutableArray arrayWithArray:self.coursesSectionsArray];
        EICoursesSection* section = [[EICoursesSection alloc] init];
        section.name = @"Courses which studied";
        section.coursesArray = [self.user.studiedCourses allObjects];
        [tempArray addObject:section];
        self.coursesSectionsArray = [NSArray arrayWithArray:tempArray];
    }
    
}

- (void)loadTaughtCourses {
        
    if ([self.user.taughtCourses count] > 0) {
        NSMutableArray* tempArray = [NSMutableArray arrayWithArray:self.coursesSectionsArray];
        EICoursesSection* section = [[EICoursesSection alloc] init];
        section.name = @"Courses which leads";
        section.coursesArray = [self.user.taughtCourses allObjects];
        [tempArray addObject:section];
        self.coursesSectionsArray = [NSArray arrayWithArray:tempArray];
    }
    
}

#pragma mark - Other

- (void)configureView {
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", self.user.firstName, self.user.lastName];
    self.emailLabel.text = self.user.email;
    
}

- (void)configureNavigationBar {
    self.navigationItem.title = @"Profile";
}

- (NSString *)getCourseNameAtIndexPath:(NSIndexPath *)indexPath {
    
    EICoursesSection* section = [self.coursesSectionsArray objectAtIndex:indexPath.section];
    
    EICourse* course = [section.coursesArray objectAtIndex:indexPath.row];
    
    return course.name;
    
}

@end
