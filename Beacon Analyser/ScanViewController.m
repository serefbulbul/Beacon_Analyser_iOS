//
//  ScanViewController.m
//  Beacon Analyser
//
//  Created by Şeref Bülbül on 07/12/15.
//  Copyright © 2015 adesso TR. All rights reserved.
//

#import "ScanViewController.h"

#define kModeStop 0
#define kModeScan 1
#define kModeScanAndSave 2

@interface ScanViewController ()

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSMutableArray *beaconsArray;
@property (strong, nonatomic) NSMutableArray *tempBeaconsArray;
@property (strong, nonatomic) NSMutableArray *regionsArray;
@property (strong, nonatomic) NSNumber *mode;
@property (strong, nonatomic) NSArray *sortDescriptors;
@property (strong, nonatomic) NSTimer *scanAndSaveTimer;
@property (strong, nonatomic) NSTimer *counterTimer;
@property int timerSecondsLeft;

@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    self.beaconAnalyserManagedObjectContext = appDelegate.beaconAnalyserManagedObjectContext;
    
    self.locationManager = [CLLocationManager new];
    [self.locationManager setDelegate:self];
    [self.locationManager requestAlwaysAuthorization];
    
    self.mode = @(kModeStop);
    [self.examinationIdLabel setHidden:YES];
    self.tempBeaconsArray = [NSMutableArray new];
    self.regionsArray = [NSMutableArray new];
    
    NSSortDescriptor *uuidDescriptor = [[NSSortDescriptor alloc] initWithKey:@"proximityUUID.UUIDString" ascending:YES];
    NSSortDescriptor *majorDescriptor = [[NSSortDescriptor alloc] initWithKey:@"major" ascending:YES];
    NSSortDescriptor *minorDescriptor = [[NSSortDescriptor alloc] initWithKey:@"minor" ascending:YES];
    self.sortDescriptors = @[uuidDescriptor, majorDescriptor, minorDescriptor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [self stopScanning];
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.beaconsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"beaconListTableViewCellIdentifier"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"beaconListTableViewCellIdentifier"];
    }
    
    CLBeacon *beacon = [self.beaconsArray objectAtIndex:indexPath.row];
    BeaconModel *beaconModel =[[DatabaseHelper searchObjectsForEntity:@"Beacon" withPredicate:[NSPredicate predicateWithFormat:@"proximityUUID == %@ AND major == %@ AND minor == %@", [beacon.proximityUUID UUIDString], beacon.major, beacon.minor] andSortKey:nil andSortAscending:NO andContext:self.beaconAnalyserManagedObjectContext] firstObject];
    
    if (beaconModel.name && ![beaconModel.name isEqualToString:@""]) {
        [cell.textLabel setText:[NSString stringWithFormat:@"%@, Actual Proximity: %@ ---- %f / %d",beaconModel.name, beaconModel.beaconData.actualProximity, beacon.accuracy, (int)beacon.rssi]];
    } else {
        [cell.textLabel setText:[NSString stringWithFormat:@"%@, %@, %@, %@ ---- %f / %d",[beacon.proximityUUID UUIDString], beacon.major, beacon.minor, beaconModel.beaconData.actualProximity, beacon.accuracy, (int)beacon.rssi]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CLBeacon *beacon = [self.beaconsArray objectAtIndex:indexPath.row];
    
    
    __block BeaconModel *beaconModel = [[DatabaseHelper searchObjectsForEntity:@"Beacon" withPredicate:[NSPredicate predicateWithFormat:@"proximityUUID == %@ AND major == %@ AND minor == %@", [beacon.proximityUUID UUIDString], beacon.major, beacon.minor] andSortKey:nil andSortAscending:NO andContext:self.beaconAnalyserManagedObjectContext] firstObject];
    
    SCLAlertView *alertView = [Utils initCustomAlert];
    UITextField *beaconNametextField = [alertView addTextField:@"Beacon Name"];
    if (beaconModel.name) {
        [beaconNametextField setText:beaconModel.name];
    }
    
    UITextField *actualProximitytextField = [alertView addTextField:@"Actual Proximity"];
    if (beaconModel.beaconData.actualProximity) {
        [actualProximitytextField setText:[beaconModel.beaconData.actualProximity stringValue]];
    }
    
    [alertView addButton:@"Save" actionBlock:^(void) {
        if (![beaconNametextField.text isEqualToString:@""] && ![actualProximitytextField.text isEqualToString:@""]) {
            
            if (!beaconModel) {
                beaconModel = (BeaconModel *)[DatabaseHelper insertNewEntityWithName:@"Beacon" andContext:self.beaconAnalyserManagedObjectContext];
            }
            
            [beaconModel setName:beaconNametextField.text];
            [beaconModel setProximityUUID:[beacon.proximityUUID UUIDString]];
            [beaconModel setMajor:beacon.major];
            [beaconModel setMinor:beacon.minor];
            
            BeaconDataModel *beaconDataModel = beaconModel.beaconData;
            
            if (!beaconDataModel) {
                beaconDataModel = (BeaconDataModel *)[DatabaseHelper insertNewEntityWithName:@"BeaconData" andContext:self.beaconAnalyserManagedObjectContext];
            }
            
            [beaconModel setBeaconData:beaconDataModel];
            [beaconDataModel setActualProximity:@([actualProximitytextField.text doubleValue])];
            
            [DatabaseHelper saveCoreData:self.beaconAnalyserManagedObjectContext];
            [self.beaconListTableView reloadData];
        }
    }];
    [alertView showEdit:@"" subTitle:[NSString stringWithFormat:@"Enter Actual Proximity for the Beacon:\nUUID: %@\nMajor: %@\nMinor: %@\n", [beacon.proximityUUID UUIDString], beacon.major, beacon.minor] closeButtonTitle:@"Close" duration:0.0f];
    [alertView alertIsDismissed:^{
        [self.view endEditing:YES];
    }];
}

#pragma mark - SegmentedControl

- (IBAction)modeSegmentedControlValueChanged:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    if ((int)segmentedControl.selectedSegmentIndex == 0) {
        self.mode = @(kModeStop);
        [self.examinationIdLabel setHidden:YES];
        [self stopScanning];
        self.beaconsArray = nil;
        [self.beaconListTableView reloadData];
    } else if ((int)segmentedControl.selectedSegmentIndex == 1) {
        [self stopTimers];
        self.mode = @(kModeScan);
        [self.examinationIdLabel setHidden:YES];
        [self startScanning];
    } else if((int)segmentedControl.selectedSegmentIndex == 2) {
        SCLAlertView *alertView = [Utils initCustomAlert];
        UITextField *examinationTimeTextField = [alertView addTextField:@"Examination Time (min)"];
        UITextField *examinationIdTextField = [alertView addTextField:@"Examination Id"];
        [alertView addButton:@"Done" actionBlock:^(void) {
            if (![examinationIdTextField.text isEqualToString:@""]) {
                self.mode = @(kModeScanAndSave);
                [self.examinationIdLabel setHidden:NO];
                [self.examinationIdLabel setText:examinationIdTextField.text];
                if ([examinationTimeTextField.text doubleValue] != 0.0) {
                    self.scanAndSaveTimer = [NSTimer timerWithTimeInterval:[examinationTimeTextField.text doubleValue]*60+2 target: self selector:@selector(scanAndSaveTimer:) userInfo: nil repeats:NO];
                    [[NSRunLoop mainRunLoop] addTimer:self.scanAndSaveTimer forMode:NSRunLoopCommonModes];
                    self.timerSecondsLeft = [examinationTimeTextField.text doubleValue]*60;
                    self.counterTimer = [NSTimer timerWithTimeInterval:1.0 target: self selector:@selector(counterTimer:) userInfo: nil repeats:YES];
                    [[NSRunLoop mainRunLoop] addTimer:self.counterTimer forMode:NSRunLoopCommonModes];
                }
                [self startScanning];
            } else {
                [self.modeSegmentedControl setSelectedSegmentIndex:0];
                [self stopScanning];
            }
        }];
        [alertView addButton:@"Close" actionBlock:^(void) {
            if ([self.mode  isEqual: @(kModeStop)]) {
                [self.modeSegmentedControl setSelectedSegmentIndex:0];
            } else if ([self.mode  isEqual: @(kModeScan)]) {
                [self.modeSegmentedControl setSelectedSegmentIndex:1];
            }
        }];
        [alertView showEdit:@"" subTitle:@"Enter Examination Id" closeButtonTitle:nil duration:0.0f];
        [alertView alertIsDismissed:^{
            [self.view endEditing:YES];
        }];
    }
    [self.beaconListTableView reloadData];
}

#pragma mark - CLLocationManager

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSLog(@"didEnterRegion");
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    NSLog(@"didExitRegion");
}

- (void)locationManager:(CLLocationManager*)manager
        didRangeBeacons:(NSArray*)beacons
               inRegion:(CLBeaconRegion*)region {
    if ([region isEqual:[self.regionsArray firstObject]]) {
        [self.tempBeaconsArray removeAllObjects];
    }
    
    if (([self.mode intValue] == kModeScanAndSave || [self.mode intValue] == kModeScan) && beacons.count > 0) {
        [self.tempBeaconsArray addObjectsFromArray:beacons];
        
        if ([self.mode intValue] == kModeScanAndSave) {
            for (CLBeacon *beacon in beacons) {
                BeaconModel *beaconModel = [[DatabaseHelper searchObjectsForEntity:@"Beacon" withPredicate:[NSPredicate predicateWithFormat:@"proximityUUID == %@ AND major == %@ AND minor == %@", [beacon.proximityUUID UUIDString], beacon.major , beacon.minor] andSortKey:nil andSortAscending:NO andContext:self.beaconAnalyserManagedObjectContext] firstObject];
                
                if (beaconModel) {
                    SavedBeaconModel *savedBeaconModel = (SavedBeaconModel *)[DatabaseHelper insertNewEntityWithName:@"SavedBeacon" andContext:self.beaconAnalyserManagedObjectContext];
                    
                    [savedBeaconModel setAccuracy:@(beacon.accuracy)];
                    [savedBeaconModel setActualProximity:beaconModel.beaconData.actualProximity];
                    [savedBeaconModel setBeacon:beaconModel];
                    [savedBeaconModel setProximity:@(beacon.proximity)];
                    [savedBeaconModel setRssi:@(beacon.rssi)];
                    [savedBeaconModel setExaminationId:self.examinationIdLabel.text];
                    [savedBeaconModel setSaveTime:[[NSDate date] fullDate]];
                }
            }
            [DatabaseHelper saveCoreData:self.beaconAnalyserManagedObjectContext];
        }
    }
    if ([region isEqual:[self.regionsArray lastObject]]) {
        self.beaconsArray = [[self.tempBeaconsArray sortedArrayUsingDescriptors:self.sortDescriptors] mutableCopy];
        [self.beaconListTableView reloadData];
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
}

#pragma mark - NSTimer

-(void)scanAndSaveTimer:(NSTimer *)timer {
    [self.timerLabel setHidden:YES];
    [self.counterTimer invalidate];
    [self stopScanning];
}

-(void)counterTimer:(NSTimer *)timer {
    if(self.timerSecondsLeft >= 0 ) {
        int hours = self.timerSecondsLeft / 3600;
        int minutes = (self.timerSecondsLeft % 3600) / 60;
        int seconds = (self.timerSecondsLeft %3600) % 60;
        [self.timerLabel setText:[NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds]];
        if (self.timerLabel.hidden) {
            [self.timerLabel setHidden:NO];
        }
        self.timerSecondsLeft -- ;
    }
}

#pragma mark - Bussiness
- (void)refreshRegionsArray {
    [self.regionsArray removeAllObjects];
    
    NSArray *regionModelsArray = [DatabaseHelper getObjectsForEntity:@"Region" withSortKey:nil andSortAscending:NO andContext:self.beaconAnalyserManagedObjectContext];
    
    int counter = 0;
    for (RegionModel *regionModel in regionModelsArray) {
        if ([regionModel.willBeScanned boolValue]) {
            CLBeaconRegion *beaconRegion;
            NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:regionModel.proximityUUID];
            
            beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                              identifier:[NSString stringWithFormat:@"Region%d", counter++]];
            [self.regionsArray addObject:beaconRegion];
        }
    }
}

- (void)startScanning {
    [self refreshRegionsArray];
    for (CLBeaconRegion *beaconRegion in self.regionsArray) {
        [self.locationManager startMonitoringForRegion:beaconRegion];
        [self.locationManager startRangingBeaconsInRegion:beaconRegion];
    }
}

- (void)stopScanning {
    self.mode = @(kModeStop);
    [self.modeSegmentedControl setSelectedSegmentIndex:[self.mode integerValue]];
    [self stopTimers];
    [self.beaconsArray removeAllObjects];
    [self.beaconListTableView reloadData];
    for (CLBeaconRegion *beaconRegion in self.regionsArray) {
        [self.locationManager stopMonitoringForRegion:beaconRegion];
        [self.locationManager stopRangingBeaconsInRegion:beaconRegion];
    }
}

- (void)stopTimers {
    [self.timerLabel setHidden:YES];
    [self.counterTimer invalidate];
    [self.scanAndSaveTimer invalidate];
    [self.examinationIdLabel setHidden:YES];
}

- (void)sortingTypeSelectionButtonTapped:(id)sender {
    UIAlertController *alertController;
    
    alertController = [UIAlertController alertControllerWithTitle:nil
                                                          message:nil
                                                   preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *idAlertAction = [UIAlertAction actionWithTitle:@"Id"
                                                            style:UIAlertActionStyleDestructive
                                                          handler:^(UIAlertAction *action) {
                                                              [self.sortingTypeSelectionButton setTitle:@"Id" forState:UIControlStateNormal];
                                                              
                                                              NSSortDescriptor *uuidDescriptor = [[NSSortDescriptor alloc] initWithKey:@"proximityUUID.UUIDString" ascending:YES];
                                                              NSSortDescriptor *majorDescriptor = [[NSSortDescriptor alloc] initWithKey:@"major" ascending:YES];
                                                              NSSortDescriptor *minorDescriptor = [[NSSortDescriptor alloc] initWithKey:@"minor" ascending:YES];
                                                              self.sortDescriptors = @[uuidDescriptor, majorDescriptor, minorDescriptor];
                                                              [self.beaconListTableView reloadData];
                                                          }];
    [alertController addAction:idAlertAction];
    
    UIAlertAction *proximityAlertAction = [UIAlertAction actionWithTitle:@"Proximity"
                                                                   style:UIAlertActionStyleDestructive
                                                                 handler:^(UIAlertAction *action) {
                                                                     [self.sortingTypeSelectionButton setTitle:@"Proximity" forState:UIControlStateNormal];
                                                                     
                                                                     NSSortDescriptor *accuracyDescriptor = [[NSSortDescriptor alloc] initWithKey:@"accuracy" ascending:YES];
                                                                     self.sortDescriptors = @[accuracyDescriptor];
                                                                     [self.beaconListTableView reloadData];
                                                                 }];
    [alertController addAction:proximityAlertAction];
    
    [alertController setModalPresentationStyle:UIModalPresentationPopover];
    
    UIPopoverPresentationController *popPresenter = [alertController
                                                     popoverPresentationController];
    popPresenter.sourceView = self.sortingTypeSelectionButton;
    popPresenter.sourceRect = self.sortingTypeSelectionButton.bounds;
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
