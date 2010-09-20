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


// Type definition for error handling functions.
typedef LMErrorHandlerResult (*LMErrorHandlerFunction) (NSError *error, void *userData);

// Type definitino for optional userData destructor.
typedef void (*LMErrorHandlerContextDestructor) (void *ptr);


// Type for error handling blocks
// Takes an id for the NSError argument and returns an LMErrorHandlerResult
typedef LMErrorHandlerResult (^LMErrorHandlerBlock)(id);


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

- (LMErrorHandlerResult)handleError:(NSError *)error;

@end
