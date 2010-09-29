/*
//  LMErrorManager.h
//  LMErrorManagement
//
//  Created by Jose Vazquez on 9/21/10.
//  Copyright 2010 Little Mustard LLC. All rights reserved.
*/

#import <Cocoa/Cocoa.h>
#import "LMErrorKitTypes.h"

@class LMErrorHandler;

@interface LMErrorManager : NSObject {

}

@property (nonatomic, assign, readonly) NSUInteger handlerCountForCurrentThread;

+ (id)sharedManager;

- (void)pushHandler:(LMErrorHandler *)handler;
- (void)popHandler;
- (LMErrorResult)handleError:(NSError *)error;

@end
