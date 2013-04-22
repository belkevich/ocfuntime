//
//  Created by Alexey Belkevich on 4/22/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//


#import <objc/runtime.h>
#import "OCFMethod.h"

@interface OCFMethod ()

@property (nonatomic, assign, readwrite) Method method;
@property (nonatomic, assign, readwrite) IMP implementation;

@end

@implementation OCFMethod

#pragma mark -
#pragma mark main routine

@synthesize method, implementation;

- (id)initWithClass:(Class)theClass selector:(SEL)selector
{
    self = [super init];
    if (self)
    {
        self.method = class_getInstanceMethod(theClass, selector);
    }
    return self;
}

+ (id)methodWithClass:(Class)theClass selector:(SEL)selector
{
    return [[[self alloc] initWithClass:theClass selector:selector] autorelease];
}

#pragma mark -
#pragma mark actions

- (void)changeImplementationWithBlock:(id)block
{
    self.implementation = method_getImplementation(self.method);
    IMP blockImplementation = imp_implementationWithBlock(block);
    method_setImplementation(self.method, blockImplementation);
}

- (void)revertImplementation
{
    method_setImplementation(self.method, self.implementation);
}

@end