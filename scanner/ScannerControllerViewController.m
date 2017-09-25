//
//  ScannerControllerViewController.m
//  SZQRCodeViewController
//
//  Created by tsm on 2017/9/1.
//  Copyright © 2017年 StephenZhuang. All rights reserved.
//

#import "ScannerControllerViewController.h"
#import "IosToast+UIView.h"
#import "UIButton+Border.h"
#define QRCODE_WIDTH  260.0   //正方形二维码的边长
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width   //设备屏幕的宽度
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height //设备屏幕的高度
#define HEADER_HEIGHT 64
#define CART @"scanAssets.bundle/cart.png"
#define FLASH @"scanAssets.bundle/flash.png"
#define LINE @"scanAssets.bundle/line@2x.png"
enum ACTION_TYPE{
    ADDTOSHOPCART = 0,
    DELFROMSHOPCART = 1
};
@interface ScannerControllerViewController ()

@end

@implementation ScannerControllerViewController



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    // Do any additional setup after loading the view.
    [super viewDidLoad];
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.title = @"二维码／条码";
//    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:55/255 green:56/255 blue:62/255 alpha:1]];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    NSString *mediaType = AVMediaTypeVideo;
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"没有相机权限" message:@"请去设置-隐私-相机中对爱儿邦授权" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertController addAction:okAction];
        
        hasCameraRight = NO;
        return;
    }
    hasCameraRight = YES;
    
    [self addBackgroud];
    [self addMark];
    [self setupCamera];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAction:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAction:) name:UIKeyboardWillHideNotification object:nil];
    self.textField = [self.view viewWithTag:2];
    
}
- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize

{
    
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
                                [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
                                UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
                                UIGraphicsEndImageContext();
                                
                                return scaledImage;
                                
                                }
-(void) addBackgroud
{
    //设置统一的视图颜色和视图的透明度
    UIColor *color = [UIColor colorWithRed:92.0/255 green:90.0/255 blue:92.0/255 alpha:0.7];
    
    NSLog(@"%f",SCREEN_HEIGHT);
    NSLog(@"%f",SCREEN_WIDTH);
    //设置扫描区域外部上部的视图
    CGFloat topViewHeight = (SCREEN_HEIGHT-HEADER_HEIGHT-QRCODE_WIDTH)/2.0-HEADER_HEIGHT;
    NSLog(@"%f",topViewHeight);
    UIView *topView = [[UIView alloc]init];
    topView.frame = CGRectMake(0, HEADER_HEIGHT, SCREEN_WIDTH, topViewHeight);
    topView.backgroundColor = color;
    
    //设置扫描区域外部左边的视图
    UIView *leftView = [[UIView alloc]init];
    leftView.frame = CGRectMake(0, HEADER_HEIGHT+topViewHeight, (SCREEN_WIDTH-QRCODE_WIDTH)/2.0,QRCODE_WIDTH);
    leftView.backgroundColor = color;
 
    
    //设置扫描区域外部右边的视图
    UIView *rightView = [[UIView alloc]init];
    rightView.frame = CGRectMake((SCREEN_WIDTH-QRCODE_WIDTH)/2.0+QRCODE_WIDTH,HEADER_HEIGHT+topViewHeight, (SCREEN_WIDTH-QRCODE_WIDTH)/2.0,QRCODE_WIDTH);
    rightView.backgroundColor = color;
  
    
    //设置扫描区域外部底部的视图
    UIView *botView = [[UIView alloc]init];
    botView.frame = CGRectMake(0, HEADER_HEIGHT+QRCODE_WIDTH+topViewHeight,SCREEN_WIDTH,SCREEN_HEIGHT-HEADER_HEIGHT-QRCODE_WIDTH-topViewHeight);
    botView.backgroundColor = color;
    
    
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, QRCODE_WIDTH, 2)];
    _line.image = [UIImage imageNamed:LINE];
    _line.center = CGPointMake(SCREEN_WIDTH/2, topViewHeight + HEADER_HEIGHT);
    CABasicAnimation *scanNetAnimation = [CABasicAnimation animation];
    scanNetAnimation.keyPath = @"transform.translation.y";
    scanNetAnimation.byValue = @(QRCODE_WIDTH);
    scanNetAnimation.duration = 2.0;
    scanNetAnimation.repeatCount = MAXFLOAT;
    [_line.layer addAnimation:scanNetAnimation forKey:nil];
    //将设置好的扫描二维码区域之外的视图添加到视图图层上
    [self.view addSubview:topView];
    [self.view addSubview:leftView];
    [self.view addSubview:rightView];
    [self.view addSubview:botView];
    [self.view addSubview:_line];
    
    UIView* footer = [self.view viewWithTag:1];
    [self.view bringSubviewToFront:footer];
    
}
-(void) addMark{
    UIColor *color = [UIColor colorWithRed:105.0/255 green:235.0/255 blue:6.0/255 alpha:1];
    CGFloat view_width = 20;
    CGFloat view_heigth = 4;
    CGFloat top =(SCREEN_HEIGHT-HEADER_HEIGHT-QRCODE_WIDTH)/2.0 ;
    CGFloat bot =top + QRCODE_WIDTH;
    CGFloat left = (SCREEN_WIDTH - QRCODE_WIDTH)/2.0;
    CGFloat right = left+QRCODE_WIDTH;
    UIView *left_Top_Ver_View = [[UIView alloc]init];
    left_Top_Ver_View.backgroundColor = color;
    left_Top_Ver_View.frame = CGRectMake(left,top, view_width, view_heigth);
    
    UIView *left_Top_Hori_View = [[UIView alloc]init];
    left_Top_Hori_View.backgroundColor = color;
    left_Top_Hori_View.frame = CGRectMake(left,top, view_heigth,view_width);
    
    UIView* right_Top_Ver_View = [[UIView alloc]init];
    right_Top_Ver_View.backgroundColor = color;
    right_Top_Ver_View.frame = CGRectMake(right-view_width, top, view_width, view_heigth);
    
    UIView* right_Top_Hori_View = [[UIView alloc]init];
    right_Top_Hori_View.backgroundColor = color;
    right_Top_Hori_View.frame = CGRectMake(right-view_heigth, top, view_heigth, view_width);
    
    
    
    UIView *left_Bot_Ver_View = [[UIView alloc]init];
    left_Bot_Ver_View.backgroundColor = color;
    left_Bot_Ver_View.frame = CGRectMake(left,bot-view_heigth, view_width,view_heigth);
    
    UIView *left_Bot_Hori_View = [[UIView alloc]init];
    left_Bot_Hori_View.backgroundColor = color;
    left_Bot_Hori_View.frame = CGRectMake(left,bot-view_width, view_heigth,view_width);
    
    UIView* right_Bot_Ver_View = [[UIView alloc]init];
    right_Bot_Ver_View.backgroundColor = color;
    right_Bot_Ver_View.frame = CGRectMake(right-view_width, bot-view_heigth, view_width, view_heigth);
    
    UIView* right_Bot_Hori_View = [[UIView alloc]init];
    right_Bot_Hori_View.backgroundColor = color;
    right_Bot_Hori_View.frame = CGRectMake(right-view_heigth, bot- view_width, view_heigth,view_width);
    
    UILabel* Lable = [[UILabel alloc]init];
    Lable.text = @"将二维码/条码放入框内,即可扫描";
    
    
    Lable.textColor =[UIColor whiteColor];
    Lable.textAlignment = NSTextAlignmentCenter;
    NSMutableParagraphStyle *paragraphstyle=[[NSMutableParagraphStyle alloc]init];
    paragraphstyle.lineBreakMode=NSLineBreakByCharWrapping;
    NSDictionary *dic=@{NSFontAttributeName:Lable.font,NSParagraphStyleAttributeName:paragraphstyle.copy};
    //计算label的真正大小,其中宽度和高度是由段落字数的多少来确定的，返回实际label的大小
    CGRect rect=[Lable.text boundingRectWithSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    Lable.frame = rect;
    Lable.center = CGPointMake(SCREEN_WIDTH/2, bot+rect.size.height + 10);
    
    [self.view addSubview:left_Top_Ver_View];
    [self.view addSubview:left_Top_Hori_View];
    [self.view addSubview:right_Top_Hori_View];
    [self.view addSubview:right_Top_Ver_View];
    
    [self.view addSubview:left_Bot_Ver_View];
    [self.view addSubview:left_Bot_Hori_View];
    [self.view addSubview:right_Bot_Hori_View];
    [self.view addSubview:right_Bot_Ver_View];
    [self.view addSubview:Lable];
    
    UIButton* button = [[UIButton alloc]init];
    [button setImage:[UIImage imageNamed:FLASH] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(openFlash:) forControlEvents:UIControlEventTouchDown];
    button.frame = CGRectMake(SCREEN_WIDTH/2, bot-10, 15, 24);
    button.center = CGPointMake(SCREEN_WIDTH/2, bot-20);
    [self.view addSubview:button];
    
    
}
- (BOOL)navigationShouldPopOnBackButton
{
    return YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (hasCameraRight) {
        if (_session && ![_session isRunning]) {
            [_session startRunning];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)setupCamera
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        // Device
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        // Input
        _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
        if(!_input) return ;
        // Output
        _output = [[AVCaptureMetadataOutput alloc]init];
        //特别注意的地方：有效的扫描区域，定位是以设置的右顶点为原点。屏幕宽所在的那条线为y轴，屏幕高所在的线为x轴
        CGFloat x = ((SCREEN_HEIGHT-QRCODE_WIDTH-HEADER_HEIGHT)/2.0)/SCREEN_HEIGHT;
        CGFloat y = ((SCREEN_WIDTH-QRCODE_WIDTH)/2.0)/SCREEN_WIDTH;
        CGFloat width = QRCODE_WIDTH/SCREEN_HEIGHT;
        CGFloat height = QRCODE_WIDTH/SCREEN_WIDTH;
        _output.rectOfInterest = CGRectMake(x, y, width, height);

        [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        // Session
        _session = [[AVCaptureSession alloc]init];
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
        if ([_session canAddInput:self.input])
        {
            [_session addInput:self.input];
        }
        
        if ([_session canAddOutput:self.output])
        {
            [_session addOutput:self.output];
        }
        
        // 条码类型 AVMetadataObjectTypeQRCode
        _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            // Preview
            _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
            _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
            //    _preview.frame =CGRectMake(20,110,280,280);
            _preview.frame = self.view.bounds;
            [self.view.layer insertSublayer:self.preview atIndex:0];
            // Start
            [_session startRunning];
        });
    });
}

- (IBAction)openFlash:(id)sender
{
    
    
    NSError *error = nil;
    if ([_device hasTorch])
    {
        BOOL locked = [_device lockForConfiguration:&error];
        if (locked)
        {
            if (!isLight)
            {
                [_device setTorchMode:AVCaptureTorchModeOn];
                isLight = YES;
            } else {
                [_device setTorchMode:AVCaptureTorchModeOff];
                isLight = NO;
            }
            [_device unlockForConfiguration];
        }
    }
}

- (IBAction)find:(id)sender{
    
    NSString* txt = self.textField.text;
    [self.textField resignFirstResponder];
    if(txt==NULL||[txt isEqualToString:@""]){
        [self.view makeToast:@"请输入条码"
                    duration:2
                    position:NULL
                  addPixelsY:0
                        data:NULL
                     styling:NULL];
        return;
    }
    NSLog(@"%@",txt);
}

#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField*)textField {
    NSLog(@"textFieldDidBeginEditing %f",textField.frame.origin.y);
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"textFieldShouldReturn ");
    [textField resignFirstResponder];
    return YES;
}
- (void)keyboardAction:(NSNotification*)sender{
    NSDictionary *useInfo = [sender userInfo];
    NSValue *value = [useInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat y = 0;
    if([sender.name isEqualToString:UIKeyboardWillShowNotification]){
        y = [value CGRectValue].size.height;
    }
    [self changeViewY:-y];
}
-(void)changeViewY:(int)y{
    CGRect frame =self.view.frame;
    self.view.frame = CGRectMake(frame.origin.x, y, frame.size.width, frame.size.height);
}
#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    NSString *stringValue;
    
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        
        [_session stopRunning];
        NSLog(@"%@",stringValue);
    
        if (stringValue.length > 0) {
            NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:stringValue,@"text", nil];
            NSNotification *notification =[NSNotification notificationWithName:@"InfoNotification" object:nil userInfo:dict];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            //重复扫描
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                [_session stopRunning];
                [_session startRunning];
            });
        }

    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
