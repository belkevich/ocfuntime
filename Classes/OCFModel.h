//
//  OCFModel.h
//  OCFuntime
//
//  Created by Alexey Belkevich on 4/22/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface OCFModel : NSObject

// initialization
- (id)initWithClass:(Class)theClass;
+ (id)modelWithClass:(Class)theClass;
// action
- (void)changeMethodSelector:(SEL)selector withBlock:(id)block;
- (void)revertMethodSelector:(SEL)selector;
- (void)revertModel;

@end