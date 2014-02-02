//
//  OCFProperty.m
//  OCFuntime
//
//  Created by Alexey Belkevich on 12/16/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import "OCFProperty.h"
#import "OCFAttributes.h"
#import "NSString+ASCIIString.h"

@implementation OCFProperty

#pragma mark - life cycle

- (id)initWithProperty:(objc_property_t)property
{
    self = [super init];
    if (self)
    {
        _attributes = [[OCFAttributes alloc] initWithProperty:property];
        const char *string = property_getName(property);
        _getterName = [NSString stringWithCString:string encoding:NSASCIIStringEncoding];
        _setterName = [NSString stringWithFormat:@"set%@%@:",
                                [self.getterName substringToIndex:1].uppercaseString,
                                [self.getterName substringFromIndex:1]];
        _getterSignature = [NSMethodSignature signatureWithObjCTypes:self.getterObjCTypes];
        _setterSignature = [NSMethodSignature signatureWithObjCTypes:self.setterObjCTypes];
    }
    return self;
}

#pragma mark - private

- (const char *)getterObjCTypes
{
    NSString *string = [NSString stringWithFormat:@"%@@:", self.attributes.type];
    return string.ASCIIString;
}

- (const char *)setterObjCTypes
{
    NSString *string = [NSString stringWithFormat:@"v@:%@", self.attributes.type];
    return string.ASCIIString;
}

@end
