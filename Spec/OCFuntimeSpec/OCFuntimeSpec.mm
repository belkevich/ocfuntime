//
//  OCFuntimeSpec.mm
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 4/22/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import "OCFuntime.h"
#import "OCFMock.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(OCFuntimeSpec)

describe(@"OCFuntime", ^{
    __block OCFuntime *funtime = nil;
    __block OCFMock *mock = nil;

    beforeEach(^
               {
                   mock = [[OCFMock alloc] init];
                   funtime = [[OCFuntime alloc] init];
                   [funtime changeClass:[OCFMock class] instanceMethod:@selector(funInstanceMethod)
                         implementation:^
                         {
                             NSLog(@"Changed FUN instance method!");
                             return NO;
                         }];
                   [funtime changeClass:[OCFMock class] classMethod:@selector(funClassMethod)
                         implementation:^
                         {
                             NSLog(@"Changed FUN class method!");
                             return NO;
                         }];
               });

    afterEach(^
              {
                  [mock release];
                  [funtime revertAll];
                  [funtime release];
              });

    it(@"should call changed instance method if it changed", ^
    {
        [mock funInstanceMethod] should equal(NO);
    });

    it(@"should call changed class method if it changed", ^
    {
        [OCFMock funClassMethod] should equal(NO);
    });

    it(@"should call default instance method if method reverted", ^
    {
        [funtime revertClass:[OCFMock class] method:@selector(funInstanceMethod)];
        [mock funInstanceMethod] should equal(YES);
    });

    it(@"should call default class method if method reverted", ^
    {
        [funtime revertClass:[OCFMock class] method:@selector(funClassMethod)];
        [OCFMock funClassMethod] should equal(YES);
    });

    it(@"should call default methods if class reverted", ^
    {
        [funtime revertClass:[OCFMock class]];
        [mock funInstanceMethod] should equal(YES);
        [OCFMock funClassMethod] should equal(YES);
    });

    it(@"should call default methods if all reverted", ^
    {
        [funtime revertAll];
        [mock funInstanceMethod] should equal(YES);
        [OCFMock funClassMethod] should equal(YES);
    });
});

SPEC_END

