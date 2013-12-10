//
//  OCFuntimePropertySpec.mm
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 12/5/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import "OCFuntime.h"
#import "OCFPropertyMock.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(OCFuntimePropertySpec)

__block OCFuntime *funtime;
__block OCFPropertyMock *mock;

describe(@"OCFuntime synthesize property", ^
{

    beforeEach(^
               {
                   mock = [[OCFPropertyMock alloc] init];
                   funtime = [[OCFuntime alloc] init];
               });

    afterEach(^
              {
                  [mock release];
                  [funtime release];
              });

    it(@"should throw exception on property read if property doesn't synthesized", ^
    {
        ^
        {
            id someObject = mock.objectStrongProperty;
            NSLog(@"%@", someObject);
        } should raise_exception;
    });

    it(@"should not throw exception on property read if property synthesized", ^
    {
        [funtime synthesizeProperty:@"objectStrongProperty" ofClass:OCFPropertyMock.class];
        ^
        {
            id someObject = mock.objectStrongProperty;
            NSLog(@"%@", someObject);
        } should_not raise_exception;
    });

    it(@"should not throw exception on property write if property synthesized", ^
    {
        [funtime synthesizeProperty:@"objectStrongProperty" ofClass:OCFPropertyMock.class];
        ^
        {
            mock.objectStrongProperty = @"string";
        } should_not raise_exception;
    });

    it(@"should be able to set synthesized property", ^
    {
        [funtime synthesizeProperty:@"objectStrongProperty" ofClass:OCFPropertyMock.class];
        NSObject *object = [[[NSObject alloc] init] autorelease];
        mock.objectStrongProperty = object;
        mock.objectStrongProperty should equal(object);
    });

    it(@"should retain value of strong synthesized property ", ^
    {
        [funtime synthesizeProperty:@"objectStrongProperty" ofClass:OCFPropertyMock.class];
        NSObject *object = [[[NSObject alloc] init] autorelease];
        mock.objectStrongProperty = object;
        object.retainCount should equal(2);
    });

    it(@"should release value of strong synthesized property", ^
    {
        [funtime synthesizeProperty:@"objectStrongProperty" ofClass:OCFPropertyMock.class];
        NSObject *object = [[[NSObject alloc] init] autorelease];
        mock.objectStrongProperty = object;
        mock.objectStrongProperty = nil;
        object.retainCount should equal(1);
    });
});

SPEC_END