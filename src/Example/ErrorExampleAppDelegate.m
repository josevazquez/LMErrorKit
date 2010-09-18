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

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    LMErrorHandler *handler = [[LMErrorHandler alloc] init];
    NSLog(@"description :%@", handler);

}


#pragma mark -
#pragma mark IBAction Methods

- (IBAction)throwPOSIXError:(id)sender {
    NSInteger errorCode = [sender tag];
    NSLog(@"POSIX error code: %d", errorCode);
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

@end
