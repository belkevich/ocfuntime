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

@property (nonatomic, assign, readwrite) Class theClass;
@property (nonatomic, retain, readwrite) NSMutableDictionary *methods;

@end

@implementation OCFModel

@synthesize theClass, methods;

#pragma mark -
#pragma mark main routine

- (id)initWithClass:(Class)aClass
{
    self = [super init];
    if (self)
    {
        self.theClass = aClass;
        self.methods = [NSMutableDictionary dictionary];
    }
    return self;
}

+ (id)modelWithClass:(Class)aClass
{
    return [[[self alloc] initWithClass:aClass] autorelease];
}


- (void)dealloc
{
    self.methods = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark actions

- (void)changeMethodSelector:(SEL)selector withBlock:(id)block
{
    OCFMethod *method = [OCFMethod methodWithClass:self.theClass selector:selector];
    [method changeImplementationWithBlock:block];
    NSString *key = NSStringFromSelector(selector);
    [self.methods setObject:method forKey:key];
}

- (void)revertMethodSelector:(SEL)selector
{
    NSString *key = NSStringFromSelector(selector);
    OCFMethod *method = [self.methods objectForKey:key];
    if (method)
    {
        [method revertImplementation];
        [self.methods removeObjectForKey:key];
    }
}

- (void)revertModel
{
    [[self.methods allValues] makeObjectsPerformSelector:@selector(revertImplementation)];
    [self.methods removeAllObjects];
}

@end