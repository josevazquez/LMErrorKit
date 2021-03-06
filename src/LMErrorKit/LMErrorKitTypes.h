/*
 *  LMErrorKitTypes.h
 *  LMErrorManagement
 *
 *  Created by Jose Vazquez on 9/27/10.
 *  Copyright 2010 Little Mustard LLC. All rights reserved.
 *
 */

#ifdef LMERROR_USE_FULL_PATH_FILENAMES
#define __LM_FILE__ __FILE__
#else
#define __LM_FILE__ __func__
#endif

#define __LM_LINE__ (__LINE__)

// Return constants for error handlers.
enum LMErrorHandlerResult {
    kLMUndefined = 0,
    kLMHandled,
    kLMResolved,
    kLMPassed,
    kLMNoError,
    kLMInternalError = 0xDEADBEEF
};
typedef int LMErrorResult;


// Defines to return an LMErrorHandlerResult wrapped in an NSNumber instance.
#define kLMErrorHandled ([NSNumber numberWithInt:kLMErrorHandlerResultErrorHandled])
#define kLMErrorPassed ([NSNumber numberWithInt:kLMErrorHandlerResultErrorPassed])


// Type definition for error handling functions.
typedef LMErrorResult (*LMErrorHandlerFunction) (NSError *error, void *userData);


// Type definition for optional userData destructor.
typedef void (*LMErrorHandlerContextDestructor) (void *ptr);


#if NS_BLOCKS_AVAILABLE
// Type for error handling blocks
// Takes an id for the NSError argument and returns an LMErrorHandlerResult
typedef LMErrorResult (^LMErrorHandlerBlock)(id);
typedef void (^LMBasicBlock)(void);
#endif
