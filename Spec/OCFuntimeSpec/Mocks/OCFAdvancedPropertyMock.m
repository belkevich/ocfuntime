//
//  OCFAdvancedPropertyMock
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 13.06.16.
//  Copyright © 2016 okolodev. All rights reserved.
//

#import "OCFAdvancedPropertyMock.h"

@implementation OCFAdvancedPropertyMock

@dynamic someProperty;

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    _isMethodSignatureCalled = YES;
    NSString *selectorName = NSStringFromSelector(aSelector);
    if ([selectorName isEqualToString:kTestSelectorName])
    {
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    return [super methodSignatureForSelector:aSelector];
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