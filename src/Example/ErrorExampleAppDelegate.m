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

- (void)handleError:(NSError *)error {
    NSLog(@"** Selector **, %@", error);
}

- (void)handleError:(NSError *)error andMessage:(NSString *)message {
    NSLog(@"** Selector with User Object: %@ **, %@", message, error);
}

#pragma mark -
#pragma mark IBAction Methods
- (IBAction)throwPOSIXError:(id)sender {
    NSInteger errorCode = [sender tag];
    NSLog(@"POSIX error code: %d", errorCode);
    [self.errorHandler handleError:[NSError errorWithDomain:NSPOSIXErrorDomain code:errorCode userInfo:nil] 
                          onThread:[NSThread mainThread]];
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
            break;
        case 3: // Block
            NSLog(@"Block");
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
