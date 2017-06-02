//
//  BeaconInfo.h
//  Beacon Analyser
//
//  Created by Şeref Bülbül on 09/12/15.
//  Copyright © 2015 adesso TR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BeaconInfo : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *proximityUUID;
@property (strong, nonatomic) NSNumber *major;
@property (strong, nonatomic) NSNumber *minor;

@end
