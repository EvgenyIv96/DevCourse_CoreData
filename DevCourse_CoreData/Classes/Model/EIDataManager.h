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

@interface EIDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (EIUser *)createNewUser;
- (EICourse *)createNewCourse;
- (void)deleteUser:(EIUser *)user;
- (void)removeUser:(EIUser *)user fromCourse:(EICourse *)course;
- (void)cancelChanges;

- (void)generateGeekbrainsPortal;

+ (EIDataManager *) sharedManager;

@end
