//
//  EICourseEditController.m
//  DevCourse_CoreData
//
//  Created by Евгений Иванов on 03.08.16.
//  Copyright © 2016 Евгений Иванов. All rights reserved.
//

#import "EICourseEditController.h"
#import "EIEditSection.h"
#import "EIStudentsSelectionController.h"
#import "EITeacherSelectionController.h"
#import "EIEditCell.h"
#import "EIAddCell.h"
#import "EIDataManager.h"
#import "EICourse.h"
#import "EIUser.h"


static NSString* const valueSectionName = @"Course Info";
static NSString* const studentsSectionName = @"Students";
static NSString* const chooseTeacherText = @"Tap to choose teacher";

@interface EICourseEditController ()

@property (strong, nonatomic) NSArray* sectionsArray;
//@property (strong, nonatomic) EIUser* teacher;

@property (strong, nonatomic) EIStudentsSelectionController* studentsSelectionController;

@end

@implementation EICourseEditController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadAllData];
    [self configurateNavigationBar];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    EIEditSection* editSection = [self getSectionAtIndex:section];
    
    return editSection.name;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sectionsArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    EIEditSection* editSection = [self getSectionAtIndex:section];
    
    if ([editSection.name isEqualToString:valueSectionName]) {
        return [editSection.dataArray count];
    }
    
    return [editSection.dataArray count] + 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EIEditSection* section = [self getSectionAtIndex:indexPath.section];
    
    if ([section.name isEqualToString:valueSectionName]) {
        
        NSString* identifier = @"Value Cell";
        
        EIEditCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            
            [tableView registerNib:[UINib nibWithNibName:@"EIEditCell" bundle:nil] forCellReuseIdentifier:identifier];
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
        }
        
        NSDictionary* dataDictionary = [section.dataArray objectAtIndex:indexPath.row];
        NSArray* keys = [dataDictionary allKeys];
        NSString* key = [keys firstObject];
        
        cell.descriptionLabel.text = key;
        cell.valueField.text = [dataDictionary objectForKey:key];
        
        return cell;
        
    } else if ([section.name isEqualToString:studentsSectionName]) {
         
        if (indexPath.row == 0) {
         
            static NSString* identifier = @"Add Cell";

            EIAddCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];

            if (!cell) {

                [tableView registerNib:[UINib nibWithNibName:@"EIAddCell" bundle:nil] forCellReuseIdentifier:identifier];
                cell = [tableView dequeueReusableCellWithIdentifier:identifier];

            }

            [cell.addButton setAttributedTitle: nil forState: 0xffff];
            [cell.addButton setTitle: @"Add students" forState: UIControlStateNormal];
            [cell.addButton addTarget:self action:@selector(addStudentsAction:) forControlEvents:UIControlEventTouchUpInside];

            return cell;
         
         } else {
         
            EIUser* student = [section.dataArray objectAtIndex:indexPath.row - 1];

            static NSString* identifier = @"Cell";

            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];

            if (!cell) {

                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];

            }

            NSString* nameString = [NSString stringWithFormat:@"%@ %@", student.firstName, student.lastName];

            cell.textLabel.text = nameString;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

            return cell;
         
         }
    }
    
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ((indexPath.section == 1 && indexPath.row != 0)) {
        return YES;
    }
    
    return NO;
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        EIEditSection* section = [self getSectionAtIndex:indexPath.section];
        
        NSIndexPath* correctPath = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
        
        EIUser* student = [section.dataArray objectAtIndex:correctPath.row];
        
        if ([section.name isEqualToString:studentsSectionName]) {
            [[EIDataManager sharedManager] removeStudent:student fromCourse:self.course];
            [self loadStudentsData];
        }
        
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
    }
}

#pragma mark - UITableViewDelegate

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - EIMultipieSelectionControllerDelegate

- (void)controller:(EIMultipieSelectionController *)controller didChangeSelectedObjects:(NSArray *)selectedObjects {
    
    [self.course setStudents:[NSSet setWithArray: selectedObjects]];
    
    [self loadStudentsData];
    [self.tableView reloadData];
    
}

#pragma mark - Data managment

- (void)loadAllData {
    
    if (!self.course) {
        
        self.course = [[EIDataManager sharedManager] createNewCourse];
        [self loadAllData];
        
    } else {
        
        [self loadCourseValuesData];
        [self loadStudentsData];
        
    }
    
}

- (void)loadCourseValuesData {
    
    NSString* name = self.course.name;
    NSString* subject = self.course.subject;
    NSString* branch = self.course.branch;
    
    NSString* teacherName;
    
    if (self.course.teacher.firstName && self.course.teacher.lastName) {
        teacherName = [NSString stringWithFormat:@"%@ %@", self.course.teacher.firstName, self.course.teacher.lastName];
    } else {
        teacherName = chooseTeacherText;
    }

    

    NSDictionary* nameDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                         name, @"Course name",nil];
    
    NSDictionary* subjectDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        subject, @"Subject", nil];
    
    NSDictionary* branchDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                     branch, @"Branch",nil];
    
    NSDictionary* teacherDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:teacherName, @"Teacher", nil];
    
    EIEditSection* valuesSection = [[EIEditSection alloc] init];
    valuesSection.name = valueSectionName;
    valuesSection.dataArray = [NSArray arrayWithObjects:nameDictionary, subjectDictionary, branchDictionary, teacherDictionary, nil];
    
    [self addSection:valuesSection toSectionsArray:self.sectionsArray];
    
}

- (void)loadStudentsData {
    
    NSArray* students = [self.course.students allObjects];
    
    EIEditSection* studentsSection = [[EIEditSection alloc] init];
    studentsSection.name = studentsSectionName;
    studentsSection.dataArray = [NSArray arrayWithArray:students];
    
    [self addSection:studentsSection toSectionsArray:self.sectionsArray];
    
}



#pragma mark - Actions

- (void)addStudentsAction:(id)sender {
    
    EIStudentsSelectionController* selectionController = [[EIStudentsSelectionController alloc] initWithStyle:UITableViewStylePlain];
    
    selectionController.navigationTitle = @"Students";
    
    selectionController.allObjects = [[EIDataManager sharedManager] usersWithOutTeacherForCourse:self.course];
    selectionController.selectedObjects = [NSMutableArray arrayWithArray:[self.course.students allObjects]];
    selectionController.delegate = self;
    
    self.studentsSelectionController = selectionController;
    
    [self.navigationController pushViewController:selectionController animated:YES];
    
}


- (void)closeAction:(id)sender {
    
    if ([self isEmptyCourse]) {
       [[EIDataManager sharedManager] deleteCourse:self.course];
        [[EIDataManager sharedManager] saveContext];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Warning!"
                                                                       message:@"All data will be lost. Are you sure?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* saveAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[EIDataManager sharedManager] cancelChanges];
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }];
        
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        [alert addAction:cancelAction];
        [alert addAction:saveAction];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
}

- (void)saveAction:(id)sender {
    
    EIEditCell* nameCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    EIEditCell* subjectCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    EIEditCell* branchCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    
    self.course.name = nameCell.valueField.text;
    self.course.subject = subjectCell.valueField.text;
    self.course.branch = branchCell.valueField.text;
    
    [[EIDataManager sharedManager] saveContext];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


#pragma mark - Other

- (EIEditSection *)getSectionAtIndex:(NSInteger)index {
    
    EIEditSection* section = [self.sectionsArray objectAtIndex:index];
    
    return section;
    
}

- (void)addSection:(EIEditSection *)section toSectionsArray:(NSArray *)array {
    
    BOOL isAdded = NO;
    
    for (EIEditSection*  sect in self.sectionsArray) {
        
        if ([sect.name isEqualToString:section.name]) {
            sect.dataArray = [NSArray arrayWithArray:section.dataArray];
            isAdded = YES;
            break;
        }
        
    }
    
    if (!isAdded) {
        
        NSMutableArray* tempArray = [NSMutableArray arrayWithArray:self.sectionsArray];
        [tempArray addObject:section];
        self.sectionsArray = [NSArray arrayWithArray:tempArray];
        
    }
    
}

- (BOOL)isEmptyCourse {
    
    BOOL isEmpty = YES;
    
    EIEditCell* nameCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    EIEditCell* subjectCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    EIEditCell* branchCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    
    EIEditCell* teacherCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    
    NSString* emptyString = @"";
    
    if (![nameCell.valueField.text isEqualToString:emptyString] || ![subjectCell.valueField.text isEqualToString:emptyString] || ![branchCell.valueField.text isEqualToString:emptyString] ||![branchCell.valueField.text isEqualToString:emptyString] || ![teacherCell.valueField.text isEqualToString:chooseTeacherText] || [self.course.students count] > 0) {
        
        isEmpty = NO;
        
    }
    
    return isEmpty;
    
}

- (void)configurateNavigationBar {
    
    if (![self.course.name isEqualToString:@""]) {
        self.navigationItem.title = self.course.name;
    } else {
        self.navigationItem.title = @"New course";
    }
    
    UIBarButtonItem* closeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(closeAction:)];
    
    UIBarButtonItem* saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveAction:)];
    
    self.navigationItem.leftBarButtonItem = closeButton;
    self.navigationItem.rightBarButtonItem = saveButton;
    
}

@end
