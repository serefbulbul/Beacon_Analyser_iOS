//
//  BeaconScanViewController.h
//  Beacon Analyser
//
//  Created by Şeref Bülbül on 07/12/15.
//  Copyright © 2015 adesso TR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "AppDelegate.h"
#import "NSDate+Utils.h"
#import "DatabaseHelper.h"
#import "SavedBeaconModel.h"
#import "RegionModel.h"
#import "BeaconModel.h"
#import "BeaconDataModel.h"
#import "SCLAlertView.h"
#import "Utils.h"

@interface ScanViewController : UIViewController <CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, atomic) NSManagedObjectContext *beaconAnalyserManagedObjectContext;

@property (weak, nonatomic) IBOutlet UITableView *beaconListTableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *modeSegmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *examinationIdLabel;
@property (weak, nonatomic) IBOutlet UIButton *sortingTypeSelectionButton;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;

- (IBAction)sortingTypeSelectionButtonTapped:(id)sender;

@end

