/*
//  MATesting.h
//  LMErrorManagement
//
//  Created by Jose Vazquez on 9/20/10.
//  Copyright 2010 Little Mustard LLC. All rights reserved.
*/

#import <Cocoa/Cocoa.h>


#define TEST(func) MAT_Test(func, #func)

#define TEST_ASSERT(cond, ...) do { \
    gMAT_AssertionCount++; \
    if(!(cond)) { \
        gMAT_FailureCount++; \
        NSString *message = [NSString stringWithFormat: @"" __VA_ARGS__]; \
        NSLog(@"%s:%d: assertion failed: %s %@", __func__, __LINE__, #cond, message); \
    } \
} while(0)

void MAT_WithPool(void (^block)(void));

extern int gMAT_FailureCount;
extern int gMAT_AssertionCount;

void MAT_Test(void (*func)(void), const char *name);


@interface MATesting : NSObject {
}

+ (void)runTests;

@end
