/*
//  LMErrorHandler.h
//  miRecorder
//
//  Created by Jose Vazquez on 9/14/10.
//  Copyright 2010 Little Mustard LLC. All rights reserved.
*/

#import <Cocoa/Cocoa.h>
#import <LMErrorKit/LMErrorHandlerDelegate.h>

// Callback type constants. For internal use only.
enum LMErrorHandlerCallbackType {
    kLMErrorHandlerCallbackTypeSelector,
    kLMErrorHandlerCallbackTypeFunction,
    kLMErrorHandlerCallbackTypeBlock,
    kLMErrorHandlerCallbackTypeDelegate,
    kLMErrorHandlerCallbackTypeUndefined
};
typedef enum LMErrorHandlerCallbackType LMErrorHandlerCallbackType;


// Defines to return an LMErrorHandlerResult wrapped in an NSNumber instance.
#define kLMErrorHandled ([NSNumber numberWithInt:kLMErrorHandlerResultErrorHandled])
#define kLMErrorPassed ([NSNumber numberWithInt:kLMErrorHandlerResultErrorPassed])


// Type for error handling functions.
typedef LMErrorHandlerResult (*LMErrorHandlerFunctionPtr) (NSError *error, void *userData);


// Type for error handling blocks
// Takes an id for the NSError argument and returns an LMErrorHandlerResult
#warning return type is an int instead of a LMErrorHandlerResult because block compiler resolves to int. Should I use NSNumber instead?
typedef int (^LMErrorHandlerBlock)(id);


@interface LMErrorHandler : NSObject {
    LMErrorHandlerCallbackType _callbackType;

    id _receiver;
    SEL _selector;
    id _userObject;
    
    void *_userData;
    LMErrorHandlerFunctionPtr _functionPtr;

    LMErrorHandlerBlock _block;

    id <LMErrorHandlerDelegate> _delegate;
}

+ (LMErrorHandler *)errorHandlerWithReceiver:(id)receiver andSelector:(SEL)selector;
+ (LMErrorHandler *)errorHandlerWithReceiver:(id)receiver selector:(SEL)selector andUserObject:(id)object;
+ (LMErrorHandler *)errorHandlerWithFunction:(LMErrorHandlerFunctionPtr)function andUserData:(void *)data;
+ (LMErrorHandler *)errorHandlerWithBlock:(LMErrorHandlerBlock)block;
+ (LMErrorHandler *)errorHandlerWithDelegate:(id <LMErrorHandlerDelegate>)delegate;

- (LMErrorHandlerResult)handleError:(NSError *)error onThread:(NSThread *)thread;

@end
