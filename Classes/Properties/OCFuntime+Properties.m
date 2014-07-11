//
//  OCFuntime+Properties.m
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 7/10/14.
//  Copyright (c) 2014 okolodev. All rights reserved.
//

#import "OCFuntime+Properties.h"
#import "OCFuntime_Private.h"
#import "OCFPropertiesUnit.h"

@implementation OCFuntime (Properties)

- (void)injectClass:(Class)theClass property:(NSString *)propertyName
{
    OCFPropertiesUnit *unit = (OCFPropertiesUnit *)[self unitOfClass:OCFPropertiesUnit.class];
    [unit injectClass:theClass property:propertyName];
}

- (void)removeClass:(Class)theClass property:(NSString *)propertyName
{
    OCFPropertiesUnit *unit = (OCFPropertiesUnit *)[self unitOfClass:OCFPropertiesUnit.class];
    [unit removeClass:theClass property:propertyName];
}

- (void)removeClassProperties:(Class)theClass
{
    OCFPropertiesUnit *unit = (OCFPropertiesUnit *)[self unitOfClass:OCFPropertiesUnit.class];
    [unit removeClassProperties:theClass];
}

- (void)removeAllProperties
{
    OCFPropertiesUnit *unit = (OCFPropertiesUnit *)[self unitOfClass:OCFPropertiesUnit.class];
    [unit removeAllProperties];
}

@end
