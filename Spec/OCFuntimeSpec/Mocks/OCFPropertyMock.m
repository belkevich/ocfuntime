//
//  OCFPropertyMock.m
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 12/5/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import "OCFPropertyMock.h"

@implementation OCFPropertyMock

@dynamic objectStrongProperty, objectWeakProperty, objectCopyProperty, blockProperty,
booleanProperty, integerProperty, floatProperty, doubleProperty, structProperty, pIntegerProperty,
pFloatProperty;

@synthesize synthesizedProperty;
@dynamic implementedProperty;

- (id)implementedProperty
{
    return nil;
}

- (void)setImplementedProperty:(id)implementedProperty
{
    // nothing
}

@end
