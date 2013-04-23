//
//  OCFuntime.h
//  OCFuntime
//
//  Created by Alexey Belkevich on 4/22/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface OCFuntime : NSObject
{
@private
    NSMutableDictionary *classes;
}

// actions
- (void)changeClass:(Class)theClass instanceMethod:(SEL)method implementation:(id)block;
- (void)changeClass:(Class)theClass classMethod:(SEL)method implementation:(id)block;
- (void)revertClass:(Class)theClass method:(SEL)method;
- (void)revertClass:(Class)theClass;
- (void)revertAll;

@end