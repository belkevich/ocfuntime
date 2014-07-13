//
//  OCFMethodsUnit.h
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 7/10/14.
//  Copyright (c) 2014 okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCFUnitProtocol.h"

@interface OCFMethodsUnit : NSObject <OCFUnitProtocol>

- (void)changeClass:(Class)theClass instanceMethod:(SEL)method implementation:(id)block;
- (void)changeClass:(Class)theClass classMethod:(SEL)method implementation:(id)block;
- (void)revertClass:(Class)theClass instanceMethod:(SEL)method;
- (void)revertClass:(Class)theClass classMethod:(SEL)method;
- (void)revertClassMethods:(Class)theClass;
- (void)revertAllMethods;

@end
