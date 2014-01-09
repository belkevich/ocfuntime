//
//  OCFPropertyMock.h
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 12/5/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct
{
    NSInteger firstValue;
    NSInteger secondValue;
} OCFSimpleStruct;

@interface OCFPropertyMock : NSObject

@property (nonatomic, strong) id objectStrongProperty;
@property (nonatomic, weak) id objectWeakProperty;
@property (nonatomic, copy) id objectCopyProperty;
@property (nonatomic, assign) NSInteger integerProperty;
@property (nonatomic, assign) char *pointerProperty;
@property (nonatomic, assign) OCFSimpleStruct structProperty;

@end
