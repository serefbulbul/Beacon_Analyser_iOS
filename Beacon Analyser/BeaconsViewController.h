//
//  BeaconsViewController.h
//  Beacon Analyser
//
//  Created by Şeref Bülbül on 07/12/15.
//  Copyright © 2015 adesso TR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "NewBeaconViewController.h"
#import "BeaconDetailViewController.h"
#import "AppDelegate.h"
#import "RegionModel.h"
#import "BeaconModel.h"
#import "BeaconDataModel.h"
#import "DatabaseHelper.h"
#import "SCLAlertView.h"
#import "Utils.h"

@interface BeaconsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, atomic) NSManagedObjectContext *beaconAnalyserManagedObjectContext;

@property (weak, nonatomic) IBOutlet UITableView *beaconListTableView;

- (IBAction)addBeaconButtonTapped:(id)sender;

@end
