/*
//  LMErrorManager.m
//  LMErrorManagement
//
//  Created by Jose Vazquez on 9/21/10.
//  Copyright 2010 Little Mustard LLC. All rights reserved.
*/

#import "LMErrorKit.h"

NSString * const kLMErrorManagerCurrentStack = @"kLMErrorManagerCurrentStack";

@implementation LMErrorManager

- (id)init {
    if ((self = [super init])) {
        _filterStack = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    [_filterStack release], _filterStack = nil;
    [super dealloc];
}

+ (id)sharedManager {
    static dispatch_once_t pred;
    static LMErrorManager *errorManager = nil;
    
    dispatch_once(&pred, ^{
        errorManager = [[self alloc] init];
    });
    
    return errorManager;
}

- (NSMutableArray *)stackForCurrentThread {
    NSMutableDictionary *currentDictionary = [[NSThread currentThread] threadDictionary];
    #warning Will this cause an infinite recursion? Push it to the main thread?
    if (!currentDictionary) LMPostDomainCode(kLMErrorInternalDomain, kLMErrorInternalErrorThreadDictionaryUnavailable);

    NSMutableArray *stack = [currentDictionary objectForKey:kLMErrorManagerCurrentStack];
    if (stack == nil) {
        stack = [[[NSMutableArray alloc] init] autorelease];
        [currentDictionary setObject:stack forKey:kLMErrorManagerCurrentStack];
    }
    return stack;
}


#pragma mark -
#pragma mark Handler Management
- (void)pushHandler:(LMErrorHandler *)handler {
    if (handler == nil) return;
    NSMutableArray *stack = [self stackForCurrentThread];
    [stack addObject:handler];
}

- (void)popHandler {
    NSMutableArray *stack = [self stackForCurrentThread];
    [stack removeLastObject];
}


#pragma mark -
#pragma mark Filter Management
- (void)pushFilter:(LMErrorHandler *)handler {
    if (handler == nil) return;
    [_filterStack addObject:handler];
}


#pragma mark -
#pragma mark Error Handling
- (LMErrorResult)filterError:(NSError *)error {
    for (int i=[_filterStack count]-1; i>=0; i--) {
        LMErrorHandler *filter = [_filterStack objectAtIndex:i];
        LMErrorResult result = [filter handleError:error];
        if ((result == kLMHandled) || (result == kLMResolved)) {
            return result;
        }
        if (result == kLMPassed) continue;
        // If we get here, it means an ErrorHandler was pushed to the stack
        // which is returning an invalind LMErrorResult.

        // If this is an internal error reporting an invalid return value it
        // means we probably just hit the problem handler trying to handle it's
        // own error. We must ignore this case or else the code will recurse infinetly.
        if (([[error domain] isEqualToString:kLMErrorInternalDomain]) &&
            ([error code] == kLMErrorInternalErrorInvalidHandlerReturnValue)) continue;

        // Throw an internal Error signaling an invalid LMErrorResult.
        return LMPostDomainCode(kLMErrorInternalDomain, kLMErrorInternalErrorInvalidHandlerReturnValue);
    }
    // In case there is no filter added for logging purposes we do the default
    // filtering here.
    if ([[error domain] isEqualToString:kLMErrorLogDomain]) {
        [error sendToASL];
        return kLMHandled;
    }
    return kLMPassed;
}

- (LMErrorResult)handleError:(NSError *)error {
    // Run filters first. Mainly to filter out logs.
    LMErrorResult result = [self filterError:error];
    if (result != kLMPassed) return result;

    NSMutableArray *stack = [self stackForCurrentThread];
    for (int i=[stack count]-1; i>=0; i--) {
        LMErrorHandler *handler = [stack objectAtIndex:i];
        result = [handler handleError:error];
        if ((result == kLMHandled) || (result == kLMResolved)) {
            return result;
        }
        if (result == kLMPassed) continue;
        // If we get here, it means an ErrorHandler was pushed to the stack
        // which is returning an invalind LMErrorResult.

        // If this is an internal error reporting an invalid return value it
        // means we probably just hit the problem handler trying to handle it's
        // own error. We must ignore this case or else the code will recurse infinetly.
        if (([[error domain] isEqualToString:kLMErrorInternalDomain]) &&
            ([error code] == kLMErrorInternalErrorInvalidHandlerReturnValue)) continue;

        // Throw an internal Error signaling an invalid LMErrorResult.
        #warning This internal error should wrap the current error.
        return LMPostDomainCode(kLMErrorInternalDomain, kLMErrorInternalErrorInvalidHandlerReturnValue);
    }

    // This is the error handler of last resort.
    NSLog(@"Aborting Application due to unhandled error : %@", error);
    #warning Need a more elegant final solution for iOS. abort() will cause App Store rejection.
    abort();

    //last ditch here
    return kLMInternalError;
}


#pragma mark -
#pragma mark Accessors
- (NSUInteger)handlerCountForCurrentThread {
    return [[self stackForCurrentThread] count];
}

@end
