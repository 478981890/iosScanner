//
//  UIView+Border.m
//  SZQRCodeViewController
//
//  Created by tsm on 2017/9/12.
//  Copyright © 2017年 StephenZhuang. All rights reserved.
//

#import "UIButton+Border.h"

@implementation UIButton (Border)

-(void)addBorder:(UIBorderSideType)borderType color:(UIColor*)color borderWidth:(float)borderWidth{
    color = color==nil?[UIColor whiteColor]:color;
    borderWidth =borderWidth<=0?1.0f:borderWidth;
    if(borderType==UIBorderSideTypeAll){
        self.layer.borderWidth = borderWidth;
        self.layer.borderColor = color.CGColor;
        return ;
    }
    UIBezierPath * bezierPath = [UIBezierPath bezierPath];
    CGPoint begin = CGPointMake(0.0f, 0.0f);
    CGPoint end = CGPointMake(0.0f, 0.0f);
    if(borderType&UIBorderSideTypeLeft){
        begin =CGPointMake(0.0f, self.frame.size.height);
        end =CGPointMake(0.0f, 0.0f);
        [bezierPath moveToPoint:begin];
        [bezierPath addLineToPoint:end];
    }
    if(borderType&UIBorderSideTypeRight){
        begin =CGPointMake(self.frame.size.width, 0.0f);
        end =CGPointMake(self.frame.size.width, self.frame.size.height);
        [bezierPath moveToPoint:begin];
        [bezierPath addLineToPoint:end];
    }
    if(borderType&UIBorderSideTypeTop){
        begin =CGPointMake(0.0f, 0.0f);
        end =CGPointMake(self.frame.size.width, 0.0f);
        [bezierPath moveToPoint:begin];
        [bezierPath addLineToPoint:end];
        
    }
    if(borderType&UIBorderSideTypeBottom){
        begin =CGPointMake(0.0f, self.frame.size.height);
        end =CGPointMake(self.frame.size.width, self.frame.size.height);
        [bezierPath moveToPoint:begin];
        [bezierPath addLineToPoint:end];
        
    }
    
    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = color.CGColor;
    shapeLayer.fillColor  = [UIColor clearColor].CGColor;
    /// 添加路径
    shapeLayer.path = bezierPath.CGPath;
    /// 线宽度
    shapeLayer.lineWidth = borderWidth;
    
    [self.layer addSublayer:shapeLayer];
}

- (void)setBadge:(NSString *)number {
    
    UILabel *badge = [self viewWithTag:-1];
    if(badge){
        [badge removeFromSuperview];
    }
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    UIFont* fnt =[UIFont systemFontOfSize:12];
    CGSize size = [number sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName,nil]];
    if(size.width<size.height){
        size.width = size.height;
    }
    badge = [[UILabel alloc] initWithFrame:CGRectMake(width*5/6, height/10, size.width, size.height)];
    badge.text = number;
    [badge setTag:-1];
    badge.textAlignment = NSTextAlignmentCenter;
    badge.font = [UIFont systemFontOfSize:12];
    badge.backgroundColor = [UIColor redColor];
    badge.textColor = [UIColor whiteColor];
    badge.layer.cornerRadius = size.height/2;
    badge.layer.masksToBounds = YES;
    [self addSubview:badge];
    
}


@end
