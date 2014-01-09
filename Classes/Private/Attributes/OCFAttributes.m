//
//  OCFAttributes.m
//  OCFuntime
//
//  Created by Alexey Belkevich on 12/16/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import <objc/runtime.h>
#import "OCFAttributes.h"

@implementation OCFAttributes

#pragma mark - life cycle

- (id)initWithProperty:(objc_property_t)property
{
    self = [super init];
    if (self)
    {
        unsigned int count;
        objc_property_attribute_t *attributes = property_copyAttributeList(property, &count);
        [self parseAttributes:attributes count:count];
        free(attributes);
    }
    return self;
}

#pragma mark - private

- (void)parseAttributes:(objc_property_attribute_t *)attributes count:(unsigned int)count
{
    for (NSUInteger i = 0; i < count; i++)
    {
        objc_property_attribute_t attribute = attributes[i];
        if (strcmp(attribute.name, "T")  == 0)
        {
            _type = attribute.value;
        }
        else if (strcmp(attribute.name, "R") == 0)
        {
            _isReadonly = YES;
        }
        else if (strcmp(attribute.name, "N") == 0)
        {
            _isNonatomic = YES;
        }
        else if (strcmp(attribute.name, "D") == 0)
        {
            _isDynamic = YES;
        }
        else if (strcmp(attribute.name, "V") == 0)
        {
            _isSynthesized = YES;
        }
        else if (strcmp(attribute.name, "C") == 0)
        {
            _storage = OCFAttributeStorageCopy;
        }
        else if (strcmp(attribute.name, "&") == 0)
        {
            _storage = OCFAttributeStorageRetain;
        }
        else if (strcmp(attribute.name, "W") == 0)
        {
            _storage = OCFAttributeStorageWeak;
        }
    }
}

@end
