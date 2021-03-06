//
//  EIDataManager.h
//  DevCourse_41_CoreData
//
//  Created by Евгений on 28.07.16.
//  Copyright © 2016 Евгений. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@class EIUser;
@class EICourse;

static NSString* const branchesArray[] = {@"Mobile development", @"Design", @"Web", @"Backend development"};
static const NSInteger branchesCount = 4;

@interface EIDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (EIUser *)createNewUser;
- (NSArray *)coursesWithOutStudiesForUser:(EIUser *)user;
- (NSArray *)coursesWithOutTeachersForUser:(EIUser *)user;
- (NSArray *)usersWithOutTeacherForCourse:(EICourse *)course;
- (NSArray *)usersWithOutStudentsForCourse:(EICourse *)course;
- (EICourse *)createNewCourse;
- (void)deleteUser:(EIUser *)user;
- (void)deleteCourse:(EICourse *)course;
- (void)removeTeacher:(EIUser *)user fromCourse:(EICourse *)course;
- (void)removeStudent:(EIUser *)user fromCourse:(EICourse *)course;
- (void)cancelChanges;

- (void)generateGeekbrainsPortal;

+ (EIDataManager *) sharedManager;

@end
