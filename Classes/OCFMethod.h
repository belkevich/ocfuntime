//
//  Created by Alexey Belkevich on 4/22/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface OCFMethod : NSObject

// initialization
- (id)initWithClass:(Class)theClass selector:(SEL)selector;
+ (id)methodWithClass:(Class)theClass selector:(SEL)selector;
// actions
- (void)changeImplementationWithBlock:(id)block;
- (void)revertImplementation;

@end