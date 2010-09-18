/*
//  LMErrorHandler.h
//  miRecorder
//
//  Created by Jose Vazquez on 9/14/10.
//  Copyright 2010 Little Mustard LLC. All rights reserved.
*/

#import <Cocoa/Cocoa.h>

enum LMErrorHandlerCallbackType {
    kLMErrorHandlerCallbackTypeSelector,
    kLMErrorHandlerCallbackTypeFunction,
    kLMErrorHandlerCallbackTypeBlock,
    kLMErrorHandlerCallbackTypeUndefined
};
typedef enum LMErrorHandlerCallbackType LMErrorHandlerCallbackType;

enum LMErrorHandlerResult {
    kLMErrorHandlerResultErrorHandled,
    kLMErrorHandlerResultErrorPassed,
    kLMErrorHandlerResultUndefined
};
typedef enum LMErrorHandlerResult LMErrorHandlerResult;

typedef LMErrorHandlerResult (*LMErrorHandlerFunctionPtr) (
                                                void    *userData,
                                                NSError *error
                                                );

@interface LMErrorHandler : NSObject {
    LMErrorHandlerCallbackType _callbackType;

    id _receiver;
    SEL _selector;
    id _userObject;
    
    void *_userData;
    LMErrorHandlerFunctionPtr _functionPtr;
}

+ (LMErrorHandler *)errorHandlerWithReceiver:(id)receiver andSelector:(SEL)selector;

- (void)handleError:(NSError *)error onThread:(NSThread *)thread;

@end
