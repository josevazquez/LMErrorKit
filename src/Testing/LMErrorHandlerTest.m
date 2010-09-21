/*
//  LMErrorHandlerTest.m
//  LMErrorManagement
//
//  Created by Jose Vazquez on 9/21/10.
//  Copyright 2010 Little Mustard LLC. All rights reserved.
*/

#import "LMErrorHandlerTest.h"


@implementation LMErrorHandlerTest

- (void)setUpClass {
    NSLog(@"setUpClass Invoked!!");
}

- (void)tearDownClass {
    NSLog(@"tearDownClass Invoked!!");
}

- (void)setUp {
    NSLog(@"setUp Invoked!!");
}

- (void)tearDown {
    NSLog(@"tearDown Invoked!!");
}

- (void)testSelectorHandler {
    NSLog(@"testSelectorHandler Invoked!!");
}

- (void)testFunctionHandler {
    NSLog(@"testFunctionHandler Invoked!!");
}

- (void)notatest {
    NSLog(@"Danger Will Robinson!! This is NOT a test");
}

@end
