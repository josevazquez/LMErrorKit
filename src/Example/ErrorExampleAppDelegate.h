/*
//  ErrorExampleAppDelegate.h
//  LMErrorManagement
//
//  Created by Jose Vazquez on 9/17/10.
//  Copyright 2010 Little Mustard LLC. All rights reserved.
*/

#import <Cocoa/Cocoa.h>

@interface ErrorExampleAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
}

- (IBAction)throwPOSIXError:(id)sender;
- (IBAction)selectHandleType:(id)sender;


@property (assign) IBOutlet NSWindow *window;

@end
