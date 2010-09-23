/*
//  LMErrorManager.h
//  LMErrorManagement
//
//  Created by Jose Vazquez on 9/21/10.
//  Copyright 2010 Little Mustard LLC. All rights reserved.
*/

#import <Cocoa/Cocoa.h>
#import "LMErrorKit.h"

@interface LMErrorManager : NSObject {

}

@property (nonatomic, assign, readonly) NSUInteger handlerCountForCurrentThread;

+ (id)sharedLMErrorManager;

- (void)pushHandler:(LMErrorHandler *)handler;
- (void)popHandler;
- (LMErrorResult)handleError:(NSError *)error;

@end
