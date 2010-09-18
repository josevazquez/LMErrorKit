/*
//  LMErrorHandler.m
//  miRecorder
//
//  Created by Jose Vazquez on 9/14/10.
//  Copyright 2010 Little Mustard LLC. All rights reserved.
*/

#import "LMErrorHandler.h"

NSString *const LMErrorInternalDomain = @"LMErrorInternalDomain";

void throwError(NSError *error) {
    NSLog(@"failed to throw the error: %@", error);
    #warning Change this to have it throw an error.
    assert(FALSE);
}

// private interface
@interface LMErrorHandler ()
@property (nonatomic, retain) id receiver;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, retain) id userObject;
@property (nonatomic, assign) LMErrorHandlerFunctionPtr function;
@property (nonatomic, assign) void *userData;
@property (nonatomic, assign) LMErrorHandlerCallbackType callbackType;

- (NSUInteger)validArgumentCountForSelectorHandler;
@end


@implementation LMErrorHandler

- (id)init {
    if ((self = [super init])) {
        _callbackType = kLMErrorHandlerCallbackTypeUndefined;
    }
    return self;
}

+ (LMErrorHandler *)errorHandlerWithReceiver:(id)receiver andSelector:(SEL)selector {
    LMErrorHandler *errorHandler = [[[LMErrorHandler alloc] init] autorelease];
    errorHandler.receiver = receiver;
    errorHandler.selector = selector;
    errorHandler.userObject = nil;
    
    // Verify that selector takes just one (id) argument
    if ([errorHandler validArgumentCountForSelectorHandler] != 1) {
        throwError([NSError errorWithDomain:NSOSStatusErrorDomain code:kEINVALErr userInfo:nil]);
        return nil;
    }
    
    errorHandler.callbackType = kLMErrorHandlerCallbackTypeSelector;
    return errorHandler;
}

+ (LMErrorHandler *)errorHandlerWithReceiver:(id)receiver selector:(SEL)selector andUserObject:(id)object {
    LMErrorHandler *errorHandler = [[[LMErrorHandler alloc] init] autorelease];
    errorHandler.receiver = receiver;
    errorHandler.selector = selector;
    errorHandler.userObject = object;

    // Verify that selector takes two (id) arguments
    if ([errorHandler validArgumentCountForSelectorHandler] != 2) {
        throwError([NSError errorWithDomain:NSOSStatusErrorDomain code:kEINVALErr userInfo:nil]);
        return nil;
    }

    errorHandler.callbackType = kLMErrorHandlerCallbackTypeSelector;
    return errorHandler;
}

+ (LMErrorHandler *)errorHandlerWithFunction:(LMErrorHandlerFunctionPtr)function andUserData:(void *)data {
    LMErrorHandler *errorHandler = [[[LMErrorHandler alloc] init] autorelease];
    errorHandler.function = function;
    errorHandler.userData = data;

    errorHandler.callbackType = kLMErrorHandlerCallbackTypeFunction;
    return errorHandler;
}

- (void)handleError:(NSError *)error onThread:(NSThread *)thread {
    switch (self.callbackType) {
        case kLMErrorHandlerCallbackTypeSelector:
            if ([self validArgumentCountForSelectorHandler] == 1) {
                [self.receiver performSelector:self.selector withObject:error];                
            }
            if ([self validArgumentCountForSelectorHandler] == 2) {
                #warning figure out how to perform a selector with 2 argument an a specific thread
                [self.receiver performSelector:self.selector withObject:error withObject:self.userObject];
            }
            break;
        case kLMErrorHandlerCallbackTypeFunction:
            #warning figure out how to perform function on a specific thread
            (self.function)(error, self.userData);
            break;
        default:
            break;
    }
}


#pragma mark -
#pragma mark Helper Methods
- (NSUInteger)validArgumentCountForSelectorHandler {
    NSMethodSignature *signature = [self.receiver methodSignatureForSelector:self.selector];
    NSUInteger argumentCount = [signature numberOfArguments];
    if (argumentCount == 3) { // one argument plus self and _cmd
        // verify that the argument is of type id
        if (strcmp([signature getArgumentTypeAtIndex:2], @encode(id))==0) {     // this argument should be an NSError*
            return 1;
        }
    }
    
    if (argumentCount == 4) { // two arguments plus self and _cmd
        // verify that the arguments are both of type id
        if (strcmp([signature getArgumentTypeAtIndex:2], @encode(id))==0) {     // this argument should be an NSError*
            if (strcmp([signature getArgumentTypeAtIndex:3], @encode(id))==0) { // this is the user Object of type id
                return 2;
            }
        }
    }
    return 0;
}


#pragma mark -
#pragma mark Accessors
@synthesize receiver=_receiver;
@synthesize selector=_selector;
@synthesize userObject=_userObject;
@synthesize function=_functionPtr;
@synthesize userData=_userData;
@synthesize callbackType=_callbackType;

@end
