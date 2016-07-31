//
//  EICourse+CoreDataProperties.h
//  DevCourse_41_CoreData
//
//  Created by Евгений on 28.07.16.
//  Copyright © 2016 Евгений. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "EICourse.h"

NS_ASSUME_NONNULL_BEGIN

@interface EICourse (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *branch;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *subject;
@property (nullable, nonatomic, retain) NSManagedObject *eduPlatform;
@property (nullable, nonatomic, retain) NSSet<EIUser *> *students;
@property (nullable, nonatomic, retain) EIUser *teacher;

@end

@interface EICourse (CoreDataGeneratedAccessors)

- (void)addStudentsObject:(EIUser *)value;
- (void)removeStudentsObject:(EIUser *)value;
- (void)addStudents:(NSSet<EIUser *> *)values;
- (void)removeStudents:(NSSet<EIUser *> *)values;

@end

NS_ASSUME_NONNULL_END
