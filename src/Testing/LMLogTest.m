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
    LMPushHandlerWithBlock(^(id error) {
        if ([[error domain] isEqualToString:kLMErrorLogDomain]) {
            self.message = [[error userInfo] objectForKey:kLMLogMessageStringErrorKey];
            self.fileName = [[error userInfo] objectForKey:kLMErrorFileNameErrorKey];
            self.fileLineNumber = [[error userInfo] objectForKey:kLMErrorFileLineNumberErrorKey];
            
            //NSLog(@"%@:%@: %@", self.fileName, self.fileLineNumber, self.message);
            return kLMHandled;
        }
        return kLMPassed;
    });
}

- (void)setUp {
    self.message = nil;
    self.fileName = nil;
    self.fileLineNumber = nil;
}

- (void)testDebug {
    DEBUG(@"Testing Debugging Log: %@ %d", @"Hello World", 123);

    TEST_ASSERT([self.fileName hasSuffix:@"/src/Testing/LMLogTest.m"]);
    TEST_ASSERT([self.fileLineNumber isEqualToString:@"40"]);
    TEST_ASSERT([self.message isEqualToString:@"Testing Debugging Log: Hello World 123"]);
}


#pragma mark -
#pragma mark Accessors
@synthesize message;
@synthesize fileName;
@synthesize fileLineNumber;
@end
