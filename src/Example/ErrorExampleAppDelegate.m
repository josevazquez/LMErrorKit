/*
//  ErrorExampleAppDelegate.m
//  LMErrorManagement
//
//  Created by Jose Vazquez on 9/17/10.
//  Copyright 2010 Little Mustard LLC. All rights reserved.
*/

#import "ErrorExampleAppDelegate.h"
#import <LMErrorKit/LMErrorKit.h>

@implementation ErrorExampleAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.errorHandler = [LMErrorHandler errorHandlerWithReceiver:self andSelector:@selector(handleError:)];
}

- (NSNumber *)handleError:(NSError *)error {
    NSLog(@"** Selector **, %@", error);
    return kLMErrorHandled;
}

- (NSNumber *)handleError:(NSError *)error andMessage:(NSString *)message {
    NSLog(@"** Selector with User Object: %@ **, %@", message, error);
    return kLMErrorPassed;
}

LMErrorHandlerResult errorHandlerFunction(NSError *error, void *message) {
    NSLog(@"** Function with User Data: %s **, %@", message, error);
    return kLMErrorHandlerResultErrorHandled;
}

#pragma mark -
#pragma mark IBAction Methods
- (IBAction)throwPOSIXError:(id)sender {
    NSInteger errorCode = [sender tag];
    NSLog(@"POSIX error code: %d", errorCode);
    NSError *error = [NSError errorWithDomain:NSPOSIXErrorDomain code:errorCode userInfo:nil];

    LMErrorHandlerResult result = [self.errorHandler handleError:error
                          onThread:[NSThread mainThread]];
    switch (result) {
        case kLMErrorHandlerResultErrorHandled:
            NSLog(@"Error was Handled");
            break;
        case kLMErrorHandlerResultErrorPassed:
            NSLog(@"Error was Passed");
            break;
        case kLMErrorHandlerResultUndefined:
        default:
            NSLog(@"Error Handler returned an undefined result");
            break;
    }
}

- (IBAction)selectHandleType:(id)sender {
    switch ([[sender selectedCell] tag]) {
        case 0: // Selector
            NSLog(@"Selector");
            self.errorHandler = [LMErrorHandler errorHandlerWithReceiver:self andSelector:@selector(handleError:)];
            break;
        case 1: // Selector with User Object
            NSLog(@"Selector with User Object");
            self.errorHandler = [LMErrorHandler errorHandlerWithReceiver:self
                                                                selector:@selector(handleError:andMessage:)
                                                           andUserObject:@"This is the user object"];
            break;
        case 2: // Function
            NSLog(@"Function");
            self.errorHandler = [LMErrorHandler errorHandlerWithFunction:errorHandlerFunction andUserData:"This is a c-string user data"];
            break;
        case 3: // Block
            NSLog(@"Block");
            self.errorHandler = [LMErrorHandler errorHandlerWithBlock:^(id error) {
                NSLog(@"** Block **, %@", error);
                return kLMErrorHandlerResultErrorHandled;
            }];
            break;
        default:
            break;
    }
}


#pragma mark -
#pragma mark Accessors
@synthesize window=_window;
@synthesize errorHandler=_errorHandler;

@end
