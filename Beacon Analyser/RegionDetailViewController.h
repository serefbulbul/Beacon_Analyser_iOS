//
//  RegionDetailViewController.h
//  Beacon Analyser
//
//  Created by Şeref Bülbül on 07/12/15.
//  Copyright © 2015 adesso TR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "RegionModel.h"
#import "DatabaseHelper.h"
#import "SCLAlertView.h"
#import "Utils.h"

@interface RegionDetailViewController : UIViewController

@property (strong, atomic) NSManagedObjectContext *beaconAnalyserManagedObjectContext;

@property (strong, nonatomic) RegionModel *regionModel;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *proximityUUIDTextField;
@property (weak, nonatomic) IBOutlet UITextField *majorTextField;
@property (weak, nonatomic) IBOutlet UITextField *minorTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *willBeScannedSegmentedControl;

@end
