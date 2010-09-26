/*
//  LMErrorConvenience.h
//  LMErrorManagement
//
//  Created by Jose Vazquez on 9/23/10.
//  Copyright 2010 Little Mustard LLC. All rights reserved.
*/

#import <Cocoa/Cocoa.h>

FOUNDATION_EXPORT NSString *const kLMErrorFileNameErrorKey;
FOUNDATION_EXPORT NSString *const kLMErrorFileLineNumberErrorKey;


#define pushErrorHandlerBlock(block) [[LMErrorManager sharedLMErrorManager] pushHandler:[LMErrorHandler errorHandlerWithBlock:block]];

#define postPOSIXError(posixCode) [[LMErrorManager sharedLMErrorManager] handleError:[NSError errorWithDomain:NSPOSIXErrorDomain code:posixCode userInfo:nil]];


@interface LMErrorConvenience : NSObject {

}

@end
