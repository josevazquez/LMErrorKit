/*
//  ErrorExampleAppDelegate.m
//  LMErrorManagement
//
//  Created by Jose Vazquez on 9/17/10.
//  Copyright 2010 Little Mustard LLC. All rights reserved.
*/

#import "ErrorExampleAppDelegate.h"
#import <LMErrorKit/LMErrorKit.h>
#import "MATesting.h"

@implementation ErrorExampleAppDelegate

static void TestPass(void) {
    TEST_ASSERT(YES);
}

static void TestFail(void) {
    TEST_ASSERT(NO);
}

#pragma mark -
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.errorHandler = [LMErrorHandler errorHandlerWithReceiver:self selector:@selector(handleError:)];
}


#pragma mark -
#pragma mark Error Handlers
- (LMErrorResult)handleError:(NSError *)error {
    NSLog(@"** Selector **, %@", error);
    return kLMHandled;
}

- (LMErrorResult)handleError:(NSError *)error andMessage:(NSString *)message {
    NSLog(@"** Selector with User Object: %@ **, %@", message, error);
    return kLMPassed;
}

LMErrorResult errorHandlerFunction(NSError *error, void *message) {
    NSLog(@"** Function with User Data: %s **, %@", message, error);
    return kLMHandled;
}

void userDataDestructor(void *ptr) {
    NSLog(@"Data Destructor was called with pointer to %p", ptr);
}

- (LMErrorResult)handleLMError:(NSError *)error {
    NSLog(@"** Delegate **, %@", error);
    return kLMHandled;
}


#pragma mark -
#pragma mark IBAction Methods
- (IBAction)throwPOSIXError:(id)sender {
    NSInteger errorCode = [sender tag];
    NSLog(@"POSIX error code: %d", errorCode);
    NSError *error = [NSError errorWithDomain:NSPOSIXErrorDomain code:errorCode userInfo:nil];

    LMErrorResult result = [self.errorHandler handleError:error];

    switch (result) {
        case kLMHandled:
            NSLog(@"Error was Handled");
            break;
        case kLMPassed:
            NSLog(@"Error was Passed");
            break;
        case kLMUndefined:
        default:
            NSLog(@"Error Handler returned an undefined result");
            break;
    }
}

- (IBAction)selectHandleType:(id)sender {
    switch ([[sender selectedCell] tag]) {
        case 0: // Selector
            NSLog(@"Selector");
            self.errorHandler = [LMErrorHandler errorHandlerWithReceiver:self
                                                                selector:@selector(handleError:)];
            break;
        case 1: // Selector with User Object
            NSLog(@"Selector with User Object");
            self.errorHandler = [LMErrorHandler errorHandlerWithReceiver:self
                                                                selector:@selector(handleError:andMessage:)
                                                           userObject:@"This is the user object"];
            break;
        case 2: // Function
            NSLog(@"Function");
            self.errorHandler = [LMErrorHandler errorHandlerWithFunction:errorHandlerFunction
                                                                userData:"This is a c-string user data"
                                                              destructor:userDataDestructor];
            break;
        case 3: // Block
            NSLog(@"Block");
            self.errorHandler = [LMErrorHandler errorHandlerWithBlock:^(id error) {
                NSLog(@"** Block **, %@", error);
                return kLMHandled;
            }];
            break;
        case 4: // Delegate
            NSLog(@"Delegate");
            self.errorHandler = [LMErrorHandler errorHandlerWithDelegate:self];
            break;
        default:
            break;
    }
}

- (IBAction)runTests:(id)sender {
    [MATesting runTests];
}

#pragma mark -
#pragma mark Accessors
@synthesize window=_window;
@synthesize errorHandler=_errorHandler;

@end
