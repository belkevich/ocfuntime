//
//  OCFPropertyBlocksBuilder.h
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 7/2/14.
//  Copyright (c) 2014 okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OCFPropertyBlocksBuilder : NSObject

+ (id)swizzledMethodSignatureBlockWithDictionary:(NSDictionary *)dictionary;
+ (id)swizzledForwardInvocationBlockWithDictionary:(NSDictionary *)dictionary;
+ (id)injectedMethodSignatureBlockWithDictionary:(NSDictionary *)dictionary;
+ (id)injectedForwardInvocationBlockWithDictionary:(NSDictionary *)dictionary;

@end
