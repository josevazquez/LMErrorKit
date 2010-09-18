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
    NSLog(@"Selector: Handling: %@", error);
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
            break;
        case 1: // Function
            NSLog(@"Function");
            break;
        case 2: // Block
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
