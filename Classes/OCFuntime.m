//
//  OCFuntime.m
//  OCFuntime
//
//  Created by Alexey Belkevich on 4/22/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//


#import "OCFuntime.h"
#import "OCFModel.h"

@implementation OCFuntime

#pragma mark - life cycle

- (id)init
{
    self = [super init];
    if (self)
    {
        classes = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark - public

- (void)changeClass:(Class)theClass instanceMethod:(SEL)method implementation:(id)block
{
    OCFModel *model = [self modelForClass:theClass create:YES];
    [model changeInstanceMethod:method withBlock:block];
}

- (void)changeClass:(Class)theClass classMethod:(SEL)method implementation:(id)block
{
    OCFModel *model = [self modelForClass:theClass create:YES];
    [model changeClassMethod:method withBlock:block];
}

- (void)revertClass:(Class)theClass instanceMethod:(SEL)method
{
    OCFModel *model = [self modelForClass:theClass create:NO];
    [model revertInstanceMethod:method];
}

- (void)revertClass:(Class)theClass classMethod:(SEL)method
{
    OCFModel *model = [self modelForClass:theClass create:NO];
    [model revertClassMethod:method];
}

- (void)revertClass:(Class)theClass
{
    OCFModel *model = [self modelForClass:theClass create:NO];
    [model revertModel];
}

- (void)revertAll
{
    [[classes allValues] makeObjectsPerformSelector:@selector(revertModel)];
}

#pragma mark - private

- (OCFModel *)modelForClass:(Class)theClass create:(BOOL)create
{
    NSString *className = NSStringFromClass(theClass);
    OCFModel *model = [classes objectForKey:className];
    if (!model && create)
    {
        model = [OCFModel modelWithClass:theClass];
        [classes setObject:model forKey:className];

    }
    return model;
}

@end