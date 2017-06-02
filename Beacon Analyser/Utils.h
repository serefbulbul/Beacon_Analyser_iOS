//
//  Utils.h
//  iSales
//
//  Created by Zafer Caliskan on 5/20/15.
//  Copyright (c) 2015 Boran ASLAN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCLAlertView.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "ADSPopupViewController.h"
#define UIColorFromHEX(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

typedef enum {
    ErrorAlert = 0,
    WarningAlert,
    SuccessAlert
} AlertMessageType;

@interface Utils : NSObject

// View
+ (SCLAlertView *)showAlertWithType:(AlertMessageType)type message:(NSString *)message;
+ (SCLAlertView *)initCustomAlert;
+ (void)showMBProgressHUD;
+ (void)showMBProgressHUDWithDetailText:(NSString *)title;
+ (void)hideMBProgressHUD;

//Date
+ (NSString *)dateString:(NSString *)dateString Format:(NSString *)formatString;
+ (NSDate *)date:(NSString *)dateString Format:(NSString *)formatString;
+ (NSString *)getDateStringWithFormat:(NSString *)formatString;

// String
+ (NSString *)stringTrimLastWhiteSpaces:(NSString *)string;

+ (ADSPopupViewController *)initADSPopupViewController:(UIViewController *)contentViewController;

@end
