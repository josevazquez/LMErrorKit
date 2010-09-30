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

// Pushing Error Handlers to the thread stack //////////////////////////////////
static inline void LMPushHandlerWithReceiverSelector(id receiver, SEL selector) {
    [[LMErrorManager sharedManager] pushHandler:
        [LMErrorHandler errorHandlerWithReceiver:receiver selector:selector]
     ];
}

static inline void LMPushHandlerWithReceiverSelectorObject(id receiver, SEL selector, id object) {
    [[LMErrorManager sharedManager] pushHandler:
        [LMErrorHandler errorHandlerWithReceiver:receiver selector:selector userObject:object]
     ];
}

static inline void LMPushHandlerWithFunction(LMErrorHandlerFunction function, void *data, LMErrorHandlerContextDestructor destructor) {
    [[LMErrorManager sharedManager] pushHandler:
        [LMErrorHandler errorHandlerWithFunction:function userData:data destructor:destructor]
     ];
}

static inline void LMPushHandlerWithBlock(LMErrorHandlerBlock myBlock) {
    [[LMErrorManager sharedManager] pushHandler:
        [LMErrorHandler errorHandlerWithBlock:myBlock]
     ];
}

static inline void LMPushHandlerWithDelegate(id <LMErrorHandlerDelegate> delegate) {
    [[LMErrorManager sharedManager] pushHandler:
        [LMErrorHandler errorHandlerWithDelegate:delegate]
     ];
}


// Popping Error Handlers from the thread stack ////////////////////////////////
static inline void LMPopHandler() {
    [[LMErrorManager sharedManager] popHandler];
}

static inline LMErrorResult LMPostError(NSString *domain, NSInteger code, NSString *fileName, NSUInteger lineNumber) {
    return [[LMErrorManager sharedManager] handleError:
        [NSError errorWithDomain:domain code:code userInfo:
            [NSDictionary dictionaryWithObjectsAndKeys:
                fileName, kLMErrorFileNameErrorKey,
                [NSString stringWithFormat:@"%ld", (long)lineNumber], kLMErrorFileLineNumberErrorKey,
                nil
             ]
         ]
    ];
}

#define LMPostPOSIXError(code) LMPostError(NSPOSIXErrorDomain, code, @"" __FILE__, __LINE__)
#define LMPostOSStatusError(code) LMPostError(NSOSStatusErrorDomain, code, @"" __FILE__, __LINE__)
#define LMPostMachError(code) LMPostError(NSMachErrorDomain, code, @"" __FILE__, __LINE__)

@interface LMErrorConvenience : NSObject {

}

@end
