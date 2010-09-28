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
static inline void pushErrorHandlerWithReceiverSelector(id receiver, SEL selector) {
    [[LMErrorManager sharedLMErrorManager] pushHandler:
        [LMErrorHandler errorHandlerWithReceiver:receiver selector:selector]
     ];
}

static inline void pushErrorHandlerWithReceiverSelectorAndObject(id receiver, SEL selector, id object) {
    [[LMErrorManager sharedLMErrorManager] pushHandler:
        [LMErrorHandler errorHandlerWithReceiver:receiver selector:selector userObject:object]
     ];
}

static inline void pushErrorHandlerWithFunction(LMErrorHandlerFunction function, void *data, LMErrorHandlerContextDestructor destructor) {
    [[LMErrorManager sharedLMErrorManager] pushHandler:
        [LMErrorHandler errorHandlerWithFunction:function userData:data destructor:destructor]
     ];
}

static inline void pushErrorHandlerWithBlock(LMErrorHandlerBlock myBlock) {
    [[LMErrorManager sharedLMErrorManager] pushHandler:
        [LMErrorHandler errorHandlerWithBlock:myBlock]
     ];
}

static inline void pushErrorHandlerWithDelegate(id <LMErrorHandlerDelegate> delegate) {
    [[LMErrorManager sharedLMErrorManager] pushHandler:
        [LMErrorHandler errorHandlerWithDelegate:delegate]
     ];
}


// Popping Error Handlers from the thread stack ////////////////////////////////
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

#define postPOSIXError(code) postError(NSPOSIXErrorDomain, code, @"" __FILE__, __LINE__);
#define postOSStatusError(code) postError(NSOSStatusErrorDomain, code, @"" __FILE__, __LINE__);
#define postMachError(code) postError(NSMachErrorDomain, code, @"" __FILE__, __LINE__);

@interface LMErrorConvenience : NSObject {

}

@end
