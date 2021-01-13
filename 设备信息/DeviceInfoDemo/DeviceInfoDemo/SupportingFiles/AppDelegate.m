//
//  AppDelegate.m
//  DeviceInfoDemo
//
//  Created by 谢佳培 on 2020/9/4.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewConttroller.h"
#import "JumpToOtherAPPViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    JumpToOtherAPPViewController *rootVC = [[JumpToOtherAPPViewController alloc] init];
    UINavigationController *mainNC = [[UINavigationController alloc] initWithRootViewController:rootVC];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = mainNC;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
