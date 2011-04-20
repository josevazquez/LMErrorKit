/*
//  LMLogTest.h
//  LMErrorManagement
//
//  Created by Jose Vazquez on 9/26/10.
//  Copyright 2010 Little Mustard LLC. All rights reserved.
*/

#import <Foundation/Foundation.h>
#import "MATesting.h"

@interface LMLogTest : MATesting {
    NSString *_message;
    NSString *_source;
    NSString *_line;
    NSInteger _code;
}

@property (nonatomic, retain) NSString *message;
@property (nonatomic, retain) NSString *source;
@property (nonatomic, retain) NSString *line;
@property (nonatomic, assign) NSInteger code;

@end
