/*
//  LMErrorManagerTest.m
//  LMErrorManagement
//
//  Created by Jose Vazquez on 9/21/10.
//  Copyright 2010 Little Mustard LLC. All rights reserved.
*/

#import "LMErrorManagerTest.h"

NSString * const kHandlerNamePOSIXErrorEINPROGRESS = @"kHandlerNamePOSIXErrorEINPROGRESS";
NSString * const kHandlerNamePOSIXErrorENXIO = @"kHandlerNamePOSIXErrorENXIO";


@implementation LMErrorManagerTest

- (void)testObtainManager {
    LMErrorManager *manager = [LMErrorManager sharedLMErrorManager];
    LMErrorManager *manager2 = [LMErrorManager sharedLMErrorManager];
    TEST_ASSERT(manager != nil);
    TEST_ASSERT(manager == manager2);
}

- (void)setUpClass {
    pushErrorHandlerBlock(^(id error) {
        NSLog(@"kPOSIXErrorEINPROGRESS Handler");
        if ([error code] == kPOSIXErrorEINPROGRESS) {
            self.handlerName = kHandlerNamePOSIXErrorEINPROGRESS;
            return kLMHandled;
        }
        return kLMPassed;
    })
    pushErrorHandlerBlock(^(id error) {
        NSLog(@"kPOSIXErrorENXIO Handler");
        if ([error code] == kPOSIXErrorENXIO) {
            self.handlerName = kHandlerNamePOSIXErrorENXIO;
            return kLMHandled;
        }
        return kLMPassed;
    })
}

- (void)testBlockHandler {
    LMErrorResult result = postPOSIXError(kPOSIXErrorEINPROGRESS);

    TEST_ASSERT(result == kLMHandled);
    TEST_ASSERT([self.handlerName isEqual:kHandlerNamePOSIXErrorEINPROGRESS]);

    result = postPOSIXError(kPOSIXErrorENXIO);

    TEST_ASSERT(result == kLMHandled);
    TEST_ASSERT([self.handlerName isEqual:kHandlerNamePOSIXErrorENXIO]);
}


#pragma mark -
#pragma mark Accessor
@synthesize handlerName=_handlerName;

@end
