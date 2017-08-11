//
//  FNVideoPlayVC.m
//  ShareProject
//
//  Created by liuyubo on 2017/6/21.
//  Copyright © 2017年 liuyubo. All rights reserved.
//

#import "FNVideoPlayVC.h"

@interface FNVideoPlayVC ()

@property (nonatomic , strong) UIButton *cancleBtn;
@property (nonatomic , strong) UIButton *confirmBtn;
@property (nonatomic , strong) AVPlayer *player;
@property (nonatomic , strong) AVPlayerItem *playerItem;
@property (nonatomic , strong) AVPlayerLayer *playerLayer;

@end

@implementation FNVideoPlayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setStateBtn];
    [self setMainUI];
}

- (void)setStateBtn
{
    _cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancleBtn.frame = CGRectMake(kScreenWidth / 2 - 100, kScreenHeight - 60, 40, 40);
    [_cancleBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [_cancleBtn setImage:[UIImage imageNamed:@"cancle"] forState:UIControlStateHighlighted];
    [_cancleBtn setImage:[UIImage imageNamed:@"cancle"] forState:UIControlStateNormal];
    [self.view addSubview:_cancleBtn];
    
    _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _confirmBtn.frame = CGRectMake(kScreenWidth / 2 + 60, kScreenHeight - 60, 40, 40);
    [_confirmBtn addTarget:self action:@selector(saveVideo) forControlEvents:UIControlEventTouchUpInside];
    [_confirmBtn setImage:[UIImage imageNamed:@"confirm"] forState:UIControlStateNormal];
    [_confirmBtn setImage:[UIImage imageNamed:@"confirm"] forState:UIControlStateHighlighted];
    [self.view addSubview:_confirmBtn];
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

- (void)setMainUI
{
    _playerItem = [AVPlayerItem playerItemWithURL:_videoUrl];
    _player = [AVPlayer playerWithPlayerItem:_playerItem];
    [_player play];
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    [_playerLayer setFrame:self.view.bounds];
    [self.view.layer addSublayer:_playerLayer];
    [self.view.layer insertSublayer:_cancleBtn.layer above:_playerLayer];
    [self.view.layer insertSublayer:_confirmBtn.layer above:_playerLayer];
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(playerItemDidReachEnd)
     
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
     
                                               object:_playerItem];
}

- (void)playerItemDidReachEnd
{
    [_player seekToTime:CMTimeMake(0, 1)];
    [_player play];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_player pause];
    [_player replaceCurrentItemWithPlayerItem:nil];
    _player = nil;
    _playerItem = nil;
    [_playerLayer removeFromSuperlayer];
    _playerLayer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc
{
    NSLog(@"dealloc");
}


@end
