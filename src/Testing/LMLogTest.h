/*
//  LMLogTest.h
//  LMErrorManagement
//
//  Created by Jose Vazquez on 9/26/10.
//  Copyright 2010 Little Mustard LLC. All rights reserved.
*/

#import <Cocoa/Cocoa.h>
#import "MATesting.h"

@interface LMLogTest : MATesting {
}

@property (nonatomic, retain) NSString *message;
@property (nonatomic, retain) NSString *fileName;
@property (nonatomic, retain) NSString *fileLineNumber;

@end
