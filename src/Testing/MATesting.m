/*
//  MATesting.m
//  LMErrorManagement
//
//  Created by Jose Vazquez on 9/20/10.
//  Copyright 2010 Little Mustard LLC. All rights reserved.
*/

#import "MATesting.h"



void MAT_WithPool(void (^block)(void))
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    block();
    [pool release];
}

int gMAT_FailureCount;

void MAT_Test(void (*func)(void), const char *name)
{
    MAT_WithPool(^{
        int failureCount = gMAT_FailureCount;
        NSLog(@"Testing %s", name);
        func();
        NSLog(@"%s: %s", name, failureCount == gMAT_FailureCount ? "SUCCESS" : "FAILED");
    });
}


@implementation MATesting

@end