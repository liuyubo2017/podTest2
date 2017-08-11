//
//  FNMainTabbarVC.m
//  ShareProject
//
//  Created by liuyubo on 2017/6/9.
//  Copyright © 2017年 liuyubo. All rights reserved.
//

#import "FNMainTabbarVC.h"

@interface FNMainTabbarVC () <UITabBarControllerDelegate>

@end

@implementation FNMainTabbarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FNMainVC *mainVC = [[FNMainVC alloc] init];
    UINavigationController *NC1 = [[UINavigationController alloc] initWithRootViewController:mainVC];
    FNFindVC *findVC = [[FNFindVC alloc] init];
    UINavigationController *NC2 = [[UINavigationController alloc] initWithRootViewController:findVC];
    FNMsgVC *msgVC = [[FNMsgVC alloc] init];
    UINavigationController *NC3 = [[UINavigationController alloc] initWithRootViewController:msgVC];
    FNMineVC *mineVC = [[FNMineVC alloc] init];
    UINavigationController *NC4 = [[UINavigationController alloc] initWithRootViewController:mineVC];
    [self setViewControllers:@[NC1,NC2,NC3,NC4]];
    
    [self initTabBar];
    
}

- (void)initTabBar
{
    
    self.delegate = self;
    
    self.tabBar.tintColor = [UIColor whiteColor];
    
    NSArray *titles = @[@"首页", @"发现", @"消息", @"我的"];
    
    NSArray *images = @[@"tabbar_witalk_nor",@"tabbar_online_nor",@"tabbar_address_nor",@"tabbar_mine_nor"];
    
    NSArray *selected = @[@"tabbar_witalk_sel",@"tabbar_online_sel",@"tabbar_address_sel",@"tabbar_mine_sel"];
    
    for (int i = 0; i<titles.count; i++)
    {
        UITabBarItem *home = [[UITabBarItem alloc]initWithTitle:titles[i] image:[UIImage imageNamed:images[i]] tag:i];
        
        home.selectedImage = [[UIImage imageNamed:selected[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        [self.viewControllers[i] setTabBarItem:home];
        
    }
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateSelected];
    
}


@end
