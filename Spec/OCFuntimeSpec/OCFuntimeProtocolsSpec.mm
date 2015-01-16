//
//  OCFuntimeProtocolsSpec.mm
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 1/15/15.
//  Copyright (c) 2015 okolodev. All rights reserved.
//

#import "OCFuntime+Protocols.h"
#import "OCFProtocolMock.h"

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

    it(@"should throw exception on injection if protocol doesn't conform OCFAutoInjectProtocol", ^
    {
        ^
        {
            [funtime injectProtocol:@protocol(OCFBadProtocol) instanceMethod:@selector(badMethod) implementaion:^{}];
        } should raise_exception;
    });

    it(@"should throw exception on injection if protocol doesn't contain method", ^
    {
        ^
        {
            [funtime injectProtocol:@protocol(OCFSimpleProtocol) instanceMethod:@selector(badMethod) implementaion:^{}];
        } should raise_exception;
    });

    it(@"should throw exception on injection if method is required", ^
    {
        ^
        {
            [funtime injectProtocol:@protocol(OCFSimpleProtocol) instanceMethod:@selector(requiredMethod)
                      implementaion:^{}];
        } should raise_exception;

    });

    it(@"should inject protocol instance method", ^
    {
        [funtime injectProtocol:@protocol(OCFSimpleProtocol) instanceMethod:@selector(instanceMethod)
                  implementaion:^
        {
            return YES;
        }];
        [mock instanceMethod] should equal(YES);
    });

    it(@"should inject protocol class method", ^
    {
        [funtime injectProtocol:@protocol(OCFSimpleProtocol) classMethod:@selector(staticMethod)
                  implementaion:^
        {
            return YES;
        }];
        [OCFProtocolMock staticMethod] should equal(YES);
    });

    it (@"should skip injection if instance method is already implemented", ^
    {
        [funtime injectProtocol:@protocol(OCFSimpleProtocol) instanceMethod:@selector(implementedMethod)
                  implementaion:^
        {
            return YES;
        }];
        [mock implementedMethod] should equal(NO);
    });

    it (@"should override instance method if force injection", ^
    {
        [funtime forceInjectProtocol:@protocol(OCFSimpleProtocol) instanceMethod:@selector(implementedMethodToOverride)
                       implementaion:^
        {
            return YES;
        }];
        [mock implementedMethodToOverride] should equal(YES);
    });

    it (@"should skip injection if class method is already implemented", ^
    {
        [funtime injectProtocol:@protocol(OCFSimpleProtocol) classMethod:@selector(implementedMethod)
                  implementaion:^
        {
            return YES;
        }];
        [OCFProtocolMock implementedMethod] should equal(NO);
    });

    it (@"should override instance method if force injection", ^
    {
        [funtime forceInjectProtocol:@protocol(OCFSimpleProtocol) classMethod:@selector(implementedMethodToOverride)
                       implementaion:^
        {
            return YES;
        }];
        [OCFProtocolMock implementedMethodToOverride] should equal(YES);
    });

    it(@"should throw exception on injection if protocol is nil", ^
    {
        ^
        {
            [funtime injectProtocol:nil instanceMethod:@selector(simpleMethodOne) implementaion:^{}];
        } should raise_exception;
    });

    it(@"should throw exception on injection if method is nil on injection", ^
    {
        ^
        {
            [funtime injectProtocol:@protocol(OCFSimpleProtocol) instanceMethod:nil implementaion:^{}];
        } should raise_exception;
    });

    it(@"should throw exception on injection if implementation is nil", ^
    {
        ^
        {
            [funtime injectProtocol:@protocol(OCFSimpleProtocol) instanceMethod:@selector(simpleMethodOne)
                      implementaion:nil];
        } should raise_exception;
    });

});

SPEC_END