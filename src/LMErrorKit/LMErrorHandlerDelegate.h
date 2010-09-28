/*
 *  LMErrorHandlerDelegate.h
 *  LMErrorManagement
 *
 *  Created by Jose Vazquez on 9/19/10.
 *  Copyright 2010 Little Mustard LLC. All rights reserved.
 *
 */

#import "LMErrorKitTypes.h"

@protocol LMErrorHandlerDelegate <NSObject>
@required
- (LMErrorResult)handleLMError:(NSError *)error;
@end