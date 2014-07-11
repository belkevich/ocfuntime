//
//  OCFuntimePropertySpec.mm
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 12/5/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import "OCFuntime+Properties.h"
#import "OCFPropertyMock.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(OCFuntimePropertySpec)


describe(@"OCFuntime inject property", ^
{
    __block OCFuntime *funtime = nil;
    __block OCFPropertyMock *mock = nil;

    beforeEach((id)^
    {
        mock = [[OCFPropertyMock alloc] init];
        funtime = [[OCFuntime alloc] init];
    });

    afterEach((id)^
    {
        [mock release];
        [funtime release];
    });

    it(@"should throw exception on property read if property doesn't injected", ^
    {
        ^
        {
            id someObject = mock.objectStrongProperty;
            NSLog(@"%@", someObject);
        }should raise_exception;
    });

    it(@"should throw exception on property injection if property synthesized", ^
    {
        ^
        {
            [funtime injectClass:OCFPropertyMock.class property:@"synthesizedProperty"];
        } should raise_exception;
    });

    it(@"should throw exception on property injection if property already implemented", ^
    {
        ^
        {
            [funtime injectClass:OCFPropertyMock.class property:@"implementedProperty"];
        } should raise_exception;
    });

    it(@"should not throw exception on property read if property injected", ^
    {
        [funtime injectClass:OCFPropertyMock.class property:@"objectStrongProperty"];
        ^
        {
            id someObject = mock.objectStrongProperty;
            NSLog(@"%@", someObject);
        } should_not raise_exception;
    });

    it(@"should not throw exception on property write if property injected", ^
    {
        [funtime injectClass:OCFPropertyMock.class property:@"objectStrongProperty"];
        ^
        {
            mock.objectStrongProperty = @"string";
        } should_not raise_exception;
    });

    it(@"should return nil on injected strong property read if it not set", ^
    {
        [funtime injectClass:OCFPropertyMock.class property:@"objectStrongProperty"];
        mock.objectStrongProperty should be_nil;
    });

    it(@"should be able to set injected strong property", ^
    {
        [funtime injectClass:OCFPropertyMock.class property:@"objectStrongProperty"];
        NSObject *object = [[NSObject alloc] init];
        mock.objectStrongProperty = object;
        mock.objectStrongProperty should equal(object);
        [object release];
    });

    it(@"should retain value of injected strong property ", ^
    {
        [funtime injectClass:OCFPropertyMock.class property:@"objectStrongProperty"];
        NSObject *object = [[NSObject alloc] init];
        mock.objectStrongProperty = object;
        mock.objectStrongProperty should equal(object);
        mock.objectStrongProperty should equal(object);
        object.retainCount should equal(2);
        [object release];
    });

    it(@"should release value of injected strong property", ^
    {
        [funtime injectClass:OCFPropertyMock.class property:@"objectStrongProperty"];
        NSObject *object = [[NSObject alloc] init];
        mock.objectStrongProperty = object;
        mock.objectStrongProperty = object;
        mock.objectStrongProperty = nil;
        mock.objectStrongProperty should be_nil;
        object.retainCount should equal(1);
        [object release];
    });

    it(@"should return nil on injected weak property read if it not set", ^
    {
        [funtime injectClass:OCFPropertyMock.class property:@"objectWeakProperty"];
        mock.objectWeakProperty should be_nil;
    });

    it(@"should be able to set injected weak property", ^
    {
        [funtime injectClass:OCFPropertyMock.class property:@"objectWeakProperty"];
        NSObject *object = [[[NSObject alloc] init] autorelease];
        mock.objectWeakProperty = object;
        mock.objectWeakProperty should equal(object);
    });

    it(@"should not retain value of injected weak property ", ^
    {
        [funtime injectClass:OCFPropertyMock.class property:@"objectWeakProperty"];;
        NSObject *object = [[NSObject alloc] init];
        mock.objectWeakProperty = object;
        object.retainCount should equal(1);
        [object release];
    });

    it(@"should be nil if value of injected weak property released", ^
    {
        [funtime injectClass:OCFPropertyMock.class property:@"objectWeakProperty"];
        NSObject *object = [[NSObject alloc] init];
        mock.objectWeakProperty = object;
        [object release];
        mock.objectWeakProperty should be_nil;
    });

    it(@"should return nil on injected copy property read if it not set", ^
    {
        [funtime injectClass:OCFPropertyMock.class property:@"objectCopyProperty"];
        mock.objectCopyProperty should be_nil;
    });

    it(@"should be able to set injected copy property", ^
    {
        [funtime injectClass:OCFPropertyMock.class property:@"objectCopyProperty"];
        NSObject *object = [[[NSString alloc] initWithFormat:@"string"] autorelease];
        mock.objectCopyProperty = object;
        mock.objectCopyProperty should equal(object);
    });

    it(@"should not retain value of injected copy property ", ^
    {
        [funtime injectClass:OCFPropertyMock.class property:@"objectCopyProperty"];
        NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:@(1), @(2), nil];
        mock.objectCopyProperty = array;
        array.retainCount should equal(1);
        [array release];
    });

    it(@"should copy value of injected copy property", ^
    {
        [funtime injectClass:OCFPropertyMock.class property:@"objectCopyProperty"];
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

    it(@"should return nil on injected block property read if it not set", ^
    {
        [funtime injectClass:OCFPropertyMock.class property:@"blockProperty"];
        id block = mock.blockProperty;
        block should be_nil;
    });

    it(@"should be able to set injected block property", ^
    {
        [funtime injectClass:OCFPropertyMock.class property:@"blockProperty"];
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

    it(@"should return NO on injected boolean property read if it not set", ^
    {
        [funtime injectClass:OCFPropertyMock.class property:@"booleanProperty"];
        mock.booleanProperty should equal(0);
    });

    it(@"should be able to set injected boolean property", ^
    {
        [funtime injectClass:OCFPropertyMock.class property:@"booleanProperty"];
        mock.booleanProperty = YES;
        mock.booleanProperty should equal(YES);
    });

    it(@"should return 0 on injected integer property read if it not set", ^
    {
        [funtime injectClass:OCFPropertyMock.class property:@"integerProperty"];
        mock.integerProperty should equal(0);
    });

    it(@"should be able to set injected integer property", ^
    {
        [funtime injectClass:OCFPropertyMock.class property:@"integerProperty"];
        mock.integerProperty = 5;
        mock.integerProperty should equal(5);
    });

    it(@"should return 0.0 on injected float property read if it not set", ^
    {
        [funtime injectClass:OCFPropertyMock.class property:@"floatProperty"];
        mock.floatProperty should equal(0.f);
    });

    it(@"should be able to set injected float property", ^
    {
        [funtime injectClass:OCFPropertyMock.class property:@"floatProperty"];
        mock.floatProperty = 5.5;
        mock.floatProperty should equal(5.5);
    });

    it(@"should return 0.0 on injected double property read if it not set", ^
    {
        [funtime injectClass:OCFPropertyMock.class property:@"doubleProperty"];
        mock.doubleProperty should equal(0.f);
    });

    it(@"should be able to set injected double property", ^
    {
        [funtime injectClass:OCFPropertyMock.class property:@"doubleProperty"];
        mock.doubleProperty = 5.00000005;
        mock.doubleProperty should equal(5.00000005);
    });

    it(@"should return empty struct on injected struct property read if it not set", ^
    {
        [funtime injectClass:OCFPropertyMock.class property:@"structProperty"];
        mock.structProperty.x should equal(0);
        mock.structProperty.y should equal(0);
    });

    it(@"should be able to set injected struct property", ^
    {
        [funtime injectClass:OCFPropertyMock.class property:@"structProperty"];
        OCFStructMock example = {1, 2};
        mock.structProperty = example;
        mock.structProperty.x should equal(1);
        mock.structProperty.y should equal(2);
    });

    it(@"should return NULL on injected integer pointer property read if it not set", ^
    {
        [funtime injectClass:OCFPropertyMock.class property:@"pIntegerProperty"];
        mock.pIntegerProperty should be_nil;
    });

    it(@"should be able to set injected integer pointer property", ^
    {
        [funtime injectClass:OCFPropertyMock.class property:@"pIntegerProperty"];
        NSInteger integer = 5;
        mock.pIntegerProperty = &integer;
        mock.pIntegerProperty should equal(&integer);
    });

    it(@"should return NULL on injected float pointer property read if it not set", ^
    {
        [funtime injectClass:OCFPropertyMock.class property:@"pFloatProperty"];
        mock.pFloatProperty should be_nil;
    });

    it(@"should be able to set injected float pointer property", ^
    {
        [funtime injectClass:OCFPropertyMock.class property:@"pFloatProperty"];
        CGFloat floatValue = 5.5;
        mock.pFloatProperty = &floatValue;
        mock.pFloatProperty should equal(&floatValue);
    });

    it(@"should not break original 'methodSignature' method", ^
    {
        [funtime injectClass:OCFPropertyMock.class property:@"pFloatProperty"];
        [mock methodSignatureForSelector:NSSelectorFromString(@"testSelector")] should_not be_nil;
        mock.isMethodSignatureCalled should equal(YES);
    });

    it(@"should not break original 'forwardInvocation' method", ^
    {
        [funtime injectClass:OCFPropertyMock.class property:@"pFloatProperty"];
        NSMethodSignature *signature = [NSMethodSignature signatureWithObjCTypes:"v@:"];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        ^
        {
            [mock forwardInvocation:invocation];
        } should raise_exception;
        mock.isForwardInvocationCalled should equal(YES);
    });

    it(@"should revert to original 'methodSignature' after dealloc", ^
    {
        SEL testSelector = NSSelectorFromString(kTestSelectorName);
        SEL propertySelector = NSSelectorFromString(@"objectStrongProperty");
        [funtime injectClass:OCFPropertyMock.class property:@"objectStrongProperty"];
        [mock methodSignatureForSelector:propertySelector] should_not be_nil;
        [mock methodSignatureForSelector:testSelector] should_not be_nil;
        [funtime release];
        funtime = nil;
        [mock methodSignatureForSelector:propertySelector] should be_nil;
        [mock methodSignatureForSelector:testSelector] should_not be_nil;
    });
});

SPEC_END