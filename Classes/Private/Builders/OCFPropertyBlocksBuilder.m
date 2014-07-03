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

@implementation OCFPropertyBlocksBuilder

+ (id)methodSignatureBlockWithDictionary:(NSDictionary *)dictionary
{
    __weak NSDictionary *methodsSignatures = dictionary;
    return ^(id instance, SEL methodSelector)
    {
        NSString *methodName = NSStringFromSelector(methodSelector);
        return methodsSignatures[methodName];
    };
}

+ (id)forwardInvocationBlockWithDictionary:(NSDictionary *)dictionary
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
    };
}

@end
