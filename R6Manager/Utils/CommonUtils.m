//
//  CommonUtils.m
//  YSCKit
//
//  Created by yangshengchao on 14-10-29.
//  Copyright (c) 2014年 yangshengchao. All rights reserved.
//

#import "CommonUtils.h"
#import "SDImageCache.h"
#import <AVFoundation/AVFoundation.h>
 @implementation CommonUtils


+ (NSString *)simpleDateWithDate:(NSDate *)date
{
    // 1.获得年月日
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour |NSCalendarUnitMinute;
    NSDateComponents *cmp1 = [calendar components:unitFlags fromDate:date];
    NSDateComponents *cmp2 = [calendar components:unitFlags fromDate:[NSDate date]];
    
    // 2.格式化日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if ([cmp1 day] == [cmp2 day] && [cmp1 month] == [cmp2 month]) { // 今天
        formatter.dateFormat = @"HH:mm";
    } else if ([cmp1 year] == [cmp2 year]) { // 今年
        formatter.dateFormat = @"MM-dd HH:mm";
    } else {
        formatter.dateFormat = @"yyyy-MM-dd";
    }
    NSString *time = [formatter stringFromDate:date];
    
    return time;
}


 

+ (UIColor *)randomColor {
    return [UIColor colorWithRed:random() / (CGFloat)RAND_MAX
                           green:random() / (CGFloat)RAND_MAX
                            blue:random() / (CGFloat)RAND_MAX
                           alpha:1.0f];
}

+(void)showErrorMessage:(NSError *)error
{
   // [MBProgressHUD showResultThenHideOnWindow:error.localizedDescription];
    
    [SVProgressHUD showErrorWithStatus:error.localizedDescription];
}
+(void)showSuccessMessage:(NSString *)success
{
    [SVProgressHUD showSuccessWithStatus:success];
}

+(void)showInfoMessage:(NSString *)info
{
    [MBProgressHUD showResultThenHideOnWindow:info];
}
+(void)showLoading
{
    [SVProgressHUD show];
}
+(void)svDismiss
{
    [SVProgressHUD dismiss];
}


 




+ (NSString *)formatPrice:(NSNumber *)price {
    return [self formatPrice:price showMoneyTag:YES showDecimalPoint:YES useUnit:NO];
}

/**
 *  常用的价格字符串格式化方法（默认：显示￥、显示小数点、显示元）
 *
 *  @param price
 *
 *  @return
 */
+ (NSString *)formatPriceWithUnit:(NSNumber *)price {
    return [self formatPrice:price showMoneyTag:YES showDecimalPoint:YES useUnit:YES];
}

/**
 *  格式化价格字符串输出
 *
 *  @param price     价格
 *  @param useTag    是否显示￥
 *  @param isDecimal 是否显示小数点
 *
 *  @return 组装好的字符串
 */
+ (NSString *)formatPrice:(NSNumber *)price showMoneyTag:(BOOL)isTagUsed showDecimalPoint:(BOOL) isDecimal useUnit:(BOOL)isUnitUsed {
    NSString *formatedPrice = @"";
    //是否保留2位小数
    if (isDecimal) {
        formatedPrice = [NSString stringWithFormat:@"%0.2f", [price doubleValue]];
    }
    else {
        formatedPrice = [NSString stringWithFormat:@"%ld", (long)[price integerValue]];
    }
    
    //是否添加前缀 ￥
    if (isTagUsed) {
        formatedPrice = [NSString stringWithFormat:@"￥%@", formatedPrice];
    }
    
    //是否添加后缀 元
    if(isUnitUsed) {
        formatedPrice = [NSString stringWithFormat:@"%@元", formatedPrice];
    }
    
    return formatedPrice;
}


#pragma mark 打电话

+ (void)MakeCall:(NSString *)phoneNumber {
    if ([self isEmpty:phoneNumber]) {
        return;
    }
    if (NO == [UIDevice isCanMakeCall]) {
        [UIView showResultThenHideOnWindow:@"无法拨打电话"];
        return;
    }
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];//去掉-
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",[NSString trimString:phoneNumber]]];
    UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:@"提示"
                                                        message:[NSString stringWithFormat:@"确定要拨打电话：%@？", phoneNumber]];
    [alertView bk_addButtonWithTitle:@"确定" handler:^{
        [[UIApplication sharedApplication] openURL:phoneURL];
    }];
    [alertView bk_setCancelButtonWithTitle:@"取消" handler:nil];
    [alertView show];
}

#pragma makr - Sqlite操作


+ (BOOL)SqliteUpdate:(NSString *)sql dbPath:(NSString *)dbPath {
    BOOL isSuccess = NO;
    
    return isSuccess;
}


#pragma mark - 过去了多长时间
/**
 *  1. 如果是1分钟以内  返回 'xx秒之前'
 *  2. 如果是60分钟以内 返回 'xx分钟之前'
 *  3. 如果是大于1小时且在当天  返回 'x小时之前'
 *  4. 如果是昨天      返回  '昨天hh:mm:ss'
 *  5. 如果是前天      返回  '前天hh:mm:ss'
 *  6. 今年以内        返回  'MM-dd'
 *  7. 其它           返回  'yyyy-MM-dd'
 *
 *  @param startTimeStamp 开始的时间戳
 *
 *  @return
 */
+ (NSString *)TimePassed:(NSString *)timeStamp {
    NSDate *startDateTime = [NSDate dateFromTimeStamp:timeStamp];
    NSDate *nowDateTime = [NSDate date];
    //其它
    if ([startDateTime isLastYear] || [startDateTime isLaterThanDate:nowDateTime]) {
        return [startDateTime stringWithFormat:DateFormat3];
    }
    
    //当年以内
    if ([startDateTime isEarlierThanDate:[[NSDate dateBeforeYesterday] dateAtStartOfDay]]) {
        return [startDateTime stringWithFormat:@"MM-dd"];
    }
    
    //判断前天
    if ([startDateTime isBeforeYesterday]) {
        return [NSString stringWithFormat:@"前天%@",[startDateTime stringWithFormat:@"hh:mm:ss"]];
    }
    
    //判断昨天
    if ([startDateTime isYesterday]) {
        return [NSString stringWithFormat:@"昨天%@",[startDateTime stringWithFormat:@"hh:mm:ss"]];
    }
    
    NSInteger hoursPassed = [startDateTime hoursBeforeDate:nowDateTime];
    NSInteger minutesPassed = [startDateTime minutesBeforeDate:nowDateTime];
    NSInteger secondsPassed = (NSInteger)[nowDateTime timeIntervalSinceDate:startDateTime];
    if (hoursPassed > 0) {
        return [NSString stringWithFormat:@"%ld小时之前", (long)hoursPassed];
    }
    if (minutesPassed > 0) {
        return [NSString stringWithFormat:@"%ld分钟之前", (long)minutesPassed];
    }
    return [NSString stringWithFormat:@"%ld秒之前", (long)secondsPassed];
}
+ (NSString *)TimeRemain:(NSString *)timeStamp {
    return [self TimeRemain:timeStamp currentTime:[[NSDate date] timeStamp]];
}
+ (NSString *)TimeRemain:(NSString *)timeStamp currentTime:(NSString *)currentTime {
    NSDate *nowDateTime = [NSDate dateFromTimeStamp:currentTime];
    NSDate *endDateTime = [NSDate dateFromTimeStamp:timeStamp];
    //其它
    if ([endDateTime isNextYear] || [endDateTime isEarlierThanDate:nowDateTime]) {
        return [endDateTime stringWithFormat:DateFormat3];
    }
    
    //当年以内，7天以后
    if ([endDateTime isLaterThanDate:[NSDate dateWithDaysFromNow:7]]) {
        return [endDateTime stringWithFormat:@"MM-dd"];
    }
    
    //7天以内
    if ( ! [endDateTime isToday]) {
        NSInteger days = [endDateTime daysAfterDate:nowDateTime];
        NSInteger hours = [endDateTime hoursAfterDate:[nowDateTime dateByAddingDays:days]];
        return [NSString stringWithFormat:@"%ld天 %ld小时", (long)days, (long)hours];
    }
    
    //xx:xx:xx
    return [[NSDate dateFromTimeInterval:[endDateTime timeIntervalSinceDate:nowDateTime]] stringWithFormat:@"HH:mm:ss"];
}

#pragma mark - NSURL获取参数

+ (NSDictionary *)GetParamsInNSURL:(NSURL *)url {
    ReturnNilWhenObjectIsEmpty(url)
    return [self GetParamsInQueryString:url.query];
}

+ (NSDictionary *)GetParamsInQueryString:(NSString *)queryString {
    ReturnNilWhenObjectIsEmpty(queryString)
    NSScanner *scanner = [NSScanner scannerWithString:queryString];
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"&?"]];
    if ([queryString isContains:@"?"]) {
        [scanner scanUpToString:@"?" intoString:nil];//skip to ?
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *tmpValue;
    while ([scanner scanUpToString:@"&" intoString:&tmpValue]) {
        NSArray *components = [tmpValue componentsSeparatedByString:@"="];
        if (components.count >= 2) {
            NSString *key = [components[0] stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
            NSString *value = [components[1] stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
            parameters[key] = value;
        }
    }
    return parameters;
}

#pragma mark - UIButton添加pop动画

+ (void)addPopAnimationToButton:(UIButton *)button {
    [button bk_addEventHandler:^(id sender) {
        POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
        scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(0.95f, 0.95f)];
        [button.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleSmallAnimation"];
    } forControlEvents:UIControlEventTouchDown];
    [button bk_addEventHandler:^(id sender) {
        POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
        scaleAnimation.velocity = [NSValue valueWithCGSize:CGSizeMake(3.f, 3.f)];
        scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
        scaleAnimation.springBounciness = 20.0f;
        [button.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleSpringAnimation"];
    } forControlEvents:UIControlEventTouchUpInside];
    [button bk_addEventHandler:^(id sender) {
        POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
        scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
        [button.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleDefaultAnimation"];
    } forControlEvents:UIControlEventTouchDragExit];
}
//处理字符串长宽
+ (float)getHeightWithString:(NSString *)string andFont:(UIFont *)font andWidth:(float)width{
    CGRect frame = [string boundingRectWithSize:CGSizeMake(width, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    return frame.size.height;
}

+ (float)getWidthWithString:(NSString *)string andFont:(UIFont *)font andHeight:(float)height{
    CGRect frame = [string boundingRectWithSize:CGSizeMake(999, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    return frame.size.width;
}



//将年月 日 时 分 秒 转为年月日
+ (NSString *)fomateTimeString:(NSString *)timeStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];; //
    NSDate* date = [dateFormatter dateFromString:timeStr]; //------------将字符串按formatter转成nsdate
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)fomateTimeStringInSimple:(NSString *)timeStr
{
    NSTimeInterval interval=[timeStr doubleValue] / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"MM月dd日"];
    NSString * timeString = [NSString stringWithFormat:@"%@",[objDateformat stringFromDate: date]];
    return timeString;

}

+ (NSString *)fomateTimeSp:(NSString *)timeSp{
    NSTimeInterval interval=[timeSp doubleValue] / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy.MM.dd"];
    NSString * timeStr = [NSString stringWithFormat:@"%@",[objDateformat stringFromDate: date]];
    return timeStr;
}


+ (NSString *)fomateTimeInMinuteSp:(NSString *)timeSp{
    NSTimeInterval interval=[timeSp doubleValue] / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy.MM.dd HH:mm"];
    NSString * timeStr = [NSString stringWithFormat:@"%@",[objDateformat stringFromDate: date]];
    return timeStr;
}

//通过长宽质量获取阿里云图片
+ (NSString*)formatAliyImagePath:(NSString*)path imageWidth:(NSInteger)width imageHeight:(NSInteger)height andQuality:(NSInteger)quality{
    
    
    return [NSString stringWithFormat:@"%@@%ldw_%ldh_%ldq",path,(long)width,(long)height,(long)quality];
    
}

//根据质量获取阿里云图片
+ (NSString*)formatAliyImagePath:(NSString *)path andQuality:(NSInteger)quality{
    return [NSString stringWithFormat:@"%@@%ldq",path,(long)quality];
    
}


+ (NSString*)formatAliyImagePath:(NSString *)path imageWidthOrHeight:(NSInteger)widthOrHeight isWidth:(BOOL)isWidth{
    
    if (isWidth) {
        return [NSString stringWithFormat:@"%@@%ldw",path,(long)widthOrHeight];

    }else{
    return [NSString stringWithFormat:@"%@@%ldh",path,(long)widthOrHeight];
    }

}

+ (NSString*)formatAliyImagePath:(NSString *)path imageWidth:(NSInteger)width imageHeight:(NSInteger)height{
    return [NSString stringWithFormat:@"%@@%ldw_%ldh",path,(long)width,(long)height];
    
}


+ (NSString*)formatBigPrice:(NSString *)string showSymbol:(BOOL) isShow{

    
    
    if([NSString isEmpty:string]){
        return @"";
    }
    
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    
    formatter.numberStyle =kCFNumberFormatterDecimalStyle;
    
    
    NSString *newAmount1 =  [formatter stringFromNumber:[NSNumber numberWithString:string]];
    
    NSString *temp;

    
    if(![newAmount1 containsString:@"."]){
        temp = [newAmount1 stringByAppendingString:@".00"];
    }else{
        if([newAmount1 rangeOfString:@"."].location == newAmount1.length-2){
          temp =  [newAmount1 stringByAppendingString:@"0"];
        }else{
            temp = newAmount1;  
        }

    }
    
    
    if(isShow){
        if(![temp hasPrefix:@"-"]){
            return [NSString stringWithFormat:@"+%@",temp];
        }else{
            return temp;
        }
    }
    return temp;
}

@end
