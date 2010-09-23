/*
//  LMErrorConvenience.h
//  LMErrorManagement
//
//  Created by Jose Vazquez on 9/23/10.
//  Copyright 2010 Little Mustard LLC. All rights reserved.
*/

#import <Cocoa/Cocoa.h>

#define pushErrorHandlerBlock(block) [[LMErrorManager sharedLMErrorManager] pushHandler:[LMErrorHandler errorHandlerWithBlock:block]];

#define postPOSIXError(posixCode) [[LMErrorManager sharedLMErrorManager] handleError:[NSError errorWithDomain:NSPOSIXErrorDomain code:posixCode userInfo:nil]];


@interface LMErrorConvenience : NSObject {

}

@end
