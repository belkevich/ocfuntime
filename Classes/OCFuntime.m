//
//  OCFuntime.m
//  OCFuntime
//
//  Created by Alexey Belkevich on 4/22/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//


#import "OCFuntime.h"
#import "OCFModel.h"

@interface OCFuntime ()

@property (nonatomic, retain, readwrite) NSMutableDictionary *classes;

- (OCFModel *)modelForClass:(Class)theClass;

@end

@implementation OCFuntime

@synthesize classes;

#pragma mark -
#pragma mark main routine

- (id)init
{
    self = [super init];
    if (self)
    {
        self.classes = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)dealloc
{
    self.classes = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark action

- (void)changeClass:(Class)theClass method:(SEL)method implementation:(id)block
{
    OCFModel *model = [self modelForClass:theClass];
    if (!model)
    {
        NSString *className = NSStringFromClass(theClass);
        model = [OCFModel modelWithClass:theClass];
        [self.classes setObject:model forKey:className];
    }
    [model changeMethodSelector:method withBlock:block];
}

- (void)revertClass:(Class)theClass method:(SEL)method
{
    OCFModel *model = [self modelForClass:theClass];
    [model revertMethodSelector:method];
}

- (void)revertClass:(Class)theClass
{
    OCFModel *model = [self modelForClass:theClass];
    [model revertModel];
}

- (void)revertAll
{
    [[self.classes allValues] makeObjectsPerformSelector:@selector(revertModel)];
}

#pragma mark -
#pragma mark private

- (OCFModel *)modelForClass:(Class)theClass
{
    NSString *className = NSStringFromClass(theClass);
    return [self.classes objectForKey:className];
}

@end