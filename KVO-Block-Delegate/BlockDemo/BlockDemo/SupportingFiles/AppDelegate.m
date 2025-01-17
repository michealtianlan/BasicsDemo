//
//  AppDelegate.m
//  BlockDemo
//
//  Created by 谢佳培 on 2020/10/16.
//

#import "AppDelegate.h"
#import "BasicUseBlockViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    BasicUseBlockViewController *rootVC = [[BasicUseBlockViewController alloc] init];
    UINavigationController *mainNC = [[UINavigationController alloc] initWithRootViewController:rootVC];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = mainNC;
    [self.window makeKeyAndVisible];

    return YES;
}

@end
