//
//  EIUser+CoreDataProperties.m
//  DevCourse_CoreData
//
//  Created by Евгений Иванов on 07.08.16.
//  Copyright © 2016 Евгений Иванов. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "EIUser+CoreDataProperties.h"

@implementation EIUser (CoreDataProperties)

@dynamic email;
@dynamic firstName;
@dynamic lastName;
@dynamic studiedCourses;
@dynamic taughtCourses;

@end
