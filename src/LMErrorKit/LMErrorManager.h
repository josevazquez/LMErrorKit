/*
//  LMErrorManager.h
//  LMErrorManagement
//
//  Created by Jose Vazquez on 9/21/10.
//  Copyright 2010 Little Mustard LLC. All rights reserved.
*/

#import <Foundation/Foundation.h>
#import "LMErrorKitTypes.h"

@class LMErrorHandler;

@interface LMErrorManager : NSObject {
    NSMutableArray *_filterStack;
}

@property (nonatomic, assign, readonly) NSUInteger handlerCountForCurrentThread;

+ (id)sharedManager;

- (void)pushFilter:(LMErrorHandler *)handler;
- (void)pushHandler:(LMErrorHandler *)handler;
- (void)popHandler;
- (LMErrorResult)handleError:(NSError *)error;

@end
