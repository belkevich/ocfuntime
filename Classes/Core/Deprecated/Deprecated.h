//
//  Deprecated.h
//  OCFuntime
//
//  Created by Alexey Belkevich on 7/13/14.
//  Copyright (c) 2014 okolodev. All rights reserved.
//

#ifndef OCFuntime_Deprecated_h
#define OCFuntime_Deprecated_h

#define OCF_DEPRECATED(_useInstead) __attribute__((deprecated("Use " #_useInstead " instead")))

#endif
