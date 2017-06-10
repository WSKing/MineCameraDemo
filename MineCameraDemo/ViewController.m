//
//  ViewController.m
//  MineCameraDemo
//
//  Created by wsk on 17/6/10.
//  Copyright © 2017年 wsk. All rights reserved.
//

#import "ViewController.h"
#import "GPUImage.h"
@interface ViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (nonatomic, assign) BOOL isVideo;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isVideo = NO;
}

- (IBAction)takePhoto:(UIButton *)sender {
    [self presentViewController:self.imagePicker animated:YES completion:^{
        
    }];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    // 如果是拍照
        UIImage *image;
            // 获取编辑后的照片
        image = [info objectForKey:UIImagePickerControllerEditedImage];
    //用GPUImagePicture拿到你要处理的图片
    GPUImagePicture *picture = [[GPUImagePicture alloc] initWithImage:image];
    //创建滤镜
    GPUImageOutput<GPUImageInput> *filter = [[GPUImageSoftEleganceFilter alloc] init];
    //添加滤镜
    [picture addTarget:filter];
    //处理图片
    [filter useNextFrameForImageCapture];
    [picture processImage];
    //获取处理后的图片
    UIImage *dealtImg = [filter imageFromCurrentFramebuffer];
    
    // 显示照片
    self.imgView.image = dealtImg;

    [self dismissViewControllerAnimated:YES completion:nil];
}


- (UIImagePickerController *)imagePicker{
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc]init];
        // 判断现在可以获得多媒体的方式
        if ([UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera]) {
            // 设置image picker的来源，这里设置为摄像头
            _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            // 设置使用哪个摄像头，这里默认设置为前置摄像头
            _imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
                // 设置摄像头模式为照相
            _imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    
        }
        else {
            _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        // 允许编辑
        _imagePicker.allowsEditing=YES;
        // 设置代理，检测操作
        _imagePicker.delegate=self;
    }
    return _imagePicker;
}

@end
