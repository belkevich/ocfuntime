//
//  OCFPropertyBlocksBuilder.h
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 7/2/14.
//  Copyright (c) 2014 okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OCFPropertyBlocksBuilder : NSObject

+ (id)methodSignatureBlockWithDictionary:(NSDictionary *)dictionary;
+ (id)forwardInvocationBlockWithDictionary:(NSDictionary *)dictionary;

@end
