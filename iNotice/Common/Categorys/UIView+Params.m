//
//  UIView+Params.m
//  TestNewIOS7
//
//  Created by Radar on 13-8-31.
//  Copyright (c) 2013年 www.dangdang.com. All rights reserved.
//

#import "UIView+Params.h"
#import <objc/runtime.h>


@implementation UIView (Params)
@dynamic mutex;

static const void *mutexKey = &mutexKey;


//扩展属性数据
- (BOOL)mutex
{
    NSNumber *nmutex = objc_getAssociatedObject(self, mutexKey);
    BOOL mtx = NO;
    if(nmutex) mtx = [nmutex boolValue];
    
    return mtx;
}

- (void)setMutex:(BOOL)mutex
{
    NSNumber *nmutex = [NSNumber numberWithBool:mutex];
    objc_setAssociatedObject(self, mutexKey, nmutex, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}






@end
