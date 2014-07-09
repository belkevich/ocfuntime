//
//  OCFPropertyMock.m
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 12/5/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import "OCFPropertyMock.h"

@implementation OCFPropertyMock

@dynamic objectStrongProperty, objectWeakProperty, objectCopyProperty, blockProperty,
booleanProperty, integerProperty, floatProperty, doubleProperty, structProperty, pIntegerProperty,
pFloatProperty;

@synthesize synthesizedProperty;
@dynamic implementedProperty;

- (id)implementedProperty
{
    return nil;
}

- (void)setImplementedProperty:(id)implementedProperty
{
    // nothing
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    _isMethodSignatureCalled = YES;
    NSString *selectorName = NSStringFromSelector(aSelector);
    if ([selectorName isEqualToString:kTestSelectorName])
    {
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    return nil;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    _isForwardInvocationCalled = YES;
    NSString *selectorName = NSStringFromSelector(anInvocation.selector);
    if ([selectorName isEqualToString:kTestSelectorName])
    {
        // do nothing
    }
    else
    {
        [super forwardInvocation:anInvocation];
    }
}

@end
