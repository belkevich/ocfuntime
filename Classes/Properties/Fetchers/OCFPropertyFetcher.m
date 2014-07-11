//
//  OCFPropertyFetcher.m
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 7/3/14.
//  Copyright (c) 2014 okolodev. All rights reserved.
//

#import "OCFPropertyFetcher.h"

@interface OCFPropertyFetcher ()
{
    objc_property_t *_properties;
    unsigned int _count;
}
@end

@implementation OCFPropertyFetcher

#pragma mark - life cycle

- (void)dealloc
{
    [self freeProperties];
}

#pragma mark - public

- (void)fetchAllPropertiesOfClass:(Class)theClass
{
    _properties = class_copyPropertyList(theClass, &_count);
}

- (objc_property_t)findPropertyWithName:(NSString *)propertyName
{
    for (NSUInteger i = 0; i < _count; i++)
    {
        char const *name = property_getName(_properties[i]);
        NSString *string = [[NSString alloc] initWithBytes:name length:strlen(name)
                                                  encoding:NSUTF8StringEncoding];
        if ([string isEqualToString:propertyName])
        {
            return _properties[i];
        }
    }
    return nil;
}

#pragma mark - private

- (void)freeProperties
{
    if (_properties)
    {
        free(_properties);
    }
}

@end
