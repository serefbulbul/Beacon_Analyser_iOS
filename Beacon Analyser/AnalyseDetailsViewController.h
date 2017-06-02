//
//  AnalyseDetailsViewController.h
//  Beacon Analyser
//
//  Created by Şeref Bülbül on 21/12/15.
//  Copyright © 2015 adesso TR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnalyseDetailsViewController : UIViewController

@property (strong, nonatomic) NSString *numberOfRecordsText;
@property (strong, nonatomic) NSString *actualProximityText;
@property (strong, nonatomic) NSString *averageProximityText;
@property (strong, nonatomic) NSString *minimumProximityText;
@property (strong, nonatomic) NSString *maximumProximityText;
@property (strong, nonatomic) NSString *averageRssiText;
@property (strong, nonatomic) NSString *minimumRssiText;
@property (strong, nonatomic) NSString *maximumRssiText;
@property (strong, nonatomic) NSString *numberOfIndefiniteProximityText;

@property (weak, nonatomic) IBOutlet UILabel *numberOfRecordsLabel;
@property (weak, nonatomic) IBOutlet UILabel *actualProximityLabel;
@property (weak, nonatomic) IBOutlet UILabel *averageProximityLabel;
@property (weak, nonatomic) IBOutlet UILabel *minimumProximityLabel;
@property (weak, nonatomic) IBOutlet UILabel *maximumProximityLabel;
@property (weak, nonatomic) IBOutlet UILabel *averageRssiLabel;
@property (weak, nonatomic) IBOutlet UILabel *minimumRssiLabel;
@property (weak, nonatomic) IBOutlet UILabel *maximumRssiLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfIndefiniteProximityLabel;

@end
