# LMErrorKit

LMErrorKit is a framework to manage errors in Objective-C. It uses a singleton manage error handling. The user populates thread specific stacks of error handlers. When an error is posted the singleton traverses the stack until it finds a handler that can deal with the error.

LMErrorKit is released under a BSD license. For the official license, see the LICENSE file.

## Description

The user provides a callback to handle an error and wraps it with an instance of an LMErrorHandler. These handlers can then be pushed to a thread specific stack managed by an LMErrorManager singleton.

When an error is triggered it is reported to the LMErrorManager singleton. The singleton then works it's way down the handler stack. It asks each handler in turn to deal with the error. If a handler can't deal with the error is passes and the manager invokes the next handler down the stack.

## Examples

Coming soon.

## Credits

MAObjCRuntime and all code associated with it is distributed under a BSD license, as listed below.

Copyright (c) 2010, Michael Ash
All rights reserved.
