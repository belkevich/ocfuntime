//
//  NSObject+OCFuntimeSpec.mm
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 12/2/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import "NSObject+OCFuntime.h"
#import "OCFMock.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(NSObject_OCFuntimeSpec)

__block OCFMock *mock;

describe(@"Object with changed method", ^{
    
    beforeEach(^
               {
                   mock = [[OCFMock alloc] init];
                   [mock changeMethod:@selector(funInstanceMethod) implementation:^
                   {
                       NSLog(@"Changed FUN instance method!");
                       return 1;
                   }];
                   [OCFMock changeMethod:@selector(funClassMethod) implementation:^
                   {
                       NSLog(@"Changed FUN class method!");
                       return 1;
                   }];
               });
    
    afterEach(^
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
        [OCFMock funClassMethod] should equal(1);
    });

    it(@"should call default instance method if method reverted", ^
    {
        [mock revertMethod:@selector(funInstanceMethod)];
        [mock funInstanceMethod] should equal(0);
    });

    it(@"should call default class method if method reverted", ^
    {
        [OCFMock revertMethod:@selector(funClassMethod)];
        [OCFMock funClassMethod] should equal(0);
    });

    it(@"should call default methods if instance reverted", ^
    {
        [mock revertMethods];
        [mock funInstanceMethod] should equal(0);
        [OCFMock funClassMethod] should equal(0);
    });

    it(@"should call default methods if class reverted", ^
    {
        [OCFMock revertMethods];
        [mock funInstanceMethod] should equal(0);
        [OCFMock funClassMethod] should equal(0);
    });
});

SPEC_END
