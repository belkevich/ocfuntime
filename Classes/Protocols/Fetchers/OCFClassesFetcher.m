//
//  OCFClassesFetcher.m
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 1/15/15.
//  Copyright (c) 2015 okolodev. All rights reserved.
//

#import <objc/runtime.h>
#import "OCFClassesFetcher.h"

@interface OCFClassesFetcher ()
{
    unsigned int _count;
    Class *_classes;
    NSMutableDictionary *_protocolClasses;
}
@end

@implementation OCFClassesFetcher

#pragma mark - life cycle

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _classes = objc_copyClassList(&_count);
        _protocolClasses = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)dealloc
{
    if (_count > 0 && _classes)
    {
        free(_classes);
    }
}

#pragma mark - public

- (NSArray *)classesConformsToProtocol:(Protocol *)theProtocol
{
    NSString *protocolName = NSStringFromProtocol(theProtocol);
    NSArray *classes = _protocolClasses[protocolName];
    if (!classes)
    {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (NSUInteger i = 0; i < _count; i++)
        {
            Class theClass = _classes[i];
            if (class_conformsToProtocol(theClass, theProtocol))
            {
                [array addObject:NSStringFromClass(theClass)];
            }
        }
        classes = array.count > 0 ? array.copy : nil;
        _protocolClasses[protocolName] = classes;
    }
    return classes;
}

@end
