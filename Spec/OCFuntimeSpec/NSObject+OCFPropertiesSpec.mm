//
//  NSObject+OCFPropertiesSpec.mm
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 7/10/14.
//  Copyright (c) 2014 okolodev. All rights reserved.
//

#import "NSObject+OCFProperties.h"
#import "OCFPropertyMock.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(NSObject_OCFPropertiesSpec)

__block OCFPropertyMock *mock;

describe(@"Object with injected property", ^
{
    beforeEach((id)^
    {
        mock = [[OCFPropertyMock alloc] init];
        [mock injectProperty:@"objectStrongProperty"];
    });

    afterEach((id)^
    {
        [mock removeProperties];
        [mock release];
    });

    it(@"should read property", ^
    {
        ^
        {
            id value = mock.objectStrongProperty;
            NSLog(@"%@", value);
        } should_not raise_exception;
    });

    it(@"should write property", ^
    {
        NSObject *value = [[[NSObject alloc] init] autorelease];
        mock.objectStrongProperty = value;
        mock.objectStrongProperty should equal(value);
    });

    it(@"should remove injected property", ^
    {
        [mock removeProperty:@"objectStrongProperty"];
        ^
        {
            id value = mock.objectStrongProperty;
            NSLog(@"%@", value);
        } should raise_exception;
    });

    it(@"should remove all injected properties", ^
    {
        [mock removeProperties];
        ^
        {
            id value = mock.objectStrongProperty;
            NSLog(@"%@", value);
        } should raise_exception;
    });
});

SPEC_END
