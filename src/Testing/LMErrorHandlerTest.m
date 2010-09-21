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
    self.aString = message;
    self.aNumber = kUltimateAnswer;
    self.handlerType = kHandlerTypeSelectorWithUserObject;
    if ([error code] == kPOSIXErrorEINPROGRESS) {
        return kLMErrorHandlerResultErrorHandled;
    }
    return kLMErrorHandlerResultErrorPassed;
}

LMErrorHandlerResult errorHandlerFunctionForTest(NSError *error, void *selfPtr) {
    LMErrorHandlerTest *self = selfPtr;
    self.aString = kUltimateQuestion;
    self.handlerType = kHandlerTypeFunction;
    if ([error code] == kPOSIXErrorEINPROGRESS) {
        return kLMErrorHandlerResultErrorHandled;
    }
    return kLMErrorHandlerResultErrorPassed;
}

void userDataDestructorForTest(void *selfPtr) {
    LMErrorHandlerTest *self = selfPtr;
    self.aNumber = kUltimateAnswer;
}

- (LMErrorHandlerResult)handleLMError:(NSError *)error {
    self.aString = kUltimateQuestion;
    self.aNumber = kUltimateAnswer;
    self.handlerType = kHandlerTypeDelegate;
    if ([error code] == kPOSIXErrorEINPROGRESS) {
        return kLMErrorHandlerResultErrorHandled;
    }
    return kLMErrorHandlerResultErrorPassed;
}


#pragma mark -
#pragma mark Test Methods
- (void)testSelectorHandler {
    LMErrorHandler *errorHandler = [LMErrorHandler errorHandlerWithReceiver:self
                                                                   selector:@selector(handleError:)];

    NSError *error = [NSError errorWithDomain:NSPOSIXErrorDomain code:kPOSIXErrorEINPROGRESS userInfo:nil];
    LMErrorHandlerResult result = [errorHandler handleError:error];

    TEST_ASSERT(result == kLMErrorHandlerResultErrorHandled);
    TEST_ASSERT(self.aNumber == kUltimateAnswer);
    TEST_ASSERT([self.aString isEqualTo:kUltimateQuestion]);
    TEST_ASSERT([self.handlerType isEqualTo:kHandlerTypeSelector]);

    error = [NSError errorWithDomain:NSPOSIXErrorDomain code:kPOSIXErrorENXIO userInfo:nil];
    result = [errorHandler handleError:error];

    TEST_ASSERT(result == kLMErrorHandlerResultErrorPassed);
}

- (void)testSelectorHandlerWithUserObject {
    LMErrorHandler *errorHandler = [LMErrorHandler errorHandlerWithReceiver:self
                                                                   selector:@selector(handleError:andMessage:)
                                                                 userObject:kUltimateQuestion];

    NSError *error = [NSError errorWithDomain:NSPOSIXErrorDomain code:kPOSIXErrorEINPROGRESS userInfo:nil];
    LMErrorHandlerResult result = [errorHandler handleError:error];

    TEST_ASSERT(result == kLMErrorHandlerResultErrorHandled);
    TEST_ASSERT(self.aNumber == kUltimateAnswer);
    TEST_ASSERT([self.aString isEqualTo:kUltimateQuestion]);
    TEST_ASSERT([self.handlerType isEqualTo:kHandlerTypeSelectorWithUserObject]);

    error = [NSError errorWithDomain:NSPOSIXErrorDomain code:kPOSIXErrorENXIO userInfo:nil];
    result = [errorHandler handleError:error];

    TEST_ASSERT(result == kLMErrorHandlerResultErrorPassed);
}

- (void)testFunctionHandler {
    // We need an autorelease pool here to test the destructor callback.
    MAT_WithPool(^{
        LMErrorHandler *errorHandler = [LMErrorHandler errorHandlerWithFunction:errorHandlerFunctionForTest
                                                                       userData:self
                                                                     destructor:userDataDestructorForTest];

        NSError *error = [NSError errorWithDomain:NSPOSIXErrorDomain code:kPOSIXErrorEINPROGRESS userInfo:nil];
        LMErrorHandlerResult result = [errorHandler handleError:error];

        TEST_ASSERT(result == kLMErrorHandlerResultErrorHandled);
        // aNumber should still be 0 before the destructor is called.
        TEST_ASSERT(self.aNumber == 0);
        TEST_ASSERT([self.aString isEqualTo:kUltimateQuestion]);
        TEST_ASSERT([self.handlerType isEqualTo:kHandlerTypeFunction]);
    });
    //Verifies that destructor function sets aNumber
    TEST_ASSERT(self.aNumber == kUltimateAnswer);

    LMErrorHandler *errorHandler = [LMErrorHandler errorHandlerWithFunction:errorHandlerFunctionForTest
                                                                   userData:self
                                                                 destructor:userDataDestructorForTest];

    NSError *error = [NSError errorWithDomain:NSPOSIXErrorDomain code:kPOSIXErrorENXIO userInfo:nil];
    LMErrorHandlerResult result = [errorHandler handleError:error];

    TEST_ASSERT(result == kLMErrorHandlerResultErrorPassed);
}

- (void)testBlockHandler {
    LMErrorHandler *errorHandler = [LMErrorHandler errorHandlerWithBlock:^(id error) {
        self.aString = kUltimateQuestion;
        self.aNumber = kUltimateAnswer;
        self.handlerType = kHandlerTypeBlock;
        if ([error code] == kPOSIXErrorEINPROGRESS) {
            return kLMErrorHandlerResultErrorHandled;
        }
        return kLMErrorHandlerResultErrorPassed;
    }];

    NSError *error = [NSError errorWithDomain:NSPOSIXErrorDomain code:kPOSIXErrorEINPROGRESS userInfo:nil];
    LMErrorHandlerResult result = [errorHandler handleError:error];

    TEST_ASSERT(result == kLMErrorHandlerResultErrorHandled);
    TEST_ASSERT(self.aNumber == kUltimateAnswer);
    TEST_ASSERT([self.aString isEqualTo:kUltimateQuestion]);
    TEST_ASSERT([self.handlerType isEqualTo:kHandlerTypeBlock]);

    error = [NSError errorWithDomain:NSPOSIXErrorDomain code:kPOSIXErrorENXIO userInfo:nil];
    result = [errorHandler handleError:error];

    TEST_ASSERT(result == kLMErrorHandlerResultErrorPassed);
}

- (void)testDelegateHandler {
    LMErrorHandler *errorHandler = [LMErrorHandler errorHandlerWithDelegate:self];

    NSError *error = [NSError errorWithDomain:NSPOSIXErrorDomain code:kPOSIXErrorEINPROGRESS userInfo:nil];
    LMErrorHandlerResult result = [errorHandler handleError:error];

    TEST_ASSERT(result == kLMErrorHandlerResultErrorHandled);
    TEST_ASSERT(self.aNumber == kUltimateAnswer);
    TEST_ASSERT([self.aString isEqualTo:kUltimateQuestion]);
    TEST_ASSERT([self.handlerType isEqualTo:kHandlerTypeDelegate]);

    error = [NSError errorWithDomain:NSPOSIXErrorDomain code:kPOSIXErrorENXIO userInfo:nil];
    result = [errorHandler handleError:error];

    TEST_ASSERT(result == kLMErrorHandlerResultErrorPassed);
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
