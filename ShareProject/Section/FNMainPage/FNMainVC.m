//
//  FNMainVC.m
//  ShareProject
//
//  Created by liuyubo on 2017/6/9.
//  Copyright © 2017年 liuyubo. All rights reserved.
//

#import "FNMainVC.h"

@interface FNMainVC ()

@property (nonatomic , strong) AVCaptureSession *session; // 连接数据输入输出流
@property (nonatomic , strong) AVCaptureDeviceInput *captureInput; // 对象是输入流
@property (nonatomic , strong) AVCaptureStillImageOutput *stillImageOutpot; // 图片输出流对象
@property (nonatomic , strong) AVCaptureVideoPreviewLayer *previewLayer; // 预览层

@end

@implementation FNMainVC

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"首页";
    
    [self initCaptureSession];
    
    [self initLayer];
    
}

- (void)setMainUI
{
    
}

- (void)initLayer
{
        
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    
    self.previewLayer.frame = self.view.bounds;
    
    self.previewLayer.backgroundColor = [UIColor clearColor].CGColor;
    
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
    
    [self.view.layer addSublayer:self.previewLayer];
    
    UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    startBtn.frame = CGRectMake(kScreenWidth / 2 - 50, kScreenHeight - 149, 100, 100);
    
    startBtn.layer.masksToBounds = YES;
    
    startBtn.layer.cornerRadius = 50.0;
    
    startBtn.backgroundColor = [UIColor clearColor];
    
    startBtn.layer.backgroundColor = [UIColor whiteColor].CGColor;
    
    [startBtn addTarget:self action:@selector(startCapture) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:startBtn];
    
    [self.view.layer insertSublayer:startBtn.layer above:self.previewLayer];
    
}
- (void)startCapture
{
    
    if ([_session isRunning]) {
        
        [self shutterCamera];
        
    }else{
        
        [_session startRunning];
        
    }
}

- (void)initCaptureSession
{
    _session = [[AVCaptureSession alloc] init];
    
    self.captureInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self backCamera] error:nil];
    
    self.stillImageOutpot = [[AVCaptureStillImageOutput alloc] init];
    
    NSDictionary * outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    
    [self.stillImageOutpot setOutputSettings:outputSettings];
    
    if ([_session canAddInput:_captureInput]) {
        
        [_session addInput:_captureInput];
        
    }
    
    if ([_session canAddOutput:_stillImageOutpot]) {
        
        [_session addOutput:_stillImageOutpot];
        
    }
    
//    [_session startRunning];
    
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition) position {
    
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    
    for (AVCaptureDevice *device in devices) {
        
        if ([device position] == position) {
            
            return device;
            
        }
        
    }
    
    return nil;
    
}

- (AVCaptureDevice *)frontCamera
{
    return [self cameraWithPosition:AVCaptureDevicePositionFront];
}

- (AVCaptureDevice *)backCamera
{
    return [self cameraWithPosition:AVCaptureDevicePositionBack];
}

- (void)shutterCamera
{
    
    AVCaptureConnection * videoConnection = [self.stillImageOutpot connectionWithMediaType:AVMediaTypeVideo];
    
    if (!videoConnection) {
        
        NSLog(@"take photo failed");
        
        return;
        
    }
    
    [self.stillImageOutpot captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
       
        if (imageDataSampleBuffer == NULL) {
            
            return ;
            
        }
        
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        
        UIImage *image = [UIImage imageWithData:imageData];
        
        NSLog(@"image size:%@" , NSStringFromCGSize(image.size));
        
        [_session stopRunning];
        
    }];
    
}


@end
