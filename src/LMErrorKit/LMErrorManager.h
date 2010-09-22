/*
//  LMErrorManager.h
//  LMErrorManagement
//
//  Created by Jose Vazquez on 9/21/10.
//  Copyright 2010 Little Mustard LLC. All rights reserved.
*/

#import <Cocoa/Cocoa.h>
@class LMErrorHandler;

@interface LMErrorManager : NSObject {

}

- (void)pushHandler:(LMErrorHandler *)handler;
- (void)popHandler;

@end
