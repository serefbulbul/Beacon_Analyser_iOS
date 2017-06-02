//
//  NSDate+Utils.h
//  iSales
//
//  Created by Zafer Caliskan on 5/21/15.
//  Copyright (c) 2015 Boran ASLAN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Utils)

- (NSString *)formattedTime;
- (NSString *)printerShortDate;
- (NSString *)fullDate;
- (NSString *)shortDate;
- (NSString *)shortTime;
- (NSInteger)dayOfYear;
- (NSString *)stringWithFormat:(NSString *)format;

@end
