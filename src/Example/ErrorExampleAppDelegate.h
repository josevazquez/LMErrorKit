/*
//  ErrorExampleAppDelegate.h
//  LMErrorManagement
//
//  Created by Jose Vazquez on 9/17/10.
//  Copyright 2010 Little Mustard LLC. All rights reserved.
*/

#import <Cocoa/Cocoa.h>
#import <LMErrorKit/LMErrorHandlerDelegate.h>
@class LMErrorHandler;

@interface ErrorExampleAppDelegate : NSObject <NSApplicationDelegate, LMErrorHandlerDelegate> {
    NSWindow *_window;
    LMErrorHandler *_errorHandler;
}

- (IBAction)throwPOSIXError:(id)sender;
- (IBAction)selectHandleType:(id)sender;


@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, retain) LMErrorHandler *errorHandler;

@end
