/*
//  LMErrorConvenience.m
//  LMErrorManagement
//
//  Created by Jose Vazquez on 9/23/10.
//  Copyright 2010 Little Mustard LLC. All rights reserved.
*/

#import "LMErrorConvenience.h"
#import "LMErrorInternalErrors.h"
#import "LMLog.h"
#import <asl.h>

NSString *const kLMErrorFileNameErrorKey       = @"kLMErrorFileNameErrorKey";
NSString *const kLMErrorFileLineNumberErrorKey = @"kLMErrorFileLineNumberErrorKey";


#pragma mark Category on NSError
static NSString *const kLMErrorASLClientHandleForThreadKey = @"kLMErrorASLClientHandleForThreadKey";

@implementation NSError (LMErrorKit)
- (NSString *)source {
    return [[self userInfo] objectForKey:kLMErrorFileNameErrorKey];
}

- (NSString *)line {
    return [[self userInfo] objectForKey:kLMErrorFileLineNumberErrorKey];
}

- (NSString *)logMessage {
    return [[self userInfo] objectForKey:kLMLogMessageStringErrorKey];
}

- (void)sendToASL {
    NSMutableDictionary *currentDictionary = [[NSThread currentThread] threadDictionary];
    if (!currentDictionary) LMPostDomainCode(kLMErrorInternalDomain, kLMErrorInternalErrorThreadDictionaryUnavailable);

    aslclient client;
    NSData *data = [currentDictionary objectForKey:kLMErrorASLClientHandleForThreadKey];
    if (data) {
        memcpy(&client, [data bytes], sizeof(client));
    } else {
        client = asl_open([[[NSThread currentThread] name] UTF8String], "com.littlemustard.LMErrorKit", ASL_OPT_STDERR);
        if (client == NULL) LMPostDomainCode(kLMErrorInternalDomain, kLMErrorInternalErrorFailedToOpenASLHandle);

        data = [NSData dataWithBytes:&client length:sizeof(client)];
        [currentDictionary setObject:data forKey:kLMErrorASLClientHandleForThreadKey];
    }
    asl_log(client, NULL, [self code], "%s", [[self logMessage] UTF8String]);
}

@end


#pragma mark -
@implementation LMErrorConvenience

@end
