/*
//  LMErrorManager.m
//  LMErrorManagement
//
//  Created by Jose Vazquez on 9/21/10.
//  Copyright 2010 Little Mustard LLC. All rights reserved.
*/

#import "LMErrorManager.h"


@implementation LMErrorManager

+ (id)sharedLMErrorManager {
    static dispatch_once_t pred;
    static LMErrorManager *errorManager = nil;
    
    dispatch_once(&pred, ^{
        errorManager = [[self alloc] init];
    });
    
    return errorManager;
}

@end
