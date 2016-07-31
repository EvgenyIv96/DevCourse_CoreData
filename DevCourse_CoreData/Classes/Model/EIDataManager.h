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

@interface EIDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (void)addUserWithFirstName:(NSString *)firstName lastName:(NSString *)lastName andEmail:(NSString *)email;
- (void)addCourseWithName:(NSString *)name subject:(NSString *)subject branch:(NSString *)branch;

+ (EIDataManager *) sharedManager;

@end
