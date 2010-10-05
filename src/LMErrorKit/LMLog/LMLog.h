/*
//  LMLog.h
//  LMErrorManagement
//
//  Created by Jose Vazquez on 9/25/10.
//  Copyright 2010 Little Mustard LLC. All rights reserved.
*/

#import <Foundation/Foundation.h>

// Return constants for error handlers.
#define kLMLogLevelNone     (0) // Critical starts at 2 for syslog compatibility
#define kLMLogLevelCritical (2) // critical conditions
#define kLMLogLevelError    (3) // error conditions
#define kLMLogLevelWarn     (4) // warning conditions
#define kLMLogLevelNotice   (5) // normal but significant condition
#define kLMLogLevelInfo     (6) // informational
#define kLMLogLevelDebug    (7)
#define kLMLogLevelAll      (8)
typedef int LMLogLevel;

FOUNDATION_EXPORT NSString *const kLMErrorLogDomain;
FOUNDATION_EXPORT NSString *const kLMLogMessageStringErrorKey;

#ifndef LMLOG_LEVEL
#define LMLOG_LEVEL 0
#endif

#define LMPostLog(logLevel, value, ...) \
  [[LMErrorManager sharedManager] handleError: \
    [NSError errorWithDomain:kLMErrorLogDomain code:logLevel userInfo: \
      [NSDictionary dictionaryWithObjectsAndKeys: \
        [NSString stringWithFormat:@"%s",__LM_FILE__], kLMErrorFileNameErrorKey, \
        [NSString stringWithFormat:@"%d",__LM_LINE__], kLMErrorFileLineNumberErrorKey, \
        [NSString stringWithFormat:value, ## __VA_ARGS__], kLMLogMessageStringErrorKey, \
        nil \
      ] \
    ] \
  ];

/////////////////////////////////////////////////////////////////////////////////////////////////////////

#if LMLOG_LEVEL>=kLMLogLevelDebug
#define LMDebug(value, ...) LMPostLog(kLMLogLevelDebug, value, ## __VA_ARGS__)
#define LMDebugIf(expression, value, ...) if(expression){LMPostLog(kLMLogLevelDebug, value, ## __VA_ARGS__)}
#else 
#define LMDebug(value, ...)
#define LMDebugIf(expression, value, ...)
#endif

#if LMLOG_LEVEL>=kLMLogLevelInfo
#define LMInfo(value, ...) LMPostLog(kLMLogLevelInfo, value, ## __VA_ARGS__)
#define LMInfoIf(expression, value, ...) if(expression){LMPostLog(kLMLogLevelInfo, value, ## __VA_ARGS__)}
#else 
#define LMInfo(value, ...)
#define LMInfoIf(expression, value, ...)
#endif

#if LMLOG_LEVEL>=kLMLogLevelNotice
#define LMNotice(value, ...) LMPostLog(kLMLogLevelNotice, value, ## __VA_ARGS__)
#define LMNoticeIf(expression, value, ...) if(expression){LMPostLog(kLMLogLevelNotice, value, ## __VA_ARGS__)}
#else
#define LMNotice(value, ...)
#define LMNoticeIf(expression, value, ...)
#endif

#if LMLOG_LEVEL>=kLMLogLevelWarn
#define LMWarn(value, ...) LMPostLog(kLMLogLevelWarn, value, ## __VA_ARGS__)
#define LMWarnIf(expression, value, ...) if(expression){LMPostLog(kLMLogLevelWarn, value, ## __VA_ARGS__)}
#else 
#define LMWarn(value, ...)
#define LMWarnIf(expression, value, ...)
#endif

#if LMLOG_LEVEL>=kLMLogLevelError
#define LMError(value, ...) LMPostLog(kLMLogLevelError, value, ## __VA_ARGS__)
#define LMErrorIf(expression, value, ...) if(expression){LMPostLog(kLMLogLevelError, value, ## __VA_ARGS__)}
#else 
#define LMError(value, ...)
#define LMErrorIf(expression, value, ...)
#endif

#if LMLOG_LEVEL>=kLMLogLevelCritical
#define LMCritical(value, ...) LMPostLog(kLMLogLevelCritical, value, ## __VA_ARGS__)
#define LMCriticalIf(expression, value, ...) if(expression){LMPostLog(kLMLogLevelCritical, value, ## __VA_ARGS__)}
#else 
#define LMCritical(value, ...)
#define LMCriticalIf(expression, value, ...)
#endif


@interface LMLog : NSObject {

}

@end
