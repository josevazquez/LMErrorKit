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

            //NSLog(@"%d:%@:%@: %@", self.code, self.fileName, self.fileLineNumber, self.message);
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
    TEST_ASSERT([self.fileName isEqualToString:@"-[LMLogTest testDebug]"]);
    TEST_ASSERT([self.fileLineNumber isEqualToString:line]);
    TEST_ASSERT([self.message isEqualToString:@"Testing DEBUG Log: Hello World 123"]);
}

- (void)testDebugIfYes {
    LMDebugIf(YES, @"Testing DEBUG IF YES Log: %@ %d", @"Hello World", 123); NSString *line = [NSString stringWithFormat:@"%d", __LINE__];

    TEST_ASSERT(self.code == kLMLogLevelDebug);
    TEST_ASSERT([self.fileName isEqualToString:@"-[LMLogTest testDebugIfYes]"]);
    TEST_ASSERT([self.fileLineNumber isEqualToString:line]);
    TEST_ASSERT([self.message isEqualToString:@"Testing DEBUG IF YES Log: Hello World 123"]);
}

- (void)testDebugIfNo {
    LMDebugIf(NO, @"Testing DEBUG IF NO Log: %@ %d", @"Hello World", 123);

    TEST_ASSERT(self.code == -1);
    TEST_ASSERT(self.fileName == nil);
    TEST_ASSERT(self.fileLineNumber == nil);
    TEST_ASSERT(self.message == nil);
}

- (void)testInfo {
    LMInfo(@"Testing INFO Log: %@ %d", @"Hello World", 123); NSString *line = [NSString stringWithFormat:@"%d", __LINE__];
    
    TEST_ASSERT(self.code == kLMLogLevelInfo);
    TEST_ASSERT([self.fileName isEqualToString:@"-[LMLogTest testInfo]"]);
    TEST_ASSERT([self.fileLineNumber isEqualToString:line]);
    TEST_ASSERT([self.message isEqualToString:@"Testing INFO Log: Hello World 123"]);
}

- (void)testInfoIfYes {
    LMInfoIf(YES, @"Testing INFO IF YES Log: %@ %d", @"Hello World", 123); NSString *line = [NSString stringWithFormat:@"%d", __LINE__];

    TEST_ASSERT(self.code == kLMLogLevelInfo);
    TEST_ASSERT([self.fileName isEqualToString:@"-[LMLogTest testInfoIfYes]"]);
    TEST_ASSERT([self.fileLineNumber isEqualToString:line]);
    TEST_ASSERT([self.message isEqualToString:@"Testing INFO IF YES Log: Hello World 123"]);
}

- (void)testInfoIfNo {
    LMInfoIf(NO, @"Testing INFO IF NO Log: %@ %d", @"Hello World", 123);

    TEST_ASSERT(self.code == -1);
    TEST_ASSERT(self.fileName == nil);
    TEST_ASSERT(self.fileLineNumber == nil);
    TEST_ASSERT(self.message == nil);
}

- (void)testNotice {
    LMNotice(@"Testing NOTICE Log: %@ %d", @"Hello World", 123); NSString *line = [NSString stringWithFormat:@"%d", __LINE__];
    
    TEST_ASSERT(self.code == kLMLogLevelNotice);
    TEST_ASSERT([self.fileName isEqualToString:@"-[LMLogTest testNotice]"]);
    TEST_ASSERT([self.fileLineNumber isEqualToString:line]);
    TEST_ASSERT([self.message isEqualToString:@"Testing NOTICE Log: Hello World 123"]);
}

- (void)testNoticeIfYes {
    LMNoticeIf(YES, @"Testing NOTICE IF YES Log: %@ %d", @"Hello World", 123); NSString *line = [NSString stringWithFormat:@"%d", __LINE__];

    TEST_ASSERT(self.code == kLMLogLevelNotice);
    TEST_ASSERT([self.fileName isEqualToString:@"-[LMLogTest testNoticeIfYes]"]);
    TEST_ASSERT([self.fileLineNumber isEqualToString:line]);
    TEST_ASSERT([self.message isEqualToString:@"Testing NOTICE IF YES Log: Hello World 123"]);
}

- (void)testNoticeIfNo {
    LMNoticeIf(NO, @"Testing NOTICE IF NO Log: %@ %d", @"Hello World", 123);

    TEST_ASSERT(self.code == -1);
    TEST_ASSERT(self.fileName == nil);
    TEST_ASSERT(self.fileLineNumber == nil);
    TEST_ASSERT(self.message == nil);
}

- (void)testWarn {
    LMWarn(@"Testing WARN Log: %@ %d", @"Hello World", 123); NSString *line = [NSString stringWithFormat:@"%d", __LINE__];
    
    TEST_ASSERT(self.code == kLMLogLevelWarn);
    TEST_ASSERT([self.fileName isEqualToString:@"-[LMLogTest testWarn]"]);
    TEST_ASSERT([self.fileLineNumber isEqualToString:line]);
    TEST_ASSERT([self.message isEqualToString:@"Testing WARN Log: Hello World 123"]);
}

- (void)testWarnIfYes {
    LMWarnIf(YES, @"Testing WARN IF YES Log: %@ %d", @"Hello World", 123); NSString *line = [NSString stringWithFormat:@"%d", __LINE__];

    TEST_ASSERT(self.code == kLMLogLevelWarn);
    TEST_ASSERT([self.fileName isEqualToString:@"-[LMLogTest testWarnIfYes]"]);
    TEST_ASSERT([self.fileLineNumber isEqualToString:line]);
    TEST_ASSERT([self.message isEqualToString:@"Testing WARN IF YES Log: Hello World 123"]);
}

- (void)testWarnIfNo {
    LMDebugIf(NO, @"Testing WARN IF NO Log: %@ %d", @"Hello World", 123);

    TEST_ASSERT(self.code == -1);
    TEST_ASSERT(self.fileName == nil);
    TEST_ASSERT(self.fileLineNumber == nil);
    TEST_ASSERT(self.message == nil);
}

- (void)testError {
    LMError(@"Testing ERROR Log: %@ %d", @"Hello World", 123); NSString *line = [NSString stringWithFormat:@"%d", __LINE__];
    
    TEST_ASSERT(self.code == kLMLogLevelError);
    TEST_ASSERT([self.fileName isEqualToString:@"-[LMLogTest testError]"]);
    TEST_ASSERT([self.fileLineNumber isEqualToString:line]);
    TEST_ASSERT([self.message isEqualToString:@"Testing ERROR Log: Hello World 123"]);
}

- (void)testErrorIfYes {
    LMErrorIf(YES, @"Testing ERROR IF YES Log: %@ %d", @"Hello World", 123); NSString *line = [NSString stringWithFormat:@"%d", __LINE__];

    TEST_ASSERT(self.code == kLMLogLevelError);
    TEST_ASSERT([self.fileName isEqualToString:@"-[LMLogTest testErrorIfYes]"]);
    TEST_ASSERT([self.fileLineNumber isEqualToString:line]);
    TEST_ASSERT([self.message isEqualToString:@"Testing ERROR IF YES Log: Hello World 123"]);
}

- (void)testErrorIfNo {
    LMErrorIf(NO, @"Testing DEBUG IF NO Log: %@ %d", @"Hello World", 123);

    TEST_ASSERT(self.code == -1);
    TEST_ASSERT(self.fileName == nil);
    TEST_ASSERT(self.fileLineNumber == nil);
    TEST_ASSERT(self.message == nil);
}

- (void)testCritical {
    LMCritical(@"Testing CRITICAL Log: %@ %d", @"Hello World", 123); NSString *line = [NSString stringWithFormat:@"%d", __LINE__];
    
    TEST_ASSERT(self.code == kLMLogLevelCritical);
    TEST_ASSERT([self.fileName isEqualToString:@"-[LMLogTest testCritical]"]);
    TEST_ASSERT([self.fileLineNumber isEqualToString:line]);
    TEST_ASSERT([self.message isEqualToString:@"Testing CRITICAL Log: Hello World 123"]);
}

- (void)testCriticalIfYes {
    LMCriticalIf(YES, @"Testing CRITICAL IF YES Log: %@ %d", @"Hello World", 123); NSString *line = [NSString stringWithFormat:@"%d", __LINE__];

    TEST_ASSERT(self.code == kLMLogLevelCritical);
    TEST_ASSERT([self.fileName isEqualToString:@"-[LMLogTest testCriticalIfYes]"]);
    TEST_ASSERT([self.fileLineNumber isEqualToString:line]);
    TEST_ASSERT([self.message isEqualToString:@"Testing CRITICAL IF YES Log: Hello World 123"]);
}

- (void)testCriticalIfNo {
    LMCriticalIf(NO, @"Testing DEBUG IF NO Log: %@ %d", @"Hello World", 123);

    TEST_ASSERT(self.code == -1);
    TEST_ASSERT(self.fileName == nil);
    TEST_ASSERT(self.fileLineNumber == nil);
    TEST_ASSERT(self.message == nil);
}

- (void)testLogMessages {
    self.message = @"";
    __block NSString *line;

    LMRunBlockWithBlockHandler(^(void) {
        LMDebug(@"DEBUG");
        LMInfo(@"INFO");
        LMNotice(@"NOTICE");
        LMWarn(@"WARN");
        LMError(@"ERROR");
        LMCritical(@"CRITICAL"); line = [NSString stringWithFormat:@"%d", __LINE__];
    }, ^(id error) {
        if ([[error domain] isEqualToString:kLMErrorLogDomain]) {
            self.message = [NSString stringWithFormat:@"%@ %@", self.message, [[error userInfo] objectForKey:kLMLogMessageStringErrorKey]];
            self.fileName = [[error userInfo] objectForKey:kLMErrorFileNameErrorKey];
            self.fileLineNumber = [[error userInfo] objectForKey:kLMErrorFileLineNumberErrorKey];
            self.code = [error code];

            //NSLog(@"%d-%@:%@: >%@<", self.code, self.fileName, self.fileLineNumber, self.message);
            return kLMHandled;
        }
        return kLMPassed;
    });

    TEST_ASSERT(self.code == kLMLogLevelCritical);
    TEST_ASSERT([self.fileName isEqualToString:@"__-[LMLogTest testLogMessages]_block_invoke_1"]);
    TEST_ASSERT([self.fileLineNumber isEqualToString:line]);
    TEST_ASSERT([self.message isEqualToString:@" DEBUG INFO NOTICE WARN ERROR CRITICAL"]);
}

#pragma mark -
#pragma mark Accessors
@synthesize message=_message;
@synthesize fileName=_fileName;
@synthesize fileLineNumber=_fileLineNumber;
@synthesize code=_code;

@end
