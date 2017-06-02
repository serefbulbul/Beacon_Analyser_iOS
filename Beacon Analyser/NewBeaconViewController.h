//
//  NewBeaconViewController.h
//  Beacon Analyser
//
//  Created by Şeref Bülbül on 08/12/15.
//  Copyright © 2015 adesso TR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "BeaconModel.h"
#import "BeaconDataModel.h"
#import "DatabaseHelper.h"
#import "SCLAlertView.h"
#import "Utils.h"

@interface NewBeaconViewController : UIViewController

@property (strong, atomic) NSManagedObjectContext *beaconAnalyserManagedObjectContext;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *proximityUUIDTextField;
@property (weak, nonatomic) IBOutlet UITextField *majorTextField;
@property (weak, nonatomic) IBOutlet UITextField *minorTextField;
@property (weak, nonatomic) IBOutlet UITextField *actualProximityTextField;

@end
