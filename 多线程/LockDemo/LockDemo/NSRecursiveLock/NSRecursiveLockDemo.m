//
//  NSRecursiveLockDemo.m
//  多线程Demo
//
//  Created by 谢佳培 on 2020/7/16.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import "NSRecursiveLockDemo.h"

@interface NSRecursiveLockDemo()

@property (nonatomic,strong) NSRecursiveLock *lock;

@end

@implementation NSRecursiveLockDemo

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.lock =[[NSRecursiveLock alloc] init];
    }
    return self;
}

// 存钱
- (void)saveMoney
{
    [self.lock lock];// 加锁
    [super saveMoney];
    [self.lock unlock];// 解锁
}

// 取钱
- (void)drawMoney
{
    [self.lock lock];// 加锁
    [super drawMoney];
    [self.lock unlock];// 解锁
}

@end
