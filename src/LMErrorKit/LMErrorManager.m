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
    assert(currentDictionary);

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
    NSMutableArray *stack = [self stackForCurrentThread];
    [stack addObject:handler];
}

- (void)popHandler {
    NSMutableArray *stack = [self stackForCurrentThread];
    [stack removeLastObject];
}

- (LMErrorResult)handleError:(NSError *)error {
    NSMutableArray *stack = [self stackForCurrentThread];
    for (int i=[stack count]-1; i>=0; i--) {
        LMErrorHandler *handler = [stack objectAtIndex:i];
        LMErrorResult result = [handler handleError:error];
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
            ([error code] == kLMInternalErrorInvalidHandlerReturnValue)) continue;

        // Throw an internal Error signaling an invalid LMErrorResult.
        return LMPostError(kLMErrorInternalDomain, kLMInternalErrorInvalidHandlerReturnValue);
    }

    // This is the error handler of last resort.
    NSLog(@"Aborting Application due to unhandled error : %@", error);
    abort();

    //last ditch here
    return kLMInternalError;
}


#pragma mark -
#pragma mark Accessors
- (NSUInteger)handlerCountForCurrentThread {
    return [[self stackForCurrentThread] count];
}


/*
doWithHandler(^{
    stuffIwnat to doWithHandler
},
              ^{ Handler
}
}

}//*/

@end
