//
//  NSObject+OCFMethods.h
//  OCFuntime
//
//  Created by Alexey Belkevich on 12/2/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (OCFMethods)

+ (void)changeInstanceMethod:(SEL)method implementation:(id)block;
+ (void)changeClassMethod:(SEL)method implementation:(id)block;
+ (void)revertInstanceMethod:(SEL)method;
+ (void)revertClassMethod:(SEL)method;
+ (void)revertMethods;

@end
