//
//  AnalyseViewController.h
//  Beacon Analyser
//
//  Created by Şeref Bülbül on 07/12/15.
//  Copyright © 2015 adesso TR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnalyseDetailsViewController.h"
#import "AppDelegate.h"
#import "NSDate+Utils.h"
#import "DatabaseHelper.h"
#import "RegionModel.h"
#import "BeaconModel.h"
#import "BeaconDataModel.h"
#import "SavedBeaconModel.h"
#import "SCLAlertView.h"
#import "Utils.h"
#import <MessageUI/MessageUI.h>

@interface AnalyseViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate>

@property (strong, atomic) NSManagedObjectContext *beaconAnalyserManagedObjectContext;

@property (weak, nonatomic) IBOutlet UITableView *analyseListTableView;
@property (weak, nonatomic) IBOutlet UIButton *examinationIdSelectionButton;
@property (weak, nonatomic) IBOutlet UIButton *beaconNameSelectionButton;

- (IBAction)examinationIdSelectionButtonTapped:(id)sender;
- (IBAction)beaconNameSelectionButtonTapped:(id)sender;
- (IBAction)exportButtonTapped:(id)sender;
- (IBAction)analyseButtonTapped:(id)sender;
- (IBAction)clearAllSavedDataButtonTapped:(id)sender;

@end
