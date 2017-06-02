//
//  AnalyseDetailsViewController.m
//  Beacon Analyser
//
//  Created by Şeref Bülbül on 21/12/15.
//  Copyright © 2015 adesso TR. All rights reserved.
//

#import "AnalyseDetailsViewController.h"

@interface AnalyseDetailsViewController ()

@end

@implementation AnalyseDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.numberOfRecordsLabel setText:self.numberOfRecordsText];
    [self.actualProximityLabel setText:self.actualProximityText];
    [self.numberOfIndefiniteProximityLabel setText:self.numberOfIndefiniteProximityText];
    
    [self.averageProximityLabel setText:self.averageProximityText];
    [self.minimumProximityLabel setText:self.minimumProximityText];
    [self.maximumProximityLabel setText:self.maximumProximityText];
    
    [self.averageRssiLabel setText:self.averageRssiText];
    [self.minimumRssiLabel setText:self.minimumRssiText];
    [self.maximumRssiLabel setText:self.maximumRssiText];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
