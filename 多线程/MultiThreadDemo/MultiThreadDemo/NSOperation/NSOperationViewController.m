//
//  NSOperationViewController.m
//  MultiThreadDemo
//
//  Created by 谢佳培 on 2020/8/18.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import "NSOperationViewController.h"

@implementation CustomOperation

// ou should override this method to perform the desired task.
// In your implementation, do not invoke super.
// This method will automatically execute within an autorelease pool provided by NSOperation
- (void)main
{
    for (int i = 0; i < 3; i++)
    {
        NSLog(@"NSOperation的子类CustomOperation======%@",[NSThread currentThread]);
    }
}

@end

@interface NSOperationViewController ()

@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, strong) NSInvocationOperation *invocationOperation;

@end

@implementation NSOperationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addOperationToQueue];
}
 
// 使用子类 NSInvocationOperation
- (void)useInvocationOperation {
    // 1.创建 NSInvocationOperation 对象
    NSInvocationOperation *invocationOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(invocationOperationEvent) object:nil];

    // 2.调用 start 方法开始执行操作
    [invocationOperation start];
}

- (void)invocationOperationEvent {
    NSLog(@"NSInvocationOperation包含的任务，没有加入队列========%@", [NSThread currentThread]);
}

- (void)useBlockOperation {
    // 1.创建 NSBlockOperation 对象
    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"NSBlockOperation包含的任务，没有加入队列========%@", [NSThread currentThread]);
    }];
    
    // 2.调用 start 方法开始执行操作
    [blockOperation start];
}

// addExecutionBlock:实现多线程
- (void)testNSBlockOperationExecution {
    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"NSBlockOperation运用addExecutionBlock========%@", [NSThread currentThread]);
    }];
    
    [blockOperation addExecutionBlock:^{
        NSLog(@"addExecutionBlock方法添加任务1========%@", [NSThread currentThread]);
    }];
    [blockOperation addExecutionBlock:^{
        NSLog(@"addExecutionBlock方法添加任务2========%@", [NSThread currentThread]);
    }];
    [blockOperation addExecutionBlock:^{
        NSLog(@"addExecutionBlock方法添加任务3========%@", [NSThread currentThread]);
    }];
    
    [blockOperation start];
}

// 使用继承自NSOperation的子类
- (void)testCustomOperation
{
    CustomOperation *operation = [[CustomOperation alloc] init];
    [operation start];
}

// 暂停或者继续操作
- (void)pauseOrContinue
{
    if (self.queue.operationCount == 0)
    {
        NSLog(@"当前没有操作，没有必要挂起和继续");
        return;
    }
    
    if (self.queue.suspended)
    {
        NSLog(@"当前是挂起状态，准备继续");
    }
    else
    {
        // 正在执行的操作无法挂起，当前操作执行完毕后开始挂起，下个操作不再执行
        NSLog(@"当前为执行状态，准备挂起");
    }
    self.queue.suspended = !self.queue.isSuspended;
}

// 取消操作
- (void)cancelOperation
{
    [self.queue cancelAllOperations];// 取消所有操作
    [self.invocationOperation cancel];// 取消NSOperation的某个操作
}

#pragma mark - 将操作添加到队列

- (void)addOperationToQueue {
    // 1.创建队列，默认并发
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    // 2.创建操作
    // 使用 NSInvocationOperation 创建操作1
    NSInvocationOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(invocationOperationAddOperation) object:nil];
    
    // 使用 NSInvocationOperation 创建操作2
    NSInvocationOperation *op2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(invocationOperationAddOperation) object:nil];
    
    // 使用 NSBlockOperation 创建操作3
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"blockOperationWithBlock ======%@", [NSThread currentThread]);
        }
    }];
    
    [op3 addExecutionBlock:^{
        NSLog(@"addExecutionBlock ======%@", [NSThread currentThread]);
    }];
    
    // 3.使用 addOperation: 添加所有操作到队列中
    [queue addOperation:op1];
    [queue addOperation:op2];
    [queue addOperation:op3];
}

- (void)invocationOperationAddOperation
{
    NSLog(@"invocationOperationAddOperation ===%@", [NSThread currentThread]);
}

- (void)addOperationWithBlock
{
    // 创建队列，默认并发
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    // 添加操作到队列
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 3; i++)
        {
            NSLog(@"addOperationWithBlock把任务添加到队列======%@", [NSThread currentThread]);
        }
    }];
}
 
- (void)maxConcurrentOperationCount
{
    // 创建队列，默认并发
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    // 最大并发数为1，串行
    // queue.maxConcurrentOperationCount = 1;
    // 最大并发数为2，并发
    queue.maxConcurrentOperationCount = 2;
    
    // 添加操作到队列1
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 3; i++)
        {
            NSLog(@"addOperationWithBlock把操作添加到队列1======%@", [NSThread currentThread]);
        }
    }];
    
    // 添加操作到队列
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 3; i++)
        {
            NSLog(@"addOperationWithBlock把操作添加到队列2======%@", [NSThread currentThread]);
        }
    }];
    
    // 添加操作到队列
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 3; i++)
        {
            NSLog(@"addOperationWithBlock把操作添加到队列3======%@", [NSThread currentThread]);
        }
    }];
}

// 操作依赖
- (void)addDependency
{
    // 并发队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    // 操作1
    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 3; i++)
        {
            NSLog(@"operation1======%@", [NSThread  currentThread]);
        }
    }];
    
    // 操作2
    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"****operation2依赖于operation1，只有当operation1执行完毕，operation2才会执行****");
        for (int i = 0; i < 3; i++)
        {
            NSLog(@"operation2======%@", [NSThread  currentThread]);
        }
    }];
    
    // 使操作2依赖于操作1
    [operation2 addDependency:operation1];
    
    // 把操作加入队列
    [queue addOperation:operation1];
    [queue addOperation:operation2];
}

//A B C D E F
//A,B - D
//B,C - E
//D,E - F
- (void)addDependencyDemo
{
    //A
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 3; i ++)
        {
            NSLog(@"A --------------- %@", [NSThread currentThread]);
        }
    }];
    
    //B
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 3; i ++)
        {
            NSLog(@"B --------------- %@", [NSThread currentThread]);
        }
    }];
    
    //C
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 3; i ++)
        {
            NSLog(@"C --------------- %@", [NSThread currentThread]);
        }
    }];
    
    //D
    NSBlockOperation *op4 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 3; i ++)
        {
            NSLog(@"D --------------- %@", [NSThread currentThread]);
        }
    }];
    
    //E
    NSBlockOperation *op5 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 3; i ++)
        {
            NSLog(@"E --------------- %@", [NSThread currentThread]);
        }
    }];
    
    //F
    NSBlockOperation *op6 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 3; i ++)
        {
            NSLog(@"F --------------- %@", [NSThread currentThread]);
        }
    }];
    
    // 配置依赖关系
    [op4 addDependency: op1];
    [op4 addDependency: op2];
    
    [op5 addDependency: op2];
    [op5 addDependency: op3];
    
    [op6 addDependency:op4];
    [op6 addDependency:op5];
    
    // 在操作队列中添加任务
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    // 并发与否取决于这个值
    queue.maxConcurrentOperationCount = 6;
    
    [queue addOperation: op6];
    [queue addOperation: op5];
    [queue addOperation: op4];
    [queue addOperation: op3];
    [queue addOperation: op2];
    [queue addOperation: op1];
}

// 优先级：不是说设置高优先级就一定全部先完成，只是让CPU有更高的几率去调用它
- (void)testQualityOfService
{
    // 创建吃饭的操作
    NSBlockOperation *eatBlockOperation = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 10; i++)
        {
            NSLog(@"人是铁饭是钢一顿不吃饿得慌～，%d --- %@", i, [NSThread currentThread]);
        }
    }];
    // 设置优先级为用户交互
    eatBlockOperation.qualityOfService = NSQualityOfServiceUserInteractive;
    
    // 创建睡觉的操作
    NSBlockOperation *sleepBlockOperation = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 10; i++)
        {
            NSLog(@"老师别布置作业了，我好困啊～，%d --- %@", i, [NSThread currentThread]);
        }
    }];
    // 设置优先级为后台任务
    sleepBlockOperation.qualityOfService = NSQualityOfServiceBackground;
    
    // 创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    // 添加操作到队列
    [queue addOperation:eatBlockOperation];
    [queue addOperation:sleepBlockOperation];
}


@end



