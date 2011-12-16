# LMErrorKit

LMErrorKit is a framework to manage errors in Objective-C. It uses a singleton manage error handling. The user populates thread specific stacks of error handlers. When an error is posted the singleton traverses the stack until it finds a handler that can deal with the error.

LMErrorKit is released under a BSD license. For the official license, see the LICENSE file.

## Description

An LMErrorHandler is the basic building block of the system. Each instance wraps around a user provided callback. When an LMErrorHandler receives the handlerError: message, it calls that callback. The programer can supply a callback of just about any type (selector, function, block or delegate.)

Once the programer creates a handler, it can be given to the LMErrorManager singleton to be pushed to the current thread's stack. Newly added handlers will be added to the top of the stack. When an application begins, it can add a general catch-all type handler. Such a handler could simply use NSLog() to dump the error and call abort() (As a matter of fact, the system does just that by default if there are no handlers available.) A more elaborate handler could notify the user and perhaps send an error report to a server.

As the application progresses, more handlers can be added to the stack to handle more specific errors. Once the scope of a handler has come to an end, the programer can pop the handler off the stack.

When an error is posted, the LMErrorManager receives it and works it way down the stack. It will invoke handleError: on each handler in the stack until can handle the error. A handler, that can not handle an error simply returns a value of kLMPassed.

In addition to handling errors, LMLog uses LMErrorKit to post logs. This logging system uses levels compatible with those of syslog. Much like errors, the programer can add handlers to deal with logs. For example, depending on the programer's needs logs could be sent to NSLog(), sent over the network or added to the database. (NOTE: The dedicated stack for dealing with things like logs is not currently implemented.)

## Quick Example

	// Pushing a block based handler onto the stack.
    LMPushHandlerWithBlock(^(id error) {
        if ([[error domain] isEqualToString:kMyParticularDomain]) {
            NSLog(@"Do something interesting with error: %@", error);
            return kLMHandled;
        }
        return kLMPassed;
    });

	// Explicitly posting an OSStatus error.
	LMPostOSStatusError(paramErr);

	// Verifying an OSStatus return value
	chkOSStatus(FSRefMakePath(&fileRef, path, pathLength));

	// Verifying a POSIX return value
	chkPOSIX(open(filename, O_RDONLY));

	// Pop the Handler off the stack.
	LMPopHandler();

## Logging
LMLog can be used for sending log messages.

	// Available Levels are: Critical, Error, Warn, Notice, Info and Debug

	#define LMLOG_LEVEL kLMLogLevelInfo

	LMDebug(@"This will not be executed because Debug level is lower than Info set above");
	LMNotice(@"Notice is above Info so it will be sent");
	LMInfo(@"Additional information can be included usin a format : %@ %d", myObj, i);

	// Conditional variations exist for each level as well.
	LMErrorIf(i != 42, @"We must seek the answer");


## Extras

Thanks to Mike Ash, the LMErrorKit also contains a simple unit testing facility. This is contained in MATesting.m/h and it depends on MAObjCRuntime. MATesting is not a full featured unit testing framework, but it is rather lightweight and easy to work with.

Why was a custom unit testing system used instead of an existing framework? (I particularly like GHUnit) That is what happens when you spend time talking to Mike over pastries.

## Credits

MAObjCRuntime and all code associated with it is distributed under a BSD license, as listed below.

Copyright (c) 2010, Michael Ash
All rights reserved.
