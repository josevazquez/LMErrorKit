/*
//  LMErrorManagerTest.m
//  LMErrorManagement
//
//  Created by Jose Vazquez on 9/21/10.
//  Copyright 2010 Little Mustard LLC. All rights reserved.
*/

#import "LMErrorManagerTest.h"

NSString * const kHandlerNameGeneric = @"kHandlerNameGeneric";
NSString * const kHandlerNamePOSIXErrorEINPROGRESS = @"kHandlerNamePOSIXErrorEINPROGRESS";
NSString * const kHandlerNamePOSIXErrorENXIO = @"kHandlerNamePOSIXErrorENXIO";


@implementation LMErrorManagerTest

- (void)dealloc {
    [_handlerName release], _handlerName=nil;
    [_domain release], _domain=nil;
    [_fileName release], _fileName=nil;
    [_lineNumber release], _lineNumber=nil;
    [super dealloc];
}

- (void)testObtainManager {
    LMErrorManager *manager = [LMErrorManager sharedLMErrorManager];
    LMErrorManager *manager2 = [LMErrorManager sharedLMErrorManager];
    TEST_ASSERT(manager != nil);
    TEST_ASSERT(manager == manager2);
}

- (void)setUpClass {
    pushErrorHandlerBlock(^(id error) {
        self.handlerName = kHandlerNameGeneric;
        self.domain = [error domain];
        self.code = [error code];
        self.fileName = [[error userInfo] objectForKey:kLMErrorFileNameErrorKey];
        self.lineNumber = [[error userInfo] objectForKey:kLMErrorFileLineNumberErrorKey];
        return kLMHandled;
    });
    pushErrorHandlerBlock(^(id error) {
        //NSLog(@"kPOSIXErrorEINPROGRESS Handler");
        if ([error code] == kPOSIXErrorEINPROGRESS) {
            self.handlerName = kHandlerNamePOSIXErrorEINPROGRESS;
            self.domain = [error domain];
            self.code = [error code];
            self.fileName = [[error userInfo] objectForKey:kLMErrorFileNameErrorKey];
            self.lineNumber = [[error userInfo] objectForKey:kLMErrorFileLineNumberErrorKey];
            return kLMHandled;
        }
        return kLMPassed;
    });
    pushErrorHandlerBlock(^(id error) {
        //NSLog(@"kPOSIXErrorENXIO Handler");
        if ([error code] == kPOSIXErrorENXIO) {
            self.handlerName = kHandlerNamePOSIXErrorENXIO;
            self.domain = [error domain];
            self.code = [error code];
            self.fileName = [[error userInfo] objectForKey:kLMErrorFileNameErrorKey];
            self.lineNumber = [[error userInfo] objectForKey:kLMErrorFileLineNumberErrorKey];
            return kLMHandled;
        }
        return kLMPassed;
    });
}

- (void)testBlockHandler {
    LMErrorResult result = postPOSIXError(kPOSIXErrorEINPROGRESS);

    TEST_ASSERT(result == kLMHandled);
    TEST_ASSERT([self.handlerName isEqualToString:kHandlerNamePOSIXErrorEINPROGRESS]);
    TEST_ASSERT([self.fileName hasSuffix:@"/src/Testing/LMErrorManagerTest.m"]);
    TEST_ASSERT([self.lineNumber isEqualToString:@"69"]);

    result = postPOSIXError(kPOSIXErrorENXIO);

    TEST_ASSERT(result == kLMHandled);
    TEST_ASSERT([self.handlerName isEqualToString:kHandlerNamePOSIXErrorENXIO]);
}

- (void)testHandlerAdditionAndRemoval {
    LMErrorResult result = postPOSIXError(kPOSIXErrorEINPROGRESS);
    TEST_ASSERT(result == kLMHandled);
    TEST_ASSERT([self.handlerName isEqual:kHandlerNamePOSIXErrorEINPROGRESS]);

    self.handlerName = nil;

    NSString *localHandler = @"This is the local handler";
    pushErrorHandlerBlock(^(id error) {
        if ([error code] == kPOSIXErrorEINPROGRESS) {
            self.handlerName = localHandler;
            return kLMHandled;
        }
        return kLMPassed;
    });
    result = postPOSIXError(kPOSIXErrorEINPROGRESS);
    TEST_ASSERT(result == kLMHandled);
    TEST_ASSERT([self.handlerName isEqualToString:localHandler]);

    self.handlerName = nil;

    popErrorHandler();
    result = postPOSIXError(kPOSIXErrorEINPROGRESS);
    TEST_ASSERT(result == kLMHandled);
    TEST_ASSERT([self.handlerName isEqualToString:kHandlerNamePOSIXErrorEINPROGRESS]);
}

- (void)testPostOSStatusError {
    LMErrorResult result = postOSStatusError(paramErr);

    TEST_ASSERT(result == kLMHandled);
    TEST_ASSERT([self.handlerName isEqualToString:kHandlerNameGeneric]);
    TEST_ASSERT([self.domain isEqualToString:@"NSOSStatusErrorDomain"]);
    TEST_ASSERT(self.code == paramErr);
    TEST_ASSERT([self.fileName hasSuffix:@"/src/Testing/LMErrorManagerTest.m"]);
    TEST_ASSERT([self.lineNumber isEqualToString:@"110"]);
}

- (void)testPostMachError {
    LMErrorResult result = postMachError(KERN_FAILURE);

    TEST_ASSERT(result == kLMHandled);
    TEST_ASSERT([self.handlerName isEqualToString:kHandlerNameGeneric]);
    TEST_ASSERT([self.domain isEqualToString:@"NSMachErrorDomain"]);
    TEST_ASSERT(self.code == KERN_FAILURE);
    TEST_ASSERT([self.fileName hasSuffix:@"/src/Testing/LMErrorManagerTest.m"]);
    TEST_ASSERT([self.lineNumber isEqualToString:@"121"]);
}


#pragma mark -
#pragma mark Accessor
@synthesize handlerName=_handlerName;
@synthesize domain=_domain;
@synthesize code=_code;
@synthesize fileName=_fileName;
@synthesize lineNumber=_lineNumber;

@end
