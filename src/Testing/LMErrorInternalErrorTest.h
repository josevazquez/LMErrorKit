/*
//  LMErrorInternalErrorTest.h
//  LMErrorKit
//
//  Created by Jose Vazquez on 10/5/10.
//  Copyright 2010 Little Mustard LLC. All rights reserved.
*/

#import <Foundation/Foundation.h>
#import <LMErrorKit/LMErrorKit.h>
#import "MATesting.h"

@interface LMErrorInternalErrorTest : MATesting {
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
