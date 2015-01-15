//
//  OCFuntimeProtocolsSpec.mm
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 1/15/15.
//  Copyright (c) 2015 okolodev. All rights reserved.
//

#import "OCFuntime+Protocols.h"
#import "OCFProtocolMock.h"
#import "OCFuntime+Properties.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(OCFuntimeProtocolsSpec)

describe(@"OCFuntime protocol optional method injection", ^
{
    __block OCFuntime *funtime = nil;
    __block OCFProtocolMock *mock = nil;

    beforeEach((id)^
    {
        funtime = [[OCFuntime alloc] init];
        mock = [[OCFProtocolMock alloc] init];
    });

    afterEach((id)^
    {
        [funtime removeAllProperties];
        funtime = nil;
        mock = nil;
    });

    it(@"should throw exception if protocol method doesn't injected", ^
    {
        ^
        {
            [mock simpleMethodOne];
        } should raise_exception;
    });

    it(@"should throw exception on injection if protocol doesn't conform OCFAutoInjectProtocol", ^
    {
        ^
        {
            [funtime injectProtocol:@protocol(OCFBadProtocol) method:@selector(badMethod) implementaion:^{}];
        } should raise_exception;
    });

    it(@"should throw exception on injection if protocol doesn't contain method", ^
    {
        ^
        {
            [funtime injectProtocol:@protocol(OCFSimpleProtocol) method:@selector(badMethod) implementaion:^{}];
        } should raise_exception;
    });

    it(@"should throw exception on injection if method is required", ^
    {
        ^
        {
            [funtime injectProtocol:@protocol(OCFSimpleProtocol) method:@selector(requiredMethod) implementaion:^{}];
        } should raise_exception;

    });

    it (@"should skip injection if method is already implemented", ^
    {
        [funtime injectProtocol:@protocol(OCFSimpleProtocol) method:@selector(implementedMethod)
                  implementaion:^
        {
            return YES;
        }];
        [mock implementedMethod] should equal(NO);
    });

    it (@"should skip injection if method is already injected", ^
    {
        [funtime injectProtocol:@protocol(OCFSimpleProtocol) method:@selector(simpleMethodTwoWithArgument:)
                  implementaion:^
        {
            return NO;
        }];
        [funtime injectProtocol:@protocol(OCFSimpleProtocol) method:@selector(simpleMethodTwoWithArgument:)
                  implementaion:^
        {
            return YES;
        }];
        [mock simpleMethodTwoWithArgument:YES] should equal(NO);
    });

    it(@"should not throw exception on method call if method was injected", ^
    {
        [funtime injectProtocol:@protocol(OCFSimpleProtocol) method:@selector(simpleMethodOne) implementaion:^{}];
        ^
        {
            [mock simpleMethodOne];
        } should_not raise_exception;
    });

    it(@"should inject protocol method", ^
    {
        [funtime injectProtocol:@protocol(OCFSimpleProtocol) method:@selector(simpleMethodTwoWithArgument:)
                  implementaion:^(id instance, BOOL argument)
        {
            return argument;
        }];
        [mock simpleMethodTwoWithArgument:YES] should equal(YES);
        [mock simpleMethodTwoWithArgument:NO] should equal(NO);
    });

    it(@"should remove injection for protocol method", ^{
        [funtime injectProtocol:@protocol(OCFSimpleProtocol) method:@selector(simpleMethodOne) implementaion:^{}];
        [funtime removeInjectedProtocol:@protocol(OCFSimpleProtocol)
                                 method:@selector(simpleMethodOne)];
        ^
        {
            [mock simpleMethodOne];
        } should raise_exception;
    });

    it(@"should remove injection for all protocol methods", ^{
        [funtime injectProtocol:@protocol(OCFSimpleProtocol) method:@selector(simpleMethodOne) implementaion:^{}];
        [funtime injectProtocol:@protocol(OCFSimpleProtocol) method:@selector(simpleMethodTwoWithArgument:)
                  implementaion:^
        {
            return NO;
        }];
        [funtime removeInjectedProtocol:@protocol(OCFSimpleProtocol)];
        ^
        {
            [mock simpleMethodOne];
        } should raise_exception;
        ^
        {
            [mock simpleMethodTwoWithArgument:NO];
        } should raise_exception;
    });

    it(@"should remove injection on 'funtime' dealloc", ^
    {
        [funtime injectProtocol:@protocol(OCFSimpleProtocol) method:@selector(simpleMethodOne) implementaion:^{}];
        funtime = nil;
        ^
        {
            [mock simpleMethodOne];
        } should raise_exception;
    });

    it(@"should thow exception on injection if protocol is nil", ^
    {
        ^
        {
            [funtime injectProtocol:nil method:@selector(simpleMethodOne) implementaion:^{}];
        } should raise_exception;
    });

    it(@"should thow exception on injection if method is nil on injection", ^
    {
        ^
        {
            [funtime injectProtocol:@protocol(OCFSimpleProtocol) method:nil implementaion:^{}];
        } should raise_exception;
    });

    it(@"should thow exception on injection if implementation is nil", ^
    {
        ^
        {
            [funtime injectProtocol:@protocol(OCFSimpleProtocol) method:@selector(simpleMethodOne) implementaion:nil];
        } should raise_exception;
    });

    it(@"should thow exception on removing method injection if protocol is nil", ^
    {
        ^
        {
            [funtime removeInjectedProtocol:nil method:@selector(simpleMethodOne)];
        } should raise_exception;
    });

    it(@"should thow exception on removing method injection if method is nil", ^
    {
        ^
        {
            [funtime removeInjectedProtocol:@protocol(OCFSimpleProtocol) method:nil];
        } should raise_exception;
    });

    it(@"should thow exception on removing protocol injection if protocol is nil", ^
    {
        ^
        {
            [funtime removeInjectedProtocol:nil];
        } should raise_exception;
    });

});


SPEC_END