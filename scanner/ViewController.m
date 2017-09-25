//
//  ViewController.m
//  scanner
//
//  Created by tsm on 2017/9/25.
//  Copyright © 2017年 tsm. All rights reserved.
//

#import "ViewController.h"
#import "ScannerControllerViewController.h"

#import "IosToast+UIView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(InfoNotificationAction:) name:@"InfoNotification" object:nil];
    

    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)scan:(id)sender
{
    //    SZQRCodeViewController *vc = [[SZQRCodeViewController alloc] init];
    ScannerControllerViewController*vc = [[ScannerControllerViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
    //    ScannerControllerViewController*controller = [[ScannerControllerViewController alloc] init];
    //    UINavigationController* navigationController = [[UINavigationController alloc]initWithRootViewController:controller];
    //
    //    [self.navigationController presentModalViewController:navigationController
    //                                            animated:YES];
    
    
}

- (void)InfoNotificationAction:(NSNotification *)notification{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //更新UI操作
        //.....
        [self.view makeToast:[notification.userInfo objectForKey:@"text"]
                    duration:2
                    position:NULL
                  addPixelsY:0
                        data:NULL
                     styling:NULL];
    });

    
}
@end
