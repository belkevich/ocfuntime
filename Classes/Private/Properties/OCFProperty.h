//
//  OCFProperty.h
//  OCFuntime
//
//  Created by Alexey Belkevich on 12/16/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@class OCFAttributes;

@interface OCFProperty : NSObject
{
@private
    Class theClass;
    NSString *name;
    OCFAttributes *attributes;
}

- (id)initWithClass:(Class)theClass property:(objc_property_t)property;
- (void)implementProperty;

@end
