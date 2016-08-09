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
#import "EIBranchSelectionController.h"
#import "EIEditCell.h"
#import "EIAddCell.h"
#import "EIDataManager.h"
#import "EICourse.h"
#import "EIUser.h"
#import "EITextValidator.h"


static NSString* const valueSectionName = @"Course Info";
static NSString* const studentsSectionName = @"Students";
static NSString* const chooseTeacherText = @"Tap to choose teacher";
static NSString* const chooseBranchText = @"Tap to choose branch";

@interface EICourseEditController () <EISigleSelectionControllerDelegate, EIMultipieSelectionControllerDelegate, UITextFieldDelegate>

@property (strong, nonatomic) NSArray* sectionsArray;

@property (strong, nonatomic) EIStudentsSelectionController* studentsSelectionController;
@property (strong, nonatomic) EIBranchSelectionController* branchSelectionController;
@property (strong, nonatomic) EITeacherSelectionController* teacherSelectionController;

@property (weak, nonatomic) UITextField* nameField;
@property (weak, nonatomic) UITextField* subjectField;
@property (weak, nonatomic) UITextField* branchField;
@property (weak, nonatomic) UITextField* teacherField;

@end

@implementation EICourseEditController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadAllData];
    [self configurateNavigationBar];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
        cell.valueField.delegate = self;
        
        switch (indexPath.row) {
            case 0:
                self.nameField = cell.valueField;
                break;
                
            case 1:
                self.subjectField = cell.valueField;
                break;
                
            case 2:
                self.branchField = cell.valueField;
                break;
            default:
                self.teacherField = cell.valueField;
                break;
        }
        
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

- (nullable NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return nil;
    }
    
    return indexPath;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section != 0 && indexPath.row == 0) {
        [self addStudentsAction:[self.tableView cellForRowAtIndexPath:indexPath]];
    }
    
}

#pragma mark - EIMultipieSelectionControllerDelegate

- (void)controller:(EIMultipieSelectionController *)controller didChangeSelectedObjects:(NSArray *)selectedObjects {
    
    [self.course setStudents:[NSSet setWithArray: selectedObjects]];
    
    [self loadStudentsData];
    
    NSInteger section = [self getIndexOfSectionWithName:studentsSectionName];
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
    
}

#pragma mark - EISingleSelectionControllerDelegate

- (void)controller:(EISigleSelectionController *)controller didChangeSelectedObject:(id)newSelectedObject {
    
    NSInteger section = [self getIndexOfSectionWithName:valueSectionName];
    
    if (section == NSNotFound) {
        NSLog(@"Values section not found!");
        return;
    }
    
    EIEditSection* valuesSection = [self getSectionAtIndex:section];
    
    if ([controller isEqual:self.teacherSelectionController]) {
        
        self.course.teacher = newSelectedObject;
        
        NSInteger row = [self getIndexOfDictionaryForKey:@"Teacher" inArray:valuesSection.dataArray];
        
        NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:[self configureTeacherName], @"Teacher", nil];
        
        NSMutableArray* tempArray = [NSMutableArray arrayWithArray:valuesSection.dataArray];
        
        [tempArray replaceObjectAtIndex:row withObject:dict];
        
        valuesSection.dataArray = tempArray;
        
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:row inSection:section];
        
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
    }
    
    if ([controller isEqual:self.branchSelectionController]) {
        
        self.course.branch = newSelectedObject;
        
        NSInteger row = [self getIndexOfDictionaryForKey:@"Branch" inArray:valuesSection.dataArray];
        
        NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:[self configureBranchName] , @"Branch", nil];
        
        NSMutableArray* tempArray = [NSMutableArray arrayWithArray:valuesSection.dataArray];
        
        [tempArray replaceObjectAtIndex:row withObject:dict];
        
        valuesSection.dataArray = tempArray;

        
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:row inSection:section];
        
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
    }
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if ([textField isEqual:self.branchField]) {
        
        [self selectBranchAction:textField];
        
        return NO;
    } else if ([textField isEqual:self.teacherField]) {
        
        [self selectTeacherAction:textField];
        
        return NO;
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString* newString;
    
    newString = [EITextValidator validateCourseNameString:textField.text shouldChangeCharactersInRange:range replacementString:string];
    
    textField.text = newString;
    
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([textField isEqual:self.nameField]) {
        [self.subjectField becomeFirstResponder];
    } else if ([textField isEqual:self.subjectField]) {
        [textField resignFirstResponder];
    }
    
    return YES;
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
    
    NSString* teacherName = [self configureTeacherName];
    
    NSString* branch = [self configureBranchName];

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

- (NSString *)configureTeacherName {
    
    NSString* teacherName = chooseTeacherText;
    
    if (self.course.teacher.firstName && self.course.teacher.lastName) {
        teacherName = [NSString stringWithFormat:@"%@ %@", self.course.teacher.firstName, self.course.teacher.lastName];
    }
    
    return teacherName;
    
}

- (NSString *)configureBranchName {
    
    NSString* branch = self.course.branch;
    
    if (!branch || [branch isEqualToString:@""]) {
        branch = chooseBranchText;
    }
    
    return branch;
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

- (void)selectBranchAction:(id)sender {
    
    EIBranchSelectionController* selectionController = [[EIBranchSelectionController alloc] initWithStyle:UITableViewStylePlain];
    
    selectionController.navigationTitle = @"Branch";
    
    NSMutableArray* branches = [NSMutableArray arrayWithCapacity:branchesCount];
    
    for (int i = 0; i < branchesCount; i++) {
        [branches addObject:branchesArray[i]];
    }
    
    selectionController.allObjects = branches;
    
    if (![self.branchField.text isEqualToString:chooseBranchText]) {
        selectionController.selectedObject = self.branchField.text;
    }
    
    selectionController.delegate = self;
    self.branchSelectionController = selectionController;
    
    [self.navigationController pushViewController:selectionController animated:YES];
    
}

- (void)selectTeacherAction:(id)sender {
    
    EITeacherSelectionController* selectionController = [[EITeacherSelectionController alloc] initWithStyle:UITableViewStylePlain];
    
    selectionController.navigationTitle = @"Teacher";
    
    selectionController.allObjects = [[EIDataManager sharedManager] usersWithOutStudentsForCourse:self.course];
    
    selectionController.selectedObject = self.course.teacher;
    
    selectionController.delegate = self;
    self.teacherSelectionController = selectionController;
    
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
    
    if (![nameCell.valueField.text isEqualToString:emptyString] || ![subjectCell.valueField.text isEqualToString:emptyString] || ![branchCell.valueField.text isEqualToString:emptyString] ||![branchCell.valueField.text isEqualToString:chooseBranchText] || ![teacherCell.valueField.text isEqualToString:chooseTeacherText] || [self.course.students count] > 0) {
        
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

- (NSInteger)getIndexOfSectionWithName:(NSString *)name {
    
    for (EIEditSection* section in self.sectionsArray) {
        
        if ([section.name isEqualToString:name]) {
            
            return [self.sectionsArray indexOfObject:section];
            
        }
        
    }
    
    return NSNotFound;
}

- (NSInteger)getIndexOfDictionaryForKey:(NSString *)key inArray:(NSArray *)array {
    
    for (NSDictionary* dict in array) {
        
        for (NSString* tempKey in [dict allKeys]) {
            
            if ([tempKey isEqualToString:key]) {
                NSInteger index = [array indexOfObject:dict];
                return index;
            }
            
        }
        
    }
    
    return NSNotFound;
    
}

@end