//
//  NewRegionViewController.m
//  Beacon Analyser
//
//  Created by Şeref Bülbül on 07/12/15.
//  Copyright © 2015 adesso TR. All rights reserved.
//

#import "NewRegionViewController.h"

@interface NewRegionViewController ()

@end

@implementation NewRegionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)saveButtonTapped:(id)sender {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    self.beaconAnalyserManagedObjectContext = appDelegate.beaconAnalyserManagedObjectContext;
    
    RegionModel *regionModel = (RegionModel *)[DatabaseHelper insertNewEntityWithName:@"Region" andContext:self.beaconAnalyserManagedObjectContext];
    
    if (![self.nameTextField.text isEqualToString:@""] && ![self.proximityUUIDTextField.text isEqualToString:@""]) {
        [regionModel setName:self.nameTextField.text];
        [regionModel setProximityUUID:self.proximityUUIDTextField.text];
        [regionModel setMajor:[self.majorTextField.text isEqualToString:@""] ? nil : @([self.majorTextField.text doubleValue])];
        [regionModel setMinor:[self.minorTextField.text isEqualToString:@""] ? nil : @([self.minorTextField.text doubleValue])];
        [regionModel setWillBeScanned:self.willBeScannedSegmentedControl.selectedSegmentIndex == 0 ? @(YES) : @(NO)];
        
        [DatabaseHelper saveCoreData:self.beaconAnalyserManagedObjectContext];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

@end
