/*
//  LMErrorConvenience.m
//  LMErrorManagement
//
//  Created by Jose Vazquez on 9/23/10.
//  Copyright 2010 Little Mustard LLC. All rights reserved.
*/

#import "LMErrorConvenience.h"

NSString *const kLMErrorFileNameErrorKey       = @"kLMErrorFileNameErrorKey";
NSString *const kLMErrorFileLineNumberErrorKey = @"kLMErrorFileLineNumberErrorKey";


#pragma mark Category on NSError
@implementation NSError (LMErrorKit)
- (NSString *)source {
    return [[self userInfo] objectForKey:kLMErrorFileNameErrorKey];
}

- (NSString *)line {
    return [[self userInfo] objectForKey:kLMErrorFileLineNumberErrorKey];
}
@end


#pragma mark -
@implementation LMErrorConvenience

@end
