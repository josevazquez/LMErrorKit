/*
//  LMLog.h
//  LMErrorManagement
//
//  Created by Jose Vazquez on 9/25/10.
//  Copyright 2010 Little Mustard LLC. All rights reserved.
*/

#import <Cocoa/Cocoa.h>

// Return constants for error handlers.
enum LMLogLevel {
    kLMLogLevelNone = 0,
    kLMLogLevelFatal,
    kLMLogLevelError,
    kLMLogLevelWarn,
    kLMLogLevelAssert,
    kLMLogLevelInfo,
    kLMLogLevelDebug,
    kLMLogLevelAll
};
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
        @"" __FILE__, kLMErrorFileNameErrorKey, \
        [NSString stringWithFormat:@"%d",__LINE__], kLMErrorFileLineNumberErrorKey, \
        [NSString stringWithFormat:value, ## __VA_ARGS__], kLMLogMessageStringErrorKey, \
        nil \
      ] \
    ] \
  ];

/////////////////////////////////////////////////////////////////////////////////////////////////////////

#if LMLOG_LEVEL>=kLMLogLevelDebug
#define DEBUG(value, ...) LMPostLog(kLMLogLevelDebug, value, ## __VA_ARGS__)
#define DEBUGIF(expression, value, ...) if(expression){LMPostLog(kLMLogLevelDebug, value, ## __VA_ARGS__)}
#else 
#define DEBUG(value, ...)
#define DEBUGIF(expression, value, ...)
#endif

#if LMLOG_LEVEL>=kLMLogLevelInfo
#define INFO(value, ...) LMPostLog(kLMLogLevelDebug, value, ## __VA_ARGS__)
#define INFOIF(expression, value, ...) if(expression){LMPostLog(kLMLogLevelDebug, value, ## __VA_ARGS__)}
#else 
#define INFO(value, ...)
#define INFOIF(expression, value, ...)
#endif

#if LMLOG_LEVEL>=kLMLogLevelAssert
#define ASSERT(value, ...) LMPostLog(kLMLogLevelDebug, value, ## __VA_ARGS__)
#define ASSERTIF(expression, value, ...) if(expression){LMPostLog(kLMLogLevelDebug, value, ## __VA_ARGS__)}
#else 
#define ASSERT(value, ...)
#define ASSERTIF(expression, value, ...)
#endif

#if LMLOG_LEVEL>=kLMLogLevelWarn
#define WARN(value, ...) LMPostLog(kLMLogLevelDebug, value, ## __VA_ARGS__)
#define WARNIF(expression, value, ...) if(expression){LMPostLog(kLMLogLevelDebug, value, ## __VA_ARGS__)}
#else 
#define WARN(value, ...)
#define WARNIF(expression, value, ...)
#endif

#if LMLOG_LEVEL>=kLMLogLevelError
#define ERROR(value, ...) LMPostLog(kLMLogLevelDebug, value, ## __VA_ARGS__)
#define ERRORIF(expression, value, ...) if(expression){LMPostLog(kLMLogLevelDebug, value, ## __VA_ARGS__)}
#else 
#define ERROR(value, ...)
#define ERRORIF(expression, value, ...)
#endif

#if LMLOG_LEVEL>=kLMLogLevelFatal
#define FATAL(value, ...) LMPostLog(kLMLogLevelDebug, value, ## __VA_ARGS__)
#define FATALIF(expression, value, ...) if(expression){LMPostLog(kLMLogLevelDebug, value, ## __VA_ARGS__)}
#else 
#define FATAL(value, ...)
#define FATALIF(expression, value, ...)
#endif


@interface LMLog : NSObject {

}

@end
