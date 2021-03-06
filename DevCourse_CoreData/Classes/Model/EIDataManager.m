//
//  EIDataManager.m
//  DevCourse_41_CoreData
//
//  Created by Евгений on 28.07.16.
//  Copyright © 2016 Евгений. All rights reserved.
//

#import "EIDataManager.h"
#import "EIUser.h"
#import "EICourse.h"

@implementation EIDataManager

+ (EIDataManager *) sharedManager {
    
    static EIDataManager* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[EIDataManager alloc] init];
        
    });

    return manager;
}

#pragma mark - Data managment methods

- (NSArray *)coursesWithOutStudiesForUser:(EIUser *)user {
    
    NSError* error = nil;
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"NOT(SELF IN %@.studiedCourses)", user];

    NSFetchRequest* request = [self courseRequestWithPredicate:predicate];
    
    NSArray* courses = [self.managedObjectContext executeFetchRequest:request error:&error];
    
//    for (EICourse* course in courses) {
//        NSLog(@"%@",course.name);
//        NSLog(@"Students:\n %@", [course.students allObjects]);
//    }
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    return courses;
    
}

- (NSArray *)coursesWithOutTeachersForUser:(EIUser *)user {
    
    NSError* error = nil;
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"teacher=nil OR teacher!=%@", user];
    
    NSFetchRequest* request = [self courseRequestWithPredicate:predicate];
    
    NSArray* courses = [self.managedObjectContext executeFetchRequest:request error:&error];
    
//    for (EICourse* course in courses) {
//        NSLog(@"%@",course.name);
//        NSLog(@"Teachers:\n %@", [course.students allObjects]);
//    }
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    return courses;

}

- (NSArray *)usersWithOutTeacherForCourse:(EICourse *)course {
    
    NSError* error = nil;
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"NOT(SELF = %@.teacher)",course];
    
    NSFetchRequest* request = [self userRequestWithPredicate:predicate];
    
    NSArray* users = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    return users;
    
}

- (NSArray *)usersWithOutStudentsForCourse:(EICourse *)course {
    
    NSError* error = nil;
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"NOT(SELF IN %@.students)", course];
    
    NSFetchRequest* request = [self userRequestWithPredicate:predicate];
    
    NSArray* users = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    return users;
    
}

- (void)cancelChanges {
    [self.managedObjectContext rollback];
}

- (EIUser *)createNewUser {
    
    EIUser* user = [NSEntityDescription insertNewObjectForEntityForName:@"EIUser" inManagedObjectContext:self.managedObjectContext];
    
    user.firstName = @"";
    user.lastName = @"";
    user.email = @"";
    
    return user;
    
}

- (EICourse *)createNewCourse {
    
    EICourse* course = [NSEntityDescription insertNewObjectForEntityForName:@"EICourse" inManagedObjectContext:self.managedObjectContext];
    
    course.name = @"";
    course.subject = @"";
    course.branch = @"";
    
    return course;
    
}

- (void)deleteUser:(EIUser *)user {
    
    [self.managedObjectContext deleteObject:user];
    
}

- (void)deleteCourse:(EICourse *)course {
    
    [self.managedObjectContext deleteObject:course];
    
}

- (void)removeTeacher:(EIUser *)user fromCourse:(EICourse *)course {
    course.teacher = nil;
}

- (void)removeStudent:(EIUser *)user fromCourse:(EICourse *)course {
    [course removeStudentsObject:user];
}



- (void)generateGeekbrainsPortal {
    
    EICourse* ios= [NSEntityDescription insertNewObjectForEntityForName:@"EICourse" inManagedObjectContext:self.managedObjectContext];
    
    ios.name = @"iOS";
    ios.subject = @"Swift programming";
    ios.branch = @"Mobile development";
    
    EICourse* android = [NSEntityDescription insertNewObjectForEntityForName:@"EICourse" inManagedObjectContext:self.managedObjectContext];
    
    android.name = @"android";
    android.subject = @"Java programming";
    android.branch = @"Mobile development";
    
    EIUser* user1 = [NSEntityDescription insertNewObjectForEntityForName:@"EIUser" inManagedObjectContext:self.managedObjectContext]
    ;
    
    EIUser* user2 = [NSEntityDescription insertNewObjectForEntityForName:@"EIUser" inManagedObjectContext:self.managedObjectContext]
    ;

    EIUser* user3 =[NSEntityDescription insertNewObjectForEntityForName:@"EIUser" inManagedObjectContext:self.managedObjectContext]
    ;
    
    user1.firstName = @"User";
    user1.lastName = @"1";
    user1.email = @"user1@yandex.ru";
    
    user2.firstName = @"Gena";
    user2.lastName = @"Pavanysyan";
    user2.email = @"rozonor@mail.ru";
    
    user3.firstName = @"John";
    user3.lastName = @"Sims";
    user3.email = @"test@gmail.com";
    
    [user1 setStudiedCourses:[NSSet setWithObjects:ios, nil]];
    [user1 setTaughtCourses:[NSSet setWithObjects:android, nil]];
    
    [user2 setTaughtCourses:[NSSet setWithObjects:ios, nil]];
    
    [user3 setStudiedCourses:[NSSet setWithObjects:ios, android, nil]];

}

- (NSFetchRequest *)courseRequestWithPredicate:(NSPredicate *)predicate {
    
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription* description = [NSEntityDescription entityForName:@"EICourse" inManagedObjectContext:self.managedObjectContext];
    
    NSSortDescriptor* nameSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    
    [request setEntity:description];
    [request setSortDescriptors:@[nameSortDescriptor]];
    [request setPredicate:predicate];
    
    return request;
    
}

- (NSFetchRequest *)userRequestWithPredicate:(NSPredicate *)predicate {
    
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription* description = [NSEntityDescription entityForName:@"EIUser" inManagedObjectContext:self.managedObjectContext];
    
    NSSortDescriptor* secondNameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES];
    NSSortDescriptor* firstNameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES];
    
    [request setSortDescriptors:@[secondNameDescriptor, firstNameDescriptor]];
    [request setEntity:description];
    [request setPredicate:predicate];
    
    return request;
    
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "-.DevCourse_41_CoreData" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DevCourse_CoreData" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"DevCourse_41_CoreData.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
