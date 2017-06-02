//
//  RegionDetailViewController.m
//  Beacon Analyser
//
//  Created by Şeref Bülbül on 07/12/15.
//  Copyright © 2015 adesso TR. All rights reserved.
//

#import "RegionDetailViewController.h"

@interface RegionDetailViewController ()

@end

@implementation RegionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.nameTextField setText:self.regionModel.name];
    [self.proximityUUIDTextField setText:self.regionModel.proximityUUID];
    [self.majorTextField setText:[self.regionModel.major stringValue]];
    [self.minorTextField setText:[self.regionModel.minor stringValue]];
    [self.willBeScannedSegmentedControl setSelectedSegmentIndex:[self.regionModel.willBeScanned boolValue] ? 0 : 1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)saveButtonTapped:(id)sender {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    self.beaconAnalyserManagedObjectContext = appDelegate.beaconAnalyserManagedObjectContext;
    
    if (![self.nameTextField.text isEqualToString:@""] && ![self.proximityUUIDTextField.text isEqualToString:@""]) {
        [self.regionModel setName:self.nameTextField.text];
        [self.regionModel setProximityUUID:self.proximityUUIDTextField.text];
        [self.regionModel setMajor:[self.majorTextField.text isEqualToString:@""] ? nil : @([self.majorTextField.text doubleValue])];
        [self.regionModel setMinor:[self.minorTextField.text isEqualToString:@""] ? nil : @([self.minorTextField.text doubleValue])];
        [self.regionModel setWillBeScanned:self.willBeScannedSegmentedControl.selectedSegmentIndex == 0 ? @(YES) : @(NO)];
        
        [DatabaseHelper saveCoreData:self.beaconAnalyserManagedObjectContext];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

@end
