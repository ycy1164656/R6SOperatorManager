//
//  CollectButton.h
//  KQ
//
//  Created by 杨成阳 on 16/9/27.
//  Copyright © 2016年 yangshengchao. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface CollectButton : UIButton

@property (nonatomic, strong) IBInspectable UIImage *image;
@property (nonatomic, strong) IBInspectable UIColor *circleColor;
@property (nonatomic, strong) IBInspectable UIColor *lineColor;
@property (nonatomic, strong) IBInspectable UIColor *imageColorOn;
@property (nonatomic, strong) IBInspectable UIColor *imageColorOff;
@property (nonatomic, assign) IBInspectable NSTimeInterval duration;

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image;
- (void)select;
- (void)deselect;




@end
