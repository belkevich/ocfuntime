//
//  OCFuntime_Private.h
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 7/10/14.
//  Copyright (c) 2014 okolodev. All rights reserved.
//

#import "OCFuntime.h"
#import "OCFUnitProtocol.h"

@interface OCFuntime ()

- (NSObject <OCFUnitProtocol> *)unitOfClass:(Class)theClass;

@end
