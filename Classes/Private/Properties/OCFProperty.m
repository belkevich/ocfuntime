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
#import "NSString+ASCIIString.h"

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
    IMP implementation = nil;
    if ([attributes.type isEqualToString:@"@"] || [attributes.type isEqualToString:@"@?"])
    {
        implementation = imp_implementationWithBlock(^(id instance)
        {
            id object = objc_getAssociatedObject(instance, key);
            if (attributes.storage == OCFAttributeStorageWeak)
            {
                OCFWeakStore *store = object;
                return store.weakValue;
            }
            return object;
        });
    }
    else if ([attributes.type isEqualToString:@"i"])
    {
        implementation = imp_implementationWithBlock((id)^(id instance)
        {
            NSValue *store = objc_getAssociatedObject(instance, key);
            if (store)
            {
                NSInteger value;
                [store getValue:&value];
                return value;
            }
            return 0;
        });
    }
    else if ([attributes.type isEqualToString:@"c"])
    {
        implementation = imp_implementationWithBlock((id)^(id instance)
        {
            NSValue *store = objc_getAssociatedObject(instance, key);
            if (store)
            {
                char value;
                [store getValue:&value];
                return value;
            }
            return (char)0;
        });

    }
    else if ([attributes.type isEqualToString:@"f"])
    {
        implementation = imp_implementationWithBlock((id)^(id instance)
        {
            NSValue *store = objc_getAssociatedObject(instance, key);
            if (store)
            {
                float value;
                [store getValue:&value];
                return value;
            }
            return (float)0;
        });
    }
    else if ([[attributes.type substringToIndex:1] isEqualToString:@"^"])
    {
        implementation = imp_implementationWithBlock((id)^(id instance)
        {
            NSValue *store = objc_getAssociatedObject(instance, key);
            if (store)
            {
                return store.pointerValue;
            }
            return NULL;
        });
    }
    else
    {
#warning add exception or error
    }

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
    IMP implementation = nil;
    if ([attributes.type isEqualToString:@"@"] || [attributes.type isEqualToString:@"@?"])
    {
        implementation = imp_implementationWithBlock((id)^(id instance, id value)
        {
            id object = value;
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
        });
    }
    else if ([attributes.type isEqualToString:@"i"])
    {
        implementation = imp_implementationWithBlock((id)^(id instance, NSInteger value)
        {
            NSValue *store = [NSValue value:&value withObjCType:attributes.type.ASCIIString];
            objc_setAssociatedObject(instance, key, store, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        });
    }
    else if ([attributes.type isEqualToString:@"c"])
    {
        implementation = imp_implementationWithBlock((id)^(id instance, char value)
        {
            NSValue *store = [NSValue value:&value withObjCType:attributes.type.ASCIIString];
            objc_setAssociatedObject(instance, key, store, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        });
    }
    else if ([attributes.type isEqualToString:@"f"])
    {
        implementation = imp_implementationWithBlock((id)^(id instance, float value)
        {
            NSValue *store = [NSValue value:&value withObjCType:attributes.type.ASCIIString];
            objc_setAssociatedObject(instance, key, store, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        });
    }
    else if ([[attributes.type substringToIndex:1] isEqualToString:@"^"])
    {
        implementation = imp_implementationWithBlock((id)^(id instance, void *value)
        {
            NSValue *store = [NSValue valueWithPointer:value];
            objc_setAssociatedObject(instance, key, store, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        });
    }
    else
    {
#warning add exception or error
    }

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
