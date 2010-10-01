/*
//  LMErrorManagerTest.m
//  LMErrorManagement
//
//  Created by Jose Vazquez on 9/21/10.
//  Copyright 2010 Little Mustard LLC. All rights reserved.
*/

#import "LMErrorManagerTest.h"
#include <mach/mach.h>

NSString * const kHandlerNameGeneric = @"kHandlerNameGeneric";
NSString * const kHandlerNamePOSIXErrorEINPROGRESS = @"kHandlerNamePOSIXErrorEINPROGRESS";
NSString * const kHandlerNamePOSIXErrorENXIO = @"kHandlerNamePOSIXErrorENXIO";
NSString * const kHandlerNameLocalBlock = @"kHandlerNameLocalBlock";


@implementation LMErrorManagerTest

- (void)dealloc {
    [_handlerName release], _handlerName=nil;
    [_domain release], _domain=nil;
    [_fileName release], _fileName=nil;
    [_lineNumber release], _lineNumber=nil;
    [super dealloc];
}

- (void)testObtainManager {
    LMErrorManager *manager = [LMErrorManager sharedManager];
    LMErrorManager *manager2 = [LMErrorManager sharedManager];
    TEST_ASSERT(manager != nil);
    TEST_ASSERT(manager == manager2);
}

- (void)setUpClass {
    LMPushHandlerWithBlock(^(id error) {
        self.handlerName = kHandlerNameGeneric;
        self.domain = [error domain];
        self.code = [error code];
        self.fileName = [[error userInfo] objectForKey:kLMErrorFileNameErrorKey];
        self.lineNumber = [[error userInfo] objectForKey:kLMErrorFileLineNumberErrorKey];
        return kLMHandled;
    });
    LMPushHandlerWithBlock(^(id error) {
        //NSLog(@"kPOSIXErrorEINPROGRESS Handler");
        if ([error code] == kPOSIXErrorEINPROGRESS) {
            self.handlerName = kHandlerNamePOSIXErrorEINPROGRESS;
            self.domain = [error domain];
            self.code = [error code];
            self.fileName = [[error userInfo] objectForKey:kLMErrorFileNameErrorKey];
            self.lineNumber = [[error userInfo] objectForKey:kLMErrorFileLineNumberErrorKey];
            return kLMHandled;
        }
        return kLMPassed;
    });
    LMPushHandlerWithBlock(^(id error) {
        //NSLog(@"kPOSIXErrorENXIO Handler");
        if ([error code] == kPOSIXErrorENXIO) {
            self.handlerName = kHandlerNamePOSIXErrorENXIO;
            self.domain = [error domain];
            self.code = [error code];
            self.fileName = [[error userInfo] objectForKey:kLMErrorFileNameErrorKey];
            self.lineNumber = [[error userInfo] objectForKey:kLMErrorFileLineNumberErrorKey];
            return kLMHandled;
        }
        return kLMPassed;
    });
}

- (void)setUp {
    self.handlerName = nil;
    self.domain = nil;
    self.fileName = nil;
    self.lineNumber = nil;
    self.code = -1;
}

- (void)testBlockHandler {
    LMErrorResult result = LMPostPOSIXError(kPOSIXErrorEINPROGRESS); NSString *line = [NSString stringWithFormat:@"%d", __LINE__];

    TEST_ASSERT(result == kLMHandled);
    TEST_ASSERT([self.handlerName isEqualToString:kHandlerNamePOSIXErrorEINPROGRESS]);
    TEST_ASSERT([self.domain isEqualToString:NSPOSIXErrorDomain]);
    TEST_ASSERT(self.code == kPOSIXErrorEINPROGRESS);
    TEST_ASSERT([self.fileName isEqualToString:@"-[LMErrorManagerTest testBlockHandler]"]);
    TEST_ASSERT([self.lineNumber isEqualToString:line]);

    result = LMPostPOSIXError(kPOSIXErrorENXIO);

    TEST_ASSERT(result == kLMHandled);
    TEST_ASSERT([self.handlerName isEqualToString:kHandlerNamePOSIXErrorENXIO]);
}

- (void)testHandlerAdditionAndRemoval {
    LMErrorResult result = LMPostPOSIXError(kPOSIXErrorEINPROGRESS);
    TEST_ASSERT(result == kLMHandled);
    TEST_ASSERT([self.handlerName isEqual:kHandlerNamePOSIXErrorEINPROGRESS]);

    self.handlerName = nil;

    NSString *localHandler = @"This is the local handler";
    LMPushHandlerWithBlock(^(id error) {
        if ([error code] == kPOSIXErrorEINPROGRESS) {
            self.handlerName = localHandler;
            return kLMHandled;
        }
        return kLMPassed;
    });
    result = LMPostPOSIXError(kPOSIXErrorEINPROGRESS);
    TEST_ASSERT(result == kLMHandled);
    TEST_ASSERT([self.handlerName isEqualToString:localHandler]);

    self.handlerName = nil;

    LMPopHandler();
    result = LMPostPOSIXError(kPOSIXErrorEINPROGRESS);
    TEST_ASSERT(result == kLMHandled);
    TEST_ASSERT([self.handlerName isEqualToString:kHandlerNamePOSIXErrorEINPROGRESS]);
}

- (void)testPostOSStatusError {
    LMErrorResult result = LMPostOSStatusError(paramErr); NSString *line = [NSString stringWithFormat:@"%d", __LINE__];

    TEST_ASSERT(result == kLMHandled);
    TEST_ASSERT([self.handlerName isEqualToString:kHandlerNameGeneric]);
    TEST_ASSERT([self.domain isEqualToString:NSOSStatusErrorDomain]);
    TEST_ASSERT(self.code == paramErr);
    TEST_ASSERT([self.fileName isEqualToString:@"-[LMErrorManagerTest testPostOSStatusError]"]);
    TEST_ASSERT([self.lineNumber isEqualToString:line]);
}

- (void)testPostMachError {
    LMErrorResult result = LMPostMachError(KERN_FAILURE); NSString *line = [NSString stringWithFormat:@"%d", __LINE__];

    TEST_ASSERT(result == kLMHandled);
    TEST_ASSERT([self.handlerName isEqualToString:kHandlerNameGeneric]);
    TEST_ASSERT([self.domain isEqualToString:NSMachErrorDomain]);
    TEST_ASSERT(self.code == KERN_FAILURE);
    TEST_ASSERT([self.fileName isEqualToString:@"-[LMErrorManagerTest testPostMachError]"]);
    TEST_ASSERT([self.lineNumber isEqualToString:line]);
}

- (void)testChkOSStatus {
    FSRef fileRef;
    NSString *badPath = @"EAT AT JOES";
    LMErrorResult result = chkOSStatus(FSRefMakePath(&fileRef, (UInt8 *)[badPath UTF8String], [badPath length])); NSString *line = [NSString stringWithFormat:@"%d", __LINE__];

    TEST_ASSERT(result == kLMHandled);
    TEST_ASSERT([self.handlerName isEqualToString:kHandlerNameGeneric]);
    TEST_ASSERT([self.domain isEqualToString:NSOSStatusErrorDomain]);
    TEST_ASSERT(self.code == nsvErr); // no such volume
    TEST_ASSERT([self.fileName isEqualToString:@"-[LMErrorManagerTest testChkOSStatus]"]);
    TEST_ASSERT([self.lineNumber isEqualToString:line]);
}

- (void)testChkPOSIX {
    int result = chkPOSIX(open("bad file name", O_RDONLY)); NSString *line = [NSString stringWithFormat:@"%d", __LINE__];

    TEST_ASSERT(result == -1); // POSIX return value indicating an error occured.
    TEST_ASSERT([self.handlerName isEqualToString:kHandlerNameGeneric]);
    TEST_ASSERT([self.domain isEqualToString:NSPOSIXErrorDomain]);
    TEST_ASSERT(self.code == ENOENT); // O_CREAT is not set and the named file does not exist.
    TEST_ASSERT([self.fileName isEqualToString:@"-[LMErrorManagerTest testChkPOSIX]"]);
    TEST_ASSERT([self.lineNumber isEqualToString:line]);
}

- (void)testChkMach {
    LMErrorResult result = chkMach(vm_deallocate(0, (vm_address_t)NULL, vm_page_size)); NSString *line = [NSString stringWithFormat:@"%d", __LINE__];

    TEST_ASSERT(result == kLMHandled);
    TEST_ASSERT([self.handlerName isEqualToString:kHandlerNameGeneric]);
    TEST_ASSERT([self.domain isEqualToString:NSMachErrorDomain]);
    TEST_ASSERT(self.code == KERN_INVALID_ADDRESS);
    TEST_ASSERT([self.fileName isEqualToString:@"-[LMErrorManagerTest testChkMach]"]);
    TEST_ASSERT([self.lineNumber isEqualToString:line]);
    NSLog(@"vm_deallocate returned: %X", self.code);
}

- (void)testRunBlockWithBlockHandler {
    __block LMErrorResult result;
    __block NSString *line;

    LMRunBlockWithBlockHandler(^(void) {
        result = LMPostOSStatusError(unitTblFullErr); line = [NSString stringWithFormat:@"%d", __LINE__];
    }, ^(id error) {
        self.handlerName = kHandlerNameLocalBlock;
        self.domain = [error domain];
        self.code = [error code];
        self.fileName = [[error userInfo] objectForKey:kLMErrorFileNameErrorKey];
        self.lineNumber = [[error userInfo] objectForKey:kLMErrorFileLineNumberErrorKey];
        return kLMHandled;
    });

    TEST_ASSERT(result == kLMHandled);
    TEST_ASSERT([self.handlerName isEqualToString:kHandlerNameLocalBlock]);
    TEST_ASSERT([self.domain isEqualToString:NSOSStatusErrorDomain]);
    TEST_ASSERT(self.code == unitTblFullErr);
    TEST_ASSERT([self.fileName isEqualToString:@"__-[LMErrorManagerTest testRunBlockWithBlockHandler]_block_invoke_1"]);
    TEST_ASSERT([self.lineNumber isEqualToString:line]);
}

#pragma mark -
#pragma mark Accessor
@synthesize handlerName=_handlerName;
@synthesize domain=_domain;
@synthesize code=_code;
@synthesize fileName=_fileName;
@synthesize lineNumber=_lineNumber;

@end
