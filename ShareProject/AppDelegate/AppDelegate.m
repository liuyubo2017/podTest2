//
//  AppDelegate.m
//  ShareProject
//
//  Created by liuyubo on 2017/6/9.
//  Copyright © 2017年 liuyubo. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    FNMainTabbarVC *tabBarVC = [[FNMainTabbarVC alloc] init];
    self.window.rootViewController = tabBarVC;
    [self.window makeKeyAndVisible];
    FNAuthentication *auth = [[FNAuthentication alloc] init];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    
}


@end
