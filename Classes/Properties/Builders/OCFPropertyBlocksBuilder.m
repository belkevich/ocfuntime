//
//  OCFPropertyBlocksBuilder.m
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 7/2/14.
//  Copyright (c) 2014 okolodev. All rights reserved.
//

#import <objc/message.h>
#import "OCFPropertyBlocksBuilder.h"
#import "OCFPropertyAttributes.h"
#import "OCFInvocationParser.h"
#import "NSObject+OCFuntimeProperties.h"

@implementation OCFPropertyBlocksBuilder

#pragma mark - public

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

+ (id)swizzledValueForKeyPathBlockWithDictionary:(NSDictionary *)dictionary
{
    __weak NSDictionary *methodsSignatures = dictionary;
    return ^(id instance, NSString *keyPath)
    {
        if (methodsSignatures[keyPath])
        {
            SEL methodSelector = NSSelectorFromString(keyPath);
            if (methodSelector)
            {
                return ((id(*)(id, SEL))objc_msgSend)(instance, methodSelector);
            }
        }
        // run original method
        return [instance OCFValueForKeyPath:keyPath];
    };
}

+ (id)swizzledSetValueForKeyPathBlockWithDictionary:(NSDictionary *)dictionary
{
    __weak NSDictionary *methodsSignatures = dictionary;
    return ^(id instance, id value, NSString *keyPath)
    {
        NSString *firstLetter = [keyPath substringToIndex:1].capitalizedString;
        NSString *rest = [keyPath substringFromIndex:1];
        NSString *methodName = [NSString stringWithFormat:@"set%@%@:", firstLetter, rest];
        if (methodsSignatures[methodName])
        {
            SEL methodSelector = NSSelectorFromString(methodName);
            if (methodSelector)
            {
                ((void(*)(id, SEL, id))objc_msgSend)(instance, methodSelector, value);
                return;
            }
        }
        // run original method
        [instance OCFSetValue:value forKeyPath:keyPath];
    };
}


+ (id)injectedMethodSignatureBlockWithDictionary:(NSDictionary *)dictionary
{
    __weak NSDictionary *methodsSignatures = dictionary;
    return ^(id instance, SEL methodSelector)
    {
        NSString *methodName = NSStringFromSelector(methodSelector);
        NSMethodSignature *signature = methodsSignatures[methodName];
        // call superclass method
        if (!signature)
        {
            struct objc_super superInstance = [self superInstanceForInstance:instance];
            signature = ((id(*)(struct objc_super *, SEL, SEL))objc_msgSendSuper)(&superInstance,
            @selector(methodSignatureForSelector:),
            methodSelector);
        }
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
        // call superclass method
        else
        {
            struct objc_super superInstance = [self superInstanceForInstance:instance];
            ((void(*)(struct objc_super *, SEL, id))objc_msgSendSuper)(&superInstance,
                                                                       @selector(forwardInvocation:),
                                                                       invocation);
        }
    };
}

+ (id)injectedValueForKeyPathBlockWithDictionary:(NSDictionary *)dictionary
{
    __weak NSDictionary *methodsSignatures = dictionary;
    return ^(id instance, NSString *keyPath)
    {
        if (methodsSignatures[keyPath])
        {
            SEL methodSelector = NSSelectorFromString(keyPath);
            if (methodSelector)
            {
                return ((id(*)(id, SEL))objc_msgSend)(instance, methodSelector);
            }
        }
        // run super class method
        struct objc_super superInstance = [self superInstanceForInstance:instance];
        return ((id(*)(struct objc_super *, SEL, id))objc_msgSendSuper)(&superInstance,
                                                                        @selector(valueForKeyPath:),
                                                                        keyPath);
    };
}

+ (id)injectedSetValueForKeyPathBlockWithDictionary:(NSDictionary *)dictionary
{
    __weak NSDictionary *methodsSignatures = dictionary;
    return ^(id instance, id value, NSString *keyPath)
    {
        NSString *firstLetter = [keyPath substringToIndex:1].capitalizedString;
        NSString *rest = [keyPath substringFromIndex:1];
        NSString *methodName = [NSString stringWithFormat:@"set%@%@:", firstLetter, rest];
        if (methodsSignatures[methodName])
        {
            SEL methodSelector = NSSelectorFromString(methodName);
            if (methodSelector)
            {
                ((void(*)(id, SEL, id))objc_msgSend)(instance, methodSelector, value);
                return;
            }
        }
        // run super class method
        struct objc_super superInstance = [self superInstanceForInstance:instance];
        ((void(*)(struct objc_super *, SEL, id, id))objc_msgSendSuper)(&superInstance,
                                                                       @selector(setValue:forKeyPath:),
                                                                       value, keyPath);
    };
}

#pragma mark - private

+ (struct objc_super)superInstanceForInstance:(id)instance
{
    struct objc_super superInstance;
    superInstance.super_class = class_getSuperclass([instance class]);
    superInstance.receiver = instance;
    return superInstance;
}

@end
