/*
//  LMErrorConvenience.h
//  LMErrorManagement
//
//  Created by Jose Vazquez on 9/23/10.
//  Copyright 2010 Little Mustard LLC. All rights reserved.
*/

#import <Cocoa/Cocoa.h>
#import "LMErrorManager.h"
#import "LMErrorHandler.h"

FOUNDATION_EXPORT NSString *const kLMErrorFileNameErrorKey;
FOUNDATION_EXPORT NSString *const kLMErrorFileLineNumberErrorKey;

// Managing Handlers
#define pushErrorHandlerBlock(block) [[LMErrorManager sharedLMErrorManager] pushHandler:[LMErrorHandler errorHandlerWithBlock:block]];
//inline void pushErrorHandlerBlock(LMErrorHandlerBlock block);

#define popErrorHandler() [[LMErrorManager sharedLMErrorManager] popHandler];

#define postPOSIXError(posixCode) [[LMErrorManager sharedLMErrorManager] handleError:[NSError errorWithDomain:NSPOSIXErrorDomain code:posixCode userInfo:nil]];


@interface LMErrorConvenience : NSObject {

}

@end
