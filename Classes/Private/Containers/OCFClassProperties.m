//
//  OCFClassProperties.m
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 12/10/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import "OCFClassProperties.h"
#import "OCFProperty.h"

@implementation OCFClassProperties

#pragma mark - life cycle

- (id)initWithClass:(Class)aClass
{
    if (self = [super init])
    {
        theClass = aClass;
        properties = class_copyPropertyList(theClass, &propertyCount);
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

- (void)synthesizeProperty:(NSString *)propertyName
{
    objc_property_t property = [self propertyWithName:propertyName];
    if (property)
    {
        OCFProperty *implementation = [[OCFProperty alloc] initWithClass:theClass
                                                                property:property];
        [implementation implementProperty];
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
