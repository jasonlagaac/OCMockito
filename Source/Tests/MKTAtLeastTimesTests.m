//
//  OCMockito - MKTAtLeastTimesTests.m
//  Copyright 2014 Jonathan M. Reid. See LICENSE.txt
//
//  Created by: Markus Gasser
//  Source: https://github.com/jonreid/OCMockito
//

#import "MKTAtLeastTimes.h"

#define MOCKITO_SHORTHAND
#import "OCMockito.h"
#import "MKTInvocationContainer.h"
#import "MKTInvocationMatcher.h"
#import "MKTVerificationData.h"

// Test support
#import "MockTestCase.h"
#import <SenTestingKit/SenTestingKit.h>

#define HC_SHORTHAND
#if TARGET_OS_MAC
    #import <OCHamcrest/OCHamcrest.h>
#else
    #import <OCHamcrestIOS/OCHamcrestIOS.h>
#endif


@interface MKTAtLeastTimesTests : SenTestCase
@end

@implementation MKTAtLeastTimesTests
{
    MKTVerificationData *verification;
    NSInvocation *invocation;
}

- (void)setUp
{
    [super setUp];
    verification = [[MKTVerificationData alloc] init];
    verification.invocations = [[MKTInvocationContainer alloc] init];
    verification.wanted = [[MKTInvocationMatcher alloc] init];
    invocation = [NSInvocation invocationWithMethodSignature:[NSMethodSignature signatureWithObjCTypes:"v@:"]];
    [verification.wanted setExpectedInvocation:invocation];
}

- (void)simulateInvocationCount:(int)count
{
    for (int i = 0; i < count; ++i)
        [verification.invocations setInvocationForPotentialStubbing:invocation];
}

- (void)testVerifyAtLeastOne_WithNoInvocations_ShouldFail
{
    MKTAtLeastTimes *sut = [[MKTAtLeastTimes alloc] initWithMinimumCount:1];

    [self simulateInvocationCount:0];

    STAssertThrows([sut verifyData:verification], nil);
}

- (void)testVerifyData_WithTooFewInvocations_ShouldFail
{
    MKTAtLeastTimes *sut = [[MKTAtLeastTimes alloc] initWithMinimumCount:2];

    [self simulateInvocationCount:1];

    STAssertThrows([sut verifyData:verification], nil);
}

- (void)testVerifyAtLeastZero_WithNoInvocations_ShouldSucceed
{
    MKTAtLeastTimes *sut = [[MKTAtLeastTimes alloc] initWithMinimumCount:0];

    [self simulateInvocationCount:0];

    STAssertNoThrow([sut verifyData:verification], nil);
}

- (void)testVerifyData_WithExactNumberOfInvocations_ShouldSucceed
{
    MKTAtLeastTimes *sut = [[MKTAtLeastTimes alloc] initWithMinimumCount:1];

    [self simulateInvocationCount:1];

    STAssertNoThrow([sut verifyData:verification], nil);
}

- (void)testVerifyData_WithMoreInvocations_ShouldSucceed
{
    MKTAtLeastTimes *sut = [[MKTAtLeastTimes alloc] initWithMinimumCount:1];

    [self simulateInvocationCount:2];

    STAssertNoThrow([sut verifyData:verification], nil);
}

@end
