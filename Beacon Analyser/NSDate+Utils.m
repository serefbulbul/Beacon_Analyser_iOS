//
//  NSDate+Utils.m
//  iSales
//
//  Created by Zafer Caliskan on 5/21/15.
//  Copyright (c) 2015 Boran ASLAN. All rights reserved.
//

#import "NSDate+Utils.h"

@implementation NSDate (Utils)

- (NSString *)formattedTime {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter stringFromDate:self];
}

- (NSString *)printerShortDate {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    return [dateFormatter stringFromDate:self];
}

- (NSString *)fullDate{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"dd.MM.yyyy HH:mm:ss.SSS"];
    return [dateFormatter stringFromDate:self];
}

- (NSString *)shortDate{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"dd.MM.yyyy"];
    return [dateFormatter stringFromDate:self];
}

- (NSString *)shortTime {
    if (self) {
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"HH:mm"];
        return [dateFormatter stringFromDate:self];
    }
    return @"";
}

- (NSInteger)dayOfYear{
    NSDateFormatter *dateFormat = [NSDateFormatter new];
    [dateFormat setDateFormat:@"DDD"];
    NSInteger dayInYear = [[dateFormat stringFromDate:self] integerValue];
    return dayInYear;
}

- (NSString *)stringWithFormat:(NSString *)format{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:self];
}

@end
