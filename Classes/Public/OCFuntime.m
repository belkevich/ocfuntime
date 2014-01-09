//
//  OCFuntime.m
//  OCFuntime
//
//  Created by Alexey Belkevich on 4/22/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import "OCFuntime.h"
#import "OCFClassMethods.h"
#import "OCFClassProperties.h"

@implementation OCFuntime

#pragma mark - life cycle

- (id)init
{
    self = [super init];
    if (self)
    {
        changedMethods = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [self revertAll];
}

#pragma mark - public

- (void)changeClass:(Class)theClass instanceMethod:(SEL)method implementation:(id)block
{
    OCFClassMethods *model = [self modelForClass:theClass create:YES];
    [model changeInstanceMethod:method implementationWithBlock:block];
}

- (void)changeClass:(Class)theClass classMethod:(SEL)method implementation:(id)block
{
    OCFClassMethods *model = [self modelForClass:theClass create:YES];
    [model changeClassMethod:method implementationWithBlock:block];
}

- (void)revertClass:(Class)theClass instanceMethod:(SEL)method
{
    OCFClassMethods *model = [self modelForClass:theClass create:NO];
    [model revertInstanceMethod:method];
}

- (void)revertClass:(Class)theClass classMethod:(SEL)method
{
    OCFClassMethods *model = [self modelForClass:theClass create:NO];
    [model revertClassMethod:method];
}

- (void)revertClass:(Class)theClass
{
    OCFClassMethods *model = [self modelForClass:theClass create:NO];
    [model revertAllToDefaultImplementation];
}

- (void)revertAll
{
    [[changedMethods allValues] makeObjectsPerformSelector:@selector(revertAllToDefaultImplementation)];
}

- (void)synthesizeProperty:(NSString *)propertyName ofClass:(Class)theClass
{
    OCFClassProperties *properties = [[OCFClassProperties alloc] initWithClass:theClass];
    [properties synthesizeProperty:propertyName];
}

#pragma mark - private

- (OCFClassMethods *)modelForClass:(Class)theClass create:(BOOL)create
{
    NSString *className = NSStringFromClass(theClass);
    OCFClassMethods *model = [changedMethods objectForKey:className];
    if (!model && create)
    {
        model = [[OCFClassMethods alloc] initWithClass:theClass];
        [changedMethods setObject:model forKey:className];

    }
    return model;
}

@end