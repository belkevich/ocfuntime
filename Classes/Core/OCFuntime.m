//
//  OCFuntime.m
//  OCFuntime
//
//  Created by Alexey Belkevich on 4/22/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import "OCFuntime.h"
#import "OCFUnitProtocol.h"

@interface OCFuntime ()
{
    NSMutableDictionary *_units;
}
@end

@implementation OCFuntime

#pragma mark - life cycle

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _units = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [_units.allValues enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
    {
        NSObject <OCFUnitProtocol> *unit = obj;
        if ([unit respondsToSelector:@selector(shutdownUnit)])
        {
            [unit shutdownUnit];
        }
    }];
}

#pragma mark - private

- (NSObject <OCFUnitProtocol> *)unitOfClass:(Class)theClass
{
    NSString *className = NSStringFromClass(theClass);
    NSObject <OCFUnitProtocol> *unit = _units[className];
    if (!unit)
    {
        unit = [[theClass alloc] init];
        _units[className] = unit;
    }
    return unit;
}

@end