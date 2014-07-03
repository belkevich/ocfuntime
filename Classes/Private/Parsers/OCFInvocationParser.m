//
//  OCFInvocationParser.m
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 7/3/14.
//  Copyright (c) 2014 okolodev. All rights reserved.
//

#import "OCFInvocationParser.h"
#import "OCFPropertyAttributes.h"
#import "OCFWeakStore.h"
#import "NSString+ASCIIString.h"

@implementation OCFInvocationParser

#pragma mark - public

+ (void)parsePropertyInvocation:(NSInvocation *)invocation onInstance:(id)instance
                 withAttributes:(OCFPropertyAttributes *)attributes
{
    // setter
    if (invocation.methodSignature.methodReturnLength == 0)
    {
        if ([attributes.type isEqualToString:@"@"] || [attributes.type isEqualToString:@"@?"])
        {
            [self parseIdSetterInvocation:invocation instance:instance attributes:attributes];
        }
        else if ([[attributes.type substringToIndex:1] isEqualToString:@"^"])
        {
            const char *key = attributes.key;
            [self parsePointerSetterInvocation:invocation instance:instance key:key];
        }
        else
        {
            [self parsePrimitiveSetterInvocation:invocation instance:instance
                                      attributes:attributes];
        }
    }
    // getter
    else
    {
        if ([attributes.type isEqualToString:@"@"] || [attributes.type isEqualToString:@"@?"])
        {
            [self parseIdGetterInvocation:invocation instance:instance attributes:attributes];
        }
        else if ([[attributes.type substringToIndex:1] isEqualToString:@"^"])
        {
            const char *key = attributes.key;
            [self parsePointerGetterInvocation:invocation instance:instance key:key];
        }
        else
        {
            [self parsePrimitiveGetterInvocation:invocation instance:instance
                                      attributes:attributes];
        }
    }
}

#pragma mark - private

+ (void)parseIdSetterInvocation:(NSInvocation *)invocation instance:(id)instance
                     attributes:(OCFPropertyAttributes *)attributes
{
    const char *key = attributes.key;
    __unsafe_unretained id object;
    [invocation getArgument:&object atIndex:2];
    if (attributes.storage == OCFAttributeStorageWeak)
    {
        OCFWeakStore *store = objc_getAssociatedObject(instance, key);
        if (!store)
        {
            store = [[OCFWeakStore alloc] init];
        }
        store.weakValue = object;
        objc_setAssociatedObject(instance, key, store, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    else if (attributes.storage == OCFAttributeStorageCopy)
    {
        objc_setAssociatedObject(instance, key, object, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    else
    {
        objc_setAssociatedObject(instance, key, object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

+ (void)parsePointerSetterInvocation:(NSInvocation *)invocation instance:(id)instance
                                 key:(char const *)key
{
    void *pointer;
    [invocation getArgument:&pointer atIndex:2];
    NSValue *store = [NSValue valueWithPointer:pointer];
    objc_setAssociatedObject(instance, key, store, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)parsePrimitiveSetterInvocation:(NSInvocation *)invocation instance:(id)instance
                            attributes:(OCFPropertyAttributes *)attributes
{
    size_t size = 0;
    const char *type = attributes.type.ASCIIString;
    const char *key = attributes.key;
    NSGetSizeAndAlignment(type, &size, NULL);
    void *buffer = malloc(size);
    [invocation getArgument:buffer atIndex:2];
    NSValue *store = [NSValue value:buffer withObjCType:type];
    objc_setAssociatedObject(instance, key, store, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    free(buffer);
}

+ (void)parseIdGetterInvocation:(NSInvocation *)invocation instance:(id)instance
                     attributes:(OCFPropertyAttributes *)attributes
{
    const char *key = attributes.key;
    id object = objc_getAssociatedObject(instance, key);
    if (attributes.storage == OCFAttributeStorageWeak)
    {
        OCFWeakStore *store = object;
        object = store.weakValue;
    }
    [invocation setReturnValue:&object];
}

+ (void)parsePointerGetterInvocation:(NSInvocation *)invocation instance:(id)instance
                                 key:(char const *)key
{
    NSValue *store = objc_getAssociatedObject(instance, key);
    void *result = store ? store.pointerValue : NULL;
    [invocation setReturnValue:&result];
}

+ (void)parsePrimitiveGetterInvocation:(NSInvocation *)invocation instance:(id)instance
                            attributes:(OCFPropertyAttributes *)attributes
{
    const char *type = attributes.type.ASCIIString;
    const char *key = attributes.key;
    size_t size = 0;
    NSGetSizeAndAlignment(type, &size, NULL);
    void *buffer = calloc(0, size);
    NSValue *store = objc_getAssociatedObject(instance, key);
    [store getValue:buffer];
    [invocation setReturnValue:buffer];
    free(buffer);
}
@end
