//
//  EITextValidator.h
//  DevCourse_CoreData
//
//  Created by Евгений Иванов on 04.08.16.
//  Copyright © 2016 Евгений Иванов. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EITextValidator : NSObject

+ (BOOL)nameString:(NSString *)nameString shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
+ (BOOL)courseNameString:(NSString *)courseString shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
+ (BOOL)emailString:(NSString *)emailString shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

@end
