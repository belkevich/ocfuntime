//
//  OCFModel.h
//  OCFuntime
//
//  Created by Alexey Belkevich on 4/22/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface OCFModel : NSObject
{
@private
    Class theClass;
    NSMutableDictionary *methods;
}

// initialization
- (id)initWithClass:(Class)theClass;
+ (id)modelWithClass:(Class)theClass;
// action
- (void)changeInstanceMethod:(SEL)selector withBlock:(id)block;
- (void)changeClassMethod:(SEL)selector withBlock:(id)block;
- (void)revertMethodSelector:(SEL)selector;
- (void)revertModel;

@end