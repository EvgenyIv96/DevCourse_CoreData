//
//  EIUser+CoreDataProperties.h
//  DevCourse_CoreData
//
//  Created by Евгений Иванов on 07.08.16.
//  Copyright © 2016 Евгений Иванов. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "EIUser.h"
@class EICourse;

NS_ASSUME_NONNULL_BEGIN

@interface EIUser (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *email;
@property (nullable, nonatomic, retain) NSString *firstName;
@property (nullable, nonatomic, retain) NSString *lastName;
@property (nullable, nonatomic, retain) NSSet<EICourse *> *studiedCourses;
@property (nullable, nonatomic, retain) NSSet<EICourse *> *taughtCourses;

@end

@interface EIUser (CoreDataGeneratedAccessors)

- (void)addStudiedCoursesObject:(EICourse *)value;
- (void)removeStudiedCoursesObject:(EICourse *)value;
- (void)addStudiedCourses:(NSSet<EICourse *> *)values;
- (void)removeStudiedCourses:(NSSet<EICourse *> *)values;

- (void)addTaughtCoursesObject:(EICourse *)value;
- (void)removeTaughtCoursesObject:(EICourse *)value;
- (void)addTaughtCourses:(NSSet<EICourse *> *)values;
- (void)removeTaughtCourses:(NSSet<EICourse *> *)values;

@end

NS_ASSUME_NONNULL_END
