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
    kLMErrorHandlerResultErrorHandled,
    kLMErrorHandlerResultErrorPassed,
    kLMErrorHandlerResultUndefined
};
typedef enum LMErrorHandlerResult LMErrorHandlerResult;

@protocol LMErrorHandlerDelegate <NSObject>
@required
- (LMErrorHandlerResult)handleLMError:(NSError *)error;
@end