//
//  OCFPropertyBlocksBuilder.m
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 7/2/14.
//  Copyright (c) 2014 okolodev. All rights reserved.
//

#import "OCFPropertyBlocksBuilder.h"
#import "OCFPropertyAttributes.h"
#import "OCFInvocationParser.h"
#import "NSObject+OCFuntimeProperties.h"

@implementation OCFPropertyBlocksBuilder

+ (id)swizzledMethodSignatureBlockWithDictionary:(NSDictionary *)dictionary
{
    __weak NSDictionary *methodsSignatures = dictionary;
    return ^(id instance, SEL methodSelector)
    {
        NSString *methodName = NSStringFromSelector(methodSelector);
        NSMethodSignature *signature = methodsSignatures[methodName];
        if (signature)
        {
            return signature;
        }
        // run original method
        return [instance OCFMethodSignatureForSelector:methodSelector];
    };
}

+ (id)swizzledForwardInvocationBlockWithDictionary:(NSDictionary *)dictionary
{
    __weak NSDictionary *methodsAttributes = dictionary;
    return ^(id instance, NSInvocation *invocation)
    {
        NSString *methodName = NSStringFromSelector(invocation.selector);
        OCFPropertyAttributes *attributes = methodsAttributes[methodName];
        if (attributes)
        {
            [OCFInvocationParser parsePropertyInvocation:invocation onInstance:instance
                                          withAttributes:attributes];
        }
        else
        {
            // run original method
            [instance OCFForwardInvocation:invocation];
        }
    };
}

+ (id)injectedMethodSignatureBlockWithDictionary:(NSDictionary *)dictionary
{
    __weak NSDictionary *methodsSignatures = dictionary;
    return ^(id instance, SEL methodSelector)
    {
        NSString *methodName = NSStringFromSelector(methodSelector);
        NSMethodSignature *signature = methodsSignatures[methodName];
        // TODO: add superclass method call
        return signature;
    };
}

+ (id)injectedForwardInvocationBlockWithDictionary:(NSDictionary *)dictionary
{
    __weak NSDictionary *methodsAttributes = dictionary;
    return ^(id instance, NSInvocation *invocation)
    {
        NSString *methodName = NSStringFromSelector(invocation.selector);
        OCFPropertyAttributes *attributes = methodsAttributes[methodName];
        if (attributes)
        {
            [OCFInvocationParser parsePropertyInvocation:invocation onInstance:instance
                                          withAttributes:attributes];
        }
        // TODO: add superclass method call
    };
}

@end
