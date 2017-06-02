//
//  AnalyseViewController.m
//  Beacon Analyser
//
//  Created by Şeref Bülbül on 07/12/15.
//  Copyright © 2015 adesso TR. All rights reserved.
//

#import "AnalyseViewController.h"

@interface AnalyseViewController ()

@property (strong, nonatomic) NSArray *savedBeaconModelsArray;
@property (strong, nonatomic) NSArray *examinationIdsArray;
@property (strong, nonatomic) NSArray *beaconNamesArray;
@property (strong, nonatomic) NSString *selectedExaminationId;
@property (strong, nonatomic) NSString *selectedBeaconName;

@end

@implementation AnalyseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    self.beaconAnalyserManagedObjectContext = appDelegate.beaconAnalyserManagedObjectContext;
    
    self.selectedExaminationId = @"All Examinations";
    self.selectedBeaconName = @"All Beacons";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self refreshAnalyseListTableView];
    [self refreshExaminationIdsAndBeaconNames];
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.savedBeaconModelsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"analyseListTableViewCellIdentifier"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"analyseListTableViewCellIdentifier"];
    }
    
    SavedBeaconModel *savedBeaconModel = [self.savedBeaconModelsArray objectAtIndex:indexPath.row];
    
    [cell.textLabel setText:[NSString stringWithFormat:@"%@, %@, %@, %@, %@", savedBeaconModel.examinationId, savedBeaconModel.beacon.name, savedBeaconModel.saveTime, savedBeaconModel.actualProximity, savedBeaconModel.accuracy]];
    
    return cell;
}

#pragma mark - PickerView

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 0;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 0;
}

#pragma mark - Mail Composer

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Bussiness

- (void)refreshAnalyseListTableView {
    NSPredicate *predicate;
    if (self.selectedExaminationId && ![self.selectedExaminationId isEqualToString:@"All Examinations"]) {
        if (self.selectedBeaconName && ![self.selectedBeaconName isEqualToString:@"All Beacons"]) {
            predicate = [NSPredicate predicateWithFormat:@"examinationId == %@ AND beacon.name == %@", self.selectedExaminationId, self.selectedBeaconName];
        } else {
            predicate = [NSPredicate predicateWithFormat:@"examinationId == %@", self.selectedExaminationId];
        }
    } else {
        if (self.selectedBeaconName && ![self.selectedBeaconName isEqualToString:@"All Beacons"]) {
            predicate = [NSPredicate predicateWithFormat:@"beacon.name == %@", self.selectedBeaconName];
        } else {
            predicate = nil;
        }
    }
    self.savedBeaconModelsArray = [DatabaseHelper searchObjectsForEntity:@"SavedBeacon" withPredicate:predicate andSortKey:nil andSortAscending:NO andContext:self.beaconAnalyserManagedObjectContext];
    
    [self.analyseListTableView reloadData];
}

- (void)refreshExaminationIdsAndBeaconNames {
    self.examinationIdsArray = [DatabaseHelper getDistictAttributeValuesForEntity:@"SavedBeacon" forAttribute:@"examinationId" andContext:self.beaconAnalyserManagedObjectContext];
    
    self.beaconNamesArray = [DatabaseHelper getDistictAttributeValuesForEntity:@"Beacon" forAttribute:@"name" andContext:self.beaconAnalyserManagedObjectContext];
}

- (void)emailFile:(NSString*)file inPath:(NSString*)path toRecipient:(NSString*)recipient withTitle:(NSString*)title andBody:(NSString*)body
{
    NSString *emailTitle  = title;
    NSString *messageBody = body;
    NSArray *toRecipients = [NSArray arrayWithObject:recipient];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipients];
    
    // Determine the file name and extension
    NSArray *filepart = [file componentsSeparatedByString:@"."];
    NSString *filename = [filepart objectAtIndex:0];
    NSString *extension = [filepart objectAtIndex:1];
    
    // Get the resource path and read the file using NSData
    NSData *fileData = [NSData dataWithContentsOfFile:path];
    
    // Determine the MIME type
    NSString *mimeType;
    if ([extension isEqualToString:@"jpg"]) {
        mimeType = @"image/jpeg";
    } else if ([extension isEqualToString:@"png"]) {
        mimeType = @"image/png";
    } else if ([extension isEqualToString:@"doc"]) {
        mimeType = @"application/msword";
    } else if ([extension isEqualToString:@"ppt"]) {
        mimeType = @"application/vnd.ms-powerpoint";
    } else if ([extension isEqualToString:@"html"]) {
        mimeType = @"text/html";
    } else if ([extension isEqualToString:@"pdf"]) {
        mimeType = @"application/pdf";
    } else if ([extension isEqualToString:@"txt"]) {
        mimeType = @"text/rtf";
    } else if ([extension isEqualToString:@"pgp"]) {
        mimeType = @"application/pgp";
    }
    
    // add attachment
    [mc addAttachmentData:fileData mimeType:mimeType fileName:[NSString stringWithFormat:@"%@.%@", filename, extension]];
    
    // present mail view controller on screen
    [self presentViewController:mc animated:YES completion:nil];
}



#pragma mark - Actions

- (IBAction)examinationIdSelectionButtonTapped:(id)sender {
    if (self.examinationIdsArray && self.examinationIdsArray.count > 0) {
        UIAlertController *alertController;
        
        alertController = [UIAlertController alertControllerWithTitle:nil
                                                              message:nil
                                                       preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *allAction = [UIAlertAction actionWithTitle:@"All Examinations"
                                                         style:UIAlertActionStyleDestructive
                                                       handler:^(UIAlertAction *action) {
                                                           self.selectedExaminationId = @"All Examinations";
                                                           [self.examinationIdSelectionButton setTitle:@"All Examinations" forState:UIControlStateNormal];
                                                           [self refreshAnalyseListTableView];
                                                       }];
        [alertController addAction:allAction];
        
        for (NSString *examinationId in self.examinationIdsArray) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:examinationId
                                                             style:UIAlertActionStyleDestructive
                                                           handler:^(UIAlertAction *action) {
                                                               self.selectedExaminationId = examinationId;
                                                               [self.examinationIdSelectionButton setTitle:examinationId forState:UIControlStateNormal];
                                                               [self refreshAnalyseListTableView];
                                                           }];
            [alertController addAction:action];
        }
        
        [alertController setModalPresentationStyle:UIModalPresentationPopover];
        
        UIPopoverPresentationController *popPresenter = [alertController
                                                         popoverPresentationController];
        popPresenter.sourceView = self.examinationIdSelectionButton;
        popPresenter.sourceRect = self.examinationIdSelectionButton.bounds;
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (IBAction)beaconNameSelectionButtonTapped:(id)sender {
    if (self.beaconNamesArray && self.beaconNamesArray.count > 0) {
        UIAlertController *alertController;
        
        alertController = [UIAlertController alertControllerWithTitle:nil
                                                              message:nil
                                                       preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *allAction = [UIAlertAction actionWithTitle:@"All Beacons"
                                                            style:UIAlertActionStyleDestructive
                                                          handler:^(UIAlertAction *action) {
                                                              self.selectedBeaconName = @"All Beacons";
                                                              [self.beaconNameSelectionButton setTitle:@"All Beacons" forState:UIControlStateNormal];
                                                              [self refreshAnalyseListTableView];
                                                          }];
        [alertController addAction:allAction];
        
        for (NSString *beaconName in self.beaconNamesArray) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:beaconName
                                                             style:UIAlertActionStyleDestructive
                                                           handler:^(UIAlertAction *action) {
                                                               self.selectedBeaconName = beaconName;
                                                               [self.beaconNameSelectionButton setTitle:beaconName forState:UIControlStateNormal];
                                                               [self refreshAnalyseListTableView];
                                                           }];
            [alertController addAction:action];
        }
        
        [alertController setModalPresentationStyle:UIModalPresentationPopover];
        
        UIPopoverPresentationController *popPresenter = [alertController
                                                         popoverPresentationController];
        popPresenter.sourceView = self.examinationIdSelectionButton;
        popPresenter.sourceRect = self.examinationIdSelectionButton.bounds;
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (IBAction)exportButtonTapped:(id)sender {
    if (self.savedBeaconModelsArray.count > 0) {
        NSString *documentdir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *dataName = [NSString stringWithFormat:@"%@ - %@ - %@.csv",self.selectedExaminationId, self.selectedBeaconName, [[NSDate date] shortTime]];
        NSString *tmpDirectoryPath = [documentdir stringByAppendingPathComponent:[NSString stringWithFormat:@"/tmp"]];
        NSString *dataFilePath = [tmpDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", dataName]];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:dataFilePath]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:tmpDirectoryPath withIntermediateDirectories:NO attributes:nil error:nil];
            [[NSFileManager defaultManager] createFileAtPath:dataFilePath contents:nil attributes:nil];
        }
        
        NSMutableString *writeString = [NSMutableString stringWithCapacity:0]; //don't worry about the capacity, it will expand as necessary
        
        [writeString appendString:[NSString stringWithFormat:@"\"Examination Id\";\"Beacon Name\";\"Proximity UUID\";\"Major\";\"Minor\";\"Accuracy\";\"RSSI\";\"Actual Proximity\";\"Save Time\"\n"]];
        
        for (int i=0; i<self.savedBeaconModelsArray.count; i++) {
            SavedBeaconModel *savedBeaconModel = [self.savedBeaconModelsArray objectAtIndex:i];
            [writeString appendString:[NSString stringWithFormat:@"\"%@\";\"%@\";\"%@\";\"%@\";\"%@\";\"%.3f\";\"%@\";\"%@\";\"%@\"\n", self.selectedExaminationId, savedBeaconModel.beacon.name, savedBeaconModel.beacon.proximityUUID, savedBeaconModel.beacon.major, savedBeaconModel.beacon.minor, [savedBeaconModel.accuracy doubleValue], savedBeaconModel.rssi, savedBeaconModel.actualProximity, savedBeaconModel.saveTime]];
        }
        
        NSFileHandle *handle;
        handle = [NSFileHandle fileHandleForWritingAtPath:dataFilePath];
        [handle truncateFileAtOffset:[handle seekToEndOfFile]];
        [handle writeData:[writeString dataUsingEncoding:NSUTF8StringEncoding]];
        //    kazim@monolytic.com    bulbulseref@gmail.com
        [self emailFile:dataName inPath:dataFilePath toRecipient:@"bulbulseref@gmail.com" withTitle:@"Beacon Analyser CSV Export" andBody:@"CSV file is attached."];
        
        [[NSFileManager defaultManager] removeItemAtPath:tmpDirectoryPath error:nil];

    }
}

- (IBAction)analyseButtonTapped:(id)sender {
    AnalyseDetailsViewController *analyseDetailsViewController = [AnalyseDetailsViewController new];
    
    double totalProximity=0, minimumProximity=INFINITY, maximumProximity=-1.0*INFINITY, totalRssi=0, minimumRssi=INFINITY, maximumRssi=-1.0*INFINITY;
    
    int numberOfIndefiniteProximity = 0;
    
    for (SavedBeaconModel *savedBeaconModel in self.savedBeaconModelsArray) {
        totalProximity += [savedBeaconModel.accuracy doubleValue];
        totalRssi += [savedBeaconModel.rssi doubleValue];
        
        if ([savedBeaconModel.accuracy doubleValue] > maximumProximity) {
            maximumProximity = [savedBeaconModel.accuracy doubleValue];
        }
        
        if ([savedBeaconModel.rssi doubleValue] != 0.0 && [savedBeaconModel.rssi doubleValue] > maximumRssi) {
            maximumRssi = [savedBeaconModel.rssi doubleValue];
        }
        
        if ([savedBeaconModel.accuracy doubleValue] != -1.0 &&[savedBeaconModel.accuracy doubleValue] < minimumProximity) {
            minimumProximity = [savedBeaconModel.accuracy doubleValue];
        }
        
        if ([savedBeaconModel.accuracy doubleValue] == -1.0) {
            numberOfIndefiniteProximity++;
        }
        
        if ([savedBeaconModel.rssi doubleValue] < minimumRssi) {
            minimumRssi = [savedBeaconModel.rssi doubleValue];
        }
    }
    
    SavedBeaconModel *savedBeaconModel = [self.savedBeaconModelsArray firstObject];
    
    double averageProximity = totalProximity / self.savedBeaconModelsArray.count;
    double averageRssi = totalRssi / self.savedBeaconModelsArray.count;
    
    [analyseDetailsViewController setNumberOfRecordsText:[NSString stringWithFormat:@"%d", (int)self.savedBeaconModelsArray.count]];
    
    [analyseDetailsViewController setAverageProximityText:[NSString stringWithFormat:@"%f",averageProximity]];
    [analyseDetailsViewController setMinimumProximityText:[NSString stringWithFormat:@"%f",minimumProximity]];
    [analyseDetailsViewController setMaximumProximityText:[NSString stringWithFormat:@"%f",maximumProximity]];
    
    [analyseDetailsViewController setAverageRssiText:[NSString stringWithFormat:@"%f",averageRssi]];
    [analyseDetailsViewController setMinimumRssiText:[NSString stringWithFormat:@"%f",minimumRssi]];
    [analyseDetailsViewController setMaximumRssiText:[NSString stringWithFormat:@"%f",maximumRssi]];
    
    [analyseDetailsViewController setActualProximityText:[savedBeaconModel.actualProximity stringValue]];
    [analyseDetailsViewController setNumberOfIndefiniteProximityText:[NSString stringWithFormat:@"%d",numberOfIndefiniteProximity]];
    
    [self.navigationController pushViewController:analyseDetailsViewController animated:YES];
}

- (IBAction)clearAllSavedDataButtonTapped:(id)sender {
    SCLAlertView *alertView = [Utils initCustomAlert];
    [alertView addButton:@"Yes" actionBlock:^(void) {
        [DatabaseHelper deleteAllObjectsForEntity:@"SavedBeacon" andContext:self.beaconAnalyserManagedObjectContext];
        [DatabaseHelper saveCoreData:self.beaconAnalyserManagedObjectContext];
        [self.examinationIdSelectionButton setTitle:@"All Examinations" forState:UIControlStateNormal];
        [self refreshExaminationIdsAndBeaconNames];
        [self refreshAnalyseListTableView];
    }];
    [alertView showEdit:@"" subTitle:@"Are you sure to clear all saved beacon data?" closeButtonTitle:@"No" duration:0.0f];
    [alertView alertIsDismissed:^{
    }];
}

@end
