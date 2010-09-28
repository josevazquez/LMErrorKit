/*
//  LMErrorConvenience.h
//  LMErrorManagement
//
//  Created by Jose Vazquez on 9/23/10.
//  Copyright 2010 Little Mustard LLC. All rights reserved.
*/

#import <Cocoa/Cocoa.h>
#import "LMErrorKitTypes.h"
#import "LMErrorHandler.h"
#import "LMErrorManager.h"

FOUNDATION_EXPORT NSString *const kLMErrorFileNameErrorKey;
FOUNDATION_EXPORT NSString *const kLMErrorFileLineNumberErrorKey;

// Managing Handlers
static inline void pushErrorHandlerBlock(LMErrorHandlerBlock myBlock) {
    [[LMErrorManager sharedLMErrorManager] pushHandler:[LMErrorHandler errorHandlerWithBlock:myBlock]];
}

#define popErrorHandler() [[LMErrorManager sharedLMErrorManager] popHandler];

#define postPOSIXError(posixCode) [[LMErrorManager sharedLMErrorManager] handleError:[NSError errorWithDomain:NSPOSIXErrorDomain code:posixCode userInfo:nil]];


@interface LMErrorConvenience : NSObject {

}

@end
