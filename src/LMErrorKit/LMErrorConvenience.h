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

static inline void popErrorHandler() {
    [[LMErrorManager sharedLMErrorManager] popHandler];
}

static inline LMErrorResult postError(NSString *domain, NSInteger code, NSString *fileName, NSUInteger lineNumber) {
    return [[LMErrorManager sharedLMErrorManager] handleError:
        [NSError errorWithDomain:domain code:code userInfo:
            [NSDictionary dictionaryWithObjectsAndKeys:
                fileName, kLMErrorFileNameErrorKey,
                [NSString stringWithFormat:@"%d", lineNumber], kLMErrorFileLineNumberErrorKey,
                nil
             ]
         ]
    ];
}

#define postPOSIXError(posixCode) postError(NSPOSIXErrorDomain, posixCode, @"" __FILE__, __LINE__);

@interface LMErrorConvenience : NSObject {

}

@end
