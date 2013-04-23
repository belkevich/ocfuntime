//
//  OCFModel.m
//  OCFuntime
//
//  Created by Alexey Belkevich on 4/22/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//


#import "OCFModel.h"
#import "OCFMethod.h"

@interface OCFModel ()

- (void)changeMethod:(SEL)selector withBlock:(id)block instance:(BOOL)instance;

@end

@implementation OCFModel

#pragma mark -
#pragma mark main routine

- (id)initWithClass:(Class)aClass
{
    self = [super init];
    if (self)
    {
        theClass = aClass;
        methods = [[NSMutableDictionary alloc] init];
    }
    return self;
}

+ (id)modelWithClass:(Class)aClass
{
    return [[[self alloc] initWithClass:aClass] autorelease];
}

- (void)dealloc
{
    [methods release];
    [super dealloc];
}

#pragma mark -
#pragma mark actions

- (void)changeInstanceMethod:(SEL)selector withBlock:(id)block
{
    [self changeMethod:selector withBlock:block instance:YES];
}

- (void)changeClassMethod:(SEL)selector withBlock:(id)block
{
    [self changeMethod:selector withBlock:block instance:NO];
}

- (void)revertMethodSelector:(SEL)selector
{
    NSString *key = NSStringFromSelector(selector);
    OCFMethod *method = [methods objectForKey:key];
    if (method)
    {
        [method revertImplementation];
        [methods removeObjectForKey:key];
    }
}

- (void)revertModel
{
    [[methods allValues] makeObjectsPerformSelector:@selector(revertImplementation)];
    [methods removeAllObjects];
}

#pragma mark -
#pragma mark private

- (void)changeMethod:(SEL)selector withBlock:(id)block instance:(BOOL)instance
{
    OCFMethod *method = instance ? [OCFMethod methodWithClass:theClass instanceMethod:selector]:
                        [OCFMethod methodWithClass:theClass classMethod:selector];
    [method changeImplementationWithBlock:block];
    NSString *key = NSStringFromSelector(selector);
    [methods setObject:method forKey:key];
}

@end