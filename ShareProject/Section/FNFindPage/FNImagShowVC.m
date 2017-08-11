//
//  FNImagShowVC.m
//  ShareProject
//
//  Created by liuyubo on 2017/6/21.
//  Copyright © 2017年 liuyubo. All rights reserved.
//

#import "FNImagShowVC.h"

@interface FNImagShowVC ()

@property (nonatomic , strong) UIButton *cancleBtn;
@property (nonatomic , strong) UIButton *confirmBtn;
@property (nonatomic , strong) UIImageView *imgView;

@end

@implementation FNImagShowVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setMainUI];
    [self setStateBtn];
}

- (void)setMainUI
{
    _imgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _imgView.image = _image;
    _imgView.userInteractionEnabled = YES;
    _imgView.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:_imgView];
}

- (void)setStateBtn
{
    _cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancleBtn.frame = CGRectMake(kScreenWidth / 2 - 100, kScreenHeight - 60, 40, 40);
    [_cancleBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [_cancleBtn setImage:[UIImage imageNamed:@"cancle"] forState:UIControlStateHighlighted];
    [_cancleBtn setImage:[UIImage imageNamed:@"cancle"] forState:UIControlStateNormal];
    [_imgView addSubview:_cancleBtn];
    
    _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _confirmBtn.frame = CGRectMake(kScreenWidth / 2 + 60, kScreenHeight - 60, 40, 40);
    [_confirmBtn addTarget:self action:@selector(saveVideo) forControlEvents:UIControlEventTouchUpInside];
    [_confirmBtn setImage:[UIImage imageNamed:@"confirm"] forState:UIControlStateNormal];
    [_confirmBtn setImage:[UIImage imageNamed:@"confirm"] forState:UIControlStateHighlighted];
    [_imgView addSubview:_confirmBtn];
}

- (void)dismiss
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"disappear" object:nil];
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}

- (void)saveVideo
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"disappear" object:nil];
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}

@end
