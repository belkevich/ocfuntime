//
//  OCFuntimeMethodsSpec.mm
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 4/22/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import "OCFuntime.h"
#import "OCFMock.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(OCFuntimeMethodsSpec)

__block OCFuntime *funtime;
__block OCFMock *mock;

describe(@"OCFuntime with changed method", ^{

    beforeEach(^
               {
                   mock = [[OCFMock alloc] init];
                   funtime = [[OCFuntime alloc] init];
                   [funtime changeClass:[OCFMock class] instanceMethod:@selector(funInstanceMethod)
                         implementation:^
                         {
                             NSLog(@"Changed FUN instance method!");
                             return 1;
                         }];
                   [funtime changeClass:[OCFMock class] classMethod:@selector(funClassMethod)
                         implementation:^
                         {
                             NSLog(@"Changed FUN class method!");
                             return 1;
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
        [mock funInstanceMethod] should equal(1);
    });

    it(@"should call changed class method if it changed", ^
    {
        [OCFMock funClassMethod] should equal(1);
    });

    it(@"should call default instance method if method reverted", ^
    {
        [funtime revertClass:[OCFMock class] instanceMethod:@selector(funInstanceMethod)];
        [mock funInstanceMethod] should equal(0);
    });

    it(@"should call default class method if method reverted", ^
    {
        [funtime revertClass:[OCFMock class] classMethod:@selector(funClassMethod)];
        [OCFMock funClassMethod] should equal(0);
    });

    it(@"should call default methods if class reverted", ^
    {
        [funtime revertClass:[OCFMock class]];
        [mock funInstanceMethod] should equal(0);
        [OCFMock funClassMethod] should equal(0);
    });

    it(@"should call default methods if all reverted", ^
    {
        [funtime revertAll];
        [mock funInstanceMethod] should equal(0);
        [OCFMock funClassMethod] should equal(0);
    });

    it(@"should call newly changed instance method if it was changed again", ^
    {
        [funtime changeClass:[OCFMock class] instanceMethod:@selector(funInstanceMethod)
              implementation:^
              {
                  NSLog(@"One more time changed FUN instance method");
                  return 2;
              }];
        [mock funInstanceMethod] should equal(2);
    });

    it(@"should call newly changed class method if it was changed again", ^
    {
        [funtime changeClass:[OCFMock class] classMethod:@selector(funClassMethod)
              implementation:^{
                  NSLog(@"One more time changed FUN class method");
                  return 2;
              }];
        [OCFMock funClassMethod] should equal(2);
    });

    it(@"should revert to default instance method, not previous setted method", ^
    {
        [funtime changeClass:[OCFMock class] instanceMethod:@selector(funInstanceMethod)
              implementation:^
              {
                  // still returns NO
                  NSLog(@"One more time changed FUN instance method");
                  return 2;
              }];
        [funtime revertClass:[OCFMock class]];
        [mock funInstanceMethod] should equal(0);
    });

    it(@"should revert to default class method, not previous setted method", ^
    {
        [funtime changeClass:[OCFMock class] classMethod:@selector(funClassMethod)
              implementation:^
              {
                  // still returns NO
                  NSLog(@"One more time changed FUN class method");
                  return 2;
              }];
        [funtime revertClass:[OCFMock class]];
        [OCFMock funClassMethod] should equal(0);
    });
});

describe(@"OCFuntime methods changing memory management", ^
{
    it(@"should call default instance method if 'funtime' instance deallocated", ^
    {
        funtime = [[OCFuntime alloc] init];
        [funtime changeClass:[OCFMock class] instanceMethod:@selector(funInstanceMethod)
              implementation:^
              {
                  return 1;
              }];
        mock = [[OCFMock alloc] init];
        [mock funInstanceMethod] should equal(1);
        [funtime release];
        [mock funInstanceMethod] should equal(0);
        [mock release];
    });

    it(@"should call default class method if 'funtime' instance deallocated", ^
    {
        funtime = [[OCFuntime alloc] init];
        [funtime changeClass:[OCFMock class] classMethod:@selector(funClassMethod)
              implementation:^
              {
                  return 1;
              }];
        [OCFMock funClassMethod] should equal(1);
        [funtime release];
        [OCFMock funClassMethod] should equal(0);
    });
});

describe(@"OCFuntime method changing protection", ^{

    beforeEach(^
               {
                   funtime = [[OCFuntime alloc] init];
               });

    afterEach(^
              {
                  [funtime release];
              });

    it(@"should throw exception if instance method doesn't exist", ^
    {
        ^
        {
            [funtime changeClass:[OCFMock class] instanceMethod:@selector(unexistedMethod)
                  implementation:^
                  {
                      return 2;
                  }];
        } should raise_exception([NSException class]);
    });

    it(@"should throw exception if class method doesn't exist", ^
    {
        ^
        {
            [funtime changeClass:[OCFMock class] classMethod:@selector(unexistedMethod)
                  implementation:^
                  {
                      return 2;
                  }];
        } should raise_exception([NSException class]);
    });

    it(@"should not throw exception if nil implementation provided as instance method", ^
    {
        ^
        {
            [funtime changeClass:[OCFMock class] instanceMethod:@selector(funInstanceMethod)
                  implementation:nil];
        } should_not raise_exception;
    });

    it(@"should not throw exception if nil implementation provided as class method", ^
    {
        ^
        {
            [funtime changeClass:[OCFMock class] classMethod:@selector(funClassMethod)
                  implementation:nil];
        } should_not raise_exception;
    });
});

SPEC_END

