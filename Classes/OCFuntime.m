//
//  OCFuntime.m
//  OCFuntime
//
//  Created by Alexey Belkevich on 4/22/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import <objc/runtime.h>
#import "OCFuntime.h"
#import "OCFClassMethods.h"

@implementation OCFuntime

#pragma mark - life cycle

- (id)init
{
    self = [super init];
    if (self)
    {
        classes = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [self revertAll];
}

#pragma mark - public

- (void)changeClass:(Class)theClass instanceMethod:(SEL)method implementation:(id)block
{
    OCFClassMethods *model = [self modelForClass:theClass create:YES];
    [model changeInstanceMethod:method implementationWithBlock:block];
}

- (void)changeClass:(Class)theClass classMethod:(SEL)method implementation:(id)block
{
    OCFClassMethods *model = [self modelForClass:theClass create:YES];
    [model changeClassMethod:method implementationWithBlock:block];
}

- (void)revertClass:(Class)theClass instanceMethod:(SEL)method
{
    OCFClassMethods *model = [self modelForClass:theClass create:NO];
    [model revertInstanceMethod:method];
}

- (void)revertClass:(Class)theClass classMethod:(SEL)method
{
    OCFClassMethods *model = [self modelForClass:theClass create:NO];
    [model revertClassMethod:method];
}

- (void)revertClass:(Class)theClass
{
    OCFClassMethods *model = [self modelForClass:theClass create:NO];
    [model revertAllToDefaultImplementation];
}

- (void)revertAll
{
    [[classes allValues] makeObjectsPerformSelector:@selector(revertAllToDefaultImplementation)];
}

- (void)synthesizeProperty:(NSString *)propertyName ofClass:(Class)theClass
{
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList(theClass, &outCount);
    unsigned int count;
    objc_property_t property = properties[0];
    objc_property_attribute_t *dynamicAttributes = property_copyAttributeList(property, &count);
    fprintf(stdout, "%s %s\n", property_getName(property), property_getAttributes(property));

    SEL readSelector = NSSelectorFromString(propertyName);
    IMP readImplementation = imp_implementationWithBlock((id)^(id instance)
    {
        return objc_getAssociatedObject(instance,
                                        [propertyName cStringUsingEncoding:NSUTF8StringEncoding]);
    });
    BOOL result = class_addMethod(theClass, readSelector, readImplementation, "@@:");
    NSLog(@"read result - %d", result);

    SEL writeSelector = NSSelectorFromString([NSString stringWithFormat:@"set%@%@:",
                                                       [propertyName substringToIndex:1].uppercaseString,
                                                       [propertyName substringFromIndex:1]]);
    IMP writeImplementation = imp_implementationWithBlock(^(id instance, id value)
    {
        objc_setAssociatedObject(instance, [propertyName cStringUsingEncoding:NSUTF8StringEncoding],
                                 value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    });
    result = class_addMethod(theClass, writeSelector, writeImplementation, "v@:@");
    NSLog(@"write result - %d", result);

    free(dynamicAttributes);
    free(properties);
}

#pragma mark - private

- (OCFClassMethods *)modelForClass:(Class)theClass create:(BOOL)create
{
    NSString *className = NSStringFromClass(theClass);
    OCFClassMethods *model = [classes objectForKey:className];
    if (!model && create)
    {
        model = [[OCFClassMethods alloc] initWithClass:theClass];
        [classes setObject:model forKey:className];

    }
    return model;
}

@end