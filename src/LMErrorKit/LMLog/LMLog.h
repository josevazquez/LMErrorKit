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

#define postLMLog(logLevel, value, ...) \
  [[LMErrorManager sharedLMErrorManager] handleError: \
    [NSError errorWithDomain:kLMErrorLogDomain code:logLevel userInfo: \
      [NSDictionary dictionaryWithObjectsAndKeys: \
        @"" __FILE__, kLMErrorFileNameErrorKey, \
        @"" __LINE__, kLMErrorFileLineNumberErrorKey, \
        [NSString stringWithFormat:value, ## _VA_ARGS__], kLMLogMessageStringErrorKey, \
      ] \
    ] \
  ];


#if LMLOG_DESTINATION==LMLOG_TO_NSLOG
#define LMLOG_OUTPUT(value, ...) NSLog(@"%s:%u:" value, __FILE__, __LINE__, ## __VA_ARGS__);
#elif LMLOG_DESTINATION==LMLOG_TO_NSSTRING
#ifdef LMLOG_NSSTRING_VAR
#define LMLOG_OUTPUT(value, ...) LMLOG_NSSTRING_VAR=[NSString stringWithFormat:@"%s:%u:" value, __FILE__, __LINE__, ## __VA_ARGS__];
#endif
#elif LMLOG_DESTINATION==LMLOG_TO_SYSLOG
#define LMLOG_OUTPUT(value, ...) syslog(LOG_WARNING, "%s:%u:" value "\n", __FILE__, __LINE__, ## __VA_ARGS__);
#else // Default to LMLOG_TO_STDERR
#define LMLOG_OUTPUT(value, ...) fprintf(stderr, "%s:%u:" value "\n", __FILE__, __LINE__, ## __VA_ARGS__);
#endif

/////////////////////////////////////////////////////////////////////////////////////////////////////////

#if LMLOG_LEVEL>=LMLOG_DEBUG
#define DEBUG(value, ...) postLMLog(kLMLogLevelDebug, value, ## __VA_ARGS__)
#define DEBUGIF(expression, value, ...) if(expression){postLMLog(kLMLogLevelDebug, value, ## __VA_ARGS__)}
#else 
#define DEBUG(value, ...)
#define DEBUGIF(expression, value, ...)
#endif

#if LMLOG_LEVEL>=LMLOG_INFO
#define INFO(value, ...) LMLOG_OUTPUT("INFO: " value, ## __VA_ARGS__)
#define INFOIF(expression, value, ...) if(expression){LMLOG_OUTPUT("INFO: " value, ## __VA_ARGS__)}
#else 
#define INFO(value, ...)
#define INFOIF(expression, value, ...)
#endif

#if LMLOG_LEVEL>=LMLOG_ASSERT
#define ASSERT(value, ...) LMLOG_OUTPUT("ASSERT: " value, ## __VA_ARGS__)
#define ASSERTIF(expression, value, ...) if(expression){LMLOG_OUTPUT("ASSERT: " value, ## __VA_ARGS__)}
#else 
#define ASSERT(value, ...)
#define ASSERTIF(expression, value, ...)
#endif

#if LMLOG_LEVEL>=LMLOG_WARN
#define WARN(value, ...) LMLOG_OUTPUT("WARN: " value, ## __VA_ARGS__)
#define WARNIF(expression, value, ...) if(expression){LMLOG_OUTPUT("WARN: " value, ## __VA_ARGS__)}
#else 
#define WARN(value, ...)
#define WARNIF(expression, value, ...)
#endif

#if LMLOG_LEVEL>=LMLOG_ERROR
#define ERROR(value, ...) LMLOG_OUTPUT("ERROR: " value, ## __VA_ARGS__)
#define ERRORIF(expression, value, ...) if(expression){LMLOG_OUTPUT("ERROR: " value, ## __VA_ARGS__)}
#else 
#define ERROR(value, ...)
#define ERRORIF(expression, value, ...)
#endif

#if LMLOG_LEVEL>=LMLOG_FATAL
#define FATAL(value, ...) LMLOG_OUTPUT("FATAL: " value, ## __VA_ARGS__)
#define FATALIF(expression, value, ...) if(expression){LMLOG_OUTPUT("FATAL: " value, ## __VA_ARGS__)}
#else 
#define FATAL(value, ...)
#define FATALIF(expression, value, ...)
#endif


@interface LMLog : NSObject {

}

@end
