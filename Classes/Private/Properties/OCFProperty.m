//
//  OCFProperty.m
//  OCFuntime
//
//  Created by Alexey Belkevich on 12/16/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import "OCFProperty.h"
#import "OCFAttributes.h"
#import "OCFWeakStore.h"


@implementation OCFProperty

#pragma mark - life cycle

- (id)initWithClass:(Class)aClass property:(objc_property_t)property
{
    self = [super init];
    if (self)
    {
        theClass = aClass;
        const char *string = property_getName(property);
        name = [[NSString alloc] initWithBytes:string length:strlen(string)
                                      encoding:NSUTF8StringEncoding];
        attributes = [[OCFAttributes alloc] initWithProperty:property];
    }
    return self;
}

#pragma mark - public

- (void)implementProperty
{
    [self implementReadMethod];
    [self implementWriteMethod];
}

#pragma mark - private

- (void)implementReadMethod
{
    const char *key = [name cStringUsingEncoding:NSUTF8StringEncoding];
    IMP implementation = imp_implementationWithBlock((id)^(id instance)
    {
        id object = objc_getAssociatedObject(instance, key);
        if (attributes.storage == OCFAttributeStorageWeak)
        {
            OCFWeakStore *store = object;
            return store.weakValue;
        }
        return object;
    });

    SEL selector = NSSelectorFromString(name);
    BOOL result = class_addMethod(theClass, selector, implementation, "@@:");
    if (!result)
    {
#warning add exception or error
    }
}

- (void)implementWriteMethod
{
    const char *key = [name cStringUsingEncoding:NSUTF8StringEncoding];
    IMP implementation = imp_implementationWithBlock(^(id instance, id value)
    {
        if (attributes.storage == OCFAttributeStorageWeak)
        {
            OCFWeakStore *store = objc_getAssociatedObject(instance, key);
            if (!store)
            {
                store = [[OCFWeakStore alloc] init];
            }
            store.weakValue = value;
            objc_setAssociatedObject(instance, key, store, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        else if (attributes.storage == OCFAttributeStorageCopy)
        {
            objc_setAssociatedObject(instance, key, value, OBJC_ASSOCIATION_COPY_NONATOMIC);
        }
        else
        {
            objc_setAssociatedObject(instance, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    });

    NSString *selectorName = [NSString stringWithFormat:@"set%@%@:",
                                       [name substringToIndex:1].uppercaseString,
                                       [name substringFromIndex:1]];
    SEL selector = NSSelectorFromString(selectorName);
    BOOL result = class_addMethod(theClass, selector, implementation, "v@:@");
    if (!result)
    {
#warning add exception or error
    }
}

@end
