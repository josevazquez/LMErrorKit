/*
//  LMErrorHandlerTest.m
//  LMErrorManagement
//
//  Created by Jose Vazquez on 9/21/10.
//  Copyright 2010 Little Mustard LLC. All rights reserved.
*/

#import "LMErrorHandlerTest.h"
#import <LMErrorKit/LMErrorKit.h>

NSString * const kUltimateQuestion = @"the Ultimate Answer to the Ultimate Question of Life, The Universe, and Everythingthe Ultimate Answer to the Ultimate Question of Life, The Universe, and Everything";
NSInteger const kUltimateAnswer = 42;

NSString * const kHandlerTypeSelector = @"kHandlerTypeSelector";
NSString * const kHandlerTypeSelectorWithUserObject = @"kHandlerTypeSelectorWithUserObject";
NSString * const kHandlerTypeFunction = @"kHandlerTypeFunction";
NSString * const kHandlerTypeBlock = @"kHandlerTypeBlock";
NSString * const kHandlerTypeDelegate = @"kHandlerTypeDelegate";

@implementation LMErrorHandlerTest

- (void)dealloc {
    [_aString release], _aString=nil;
    [_handlerType release], _handlerType=nil;
    [super dealloc];
}

#pragma mark -
#pragma mark Test Setup and Teardown
- (void)setUpClass {
    //NSLog(@"setUpClass Invoked!!");
}

- (void)tearDownClass {
    //NSLog(@"tearDownClass Invoked!!");
}

- (void)setUp {
    self.aNumber = 0;
    self.aString = nil;
    self.handlerType = nil;
}

- (void)tearDown {
    //NSLog(@"tearDown Invoked!!");
}


#pragma mark -
#pragma mark Error Handlers
- (LMErrorHandlerResult)handleError:(NSError *)error {
    self.aString = kUltimateQuestion;
    self.aNumber = kUltimateAnswer;
    self.handlerType = kHandlerTypeSelector;
    if ([error code] == kPOSIXErrorEINPROGRESS) {
        return kLMErrorHandlerResultErrorHandled;
    }
    return kLMErrorHandlerResultErrorPassed;
}

- (LMErrorHandlerResult)handleError:(NSError *)error andMessage:(NSString *)message {
    NSLog(@"** Selector with User Object: %@ **, %@", message, error);
    return kLMErrorHandlerResultErrorPassed;
}

LMErrorHandlerResult errorHandlerFunctionForTest(NSError *error, void *message) {
    NSLog(@"** Function with User Data: %s **, %@", message, error);
    return kLMErrorHandlerResultErrorHandled;
}

void userDataDestructorForTest(void *ptr) {
    NSLog(@"Data Destructor was called with pointer to 0x%08X", ptr);
}

- (LMErrorHandlerResult)handleLMError:(NSError *)error {
    NSLog(@"** Delegate **, %@", error);
    return kLMErrorHandlerResultErrorHandled;
}


#pragma mark -
#pragma mark Test Methods
- (void)testSelectorHandler {
    LMErrorHandler *errorHandler = [LMErrorHandler errorHandlerWithReceiver:self
                                                                   selector:@selector(handleError:)];

    NSError *error = [NSError errorWithDomain:NSPOSIXErrorDomain code:kPOSIXErrorEINPROGRESS userInfo:nil];
    LMErrorHandlerResult result = [errorHandler handleError:error];

    TEST_ASSERT(result=kLMErrorHandlerResultErrorHandled);
    TEST_ASSERT(self.aNumber = kUltimateAnswer);
    TEST_ASSERT([self.aString isEqualTo:kUltimateQuestion]);
    TEST_ASSERT([self.handlerType isEqualTo:kHandlerTypeSelector]);
}

- (void)testFunctionHandler {
    TEST_ASSERT(NO);
    NSLog(@"testFunctionHandler Invoked!!");
}

- (void)testSetup {
    TEST_ASSERT(self.aNumber == 0);
    TEST_ASSERT(self.aString == nil);
    TEST_ASSERT(self.handlerType == nil);
}

- (void)notatest {
    NSLog(@"Danger Will Robinson!! This is NOT a test");
}


#pragma mark -
#pragma mark Accessors
@synthesize aNumber=_aNumber;
@synthesize aString=_aString;
@synthesize handlerType=_handlerType;

@end
