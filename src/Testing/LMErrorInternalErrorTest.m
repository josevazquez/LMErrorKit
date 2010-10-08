/*
//  LMErrorInternalErrorTest.m
//  LMErrorKit
//
//  Created by Jose Vazquez on 10/5/10.
//  Copyright 2010 Little Mustard LLC. All rights reserved.
*/

#import "LMErrorInternalErrorTest.h"

static NSString * const kFilterNameBadReturnValue = @"kFilterNameBadReturnValue";
static NSString * const kHandlerNameBadReturnValue = @"kHandlerNameBadReturnValue";
static NSString * const kHandlerNameGeneric = @"kHandlerNameGeneric";
static NSString * const kHandlerNameInternalError = @"kHandlerNameInternalError";

@implementation LMErrorInternalErrorTest
- (void)dealloc {
    [_handlerName release], _handlerName=nil;
    [_domain release], _domain=nil;
    [_source release], _source=nil;
    [_line release], _line=nil;
    [super dealloc];
}

- (void)setUpClass {
    LMPushHandlerWithBlock(^(id error) {
        self.handlerName = kHandlerNameGeneric;
        self.domain = [error domain];
        self.code = [error code];
        self.source = [error source];
        self.line = [error line];
        return kLMHandled;
    });
    LMPushHandlerWithBlock(^(id error) {
        //NSLog(@"kHandlerNameInternalError Handler");
        if ([[error domain] isEqualToString:kLMErrorInternalDomain]) {
            self.handlerName = kHandlerNameInternalError;
            self.domain = [error domain];
            self.code = [error code];
            self.source = [error source];
            self.line = [error line];
            return kLMHandled;
        }
        return kLMPassed;
    });
}

- (void)testBadFilterReturnInternalError {
    LMPushFilterWithBlock(^(id error) {
        if ([[error domain] isEqualToString:kLMErrorLogDomain]) {
            self.handlerName = kFilterNameBadReturnValue;
            self.domain = [error domain];
            self.code = [error code];
            self.source = [error source];
            self.line = [error line];
            return 0xDEAD;
        }
        return kLMPassed;
    });

    LMErrorResult result = LMError(@"Test Error log");

    TEST_ASSERT(result == kLMHandled);
    TEST_ASSERT([self.handlerName isEqualToString:kHandlerNameInternalError]);
    TEST_ASSERT([self.domain isEqualToString:kLMErrorInternalDomain]);
    TEST_ASSERT(self.code == kLMErrorInternalErrorInvalidHandlerReturnValue);
    TEST_ASSERT([self.source isEqualToString:@"-[LMErrorManager filterError:]"]);
    TEST_ASSERT([self.line isEqualToString:@"94"]);
}

- (void)testBadErrorHandlerReturnInternalError {
    LMPushHandlerWithBlock(^(id error) {
        self.handlerName = kHandlerNameBadReturnValue;
        self.domain = [error domain];
        self.code = [error code];
        self.source = [error source];
        self.line = [error line];
        return 0xDEAD;
    });
    
    LMErrorResult result = LMPostOSStatusError(paramErr);
    
    TEST_ASSERT(result == kLMHandled);
    TEST_ASSERT([self.handlerName isEqualToString:kHandlerNameInternalError]);
    TEST_ASSERT([self.domain isEqualToString:kLMErrorInternalDomain]);
    TEST_ASSERT(self.code == kLMErrorInternalErrorInvalidHandlerReturnValue);
    TEST_ASSERT([self.source isEqualToString:@"-[LMErrorManager handleError:]"]);
    TEST_ASSERT([self.line isEqualToString:@"129"]);
    LMPopHandler();
}

- (LMErrorResult)handleError:(NSError *)error {
    NSLog(@"Handling Error: %@", error);
    return kLMPassed;
}

- (LMErrorResult)handleError:(NSError *)error userObject:(id)obj {
    NSLog(@"Handling Error: %@ with Object: %@", error, obj);
    return kLMPassed;
}

- (void)testWrongSelectorForSelectorHandler {
    LMPushHandlerWithReceiverSelector(self, @selector(handleError:userObject:));

    TEST_ASSERT([self.handlerName isEqualToString:kHandlerNameInternalError]);
    TEST_ASSERT([self.domain isEqualToString:kLMErrorInternalDomain]);
    TEST_ASSERT(self.code == kLMErrorInternalErrorExpectedSelectorWithOneArguement);
    TEST_ASSERT([self.source isEqualToString:@"-[LMErrorInternalErrorTest handleError:userObject:]"]);
    TEST_ASSERT([self.line isEqualToString:@""]);
}

- (void)testWrongSelectorForSelectorandObjectHandler {
    LMPushHandlerWithReceiverSelectorObject(self, @selector(handleError:), @"UserObject");

    TEST_ASSERT([self.handlerName isEqualToString:kHandlerNameInternalError]);
    TEST_ASSERT([self.domain isEqualToString:kLMErrorInternalDomain]);
    TEST_ASSERT(self.code == kLMErrorInternalErrorExpectedSelectorWithTwoArguements);
    TEST_ASSERT([self.source isEqualToString:@"-[LMErrorInternalErrorTest handleError:]"]);
    TEST_ASSERT([self.line isEqualToString:@""]);
}

- (void)setUp {
    self.handlerName = nil;
    self.domain = nil;
    self.source = nil;
    self.line = nil;
    self.code = -1;
}


#pragma mark -
#pragma mark Accessor
@synthesize handlerName=_handlerName;
@synthesize domain=_domain;
@synthesize code=_code;
@synthesize source=_source;
@synthesize line=_line;

@end
