//
//  OCFInvocationInjector 
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 13.06.16.
//  Copyright © 2016 okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OCFInvocationInjector : NSObject

- (instancetype)initWithClass:(Class)aClass
         signaturesDictionary:(NSDictionary *)signatures
         attributesDictionary:(NSDictionary *)attributes;
- (void)injectMethodSignatureMethod;
- (void)injectForwardInvocationMethod;
- (void)revertMethodSignatureMethod;
- (void)revertForwardInvocationMethod;

@end