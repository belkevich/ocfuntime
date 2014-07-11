//
//  OCFMethodsUnit.m
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 7/10/14.
//  Copyright (c) 2014 okolodev. All rights reserved.
//

#import "OCFMethodsUnit.h"
#import "OCFMethodsSwitcher.h"

@interface OCFMethodsUnit ()
{
    NSMutableDictionary *_changedMethods;
}
@end

@implementation OCFMethodsUnit

#pragma mark - life cycle

- (id)init
{
    self = [super init];
    if (self)
    {
        _changedMethods = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark - public

- (void)changeClass:(Class)theClass instanceMethod:(SEL)method implementation:(id)block
{
    OCFMethodsSwitcher *model = [self modelForClass:theClass create:YES];
    [model changeInstanceMethod:method implementationWithBlock:block];
}

- (void)changeClass:(Class)theClass classMethod:(SEL)method implementation:(id)block
{
    OCFMethodsSwitcher *model = [self modelForClass:theClass create:YES];
    [model changeClassMethod:method implementationWithBlock:block];
}

- (void)revertClass:(Class)theClass instanceMethod:(SEL)method
{
    OCFMethodsSwitcher *model = [self modelForClass:theClass create:NO];
    [model revertInstanceMethod:method];
}

- (void)revertClass:(Class)theClass classMethod:(SEL)method
{
    OCFMethodsSwitcher *model = [self modelForClass:theClass create:NO];
    [model revertClassMethod:method];
}

- (void)revertClass:(Class)theClass
{
    OCFMethodsSwitcher *model = [self modelForClass:theClass create:NO];
    [model revertAllToDefaultImplementation];
}

- (void)revertAll
{
    [[_changedMethods allValues] makeObjectsPerformSelector:@selector(revertAllToDefaultImplementation)];
}

#pragma mark - unit protocol implementation

- (void)shutdownUnit
{
    [self revertAll];
}

#pragma mark - private

- (OCFMethodsSwitcher *)modelForClass:(Class)theClass create:(BOOL)create
{
    NSString *className = NSStringFromClass(theClass);
    OCFMethodsSwitcher *model = _changedMethods[className];
    if (!model && create)
    {
        model = [[OCFMethodsSwitcher alloc] initWithClass:theClass];
        _changedMethods[className] = model;
    }
    return model;
}

@end
