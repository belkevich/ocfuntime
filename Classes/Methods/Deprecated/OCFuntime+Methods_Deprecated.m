//
//  OCFuntime+Methods_Deprecated.m
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 7/13/14.
//  Copyright (c) 2014 okolodev. All rights reserved.
//

#import "OCFuntime+Methods_Deprecated.h"
#import "OCFuntime+Methods.h"

@implementation OCFuntime (Methods_Deprecated)

- (void)revertClass:(Class)theClass
{
    [self revertClassMethods:theClass];
}

- (void)revertAll
{
    [self revertAllMethods];
}

@end
