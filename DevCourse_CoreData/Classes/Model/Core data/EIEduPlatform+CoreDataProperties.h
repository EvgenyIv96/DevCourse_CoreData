//
//  EIEduPlatform+CoreDataProperties.h
//  DevCourse_41_CoreData
//
//  Created by Евгений on 28.07.16.
//  Copyright © 2016 Евгений. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "EIEduPlatform.h"

NS_ASSUME_NONNULL_BEGIN

@interface EIEduPlatform (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSSet<EICourse *> *courses;
@property (nullable, nonatomic, retain) NSSet<EIUser *> *users;

@end

@interface EIEduPlatform (CoreDataGeneratedAccessors)

- (void)addCoursesObject:(EICourse *)value;
- (void)removeCoursesObject:(EICourse *)value;
- (void)addCourses:(NSSet<EICourse *> *)values;
- (void)removeCourses:(NSSet<EICourse *> *)values;

- (void)addUsersObject:(EIUser *)value;
- (void)removeUsersObject:(EIUser *)value;
- (void)addUsers:(NSSet<EIUser *> *)values;
- (void)removeUsers:(NSSet<EIUser *> *)values;

@end

NS_ASSUME_NONNULL_END
