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
    NSString *_domain;
    NSInteger _code;
    NSString *_source;
    NSString *_line;
}

@property (nonatomic, retain) NSString *handlerName;
@property (nonatomic, retain) NSString *domain;
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, retain) NSString *source;
@property (nonatomic, retain) NSString *line;

@end
