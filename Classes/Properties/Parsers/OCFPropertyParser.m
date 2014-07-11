//
//  OCFPropertyParser.m
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 7/3/14.
//  Copyright (c) 2014 okolodev. All rights reserved.
//

#import "OCFPropertyParser.h"
#import "NSString+ASCIIString.h"

@implementation OCFPropertyParser

- (void)parseProperty:(objc_property_t)property name:(NSString *)name
{
    _name = [self propertyNameWithProperty:property];
    _attributes = [[OCFPropertyAttributes alloc] initWithProperty:property name:name];
    [self parseAccessorsWithPropertyName:_name];
    [self parseSignaturesWithPropertyType:_attributes.type];
}

#pragma mark - private

- (void)parseAccessorsWithPropertyName:(NSString *)name
{
    _getterName = name;
    _setterName = [NSString stringWithFormat:@"set%@%@:", [name substringToIndex:1].uppercaseString,
                                             [name substringFromIndex:1]];
}

- (void)parseSignaturesWithPropertyType:(NSString *)type
{
    NSString *getterType = [NSString stringWithFormat:@"%@@:", type];
    NSString *setterType = [NSString stringWithFormat:@"v@:%@", type];
    _getterSignature = [NSMethodSignature signatureWithObjCTypes:getterType.ASCIIString];
    _setterSignature = [NSMethodSignature signatureWithObjCTypes:setterType.ASCIIString];
}

- (NSString *)propertyNameWithProperty:(objc_property_t)property
{
    const char *string = property_getName(property);
    return [NSString stringWithCString:string encoding:NSASCIIStringEncoding];
}

@end
