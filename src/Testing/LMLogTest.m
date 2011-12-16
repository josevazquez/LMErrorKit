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
    [_source release], _source=nil;
    [_line release], _line=nil;

    [super dealloc];
}

- (void)setUpClass {
    LMPushFilterWithBlock(^(id error) {
        if ([[error domain] isEqualToString:kLMErrorLogDomain]) {
            self.message = [[error userInfo] objectForKey:kLMLogMessageStringErrorKey];
            self.source = [error source];
            self.line = [error line];
            self.code = [error code];
            return kLMHandled;
        }
        return kLMPassed;
    });
}

- (void)setUp {
    self.message = nil;
    self.source = nil;
    self.line = nil;
    self.code = -1;
}

- (void)testDebug {
    LMDebug(@"Testing DEBUG Log: %@ %d", @"Hello World", 123); NSString *line = [NSString stringWithFormat:@"%d", __LINE__];

    TEST_ASSERT(self.code == kLMLogLevelDebug);
    TEST_ASSERT([self.source isEqualToString:@"-[LMLogTest testDebug]"]);
    TEST_ASSERT([self.line isEqualToString:line]);
    TEST_ASSERT([self.message isEqualToString:@"Testing DEBUG Log: Hello World 123"]);
}

- (void)testDebugIfYes {
    LMDebugIf(YES, @"Testing DEBUG IF YES Log: %@ %d", @"Hello World", 123); NSString *line = [NSString stringWithFormat:@"%d", __LINE__];

    TEST_ASSERT(self.code == kLMLogLevelDebug);
    TEST_ASSERT([self.source isEqualToString:@"-[LMLogTest testDebugIfYes]"]);
    TEST_ASSERT([self.line isEqualToString:line]);
    TEST_ASSERT([self.message isEqualToString:@"Testing DEBUG IF YES Log: Hello World 123"]);
}

- (void)testDebugIfNo {
    LMDebugIf(NO, @"Testing DEBUG IF NO Log: %@ %d", @"Hello World", 123);

    TEST_ASSERT(self.code == -1);
    TEST_ASSERT(self.source == nil);
    TEST_ASSERT(self.line == nil);
    TEST_ASSERT(self.message == nil);
}

- (void)testInfo {
    LMInfo(@"Testing INFO Log: %@ %d", @"Hello World", 123); NSString *line = [NSString stringWithFormat:@"%d", __LINE__];

    TEST_ASSERT(self.code == kLMLogLevelInfo);
    TEST_ASSERT([self.source isEqualToString:@"-[LMLogTest testInfo]"]);
    TEST_ASSERT([self.line isEqualToString:line]);
    TEST_ASSERT([self.message isEqualToString:@"Testing INFO Log: Hello World 123"]);
}

- (void)testInfoIfYes {
    LMInfoIf(YES, @"Testing INFO IF YES Log: %@ %d", @"Hello World", 123); NSString *line = [NSString stringWithFormat:@"%d", __LINE__];

    TEST_ASSERT(self.code == kLMLogLevelInfo);
    TEST_ASSERT([self.source isEqualToString:@"-[LMLogTest testInfoIfYes]"]);
    TEST_ASSERT([self.line isEqualToString:line]);
    TEST_ASSERT([self.message isEqualToString:@"Testing INFO IF YES Log: Hello World 123"]);
}

- (void)testInfoIfNo {
    LMInfoIf(NO, @"Testing INFO IF NO Log: %@ %d", @"Hello World", 123);

    TEST_ASSERT(self.code == -1);
    TEST_ASSERT(self.source == nil);
    TEST_ASSERT(self.line == nil);
    TEST_ASSERT(self.message == nil);
}

- (void)testNotice {
    LMNotice(@"Testing NOTICE Log: %@ %d", @"Hello World", 123); NSString *line = [NSString stringWithFormat:@"%d", __LINE__];

    TEST_ASSERT(self.code == kLMLogLevelNotice);
    TEST_ASSERT([self.source isEqualToString:@"-[LMLogTest testNotice]"]);
    TEST_ASSERT([self.line isEqualToString:line]);
    TEST_ASSERT([self.message isEqualToString:@"Testing NOTICE Log: Hello World 123"]);
}

- (void)testNoticeIfYes {
    LMNoticeIf(YES, @"Testing NOTICE IF YES Log: %@ %d", @"Hello World", 123); NSString *line = [NSString stringWithFormat:@"%d", __LINE__];

    TEST_ASSERT(self.code == kLMLogLevelNotice);
    TEST_ASSERT([self.source isEqualToString:@"-[LMLogTest testNoticeIfYes]"]);
    TEST_ASSERT([self.line isEqualToString:line]);
    TEST_ASSERT([self.message isEqualToString:@"Testing NOTICE IF YES Log: Hello World 123"]);
}

- (void)testNoticeIfNo {
    LMNoticeIf(NO, @"Testing NOTICE IF NO Log: %@ %d", @"Hello World", 123);

    TEST_ASSERT(self.code == -1);
    TEST_ASSERT(self.source == nil);
    TEST_ASSERT(self.line == nil);
    TEST_ASSERT(self.message == nil);
}

- (void)testWarn {
    LMWarn(@"Testing WARN Log: %@ %d", @"Hello World", 123); NSString *line = [NSString stringWithFormat:@"%d", __LINE__];

    TEST_ASSERT(self.code == kLMLogLevelWarn);
    TEST_ASSERT([self.source isEqualToString:@"-[LMLogTest testWarn]"]);
    TEST_ASSERT([self.line isEqualToString:line]);
    TEST_ASSERT([self.message isEqualToString:@"Testing WARN Log: Hello World 123"]);
}

- (void)testWarnIfYes {
    LMWarnIf(YES, @"Testing WARN IF YES Log: %@ %d", @"Hello World", 123); NSString *line = [NSString stringWithFormat:@"%d", __LINE__];

    TEST_ASSERT(self.code == kLMLogLevelWarn);
    TEST_ASSERT([self.source isEqualToString:@"-[LMLogTest testWarnIfYes]"]);
    TEST_ASSERT([self.line isEqualToString:line]);
    TEST_ASSERT([self.message isEqualToString:@"Testing WARN IF YES Log: Hello World 123"]);
}

- (void)testWarnIfNo {
    LMDebugIf(NO, @"Testing WARN IF NO Log: %@ %d", @"Hello World", 123);

    TEST_ASSERT(self.code == -1);
    TEST_ASSERT(self.source == nil);
    TEST_ASSERT(self.line == nil);
    TEST_ASSERT(self.message == nil);
}

- (void)testError {
    LMError(@"Testing ERROR Log: %@ %d", @"Hello World", 123); NSString *line = [NSString stringWithFormat:@"%d", __LINE__];

    TEST_ASSERT(self.code == kLMLogLevelError);
    TEST_ASSERT([self.source isEqualToString:@"-[LMLogTest testError]"]);
    TEST_ASSERT([self.line isEqualToString:line]);
    TEST_ASSERT([self.message isEqualToString:@"Testing ERROR Log: Hello World 123"]);
}

- (void)testErrorIfYes {
    LMErrorIf(YES, @"Testing ERROR IF YES Log: %@ %d", @"Hello World", 123); NSString *line = [NSString stringWithFormat:@"%d", __LINE__];

    TEST_ASSERT(self.code == kLMLogLevelError);
    TEST_ASSERT([self.source isEqualToString:@"-[LMLogTest testErrorIfYes]"]);
    TEST_ASSERT([self.line isEqualToString:line]);
    TEST_ASSERT([self.message isEqualToString:@"Testing ERROR IF YES Log: Hello World 123"]);
}

- (void)testErrorIfNo {
    LMErrorIf(NO, @"Testing DEBUG IF NO Log: %@ %d", @"Hello World", 123);

    TEST_ASSERT(self.code == -1);
    TEST_ASSERT(self.source == nil);
    TEST_ASSERT(self.line == nil);
    TEST_ASSERT(self.message == nil);
}

- (void)testCritical {
    LMCritical(@"Testing CRITICAL Log: %@ %d", @"Hello World", 123); NSString *line = [NSString stringWithFormat:@"%d", __LINE__];

    TEST_ASSERT(self.code == kLMLogLevelCritical);
    TEST_ASSERT([self.source isEqualToString:@"-[LMLogTest testCritical]"]);
    TEST_ASSERT([self.line isEqualToString:line]);
    TEST_ASSERT([self.message isEqualToString:@"Testing CRITICAL Log: Hello World 123"]);
}

- (void)testCriticalIfYes {
    LMCriticalIf(YES, @"Testing CRITICAL IF YES Log: %@ %d", @"Hello World", 123); NSString *line = [NSString stringWithFormat:@"%d", __LINE__];

    TEST_ASSERT(self.code == kLMLogLevelCritical);
    TEST_ASSERT([self.source isEqualToString:@"-[LMLogTest testCriticalIfYes]"]);
    TEST_ASSERT([self.line isEqualToString:line]);
    TEST_ASSERT([self.message isEqualToString:@"Testing CRITICAL IF YES Log: Hello World 123"]);
}

- (void)testCriticalIfNo {
    LMCriticalIf(NO, @"Testing DEBUG IF NO Log: %@ %d", @"Hello World", 123);

    TEST_ASSERT(self.code == -1);
    TEST_ASSERT(self.source == nil);
    TEST_ASSERT(self.line == nil);
    TEST_ASSERT(self.message == nil);
}

#pragma mark -
#pragma mark Accessors
@synthesize message=_message;
@synthesize source=_source;
@synthesize line=_line;
@synthesize code=_code;

@end
