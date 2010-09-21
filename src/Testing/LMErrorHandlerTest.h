/*
//  LMErrorHandlerTest.h
//  LMErrorManagement
//
//  Created by Jose Vazquez on 9/21/10.
//  Copyright 2010 Little Mustard LLC. All rights reserved.
*/

#import <Cocoa/Cocoa.h>
#import "MATesting.h"

@interface LMErrorHandlerTest : MATesting {
    NSInteger _aNumber;
    NSString *_aString;
    NSString *_handlerType;
}

@property (nonatomic, assign) NSInteger aNumber;
@property (nonatomic, retain) NSString *aString;
@property (nonatomic, retain) NSString *handlerType;

@end
