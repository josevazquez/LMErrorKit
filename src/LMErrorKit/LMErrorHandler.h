/*
//  LMErrorHandler.h
//  miRecorder
//
//  Created by Jose Vazquez on 9/14/10.
//  Copyright 2010 Little Mustard LLC. All rights reserved.
*/

#import <Cocoa/Cocoa.h>
#import "LMErrorKitTypes.h"
#import "LMErrorHandlerDelegate.h"

FOUNDATION_EXPORT NSString *const kLMErrorInternalDomain;

// Callback type constants. For internal use only.
enum LMErrorHandlerCallbackType {
    kLMErrorHandlerCallbackTypeSelector,
    kLMErrorHandlerCallbackTypeFunction,
    kLMErrorHandlerCallbackTypeBlock,
    kLMErrorHandlerCallbackTypeDelegate,
    kLMErrorHandlerCallbackTypeUndefined
};
typedef enum LMErrorHandlerCallbackType LMErrorHandlerCallbackType;


@interface LMErrorHandler : NSObject {
    LMErrorHandlerCallbackType _callbackType;

    id _receiver;
    SEL _selector;
    id _userObject;
    
    void *_userData;
    LMErrorHandlerFunction _function;
    LMErrorHandlerContextDestructor _destructor;

    LMErrorHandlerBlock _block;

    id <LMErrorHandlerDelegate> _delegate;
}

+ (LMErrorHandler *)errorHandlerWithReceiver:(id)receiver selector:(SEL)selector;
+ (LMErrorHandler *)errorHandlerWithReceiver:(id)receiver selector:(SEL)selector userObject:(id)object;
+ (LMErrorHandler *)errorHandlerWithFunction:(LMErrorHandlerFunction)function userData:(void *)data destructor:(LMErrorHandlerContextDestructor)destructor;
+ (LMErrorHandler *)errorHandlerWithBlock:(LMErrorHandlerBlock)block;
+ (LMErrorHandler *)errorHandlerWithDelegate:(id <LMErrorHandlerDelegate>)delegate;

- (LMErrorResult)handleError:(NSError *)error;

@end
