//
//  Utils.m
//  iSales
//
//  Created by Zafer Caliskan on 5/20/15.
//  Copyright (c) 2015 Boran ASLAN. All rights reserved.
//

#import "Utils.h"
#import "AppDelegate.h"

@implementation Utils

#pragma mark - View

+ (SCLAlertView *)showAlertWithType:(AlertMessageType)type message:(NSString *)message {
    SCLAlertView *alertView = [[SCLAlertView alloc] initWithNewWindow];
    switch (type) {
        case ErrorAlert:
            [alertView showError:@"" subTitle:message closeButtonTitle:@"Tamam" duration:0.0f];
            break;
        case WarningAlert:
            [alertView showWarning:@"" subTitle:message closeButtonTitle:@"Tamam" duration:0.0f];
            break;
        case SuccessAlert:
            [alertView showSuccess:@"" subTitle:message closeButtonTitle:@"Tamam" duration:0.0f];
            break;
        default:
            break;
    }
    return alertView;
}

+ (SCLAlertView *)initCustomAlert {
    SCLAlertView *alertView = [[SCLAlertView alloc] initWithNewWindow];    
    return alertView;
}

+ (void)showMBProgressHUD{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [MBProgressHUD showHUDAddedTo:appDelegate.window animated:YES];
    [appDelegate.window setUserInteractionEnabled:NO];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
}

+ (void)showMBProgressHUDWithDetailText:(NSString *)title{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:appDelegate.window animated:YES];
    progressHUD.detailsLabelText = title;
    [appDelegate.window setUserInteractionEnabled:NO];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
}

+ (void)hideMBProgressHUD{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [MBProgressHUD hideHUDForView:appDelegate.window animated:YES];
    [appDelegate.window setUserInteractionEnabled:YES];
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

+ (NSString *)convertAmountToStringWithoutSymbol:(NSDecimalNumber *)amount {
    return [self converAmountToStringWithoutSymbol:amount maximumFractionDigits:2];
}

+ (NSString *)converAmountToStringWithoutSymbol:(NSDecimalNumber *)amount maximumFractionDigits:(int)maxFractionDigit {
    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
    [currencyFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"tr_TR"]];
    [currencyFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [currencyFormatter setMinimumFractionDigits:2];
    [currencyFormatter setMaximumFractionDigits:maxFractionDigit];
    return [currencyFormatter stringFromNumber:amount];
}

+ (NSString *)convertAmountToString:(NSDecimalNumber *)amount maximumFractionDigits:(int)maxFractionDigit{
    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
    [currencyFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"tr_TR"]];
    [currencyFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [currencyFormatter setMinimumFractionDigits:2];
    [currencyFormatter setMaximumFractionDigits:maxFractionDigit];
    return [currencyFormatter stringFromNumber:amount];
}

+ (NSString *)convertPackageToCartonCountString:(int)packageCount{
    int krtCount = packageCount / 10;
    int pktCount = packageCount % 10;
    return [NSString stringWithFormat:@"%i,%i",krtCount,pktCount];
}

+ (NSString *)getAmountSpellOut:(NSDecimalNumber *)amount {
    NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"tr_TR"];
    NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setLocale:locale];
    
    NSString *numberString = [self convertAmountToStringWithoutSymbol:amount];
    
    NSArray *commaArray = [numberString componentsSeparatedByString:@","];
    NSNumber *beforeCommaNumber = [numberFormatter numberFromString:[commaArray objectAtIndex:0]];
    NSNumber *afterCommaNumber = [numberFormatter numberFromString:[commaArray objectAtIndex:1]];
    
    [numberFormatter setNumberStyle:NSNumberFormatterSpellOutStyle];
    
    NSMutableString *spellOut = [NSMutableString stringWithString:@"YALNIZ "];
    [spellOut appendFormat:@"%@TL", [[[numberFormatter stringFromNumber:beforeCommaNumber] uppercaseStringWithLocale:locale] stringByReplacingOccurrencesOfString:@" " withString:@""]];
    [spellOut appendFormat:@"%@KR", [[[numberFormatter stringFromNumber:afterCommaNumber] uppercaseStringWithLocale:locale]  stringByReplacingOccurrencesOfString:@" " withString:@""]];
    
    return spellOut;
}

+ (NSDecimalNumber *)priceRounding:(NSDecimalNumber *)amount isRoundUp:(BOOL)isRoundUp {
    int digit = 2;
    NSDecimalNumber *tenPower = [NSDecimalNumber zero];
    BOOL useTenPower = digit > 0;
    
    if (useTenPower)
        tenPower = [[[NSDecimalNumber alloc] initWithInt:10] decimalNumberByRaisingToPower:digit];
    
    if (digit < 0)
        return nil;
    
    // moves the comma to the right
    if (useTenPower)
        amount = [amount decimalNumberByMultiplyingBy:tenPower];
    
    // adds 0.5 to the amount / adds 0.4 to the amount
    NSDecimalNumber *addingDecimal;
    if (isRoundUp)
        addingDecimal = [[NSDecimalNumber alloc] initWithDouble:0.5];
    else
        addingDecimal = [[NSDecimalNumber alloc] initWithDouble:0.4];
    amount = [amount decimalNumberByAdding:addingDecimal];
    
    // gets the integer value of the amount
    amount = [[NSDecimalNumber alloc] initWithInt:[amount intValue]];
    
    if (useTenPower)
        amount = [amount decimalNumberByDividingBy:tenPower];
    
    return amount;
}

#pragma mark - Date

+ (NSString *)dateString:(NSString *)dateString Format:(NSString *)formatString {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date = [format dateFromString:dateString];
    [format setDateFormat:formatString];
    
    return [format stringFromDate:date];
}

+ (NSString *)getDateStringWithFormat:(NSString *)formatString {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:formatString];
    return [format stringFromDate:[NSDate date]];
}

+ (NSDate *)date:(NSString *)dateString Format:(NSString *)formatString {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:formatString];
    return [format dateFromString:dateString];
}

#pragma mark - String

+ (NSString *)stringTrimLastWhiteSpaces:(NSString *)string {
    NSRange range = [string rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:[string stringByReplacingOccurrencesOfString:@" " withString:@""]] options:NSBackwardsSearch];
    return [string substringToIndex:range.location+1];
}


#pragma mark - Directory

+ (NSString *)getDocumentDirectory {
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = ([path count] > 0) ? [path objectAtIndex:0] : nil;
    
    if (!documentDirectory)
        return nil;
    return documentDirectory;
}

+ (ADSPopupViewController *)initADSPopupViewController:(UIViewController *)contentViewController{
    ADSPopupViewController *adsPopupViewController = [[ADSPopupViewController alloc] initWithNibName:@"ADSPopupViewController" bundle:nil];
    adsPopupViewController.contentViewSize = contentViewController.view.frame;
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [adsPopupViewController presentPopupViewController:contentViewController on:appDelegate.window];
    [adsPopupViewController disableCloseButton:NO];
    return adsPopupViewController;
}

+ (NSString *)appendString:(NSString *)string length:(int)length {
    return [string stringByPaddingToLength:length withString:@" " startingAtIndex:0];
}

@end
