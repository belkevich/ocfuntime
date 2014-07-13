//
//  OCFuntime+Methods.h
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 7/10/14.
//  Copyright (c) 2014 okolodev. All rights reserved.
//

#import "OCFuntime.h"
#import "OCFuntime+Methods_Deprecated.h"

@interface OCFuntime (Methods)

- (void)changeClass:(Class)theClass instanceMethod:(SEL)method implementation:(id)block;
- (void)changeClass:(Class)theClass classMethod:(SEL)method implementation:(id)block;
- (void)revertClass:(Class)theClass instanceMethod:(SEL)method;
- (void)revertClass:(Class)theClass classMethod:(SEL)method;
- (void)revertClassMethods:(Class)theClass;
- (void)revertAllMethods;

@end