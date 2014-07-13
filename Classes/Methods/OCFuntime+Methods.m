//
//  OCFuntime+Methods.m
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 7/10/14.
//  Copyright (c) 2014 okolodev. All rights reserved.
//

#import "OCFuntime+Methods.h"
#import "OCFuntime_Private.h"
#import "OCFMethodsUnit.h"

@implementation OCFuntime (Methods)

- (void)changeClass:(Class)theClass instanceMethod:(SEL)method implementation:(id)block
{
    OCFMethodsUnit *unit = (OCFMethodsUnit *)[self unitOfClass:OCFMethodsUnit.class];
    [unit changeClass:theClass instanceMethod:method implementation:block];
}

- (void)changeClass:(Class)theClass classMethod:(SEL)method implementation:(id)block
{
    OCFMethodsUnit *unit = (OCFMethodsUnit *)[self unitOfClass:OCFMethodsUnit.class];
    [unit changeClass:theClass classMethod:method implementation:block];
}

- (void)revertClass:(Class)theClass instanceMethod:(SEL)method
{
    OCFMethodsUnit *unit = (OCFMethodsUnit *)[self unitOfClass:OCFMethodsUnit.class];
    [unit revertClass:theClass instanceMethod:method];
}

- (void)revertClass:(Class)theClass classMethod:(SEL)method
{
    OCFMethodsUnit *unit = (OCFMethodsUnit *)[self unitOfClass:OCFMethodsUnit.class];
    [unit revertClass:theClass classMethod:method];
}

- (void)revertClassMethods:(Class)theClass
{
    OCFMethodsUnit *unit = (OCFMethodsUnit *)[self unitOfClass:OCFMethodsUnit.class];
    [unit revertClassMethods:theClass];
}

- (void)revertAllMethods
{
    OCFMethodsUnit *unit = (OCFMethodsUnit *)[self unitOfClass:OCFMethodsUnit.class];
    [unit revertAllMethods];
}

@end
