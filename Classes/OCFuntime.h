//
//  OCFuntime.h
//  OCFuntime
//
//  Created by Alexey Belkevich on 4/22/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface OCFuntime : NSObject

// actions
- (void)changeClass:(Class)theClass method:(SEL)method implementation:(id)block;
- (void)revertClass:(Class)theClass method:(SEL)method;
- (void)revertClass:(Class)theClass;
- (void)revertAll;

@end