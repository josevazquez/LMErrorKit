/*
//  LMErrorManagerTest.h
//  LMErrorManagement
//
//  Created by Jose Vazquez on 9/21/10.
//  Copyright 2010 Little Mustard LLC. All rights reserved.
*/

#import <Cocoa/Cocoa.h>
#import "MATesting.h"
#import <LMErrorKit/LMErrorKit.h>

@interface LMErrorManagerTest : MATesting {
    NSString *_handlerName;
    NSString *_fileName;
    NSString *_lineNumber;
}

@property (nonatomic, retain) NSString *handlerName;
@property (nonatomic, retain) NSString *fileName;
@property (nonatomic, retain) NSString *lineNumber;

@end
