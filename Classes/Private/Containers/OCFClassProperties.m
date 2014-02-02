//
//  OCFClassProperties.m
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 12/10/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import "OCFClassProperties.h"
#import "OCFProperty.h"
#import "OCFAttributes.h"
#import "OCFWeakStore.h"
#import "NSString+ASCIIString.h"

@interface OCFClassProperties ()
{
    Class theClass;
    objc_property_t *properties;
    unsigned int propertyCount;
}
@property (nonatomic, readonly) NSMutableDictionary *methodsSignatures;
@property (nonatomic, readonly) NSMutableDictionary *methodsAttributes;
@end

@implementation OCFClassProperties

#pragma mark - life cycle

- (id)initWithClass:(Class)aClass
{
    if (self = [super init])
    {
        theClass = aClass;
        properties = class_copyPropertyList(theClass, &propertyCount);
        _methodsSignatures = [[NSMutableDictionary alloc] init];
        _methodsAttributes = [[NSMutableDictionary alloc] init];
        [self addMethodSignatureMethod];
        [self addForwardInvocationMethod];
    }
    return self;
}

- (void)dealloc
{
    if (properties)
    {
        free(properties);
    }
}

#pragma mark - public

- (void)addMethodSignatureMethod
{
    __weak __typeof(self) weakSelf = self;
    IMP implementation = imp_implementationWithBlock((id)^(id instance, SEL methodSelector)
    {
        NSString *methodName = NSStringFromSelector(methodSelector);
        return [weakSelf.methodsSignatures objectForKey:methodName];
    });
    SEL selector = @selector(methodSignatureForSelector:);
    IMP oldImplementation = class_replaceMethod(theClass, selector, implementation, "@@::");
    if (oldImplementation)
    {
        imp_removeBlock(oldImplementation);
    }
    //    BOOL result = class_addMethod(theClass, selector, implementation, "@@::");
//    if (!result)
//    {
//#warning add exception or error
//    }
}

- (void)addForwardInvocationMethod
{
    __weak __typeof(self) weakSelf = self;
    IMP implementation = imp_implementationWithBlock((id)^(id instance, NSInvocation *invocation)
    {
        NSString *methodName = NSStringFromSelector(invocation.selector);
        OCFProperty *property = [weakSelf.methodsAttributes objectForKey:methodName];
        if (property)
        {
            OCFAttributes *attributes = property.attributes;
            const char *key = property.getterName.ASCIIString;
            // setter
            if (invocation.methodSignature.methodReturnLength == 0)
            {
                if ([attributes.type isEqualToString:@"@"] || [attributes.type isEqualToString:@"@?"])
                {
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
                else if ([[attributes.type substringToIndex:1] isEqualToString:@"^"])
                {
                    void *pointer;
                    [invocation getArgument:&pointer atIndex:2];
                    NSValue *store = [NSValue valueWithPointer:pointer];
                    objc_setAssociatedObject(instance, key, store, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                }
                else
                {
                    size_t size = 0;
                    const char *type = attributes.type.ASCIIString;
                    NSGetSizeAndAlignment(type, &size, NULL);
                    void *buffer = malloc(size);
                    [invocation getArgument:buffer atIndex:2];
                    NSValue *store = [NSValue value:buffer withObjCType:type];
                    objc_setAssociatedObject(instance, key, store, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                    free(buffer);
                }
            }
            // getter
            else
            {
                if ([attributes.type isEqualToString:@"@"] || [attributes.type isEqualToString:@"@?"])
                {
                    id object = objc_getAssociatedObject(instance, key);
                    if (attributes.storage == OCFAttributeStorageWeak)
                    {
                        OCFWeakStore *store = object;
                        object = store.weakValue;
                    }
                    [invocation setReturnValue:&object];
                }
                else if ([[attributes.type substringToIndex:1] isEqualToString:@"^"])
                {
                    NSValue *store = objc_getAssociatedObject(instance, key);
                    void *result = store ? store.pointerValue : NULL;
                    [invocation setReturnValue:&result];
                }
                else
                {
                    const char *type = attributes.type.ASCIIString;
                    size_t size = 0;
                    NSGetSizeAndAlignment(type, &size, NULL);
                    void *buffer = calloc(0, size);
                    NSValue *store = objc_getAssociatedObject(instance, key);
                    [store getValue:buffer];
                    [invocation setReturnValue:buffer];
                    free(buffer);
                }
            }
        }
    });
    SEL selector = @selector(forwardInvocation:);
    IMP oldImplementation = class_replaceMethod(theClass, selector, implementation, "v@:@");
    if (oldImplementation)
    {
        imp_removeBlock(oldImplementation);
    }
    //    BOOL result = class_addMethod(theClass, selector, implementation, "v@:@");
//    if (!result)
//    {
//#warning add exception or error
//    }
}

- (void)synthesizeProperty:(NSString *)propertyName
{
    objc_property_t property = [self propertyWithName:propertyName];
    if (property)
    {
        OCFProperty *implementation = [[OCFProperty alloc] initWithProperty:property];
        [self.methodsSignatures setObject:implementation.getterSignature
                                   forKey:implementation.getterName];
        [self.methodsSignatures setObject:implementation.setterSignature
                                   forKey:implementation.setterName];
        [self.methodsAttributes setObject:implementation forKey:implementation.getterName];
        [self.methodsAttributes setObject:implementation forKey:implementation.setterName];
    }
    else {
        NSLog(@"something went wrong");
    }
}

#pragma mark - private

- (objc_property_t)propertyWithName:(NSString *)propertyName
{
    for (NSUInteger i = 0; i < propertyCount; i++)
    {
        char const *name = property_getName(properties[i]);
        NSString *string = [[NSString alloc] initWithBytes:name length:strlen(name)
                                                  encoding:NSUTF8StringEncoding];
        if ([string isEqualToString:propertyName])
        {
            return properties[i];
        }
    }
    return nil;
}

@end
