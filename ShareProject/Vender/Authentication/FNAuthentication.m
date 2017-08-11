//
//  FNAuthentication.m
//  ShareProject
//
//  Created by liuyubo on 2017/6/9.
//  Copyright © 2017年 liuyubo. All rights reserved.
//

#import "FNAuthentication.h"

@implementation FNAuthentication

- (instancetype)init
{
    self = [super init];
    if (self) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            
        }];
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            
        }];
    }
    return self;
}

@end
