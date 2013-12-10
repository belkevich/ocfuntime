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
    NSMutableDictionary *instanceMethods;
    NSMutableDictionary *classMethods;
}

// initialization
- (id)initWithClass:(Class)theClass;
+ (instancetype)modelWithClass:(Class)theClass;
// actions
- (void)changeInstanceMethod:(SEL)selector withBlock:(id)block;
- (void)changeClassMethod:(SEL)selector withBlock:(id)block;
- (void)revertMethod:(SEL)selector;
- (void)revertClassMethod:(SEL)selector;
- (void)revertModel;

@end