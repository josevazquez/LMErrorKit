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
#include <mach/mach.h>

FOUNDATION_EXPORT NSString *const kLMErrorFileNameErrorKey;
FOUNDATION_EXPORT NSString *const kLMErrorFileLineNumberErrorKey;


#pragma mark Functions to push Error Handlers to the thread stack
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

static inline void LMPushHandlerWithBlock(LMErrorHandlerBlock blockHandler) {
    [[LMErrorManager sharedManager] pushHandler:
        [LMErrorHandler errorHandlerWithBlock:blockHandler]
     ];
}

static inline void LMPushHandlerWithDelegate(id <LMErrorHandlerDelegate> delegate) {
    [[LMErrorManager sharedManager] pushHandler:
        [LMErrorHandler errorHandlerWithDelegate:delegate]
     ];
}


#pragma mark -
#pragma mark Functions to remove Error Handlers from the thread stack
static inline void LMPopHandler() {
    [[LMErrorManager sharedManager] popHandler];
}


#pragma mark -
#pragma mark Functions to post errors to the LMErrorManager singleton
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


#pragma mark -
#pragma mark Macros to explicitly post errors
#define LMPostPOSIXError(code) LMPostError(NSPOSIXErrorDomain, code, @"" __FILE__, __LINE__)
#define LMPostOSStatusError(code) LMPostError(NSOSStatusErrorDomain, code, @"" __FILE__, __LINE__)
#define LMPostMachError(code) LMPostError(NSMachErrorDomain, code, @"" __FILE__, __LINE__)


#pragma mark -
#pragma mark Macros to post error resulting from function calls
#define chkOSStatus(status) InternalChkOSStatusFunction(status, @"" __FILE__, __LINE__)
#define chkPOSIX(expression) InternalChkPOSIXFunction(expression, @"" __FILE__, __LINE__)
#define chkMach(expression) InternalChkMachFunction(expression, @"" __FILE__, __LINE__)


#pragma mark -
#pragma mark Functions to blocks of code with a local handler
static inline void LMRunBlockWithBlockHandler(LMBasicBlock block, LMErrorHandlerBlock blockHandler) {
    LMPushHandlerWithBlock(blockHandler);
    block();
    LMPopHandler();
}


#pragma mark -
#pragma mark Internal functions to assist public macros
static inline LMErrorResult InternalChkOSStatusFunction(OSStatus status, NSString *fileName, NSUInteger lineNumber) {
    if (status != noErr) return LMPostError(NSOSStatusErrorDomain, status, fileName, lineNumber);
    return kLMNoError;
}

static inline LMErrorResult InternalChkPOSIXFunction(int result, NSString *fileName, NSUInteger lineNumber) {
    if (result == -1) return LMPostError(NSPOSIXErrorDomain, errno, fileName, lineNumber);
    return kLMNoError;
}

static inline LMErrorResult InternalChkMachFunction(kern_return_t result, NSString *fileName, NSUInteger lineNumber) {
    if (result != KERN_SUCCESS) return LMPostError(NSMachErrorDomain, result, fileName, lineNumber);
    return kLMNoError;
}


#pragma mark -
@interface LMErrorConvenience : NSObject {

}

@end
