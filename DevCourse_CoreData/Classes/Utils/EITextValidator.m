//
//  EITextValidator.m
//  DevCourse_CoreData
//
//  Created by Евгений Иванов on 04.08.16.
//  Copyright © 2016 Евгений Иванов. All rights reserved.
//

#import "EITextValidator.h"

@implementation EITextValidator

+ (BOOL)nameString:(NSString *)nameString shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString* resultString = nameString;
    
    NSMutableCharacterSet* letterSet = [NSMutableCharacterSet letterCharacterSet];
    [letterSet addCharactersInString:@" "];
    
    NSCharacterSet* validationSet = [letterSet invertedSet];
    
    NSArray* components = [string componentsSeparatedByCharactersInSet:validationSet];
    
    if (!([components count] > 1)) {
        resultString = [nameString stringByReplacingCharactersInRange:range withString:string];
    } else {
        return NO;
    }
    
    if (resultString.length >= 25) {
        return NO;
    }
    
    return YES;
    
}

+ (BOOL)courseNameString:(NSString *)courseString shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString* resultString = courseString;
    
    NSMutableCharacterSet* letterSet = [NSMutableCharacterSet alphanumericCharacterSet];
    [letterSet addCharactersInString:@" ,."];
    
    NSCharacterSet* validationSet = [letterSet invertedSet];
    
    NSArray* components = [string componentsSeparatedByCharactersInSet:validationSet];
    
    if (!([components count] > 1)) {
        resultString = [courseString stringByReplacingCharactersInRange:range withString:string];
    } else {
        return NO;
    }
    
    if (resultString.length >= 40) {
        return NO;
    }
    
    return YES;
    
}

+ (BOOL)emailString:(NSString *)emailString shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString* resultString = emailString;
    
    NSMutableCharacterSet* alphanumericSet = [NSMutableCharacterSet alphanumericCharacterSet];
    [alphanumericSet addCharactersInString:@"@ ."];
    
    NSCharacterSet* validationSet = [alphanumericSet invertedSet];
    
    NSArray* components = [string componentsSeparatedByCharactersInSet:validationSet];
    
    if (!([components count] > 1)) {
        resultString = [emailString stringByReplacingCharactersInRange:range withString:string];
    } else {
        return NO;
    }

    NSCharacterSet* atSet = [NSCharacterSet characterSetWithCharactersInString:@"@"];
    NSCharacterSet* dotSet = [NSCharacterSet characterSetWithCharactersInString:@"."];
    
    NSArray* atComponentsInResultString = [resultString componentsSeparatedByCharactersInSet:atSet];
    NSArray* dotComponentsInString = [resultString componentsSeparatedByCharactersInSet:dotSet];
    
    if ([atComponentsInResultString count] > 2) {
        return NO;
    }
    
    if ([dotComponentsInString count] > 2) {
        return NO;
    }
    
    if ([resultString length] >= 30) {
        return NO;
    }
    
    return YES;
    
}

@end
