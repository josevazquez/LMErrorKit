/*
//  LMErrorHandler.m
//  miRecorder
//
//  Created by Jose Vazquez on 9/14/10.
//  Copyright 2010 Little Mustard LLC. All rights reserved.
*/

#import "LMErrorHandler.h"

#warning move to a separate file with all define error codes
NSString *const kLMErrorInternalDomain = @"com.littlemustard.LMErrorKit.InternalDomain";

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
@property (nonatomic, assign) LMErrorHandlerFunction function;
@property (nonatomic, assign) LMErrorHandlerContextDestructor destructor;
@property (nonatomic, assign) void *userData;
@property (nonatomic, copy) LMErrorHandlerBlock block;
@property (nonatomic, assign) id <LMErrorHandlerDelegate> delegate;
@property (nonatomic, assign) LMErrorHandlerCallbackType callbackType;

- (NSUInteger)validArgumentCountForSelectorHandler;
@end


@implementation LMErrorHandler

#pragma mark -
- (id)init {
    if ((self = [super init])) {
        _callbackType = kLMErrorHandlerCallbackTypeUndefined;
        _destructor = NULL;
        _userData = NULL;
    }
    return self;
}

- (void)dealloc {
    if ((_destructor != NULL) && (_userData != NULL)) {
        _destructor(_userData);
    }
    [_receiver release], _receiver=nil;
    [_userObject release], _userObject=nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Creating an LMErrorHandler
+ (LMErrorHandler *)errorHandlerWithReceiver:(id)receiver selector:(SEL)selector {
    LMErrorHandler *errorHandler = [[[LMErrorHandler alloc] init] autorelease];
    errorHandler.receiver = receiver;
    errorHandler.selector = selector;
    errorHandler.userObject = nil;
    
    // Verify that selector takes just one (id) argument
    if ([errorHandler validArgumentCountForSelectorHandler] != 1) {
        throwError([NSError errorWithDomain:kLMErrorInternalDomain code:1 userInfo:nil]);
        return nil;
    }
    
    errorHandler.callbackType = kLMErrorHandlerCallbackTypeSelector;
    return errorHandler;
}

+ (LMErrorHandler *)errorHandlerWithReceiver:(id)receiver selector:(SEL)selector userObject:(id)object {
    LMErrorHandler *errorHandler = [[[LMErrorHandler alloc] init] autorelease];
    errorHandler.receiver = receiver;
    errorHandler.selector = selector;
    errorHandler.userObject = object;

    // Verify that selector takes two (id) arguments
    if ([errorHandler validArgumentCountForSelectorHandler] != 2) {
        #warning Try using the wrong Handler to check user experience on error.
        throwError([NSError errorWithDomain:kLMErrorInternalDomain code:1 userInfo:nil]);
        return nil;
    }

    errorHandler.callbackType = kLMErrorHandlerCallbackTypeSelector;
    return errorHandler;
}

+ (LMErrorHandler *)errorHandlerWithFunction:(LMErrorHandlerFunction)function
                                    userData:(void *)data
                          destructor:(LMErrorHandlerContextDestructor)destructor {
    LMErrorHandler *errorHandler = [[[LMErrorHandler alloc] init] autorelease];
    errorHandler.function = function;
    errorHandler.userData = data;
    errorHandler.destructor = destructor;

    errorHandler.callbackType = kLMErrorHandlerCallbackTypeFunction;
    return errorHandler;
}

+ (LMErrorHandler *)errorHandlerWithBlock:(LMErrorHandlerBlock)block {
    LMErrorHandler *errorHandler = [[[LMErrorHandler alloc] init] autorelease];
    errorHandler.block = block;

    errorHandler.callbackType = kLMErrorHandlerCallbackTypeBlock;
    return errorHandler;
}

+ (LMErrorHandler *)errorHandlerWithDelegate:(id <LMErrorHandlerDelegate>)delegate {
    LMErrorHandler *errorHandler = [[[LMErrorHandler alloc] init] autorelease];
    errorHandler.delegate = delegate;

    errorHandler.callbackType = kLMErrorHandlerCallbackTypeDelegate;
    return errorHandler;
}


#pragma mark -
#pragma mark Using an LMErrorHandler
- (LMErrorResult)handleError:(NSError *)error {
    LMErrorResult result = kLMUndefined;
    switch (self.callbackType) {
        case kLMErrorHandlerCallbackTypeSelector:
            if ([self validArgumentCountForSelectorHandler] == 1) {
                // declare the method function pointer
                LMErrorResult (*methodPointer)(id self, SEL _cmd, id error);

                // fetch the pointer, cast to avoid warnings
                methodPointer = (void *)[self.receiver methodForSelector:self.selector];

                // call the method
                result = methodPointer(self.receiver, self.selector, error);
            }
            if ([self validArgumentCountForSelectorHandler] == 2) {
                // declare the method function pointer
                LMErrorResult (*methodPointer)(id self, SEL _cmd, id error, id userObject);

                // fetch the pointer, cast to avoid warnings
                methodPointer = (void *)[self.receiver methodForSelector:self.selector];

                // call the method
                result = methodPointer(self.receiver, self.selector, error, self.userObject);
            }
            break;
        case kLMErrorHandlerCallbackTypeFunction:
            result = (self.function)(error, self.userData);
            break;
        case kLMErrorHandlerCallbackTypeBlock:
            result = (self.block)(error);
            break;
        case kLMErrorHandlerCallbackTypeDelegate:
            result = [self.delegate handleLMError:error];
            break;
        default:
            break;
    }
    return result;
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
//@synthesize function=_function;
@synthesize destructor=_destructor;
@synthesize userData=_userData;
@synthesize block=_block;
@synthesize delegate=_delegate;
@synthesize callbackType=_callbackType;

- (LMErrorHandlerFunction)function {
    return _function;
}
- (void)setFunction:(LMErrorHandlerFunction)function {
    if ((_destructor != NULL) && (_userData != NULL)) {
        _destructor(_userData);
    }
    _function = function;
}


@end
