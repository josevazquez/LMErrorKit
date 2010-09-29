/*
//  LMLogTest.m
//  LMErrorManagement
//
//  Created by Jose Vazquez on 9/26/10.
//  Copyright 2010 Little Mustard LLC. All rights reserved.
*/

#import "LMLogTest.h"

#import <LMErrorKit/LMErrorKit.h>

#define LMLOG_LEVEL kLMLogLevelAll
#import <LMErrorKit/LMLog.h>

@implementation LMLogTest


- (void)dealloc {
    [_message release], _message=nil;
    [_fileName release], _fileName=nil;
    [_fileLineNumber release], _fileLineNumber=nil;

    [super dealloc];
}

- (void)setUpClass {
    LMPushHandlerWithBlock(^(id error) {
        if ([[error domain] isEqualToString:kLMErrorLogDomain]) {
            self.message = [[error userInfo] objectForKey:kLMLogMessageStringErrorKey];
            self.fileName = [[error userInfo] objectForKey:kLMErrorFileNameErrorKey];
            self.fileLineNumber = [[error userInfo] objectForKey:kLMErrorFileLineNumberErrorKey];
            self.code = [error code];

            //NSLog(@"%d-%@:%@: %@", self.code, self.fileName, self.fileLineNumber, self.message);
            return kLMHandled;
        }
        return kLMPassed;
    });
}

- (void)setUp {
    self.message = nil;
    self.fileName = nil;
    self.fileLineNumber = nil;
    self.code = -1;
}

- (void)testDebug {
    LMDebug(@"Testing DEBUG Log: %@ %d", @"Hello World", 123); NSString *line = [NSString stringWithFormat:@"%d", __LINE__];

    TEST_ASSERT(self.code == kLMLogLevelDebug);
    TEST_ASSERT([self.fileName hasSuffix:@"/src/Testing/LMLogTest.m"]);
    TEST_ASSERT([self.fileLineNumber isEqualToString:line]);
    TEST_ASSERT([self.message isEqualToString:@"Testing DEBUG Log: Hello World 123"]);
}

- (void)testInfo {
    LMInfo(@"Testing INFO Log: %@ %d", @"Hello World", 123); NSString *line = [NSString stringWithFormat:@"%d", __LINE__];
    
    TEST_ASSERT(self.code == kLMLogLevelInfo);
    TEST_ASSERT([self.fileName hasSuffix:@"/src/Testing/LMLogTest.m"]);
    TEST_ASSERT([self.fileLineNumber isEqualToString:line]);
    TEST_ASSERT([self.message isEqualToString:@"Testing INFO Log: Hello World 123"]);
}

- (void)testNotice {
    LMNotice(@"Testing NOTICE Log: %@ %d", @"Hello World", 123); NSString *line = [NSString stringWithFormat:@"%d", __LINE__];
    
    TEST_ASSERT(self.code == kLMLogLevelNotice);
    TEST_ASSERT([self.fileName hasSuffix:@"/src/Testing/LMLogTest.m"]);
    TEST_ASSERT([self.fileLineNumber isEqualToString:line]);
    TEST_ASSERT([self.message isEqualToString:@"Testing NOTICE Log: Hello World 123"]);
}

- (void)testWarn {
    LMWarn(@"Testing WARN Log: %@ %d", @"Hello World", 123); NSString *line = [NSString stringWithFormat:@"%d", __LINE__];
    
    TEST_ASSERT(self.code == kLMLogLevelWarn);
    TEST_ASSERT([self.fileName hasSuffix:@"/src/Testing/LMLogTest.m"]);
    TEST_ASSERT([self.fileLineNumber isEqualToString:line]);
    TEST_ASSERT([self.message isEqualToString:@"Testing WARN Log: Hello World 123"]);
}

- (void)testError {
    LMError(@"Testing ERROR Log: %@ %d", @"Hello World", 123); NSString *line = [NSString stringWithFormat:@"%d", __LINE__];
    
    TEST_ASSERT(self.code == kLMLogLevelError);
    TEST_ASSERT([self.fileName hasSuffix:@"/src/Testing/LMLogTest.m"]);
    TEST_ASSERT([self.fileLineNumber isEqualToString:line]);
    TEST_ASSERT([self.message isEqualToString:@"Testing ERROR Log: Hello World 123"]);
}

- (void)testCritical {
    LMCritical(@"Testing CRITICAL Log: %@ %d", @"Hello World", 123); NSString *line = [NSString stringWithFormat:@"%d", __LINE__];
    
    TEST_ASSERT(self.code == kLMLogLevelCritical);
    TEST_ASSERT([self.fileName hasSuffix:@"/src/Testing/LMLogTest.m"]);
    TEST_ASSERT([self.fileLineNumber isEqualToString:line]);
    TEST_ASSERT([self.message isEqualToString:@"Testing CRITICAL Log: Hello World 123"]);
}

#pragma mark -
#pragma mark Accessors
@synthesize message=_message;
@synthesize fileName=_fileName;
@synthesize fileLineNumber=_fileLineNumber;
@synthesize code=_code;

@end
