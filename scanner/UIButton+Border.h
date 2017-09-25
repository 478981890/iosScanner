//
//  UIView+Border.h
//  SZQRCodeViewController
//
//  Created by tsm on 2017/9/12.
//  Copyright © 2017年 StephenZhuang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, UIBorderSideType) {
    UIBorderSideTypeAll    = 0,
    UIBorderSideTypeTop    = 1 << 0,
    UIBorderSideTypeBottom = 1 << 1,
    UIBorderSideTypeLeft   = 1 << 2,
    UIBorderSideTypeRight  = 1 << 3,
};

@interface UIButton (Border)
- (void)addBorder:(UIBorderSideType)borderType color:(UIColor*)color borderWidth:(float)borderWidth ;
-(void)setBadge:(NSString *)number;
@end
