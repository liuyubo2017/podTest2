//
//  FNFindVC.m
//  ShareProject
//
//  Created by liuyubo on 2017/6/9.
//  Copyright © 2017年 liuyubo. All rights reserved.
//

#import "FNFindVC.h"

@interface FNFindVC () <AVCaptureFileOutputRecordingDelegate>

@property (nonatomic , strong) AVCaptureSession *session;
@property (nonatomic , strong) AVCaptureConnection *videoConnection;
@property (nonatomic , strong) AVCaptureDeviceInput *backCameraInput;
@property (nonatomic , strong) AVCaptureDeviceInput *frontCameraInput;
@property (nonatomic , strong) AVCaptureVideoPreviewLayer *preLayer;
@property (nonatomic , strong) AVCaptureDeviceInput *audioInput;// 麦克风输入
@property (nonatomic , strong) AVCaptureAudioDataOutput *audioOutput; // 麦克风输出
@property (nonatomic , strong) AVCaptureMovieFileOutput *captureMovieFileOutput; // 输出视频流
@property (nonatomic , strong) UIView *takeCaptureView;
@property (nonatomic , strong) AVCaptureStillImageOutput *stillImageOutpot; // 图片输出流对象
@property (nonatomic , strong) NSTimer *recodeTimer; // 录制时间
@property (nonatomic , assign) NSInteger second;
@property (nonatomic , strong) UIButton *rightBtn;
@property (nonatomic , strong) UIButton *rotateBtn;
@property (nonatomic , assign) BOOL isBack;

@end

@implementation FNFindVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"发现";
//    self.navigationController.navigationBar.hidden = YES;
    _isBack = YES;
    [self.session startRunning];
    [self.view.layer addSublayer:self.preLayer];
    [self.view.layer insertSublayer:self.takeCaptureView.layer above:_preLayer];
    [self setNavBar];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restartRunning) name:@"disappear" object:nil];
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        
    }];
}

- (void)setNavBar
{
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.frame = CGRectMake(0, 0, 60, 30);
    [_rightBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [_rightBtn setTitle:@"00:00" forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    _rotateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rotateBtn.frame = CGRectMake(kScreenWidth - 80, 84, 40, 40);
    [_rotateBtn setImage:[UIImage imageNamed:@"rotate"] forState:UIControlStateNormal];
    [_rotateBtn addTarget:self action:@selector(rotateAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_rotateBtn];
    [self.view.layer insertSublayer:_rotateBtn.layer above:self.preLayer];
}

- (void)rotateAction
{
    if (self.captureMovieFileOutput.isRecording) {
        [self.captureMovieFileOutput stopRecording];
    }
    if (self.session) {
        [self.session stopRunning];
    }
    if (_isBack) {
        [self.session removeInput:self.backCameraInput];
        if ([self.session canAddInput:self.frontCameraInput]) {
            [_session addInput:self.frontCameraInput];
        }
    }else{
        [self.session removeInput:self.frontCameraInput];
        if ([self.session canAddInput:self.backCameraInput]) {
            [self.session addInput:self.backCameraInput];
        }
    }
    _isBack = !_isBack;
    [self.session startRunning];
}

- (AVCaptureSession *)session
{
    if (_session == nil) {
        
        _session = [[AVCaptureSession alloc] init];
        
        if ([_session canAddInput:self.backCameraInput]) {
            [_session addInput:self.backCameraInput];
        }
        
        if ([_session canAddInput:self.audioInput]) {
            [_session addInput:self.audioInput];
        }
        
        if ([_session canAddOutput:self.captureMovieFileOutput]) {
            [_session addOutput:self.captureMovieFileOutput];
        }
        if ([_session canAddOutput:self.stillImageOutpot]) {
            [_session addOutput:_stillImageOutpot];
        }
        
        //设置分辨率
        if ([_session canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
            _session.sessionPreset = AVCaptureSessionPreset1280x720;
        }
        self.videoConnection.videoOrientation = AVCaptureVideoOrientationPortrait;
        
    }
    return _session;
}

- (AVCaptureDeviceInput *)backCameraInput
{
    if (!_backCameraInput) {
        _backCameraInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self backCamera] error:nil];
    }
    return _backCameraInput;
}

- (AVCaptureDeviceInput *)frontCameraInput
{
    if (!_frontCameraInput) {
        NSError *error;
        _frontCameraInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self frontCamera] error:&error];
        if (error) {
            NSLog(@"....");
        }
    }
    return _frontCameraInput;
}

- (AVCaptureDeviceInput *)audioInput
{
    if (!_audioInput) {
       AVCaptureDevice *mic = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
        _audioInput = [AVCaptureDeviceInput deviceInputWithDevice:mic error:nil];
    }
    return _audioInput;
}

- (AVCaptureStillImageOutput *)stillImageOutpot
{
    if (!_stillImageOutpot) {
        _stillImageOutpot = [[AVCaptureStillImageOutput alloc] init];
        NSDictionary * outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
        
        [_stillImageOutpot setOutputSettings:outputSettings];
    }
    return _stillImageOutpot;
}

- (AVCaptureMovieFileOutput *)captureMovieFileOutput
{
    if (!_captureMovieFileOutput) {
        _captureMovieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
        _captureMovieFileOutput.movieFragmentInterval = kCMTimeInvalid;
    }
    return _captureMovieFileOutput;
}

- (AVCaptureDevice *)backCamera
{
    return [self cameraWithPosition:AVCaptureDevicePositionBack];
}

- (AVCaptureDevice *)frontCamera
{
    return [self cameraWithPosition:AVCaptureDevicePositionFront];
}

//用来返回是前置摄像头还是后置摄像头
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition) position {
    //返回和视频录制相关的所有默认设备
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    //遍历这些设备返回跟position相关的设备
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            return device;
        }
    }
    return nil;
}

- (AVCaptureVideoPreviewLayer *)preLayer
{
    if (!_preLayer) {
        _preLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        _preLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [_preLayer setFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 113)];
    }
    return _preLayer;
}

- (AVCaptureConnection *)videoConnection
{
    _videoConnection = [self.captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
    return _videoConnection;
}

- (UIView *)takeCaptureView
{
    if (!_takeCaptureView) {
        _takeCaptureView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - 40, kScreenHeight - 129, 80, 80)];
        _takeCaptureView.backgroundColor = [UIColor redColor];
        _takeCaptureView.layer.masksToBounds = YES;
        _takeCaptureView.layer.cornerRadius = 40.0;
        [self.view addSubview:_takeCaptureView];
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            [self shutterCamera];
        }];
        [_takeCaptureView addGestureRecognizer:tapGes];

        UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [_takeCaptureView addGestureRecognizer:longPressGes];
    }
    return _takeCaptureView;
}

- (void)longPress:(UILongPressGestureRecognizer *)longPress
{
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan:
            if (!_session.isRunning) {
                [_session startRunning];
            }
            break;
        case UIGestureRecognizerStateChanged:
            [self startMovieRecord];
            break;
        case UIGestureRecognizerStateEnded:
        {
            [_recodeTimer invalidate];
            _recodeTimer = nil;
            if (self.captureMovieFileOutput.isRecording) {
                [self.captureMovieFileOutput stopRecording];
            }
            if (_session.isRunning) {
                [_session stopRunning];
            }
        }break;
        default:
            break;
    }
}

- (void)startMovieRecord
{
    if (self.captureMovieFileOutput.isRecording) {
        return;
    }
    _second = 0;
    _videoConnection = [self.captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
    NSString *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSDate *date = [NSDate date];
    filePath = [filePath stringByAppendingString:[NSString stringWithFormat:@"/%ld-%ld-%ld-%ld-%ld-%ld.mp4" , date.year , date.month , date.day , date.hour , date.minute , date.second]];
    NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
    [self.captureMovieFileOutput startRecordingToOutputFileURL:fileUrl recordingDelegate:self];
    if (!_recodeTimer) {
        _recodeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 block:^(NSTimer * _Nonnull timer) {
            dispatch_async(dispatch_get_main_queue(), ^{
                _second++;
                [_rightBtn setTitle:[self translateSecondToString:_second] forState:UIControlStateNormal];
            });
            
        } repeats:YES];
    }
}

- (NSString *)translateSecondToString:(NSInteger)second
{
    NSString *value;
    if (second < 60) {
        value = [NSString stringWithFormat:@"00:%.2ld" , second];
    }else{
        NSInteger sec = second % 60;
        NSInteger min = sec / 60;
        value = [NSString stringWithFormat:@"%.2ld:%.2ld" , min , sec];
    }
    NSLog(@"%@  %ld" , value ,second);
    return value;
}


#pragma mark AVCaptureFileOutputRecordingDelegate
// 开始录制
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections
{
    NSLog(@"start record");
}

// 结束录制
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    NSLog(@"finsh record");
    FNVideoPlayVC *vc = [[FNVideoPlayVC alloc] init];
    vc.videoUrl = outputFileURL;
    [self presentViewController:vc animated:NO completion:^{
        
    }];
}

// 拍照
- (void)shutterCamera
{
    
    _videoConnection = [self.stillImageOutpot connectionWithMediaType:AVMediaTypeVideo];
    
    if (!_videoConnection) {
        
        NSLog(@"take photo failed");
        
        return;
        
    }
    
    [self.stillImageOutpot captureStillImageAsynchronouslyFromConnection:_videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        
        if (imageDataSampleBuffer == NULL) {
            
            return ;
            
        }
        
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        
        UIImage *image = [UIImage imageWithData:imageData];
        
        NSLog(@"image size:%@" , NSStringFromCGSize(image.size));
        
//        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
//            [PHAssetChangeRequest creationRequestForAssetFromImage:image];
//        } completionHandler:^(BOOL success, NSError * _Nullable error) {
//            if (success) {
//                UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"提示" message:@"图片已保存到相册" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                [alt show];
//            }else
//            {
//                UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无相册访问权限" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                [alt show];
//            }
//        }];
        FNImagShowVC *VC = [[FNImagShowVC alloc] init];
        VC.image = image;
        [self presentViewController:VC animated:NO completion:^{
            
        }];
        [_session stopRunning];
        
    }];
    
}

- (void)restartRunning
{
    [_rightBtn setTitle:@"00:00" forState:UIControlStateNormal];
    [_session startRunning];
}

@end




























