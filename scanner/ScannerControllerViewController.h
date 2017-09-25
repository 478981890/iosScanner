//
//  ScannerControllerViewController.h
//  SZQRCodeViewController
//
//  Created by tsm on 2017/9/1.
//  Copyright © 2017年 StephenZhuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface ScannerControllerViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate,UITextFieldDelegate>
{
    BOOL hasCameraRight;
    BOOL isLight;
}
@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;
@property (nonatomic, retain) UIImageView * line;
@property (strong,nonatomic)UITextField * textField;
@end
