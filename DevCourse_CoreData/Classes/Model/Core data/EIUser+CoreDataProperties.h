//
//  EIUser+CoreDataProperties.h
//  DevCourse_41_CoreData
//
//  Created by Евгений on 28.07.16.
//  Copyright © 2016 Евгений. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "EIUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface EIUser (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *email;
@property (nullable, nonatomic, retain) NSString *firstName;
@property (nullable, nonatomic, retain) NSString *lastName;
@property (nullable, nonatomic, retain) NSManagedObject *eduPlatform;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *studiedCourses;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *taughtCourses;

@end

@interface EIUser (CoreDataGeneratedAccessors)

- (void)addStudiedCoursesObject:(NSManagedObject *)value;
- (void)removeStudiedCoursesObject:(NSManagedObject *)value;
- (void)addStudiedCourses:(NSSet<NSManagedObject *> *)values;
- (void)removeStudiedCourses:(NSSet<NSManagedObject *> *)values;

- (void)addTaughtCoursesObject:(NSManagedObject *)value;
- (void)removeTaughtCoursesObject:(NSManagedObject *)value;
- (void)addTaughtCourses:(NSSet<NSManagedObject *> *)values;
- (void)removeTaughtCourses:(NSSet<NSManagedObject *> *)values;

@end

NS_ASSUME_NONNULL_END
