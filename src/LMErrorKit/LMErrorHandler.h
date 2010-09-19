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

// Type for error handling functions.
#warning ask Mike if userData should be void * or id. (What every  dev should know)
typedef LMErrorHandlerResult (*LMErrorHandlerFunctionPtr) (NSError *error, void *userData);

// Type for error handling blocks
// Takes an id for the NSError argument and returns an LMErrorHandlerResult
typedef int (^LMErrorHandlerBlock)(id);

@interface LMErrorHandler : NSObject {
    LMErrorHandlerCallbackType _callbackType;

    id _receiver;
    SEL _selector;
    id _userObject;
    
    void *_userData;
    LMErrorHandlerFunctionPtr _functionPtr;

    LMErrorHandlerBlock _block;
}

+ (LMErrorHandler *)errorHandlerWithReceiver:(id)receiver andSelector:(SEL)selector;
+ (LMErrorHandler *)errorHandlerWithReceiver:(id)receiver selector:(SEL)selector andUserObject:(id)object;
+ (LMErrorHandler *)errorHandlerWithFunction:(LMErrorHandlerFunctionPtr)function andUserData:(void *)data;
+ (LMErrorHandler *)errorHandlerWithBlock:(LMErrorHandlerBlock)block;

- (void)handleError:(NSError *)error onThread:(NSThread *)thread;

@end
