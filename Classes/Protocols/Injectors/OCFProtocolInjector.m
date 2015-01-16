//
//  OCFProtocolInjector.m
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 1/16/15.
//  Copyright (c) 2015 okolodev. All rights reserved.
//

#import <objc/runtime.h>
#import "OCFProtocolInjector.h"

@interface OCFProtocolInjector ()
{
    Protocol *_protocol;
    NSArray *_classes;
}
@end

@implementation OCFProtocolInjector

#pragma mark - life cycle

- (instancetype)initWithProtocol:(Protocol *)theProtocol classes:(NSArray *)classes {
    self = [super init];
    if (self)
    {
        _protocol = theProtocol;
        _classes = classes;
    }
    return self;
}

#pragma mark - public

- (void)forceInject:(BOOL)force instance:(BOOL)instance method:(SEL)method implementation:(id)implementation
{
    for (NSString *className in _classes)
    {
        Class theClass = [self classFromClassName:className instance:instance];
        IMP blockImplementation = imp_implementationWithBlock(implementation);
        struct objc_method_description methodDescription = protocol_getMethodDescription(_protocol, method, NO, instance);
        if (!force)
        {
            class_addMethod(theClass, method, blockImplementation, methodDescription.types);
        }
        else
        {
            IMP oldImplementation = class_replaceMethod(theClass, method, blockImplementation, methodDescription.types);
            imp_removeBlock(oldImplementation);
        }
    }
}

#pragma mark - private

- (Class)classFromClassName:(NSString *)className instance:(BOOL)instance
{
    Class theClass = NSClassFromString(className);
    if (!instance)
    {
        theClass = object_getClass(theClass);
    }
    return theClass;
}

@end