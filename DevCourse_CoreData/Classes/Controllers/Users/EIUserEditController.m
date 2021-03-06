//
//  EIUserEditController.m
//  DevCourse_CoreData
//
//  Created by Евгений Иванов on 01.08.16.
//  Copyright © 2016 Евгений Иванов. All rights reserved.
//

#import "EIUserEditController.h"
#import "EIDataManager.h"
#import "EIUser.h"
#import "EICourse.h"
#import "EIEditSection.h"
#import "EIEditCell.h"
#import "EIAddCell.h"
#import "EICoursesSelectionController.h"
#import "EITextValidator.h"

static NSString* const valueSectionName = @"User Info";
static NSString* const studiedCoursesSectionName = @"Studied Courses";
static NSString* const teachesCoursesSectionName = @"Taught Courses";

@interface EIUserEditController () <EIMultipieSelectionControllerDelegate, UITextFieldDelegate>

@property (strong, nonatomic) NSArray* sectionsArray;
@property (weak, nonatomic) EICoursesSelectionController* studiesController;
@property (weak, nonatomic) EICoursesSelectionController* taughtController;

@property (weak, nonatomic) UITextField* firstNameField;
@property (weak, nonatomic) UITextField* lastNameField;
@property (weak, nonatomic) UITextField* emailField;

@end

@implementation EIUserEditController

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
                self.firstNameField = cell.valueField;
                cell.valueField.returnKeyType = UIReturnKeyNext;
                cell.valueField.autocorrectionType = UITextAutocorrectionTypeNo;
                cell.valueField.autocapitalizationType = UITextAutocapitalizationTypeWords;
                break;
                
            case 1:
                self.lastNameField = cell.valueField;
                cell.valueField.returnKeyType = UIReturnKeyNext;
                cell.valueField.autocorrectionType = UITextAutocorrectionTypeNo;
                cell.valueField.autocapitalizationType = UITextAutocapitalizationTypeWords;
                break;
                
            default:
                self.emailField = cell.valueField;
                cell.valueField.returnKeyType = UIReturnKeyDone;
                cell.valueField.autocorrectionType = UITextAutocorrectionTypeNo;
                cell.valueField.autocapitalizationType = UITextAutocapitalizationTypeNone;
                break;
        }

        
        return cell;
    
    } else {
        
        if (indexPath.row == 0) {
            
            NSString* identifier = @"Add Cell";
            
            EIAddCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (!cell) {
                
                [tableView registerNib:[UINib nibWithNibName:@"EIAddCell" bundle:nil] forCellReuseIdentifier:identifier];
                cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                
            }
            
            [cell.addButton setAttributedTitle: nil forState: 0xffff];
            [cell.addButton setTitle: @"Add course" forState: UIControlStateNormal];
            
            if ([section.name isEqualToString:teachesCoursesSectionName]) {
                [cell.addButton removeTarget:nil action:nil forControlEvents:UIControlEventAllTouchEvents];
                [cell.addButton addTarget:self action:@selector(addTaughtCourse:) forControlEvents:UIControlEventTouchUpInside];
            } else if ([section.name isEqualToString:studiedCoursesSectionName]) {
                [cell.addButton removeTarget:nil action:nil forControlEvents:UIControlEventAllTouchEvents];
                [cell.addButton addTarget:self action:@selector(addStudiedCourse:) forControlEvents:UIControlEventTouchUpInside];
            }

            
            return cell;
            
        } else {
            
            EICourse* course = [section.dataArray objectAtIndex:indexPath.row - 1];
            
            NSString* identifier = @"Cell";
            
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (!cell) {
                
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                
            }
            
            NSString* nameString = [NSString stringWithFormat:@"%@",course.name];
            
            cell.textLabel.text = nameString;
            
            return cell;

        }
    }
    
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ((indexPath.section == 1 && indexPath.row != 0) || (indexPath.section == 2 && indexPath.row != 0)) {
        return YES;
    }
    
    return NO;
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        EIEditSection* section = [self getSectionAtIndex:indexPath.section];
        
        NSIndexPath* correctPath = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
        
        EICourse* course = [section.dataArray objectAtIndex:correctPath.row];
        
        if ([section.name isEqualToString:teachesCoursesSectionName]) {
            [[EIDataManager sharedManager] removeTeacher:self.user fromCourse:course];
            [self loadTaughtCoursesData];
        } else if ([section.name isEqualToString:studiedCoursesSectionName]) {
            [[EIDataManager sharedManager] removeStudent:self.user fromCourse:course];
            [self loadStudiedCoursesData];
        }
        
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
    }   
}

#pragma mark - UITableViewDelegate

- (nullable NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 || indexPath.row != 0) {
        return nil;
    }
    
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EIEditSection* editSection = [self getSectionAtIndex:indexPath.section];
    
    if ([editSection.name isEqualToString:studiedCoursesSectionName]) {
        [self addStudiedCourse:[tableView cellForRowAtIndexPath:indexPath]];
    } else if ([editSection.name isEqualToString:teachesCoursesSectionName]) {
        [self addTaughtCourse:[tableView cellForRowAtIndexPath:indexPath]];
    }
    
}

#pragma mark - EIMultipieSelectionControllerDelegate

- (void)controller:(EIMultipieSelectionController *)controller didChangeSelectedObjects:(NSArray *)selectedObjects {
    
    if ([controller isEqual:self.studiesController]) {
        
        [self.user setStudiedCourses:[NSSet setWithArray:selectedObjects]];
        [self loadStudiedCoursesData];
        
        NSInteger section = [self getIndexOfSectionWithName:studiedCoursesSectionName];
        
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
        
    } else if ([controller isEqual:self.taughtController]) {
        
        [self.user setTaughtCourses:[NSSet setWithArray:selectedObjects]];
        [self loadTaughtCoursesData];
        
        NSInteger section = [self getIndexOfSectionWithName:teachesCoursesSectionName];
        
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
        
    }
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([textField isEqual:self.emailField]) {
        [textField resignFirstResponder];
    } else if ([textField isEqual:self.firstNameField]){
        [self.lastNameField becomeFirstResponder];
    } else {
        [self.emailField becomeFirstResponder];
    }
    
    return YES;
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([textField isEqual:self.emailField]) {
        
        return [EITextValidator emailString:textField.text shouldChangeCharactersInRange:range replacementString:string];
        
    } else {
        
        return [EITextValidator nameString:textField.text shouldChangeCharactersInRange:range replacementString:string];
        
    }
    
    return NO;
    
}

#pragma mark - Data managment

- (void)loadAllData {
    
    if (!self.user) {
        
        self.user = [[EIDataManager sharedManager] createNewUser];
        [self loadAllData];
        
    } else {
        
        [self loadUserValuesData];
        [self loadStudiedCoursesData];
        [self loadTaughtCoursesData];
        
    }
    
}

- (void)loadUserValuesData {
    
    NSString* firstName = self.user.firstName;
    NSString* lastName = self.user.lastName;
    NSString* email = self.user.email;
    
    NSDictionary* firstNameDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        firstName, @"First name",nil];
    
    NSDictionary* lastNameDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        lastName, @"Last name", nil];
    
    
    NSDictionary* emailDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                     email, @"Email",nil];
    
    EIEditSection* valuesSection = [[EIEditSection alloc] init];
    valuesSection.name = valueSectionName;
    valuesSection.dataArray = [NSArray arrayWithObjects:firstNameDictionary, lastNameDictionary, emailDictionary, nil];
    
    [self addSection:valuesSection toSectionsArray:self.sectionsArray];
    
}

- (void)loadStudiedCoursesData {
    
    NSArray* studiedCourses = [self.user.studiedCourses allObjects];
    
    EIEditSection* studiedCoursesSection = [[EIEditSection alloc] init];
    studiedCoursesSection.name = studiedCoursesSectionName;
    studiedCoursesSection.dataArray = [NSArray arrayWithArray:studiedCourses];
    
    [self addSection:studiedCoursesSection toSectionsArray:self.sectionsArray];
    
}

- (void)loadTaughtCoursesData {
    
    NSArray* taughtCoursesData = [self.user.taughtCourses allObjects];
    
    EIEditSection* taughtSection = [[EIEditSection alloc] init];
    taughtSection.name = teachesCoursesSectionName;
    taughtSection.dataArray = [NSArray arrayWithArray:taughtCoursesData];
    
    [self addSection:taughtSection toSectionsArray:self.sectionsArray];
    
}

#pragma mark - Actions

- (void)addStudiedCourse:(id)sender {
    
    EICoursesSelectionController* selectionController = [[EICoursesSelectionController alloc] initWithStyle:UITableViewStylePlain];
    
    selectionController.navigationTitle = @"Studied courses";
    
    selectionController.allObjects = [[EIDataManager sharedManager] coursesWithOutTeachersForUser:self.user];
    selectionController.selectedObjects = [NSMutableArray arrayWithArray:[self.user.studiedCourses allObjects]];
    selectionController.delegate = self;
    
    self.studiesController = selectionController;
    
    [self.navigationController pushViewController:selectionController animated:YES];
    
}

- (void)addTaughtCourse:(id)sender {
    
    EICoursesSelectionController* selectionController = [[EICoursesSelectionController alloc] initWithStyle:UITableViewStylePlain];
    
    selectionController.navigationTitle = @"Courses which are leads";
    
    selectionController.allObjects = [[EIDataManager sharedManager] coursesWithOutStudiesForUser:self.user];
    selectionController.selectedObjects = [NSMutableArray arrayWithArray:[self.user.taughtCourses allObjects]];
    selectionController.delegate = self;
    
    self.taughtController = selectionController;
    
    [self.navigationController pushViewController:selectionController animated:YES];
    
}

- (void)closeAction:(id)sender {
    
    if ([self isEmptyUser]) {
        [[EIDataManager sharedManager] deleteUser:self.user];
        [[EIDataManager sharedManager] saveContext];
        [self dismissViewControllerAnimated:YES completion:^{
            [self.delegate userEditControllerDidFinishedWork:self];
        }];
    } else {
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Warning!"
                                                            message:@"All data will be lost. Are you sure?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* saveAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[EIDataManager sharedManager] cancelChanges];
            [self dismissViewControllerAnimated:YES completion:^{
                [self.delegate userEditControllerDidFinishedWork:self];
            }];
            
        }];
        
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        [alert addAction:cancelAction];
        [alert addAction:saveAction];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
}

- (void)saveAction:(id)sender {
    
    EIEditCell* firstNameCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];

    EIEditCell* lastNameCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    EIEditCell* emailCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    
    self.user.firstName = firstNameCell.valueField.text;
    self.user.lastName = lastNameCell.valueField.text;
    self.user.email = emailCell.valueField.text;
    
    [[EIDataManager sharedManager] saveContext];
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate userEditControllerDidFinishedWork:self];
    }];
    
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

- (BOOL)isEmptyUser {
    
    BOOL isEmpty = YES;
    
    EIEditCell* firstNameCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    EIEditCell* lastNameCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    EIEditCell* emailCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    
    NSString* emptyString = @"";

    if (![firstNameCell.valueField.text isEqualToString:emptyString] || ![lastNameCell.valueField.text isEqualToString:emptyString] || ![emailCell.valueField.text isEqualToString:emptyString] || [self.user.studiedCourses count] > 0 || [self.user.taughtCourses count] > 0) {
        
        isEmpty = NO;
        
    }
    
    return isEmpty;
    
}

- (void)configurateNavigationBar {
    
    NSString* name = [NSString stringWithFormat:@"%@ %@", self.user.firstName, self.user.lastName];
    
    if (![name isEqualToString:@" "]) {
        self.navigationItem.title = name;
    } else {
        self.navigationItem.title = @"New user";
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

@end