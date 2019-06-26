//
//  CommonUtils.h
//  YSCKit
//
//  Created by yangshengchao on 14-10-29.
//  Copyright (c) 2014年 yangshengchao. All rights reserved.
//

#import <Foundation/Foundation.h>
 
/**
 *  全局通用静态类
 *  作用：主要是公用可以独立执行的方法集合
 */
@interface CommonUtils : NSObject

+ (NSString *)simpleDateWithDate:(NSDate *)date;
 
+ (void )showLoginViewInWindow;
+ (void )getVideoFirstSceneWithUrl:(NSString *)url image:( void(^)(UIImage * getImage))imageBlock;
+ (void) showErrorMessage:(NSError *)error;
+ (void) showSuccessMessage:(NSString *)success;
+ (void) showInfoMessage:(NSString *)info;
+ (void) showLoading;
+ (void) svDismiss;

+ (UIColor *)randomColor;

#pragma mark - 格式化金额
+ (NSString *)fomateTimeString:(NSString *)timeStr;
+ (NSString *)fomateTimeStringInSimple:(NSString *)timeStr;
+ (NSString *)fomateTimeSp:(NSString *)timeSp;//将时间戳转为标准时间
+ (NSString *)fomateTimeInMinuteSp:(NSString *)timeSp;
/**
 *  常用的价格字符串格式化方法（默认：显示￥、显示小数点）
 *
 *  @param price 价格参数
 *
 *  @return
 */
+ (NSString *)formatPrice:(NSNumber *)price;
/**
 *  常用的价格字符串格式化方法（默认：显示￥、显示小数点、显示元）
 *
 *  @param price
 *
 *  @return
 */
+ (NSString *)formatPriceWithUnit:(NSNumber *)price;
/**
 *  格式化价格字符串输出
 *
 *  @param price     价格
 *  @param useTag    是否显示￥
 *  @param isDecimal 是否显示小数点
 *
 *  @return 组装好的字符串
 */
+ (NSString *)formatPrice:(NSNumber *)price showMoneyTag:(BOOL)isTagUsed showDecimalPoint:(BOOL) isDecimal useUnit:(BOOL)isUnitUsed;

#pragma mark - 打电话

+ (void)MakeCall:(NSString *)phoneNumber;

#pragma mark - 更新Sqlite操作


+ (BOOL)SqliteUpdate:(NSString *)sql dbPath:(NSString *)dbPath;


#pragma mark - 过去了多长时间 + 还剩多少时间

+ (NSString *)TimePassed:(NSString *)timeStamp;
+ (NSString *)TimeRemain:(NSString *)timeStamp;
+ (NSString *)TimeRemain:(NSString *)timeStamp currentTime:(NSString *)currentTime;

#pragma mark - NSURL获取参数

+ (NSDictionary *)GetParamsInNSURL:(NSURL *)url;
+ (NSDictionary *)GetParamsInQueryString:(NSString *)queryString;

#pragma mark - UIButton添加pop动画

+ (void)addPopAnimationToButton:(UIButton *)button;
//求取字符串 长宽
+ (float)getHeightWithString:(NSString *)string andFont:(UIFont *)font andWidth:(float)width;

+ (float)getWidthWithString:(NSString *)string andFont:(UIFont *)font andHeight:(float)height;
/**
 *  banner 或者首页特殊单元格 点击后的响应方法
 *
 *  @param vc   单前的vc
 *  @param item  对应的item
 */
+ (NSString*)formatAliyImagePath:(NSString*)path imageWidth:(NSInteger)width imageHeight:(NSInteger)height andQuality:(NSInteger)quality;
+ (NSString *)formatAliyImagePath:(NSString*)path imageWidthOrHeight:(NSInteger)widthOrHeight isWidth:(BOOL)isWidth;
+ (NSString*)formatAliyImagePath:(NSString *)path imageWidth:(NSInteger)width imageHeight:(NSInteger)height ;
+ (NSString*)formatAliyImagePath:(NSString *)path andQuality:(NSInteger)quality ;
+ (NSString*)formatBigPrice:(NSString *)string showSymbol:(BOOL) isShow;
@end
