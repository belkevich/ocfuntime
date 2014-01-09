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

    it(@"should return nil on synthesized strong property read if it not set", ^
    {
        [funtime synthesizeProperty:@"objectStrongProperty" ofClass:OCFPropertyMock.class];
        mock.objectStrongProperty should be_nil;
    });

    it(@"should be able to set synthesized strong property", ^
    {
        [funtime synthesizeProperty:@"objectStrongProperty" ofClass:OCFPropertyMock.class];
        NSObject *object = [[[NSObject alloc] init] autorelease];
        mock.objectStrongProperty = object;
        mock.objectStrongProperty should equal(object);
    });

    it(@"should retain value of synthesized strong property ", ^
    {
        [funtime synthesizeProperty:@"objectStrongProperty" ofClass:OCFPropertyMock.class];
        NSObject *object = [[NSObject alloc] init];
        mock.objectStrongProperty = object;
        object.retainCount should equal(2);
        [object release];
    });

    it(@"should release value of synthesized strong property", ^
    {
        [funtime synthesizeProperty:@"objectStrongProperty" ofClass:OCFPropertyMock.class];
        NSObject *object = [[NSObject alloc] init];
        mock.objectStrongProperty = object;
        mock.objectStrongProperty = nil;
        object.retainCount should equal(1);
        [object release];
    });

    it(@"should return nil on synthesized weak property read if it not set", ^
    {
        [funtime synthesizeProperty:@"objectWeakProperty" ofClass:OCFPropertyMock.class];
        mock.objectWeakProperty should be_nil;
    });

    it(@"should be able to set synthesized weak property", ^
    {
        [funtime synthesizeProperty:@"objectWeakProperty" ofClass:OCFPropertyMock.class];
        NSObject *object = [[[NSObject alloc] init] autorelease];
        mock.objectWeakProperty = object;
        mock.objectWeakProperty should equal(object);
    });

    it(@"should not retain value of synthesized weak property ", ^
    {
        [funtime synthesizeProperty:@"objectWeakProperty" ofClass:OCFPropertyMock.class];
        NSObject *object = [[NSObject alloc] init];
        mock.objectWeakProperty = object;
        object.retainCount should equal(1);
        [object release];
    });

    it(@"should be nil if value of synthesized weak property released", ^
    {
        [funtime synthesizeProperty:@"objectWeakProperty" ofClass:OCFPropertyMock.class];
        NSObject *object = [[NSObject alloc] init];
        mock.objectWeakProperty = object;
        [object release];
        mock.objectWeakProperty should be_nil;
    });

    it(@"should return nil on synthesized copy property read if it not set", ^
    {
        [funtime synthesizeProperty:@"objectCopyProperty" ofClass:OCFPropertyMock.class];
        mock.objectCopyProperty should be_nil;
    });

    it(@"should be able to set synthesized copy property", ^
    {
        [funtime synthesizeProperty:@"objectCopyProperty" ofClass:OCFPropertyMock.class];
        NSObject *object = [[[NSString alloc] initWithFormat:@"string"] autorelease];
        mock.objectCopyProperty = object;
        mock.objectCopyProperty should equal(object);
    });

    it(@"should not retain value of synthesized copy property ", ^
    {
        [funtime synthesizeProperty:@"objectCopyProperty" ofClass:OCFPropertyMock.class];
        NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:@(1), @(2), nil];
        mock.objectCopyProperty = array;
        array.retainCount should equal(1);
        [array release];
    });

    it(@"should copy value of synthesized copy property", ^
    {
        [funtime synthesizeProperty:@"objectCopyProperty" ofClass:OCFPropertyMock.class];
        NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:@(1), @(2), nil];
        mock.objectCopyProperty = array;
        // --- workaround to prevent compiler optimizations ---
        [array removeLastObject];
        // --- workaround ends
        [mock.objectCopyProperty isEqual:array] should equal(NO);
        [mock.objectCopyProperty firstObject] should equal(@(1));
        [mock.objectCopyProperty lastObject] should equal(@(2));
        [array release];
    });
});

SPEC_END