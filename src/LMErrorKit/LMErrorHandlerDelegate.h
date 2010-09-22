/*
 *  LMErrorHandlerDelegate.h
 *  LMErrorManagement
 *
 *  Created by Jose Vazquez on 9/19/10.
 *  Copyright 2010 Little Mustard LLC. All rights reserved.
 *
 */

// Return constants for error handlers.
enum LMErrorHandlerResult {
    kLMUndefined = 0,
    kLMHandled,
    kLMResolved,
    kLMPassed,
    kLMInternalError = 0xDEADBEEF
};
typedef int LMErrorResult;

@protocol LMErrorHandlerDelegate <NSObject>
@required
- (LMErrorResult)handleLMError:(NSError *)error;
@end