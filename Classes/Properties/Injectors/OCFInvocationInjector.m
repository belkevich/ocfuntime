//
//  OCFInvocationInjector 
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 13.06.16.
//  Copyright © 2016 okolodev. All rights reserved.
//

#import <objc/runtime.h>
#import "OCFInvocationInjector.h"
#import "OCFMethodInjector.h"
#import "OCFPropertyBlocksBuilder.h"

@interface OCFInvocationInjector ()
{
    Class _theClass;
    NSDictionary *_signatures;
    NSDictionary *_attributes;
    BOOL _isMethodSignatureMethodSwizzled;
    BOOL _isForwardInvocationMethodSwizzled;
    BOOL _isValueForKeyPathSwizzled;
    BOOL _isSetValueForKeyPathSwizzled;
}
@end

@implementation OCFInvocationInjector

#pragma mark - life cycle

- (instancetype)initWithClass:(Class)aClass
         signaturesDictionary:(NSDictionary *)signatures
         attributesDictionary:(NSDictionary *)attributes
{
    self = [super init];
    if (self)
    {
        _theClass = aClass;
        _signatures = signatures;
        _attributes = attributes;
    }
    return self;
}

#pragma mark - public

- (void)injectMethodSignatureMethod
{
    SEL method = @selector(methodSignatureForSelector:);
    static const char *types = "@@::";
    if ([self isMethodWithSelectorImplemented:method])
    {
        SEL swizzledMethod = @selector(OCFMethodSignatureForSelector:);
        id block = [OCFPropertyBlocksBuilder swizzledMethodSignatureBlockWithDictionary:_signatures];
        [OCFMethodInjector injectClass:_theClass instanceMethod:swizzledMethod types:types block:block];
        [OCFMethodInjector swizzleClass:_theClass instanceMethod:method withMethod:swizzledMethod];
        _isMethodSignatureMethodSwizzled = YES;
    }
    else
    {
        id block = [OCFPropertyBlocksBuilder injectedMethodSignatureBlockWithDictionary:_signatures];
        [OCFMethodInjector injectClass:_theClass instanceMethod:method types:types block:block];
    }
}

- (void)injectForwardInvocationMethod
{
    SEL method = @selector(forwardInvocation:);
    static const char *types = "v@:@";
    if ([self isMethodWithSelectorImplemented:method])
    {
        SEL swizzledMethod = @selector(OCFForwardInvocation:);
        id block = [OCFPropertyBlocksBuilder swizzledForwardInvocationBlockWithDictionary:_attributes];
        [OCFMethodInjector injectClass:_theClass instanceMethod:swizzledMethod types:types block:block];
        [OCFMethodInjector swizzleClass:_theClass instanceMethod:method withMethod:swizzledMethod];
        _isForwardInvocationMethodSwizzled = YES;
    }
    else
    {
        id block = [OCFPropertyBlocksBuilder injectedForwardInvocationBlockWithDictionary:_attributes];
        [OCFMethodInjector injectClass:_theClass instanceMethod:method types:types block:block];
    }
}

- (void)injectValueForKeyPathMethod
{
    SEL method = @selector(valueForKeyPath:);
    static const char *types = "@@:@";
    if ([self isMethodWithSelectorImplemented:method])
    {
        SEL swizzledMethod = @selector(OCFValueForKeyPath:);
        id block = [OCFPropertyBlocksBuilder swizzledValueForKeyPathBlockWithDictionary:_signatures];
        [OCFMethodInjector injectClass:_theClass instanceMethod:swizzledMethod types:types block:block];
        [OCFMethodInjector swizzleClass:_theClass instanceMethod:method withMethod:swizzledMethod];
        _isValueForKeyPathSwizzled = YES;
    }
    else
    {
        id block = [OCFPropertyBlocksBuilder injectedValueForKeyPathBlockWithDictionary:_signatures];
        [OCFMethodInjector injectClass:_theClass instanceMethod:method types:types block:block];
    }
}

- (void)injectSetValueForKeyPathMethod
{
    SEL method = @selector(setValue:forKeyPath:);
    static const char *types = "v@:@:@";
    if ([self isMethodWithSelectorImplemented:method])
    {
        SEL swizzledMethod = @selector(OCFSetValue:forKeyPath:);
        id block = [OCFPropertyBlocksBuilder swizzledSetValueForKeyPathBlockWithDictionary:_signatures];
        [OCFMethodInjector injectClass:_theClass instanceMethod:swizzledMethod types:types block:block];
        [OCFMethodInjector swizzleClass:_theClass instanceMethod:method withMethod:swizzledMethod];
        _isSetValueForKeyPathSwizzled = YES;
    }
    else
    {
        id block = [OCFPropertyBlocksBuilder injectedSetValueForKeyPathBlockWithDictionary:_signatures];
        [OCFMethodInjector injectClass:_theClass instanceMethod:method types:types block:block];
    }
}

- (void)revertMethodSignatureMethod
{
    SEL method = @selector(methodSignatureForSelector:);
    if (_isMethodSignatureMethodSwizzled)
    {
        [OCFMethodInjector swizzleClass:_theClass instanceMethod:method
                             withMethod:@selector(OCFMethodSignatureForSelector:)];
        _isMethodSignatureMethodSwizzled = NO;
    }
}

- (void)revertForwardInvocationMethod
{
    SEL method = @selector(forwardInvocation:);
    if (_isForwardInvocationMethodSwizzled)
    {
        [OCFMethodInjector swizzleClass:_theClass instanceMethod:method
                             withMethod:@selector(OCFForwardInvocation:)];
        _isForwardInvocationMethodSwizzled = NO;
    }
}

- (void)revertValueForKeyPathMethod
{
    SEL method = @selector(valueForKeyPath:);
    if (_isValueForKeyPathSwizzled)
    {
        [OCFMethodInjector swizzleClass:_theClass instanceMethod:method
                             withMethod:@selector(OCFValueForKeyPath:)];
        _isValueForKeyPathSwizzled = NO;
    }
}

- (void)revertSetValueForKeyPathMethod
{
    SEL method = @selector(setValue:forKeyPath:);
    if (_isSetValueForKeyPathSwizzled)
    {
        [OCFMethodInjector swizzleClass:_theClass instanceMethod:method
                             withMethod:@selector(OCFSetValue:forKeyPath:)];
        _isSetValueForKeyPathSwizzled = NO;
    }
}

#pragma mark - private

- (BOOL)isMethodWithSelectorImplemented:(SEL)methodSelector
{
    BOOL result = NO;
    unsigned int count = 0;
    Method *methods = class_copyMethodList(_theClass, &count);
    if (methods && count > 0)
    {
        for (NSUInteger i = 0; i < count; i++)
        {
            Method method = methods[i];
            SEL methodName = method_getName(method);
            if (methodName == methodSelector)
            {
                result = YES;
                break;
            }
        }
        free(methods);
    }
    return result;
}

@end