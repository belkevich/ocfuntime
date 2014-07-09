//
//  NSObject+OCFuntimeSpec.mm
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 12/2/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import "NSObject+OCFuntime.h"
#import "OCFMethodMock.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(NSObject_OCFuntimeSpec)

__block OCFMethodMock *mock;

describe(@"Object with changed method", ^
{

    beforeEach((id)^
    {
        mock = [[OCFMethodMock alloc] init];
        [mock changeMethod:@selector(funInstanceMethod) implementation:^
        {
            NSLog(@"Changed FUN instance method!");
            return 1;
        }];
        [OCFMethodMock changeMethod:@selector(funClassMethod) implementation:^
        {
            NSLog(@"Changed FUN class method!");
            return 1;
        }];
    });

    afterEach((id)^
    {
        [mock revertMethods];
        [mock release];
    });

    it(@"should call changed instance method if it changed", ^
    {
        [mock funInstanceMethod] should equal(1);
    });

    it(@"should call changed class method if it changed", ^
    {
        [OCFMethodMock funClassMethod] should equal(1);
    });

    it(@"should call default instance method if method reverted", ^
    {
        [mock revertMethod:@selector(funInstanceMethod)];
        [mock funInstanceMethod] should equal(0);
    });

    it(@"should call default class method if method reverted", ^
    {
        [OCFMethodMock revertMethod:@selector(funClassMethod)];
        [OCFMethodMock funClassMethod] should equal(0);
    });

    it(@"should call default methods if instance reverted", ^
    {
        [mock revertMethods];
        [mock funInstanceMethod] should equal(0);
        [OCFMethodMock funClassMethod] should equal(0);
    });

    it(@"should call default methods if class reverted", ^
    {
        [OCFMethodMock revertMethods];
        [mock funInstanceMethod] should equal(0);
        [OCFMethodMock funClassMethod] should equal(0);
    });
});

SPEC_END
