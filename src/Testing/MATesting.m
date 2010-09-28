/*
//  MATesting.m
//  LMErrorManagement
//
//  Created by Jose Vazquez on 9/20/10.
//  Copyright 2010 Little Mustard LLC. All rights reserved.
*/

#import "MATesting.h"
#import "MARTNSObject.h"
#import "RTMethod.h"

void MAT_WithPool(void (^block)(void))
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    block();
    [pool release];
}

int gMAT_FailureCount;
int gMAT_AssertionCount;
int gMAT_testCount;

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

void runMethodWithNameOnReceiver(id receiver, NSArray *methods, NSString *name) {
    for (RTMethod *method in methods) {
        NSString *methodName = [method selectorName];
        if ([methodName hasPrefix:name]) {
            [receiver performSelector:[method selector]];
            return;
        }
    }
}

+ (void)runTests {
    @try {
        gMAT_FailureCount = 0;
        gMAT_AssertionCount = 0;
        gMAT_testCount = 0;

        // Find all subclasses of our testing base class.
        NSArray *testClasses = [MATesting rt_subclasses];
        for (Class testClass in testClasses) {
            MAT_WithPool(^{

                // Create an instance of each testing class.
                id receiver = [[[testClass alloc] init] autorelease];
                NSArray *methods = [testClass rt_methods];

                // If it exists, run the setUpClass method on the instance.
                runMethodWithNameOnReceiver(receiver, methods, @"setUpClass");

                // Send a message to any test method in the class.
                for (RTMethod *method in methods) {
                    NSString *methodName = [method selectorName];
                    if ([methodName hasPrefix:@"test"]) {
                        MAT_WithPool(^{

                            // If it exists, run the setUp method on the instance.
                            runMethodWithNameOnReceiver(receiver, methods, @"setUp");

                            // Perform the test method now.
                            gMAT_testCount++;
                            [receiver performSelector:[method selector]];

                            // If it exists, run the tearDown method on the instance.
                            runMethodWithNameOnReceiver(receiver, methods, @"tearDown");
                        });
                    }
                }

                // If it exists, run the tearDownClass method on the instance.
                runMethodWithNameOnReceiver(receiver, methods, @"tearDownClass");
            });
        }

        NSString *message;
        if(gMAT_FailureCount) {
            message = [NSString stringWithFormat: @"FAILED: %d total assertion failure%s", gMAT_FailureCount, gMAT_FailureCount > 1 ? "s" : ""];
        } else {
            message = @"SUCCESS";
        }
        NSString *assertCountMessage = [NSString stringWithFormat: @"%d assertion%s", gMAT_AssertionCount, gMAT_AssertionCount > 1 ? "s" : ""];
        NSString *testCountMessage = [NSString stringWithFormat: @"%d test%s", gMAT_testCount, gMAT_testCount > 1 ? "s" : ""];
        NSLog(@"Tests complete. %@, %@: %@", testCountMessage, assertCountMessage, message);
    }
    @catch(id exception) {
        NSLog(@"FAILED: exception: %@", exception);
    }
}

@end
