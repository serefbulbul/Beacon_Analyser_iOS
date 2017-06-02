//
//  NewBeaconViewController.m
//  Beacon Analyser
//
//  Created by Şeref Bülbül on 08/12/15.
//  Copyright © 2015 adesso TR. All rights reserved.
//

#import "NewBeaconViewController.h"

@interface NewBeaconViewController ()

@end

@implementation NewBeaconViewController

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
    
    BeaconModel *beaconModel = (BeaconModel *)[DatabaseHelper insertNewEntityWithName:@"Beacon" andContext:self.beaconAnalyserManagedObjectContext];
    
    if (![self.nameTextField.text isEqualToString:@""] && ![self.proximityUUIDTextField.text isEqualToString:@""] && ![self.majorTextField.text isEqualToString:@""] && ![self.minorTextField.text isEqualToString:@""]) {
        [beaconModel setName:self.nameTextField.text];
        [beaconModel setProximityUUID:self.proximityUUIDTextField.text];
        [beaconModel setMajor:@([self.majorTextField.text doubleValue])];
        [beaconModel setMinor:@([self.minorTextField.text doubleValue])];
        
        BeaconDataModel *beaconDataModel = (BeaconDataModel *)[DatabaseHelper insertNewEntityWithName:@"BeaconData" andContext:self.beaconAnalyserManagedObjectContext];
        [beaconModel setBeaconData:beaconDataModel];
        
        [beaconDataModel setActualProximity:@([self.actualProximityTextField.text doubleValue])];
        
        [DatabaseHelper saveCoreData:self.beaconAnalyserManagedObjectContext];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

@end
