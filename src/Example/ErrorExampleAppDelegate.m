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
	// Insert code here to initialize your application 
}

@end
