//
//  OCFClassProperties.m
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 12/10/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import <objc/runtime.h>
#import "OCFClassProperties.h"

@implementation OCFClassProperties

#pragma mark - life cycle

- (id)initWithPropertiesClass:(Class)aClass
{
    if (self = [super init])
    {
        theClass = aClass;
    }
    return self;
}

#pragma mark - public

- (void)synthesizeProperty:(NSString *)propertyName
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

@end
