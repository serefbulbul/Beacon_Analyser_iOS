//
//  BeaconDetailViewController.m
//  Beacon Analyser
//
//  Created by Şeref Bülbül on 08/12/15.
//  Copyright © 2015 adesso TR. All rights reserved.
//

#import "BeaconDetailViewController.h"

@interface BeaconDetailViewController ()

@end

@implementation BeaconDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.nameTextField setText:self.beaconModel.name];
    [self.proximityUUIDTextField setText:self.beaconModel.proximityUUID];
    [self.majorTextField setText:[self.beaconModel.major stringValue]];
    [self.minorTextField setText:[self.beaconModel.minor stringValue]];
    [self.actualProximityTextField setText:[self.beaconModel.beaconData.actualProximity stringValue]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)saveButtonTapped:(id)sender {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    self.beaconAnalyserManagedObjectContext = appDelegate.beaconAnalyserManagedObjectContext;
    
    if (![self.nameTextField.text isEqualToString:@""] && ![self.proximityUUIDTextField.text isEqualToString:@""] && ![self.majorTextField.text isEqualToString:@""] && ![self.minorTextField.text isEqualToString:@""]) {
        [self.beaconModel setName:self.nameTextField.text];
        [self.beaconModel setProximityUUID:self.proximityUUIDTextField.text];
        [self.beaconModel setMajor:@([self.majorTextField.text doubleValue])];
        [self.beaconModel setMinor:@([self.minorTextField.text doubleValue])];
        
        BeaconDataModel *beaconDataModel = self.beaconModel.beaconData;
        
        if (!beaconDataModel) {
            beaconDataModel = (BeaconDataModel *)[DatabaseHelper insertNewEntityWithName:@"BeaconData" andContext:self.beaconAnalyserManagedObjectContext];
            [self.beaconModel setBeaconData:beaconDataModel];
        }
        
        [beaconDataModel setActualProximity:@([self.actualProximityTextField.text doubleValue])];
        
        [DatabaseHelper saveCoreData:self.beaconAnalyserManagedObjectContext];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

@end
