//
//  OCFuntime+Methods_Deprecated.h
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 7/13/14.
//  Copyright (c) 2014 okolodev. All rights reserved.
//

#import "OCFuntime.h"
#import "Deprecated.h"

@interface OCFuntime (Methods_Deprecated)

- (void)revertClass:(Class)theClass OCF_DEPRECATED("revertClassMethods:");
- (void)revertAll OCF_DEPRECATED("revertAllMethods");

@end
