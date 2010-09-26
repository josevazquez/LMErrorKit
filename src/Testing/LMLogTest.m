/*
//  LMLogTest.m
//  LMErrorManagement
//
//  Created by Jose Vazquez on 9/26/10.
//  Copyright 2010 Little Mustard LLC. All rights reserved.
*/

#import "LMLogTest.h"

#import <LMErrorKit/LMErrorKit.h>

#warning Deal with chicken & egg issue of logging level definition before including header.
#define LMLOG_LEVEL (7)
#import <LMErrorKit/LMLog.h>

@implementation LMLogTest

- (void)setUpClass {
    pushErrorHandlerBlock(^(id error) {
        NSLog(@"LMLog Filter --------------");
        if ([[error domain] isEqualToString:kLMErrorLogDomain]) {
            NSString *message = [[error userInfo] objectForKey:kLMLogMessageStringErrorKey];
            NSString *fileName = [[error userInfo] objectForKey:kLMErrorFileNameErrorKey];
            NSString *fileLineNumber = [[error userInfo] objectForKey:kLMErrorFileLineNumberErrorKey];
            
            NSLog(@"%@:%@: %@", fileName, fileLineNumber, message);
            return kLMHandled;
        }
        return kLMPassed;
    })
}


- (void)testDebug {
    DEBUG(@"Testing Debuggin Log: %@ %d", @"Hello World", 123);
}


@end
