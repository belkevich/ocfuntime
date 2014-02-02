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
        NSObject *object = [[NSObject alloc] init];
        mock.objectStrongProperty = object;
        mock.objectStrongProperty should equal(object);
        [object release];
    });

    it(@"should retain value of synthesized strong property ", ^
    {
        [funtime synthesizeProperty:@"objectStrongProperty" ofClass:OCFPropertyMock.class];
        NSObject *object = [[NSObject alloc] init];
        mock.objectStrongProperty = object;
        mock.objectStrongProperty should equal(object);
        mock.objectStrongProperty should equal(object);
        object.retainCount should equal(2);
        [object release];
    });

    it(@"should release value of synthesized strong property", ^
    {
        [funtime synthesizeProperty:@"objectStrongProperty" ofClass:OCFPropertyMock.class];
        NSObject *object = [[NSObject alloc] init];
        mock.objectStrongProperty = object;
        mock.objectStrongProperty = object;
        mock.objectStrongProperty = nil;
        mock.objectStrongProperty should be_nil;
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

    it(@"should return nil on synthesized block property read if it not set", ^
    {
        [funtime synthesizeProperty:@"blockProperty" ofClass:OCFPropertyMock.class];
        id block = mock.blockProperty;
        block should be_nil;
    });

    it(@"should be able to set synthesized block property", ^
    {
        [funtime synthesizeProperty:@"blockProperty" ofClass:OCFPropertyMock.class];
        __block BOOL someValue = NO;
        mock.blockProperty = ^
        {
            someValue = YES;
        };
        id block = mock.blockProperty;
        block should_not be_nil;
        ^{mock.blockProperty();} should_not raise_exception;
        someValue should equal(YES);
    });

    it(@"should return NO on synthesized boolean property read if it not set", ^
    {
        [funtime synthesizeProperty:@"booleanProperty" ofClass:OCFPropertyMock.class];
        mock.booleanProperty should equal(0);
    });

    it(@"should be able to set synthesized boolean property", ^
    {
        [funtime synthesizeProperty:@"booleanProperty" ofClass:OCFPropertyMock.class];
        mock.booleanProperty = YES;
        mock.booleanProperty should equal(YES);
    });

    it(@"should return 0 on synthesized integer property read if it not set", ^
    {
        [funtime synthesizeProperty:@"integerProperty" ofClass:OCFPropertyMock.class];
        mock.integerProperty should equal(0);
    });

    it(@"should be able to set synthesized integer property", ^
    {
        [funtime synthesizeProperty:@"integerProperty" ofClass:OCFPropertyMock.class];
        mock.integerProperty = 5;
        mock.integerProperty should equal(5);
    });

    it(@"should return 0.0 on synthesized float property read if it not set", ^
    {
        [funtime synthesizeProperty:@"floatProperty" ofClass:OCFPropertyMock.class];
        mock.floatProperty should equal(0.f);
    });

    it(@"should be able to set synthesized float property", ^
    {
        [funtime synthesizeProperty:@"floatProperty" ofClass:OCFPropertyMock.class];
        mock.floatProperty = 5.5;
        mock.floatProperty should equal(5.5);
    });

    it(@"should return 0.0 on synthesized double property read if it not set", ^
    {
        [funtime synthesizeProperty:@"doubleProperty" ofClass:OCFPropertyMock.class];
        mock.doubleProperty should equal(0.f);
    });

    it(@"should be able to set synthesized double property", ^
    {
        [funtime synthesizeProperty:@"doubleProperty" ofClass:OCFPropertyMock.class];
        mock.doubleProperty = 5.00000005;
        mock.doubleProperty should equal(5.00000005);
    });

    it(@"should return empty struct on synthesized struct property read if it not set", ^
    {
        [funtime synthesizeProperty:@"structProperty" ofClass:OCFPropertyMock.class];
        mock.structProperty.x should equal(0);
        mock.structProperty.y should equal(0);
    });

    it(@"should be able to set synthesized struct property", ^
    {
        [funtime synthesizeProperty:@"structProperty" ofClass:OCFPropertyMock.class];
        OCFStructMock example = {1, 2};
        mock.structProperty = example;
        mock.structProperty.x should equal(1);
        mock.structProperty.y should equal(2);
    });

    it(@"should return NULL on synthesized integer pointer property read if it not set", ^
    {
        [funtime synthesizeProperty:@"pIntegerProperty" ofClass:OCFPropertyMock.class];
        mock.pIntegerProperty should be_nil;
    });

    it(@"should be able to set synthesized integer pointer property", ^
    {
        [funtime synthesizeProperty:@"pIntegerProperty" ofClass:OCFPropertyMock.class];
        NSInteger integer = 5;
        mock.pIntegerProperty = &integer;
        mock.pIntegerProperty should equal(&integer);
    });

    it(@"should return NULL on synthesized float pointer property read if it not set", ^
    {
        [funtime synthesizeProperty:@"pFloatProperty" ofClass:OCFPropertyMock.class];
        mock.pFloatProperty should be_nil;
    });

    it(@"should be able to set synthesized float pointer property", ^
    {
        [funtime synthesizeProperty:@"pFloatProperty" ofClass:OCFPropertyMock.class];
        CGFloat floatValue = 5.5;
        mock.pFloatProperty = &floatValue;
        mock.pFloatProperty should equal(&floatValue);
    });
});

SPEC_END