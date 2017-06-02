//
//  RegionsViewController.h
//  Beacon Analyser
//
//  Created by Şeref Bülbül on 07/12/15.
//  Copyright © 2015 adesso TR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewRegionViewController.h"
#import "RegionDetailViewController.h"
#import "AppDelegate.h"
#import "RegionModel.h"
#import "DatabaseHelper.h"
#import "SCLAlertView.h"
#import "Utils.h"

@interface RegionsViewController : UIViewController <UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, atomic) NSManagedObjectContext *beaconAnalyserManagedObjectContext;

@property (weak, nonatomic) IBOutlet UITableView *regionListTableView;

- (IBAction)addRegionButtonTapped:(id)sender;

@end
