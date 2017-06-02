//
//  BeaconsViewController.m
//  Beacon Analyser
//
//  Created by Şeref Bülbül on 07/12/15.
//  Copyright © 2015 adesso TR. All rights reserved.
//

#import "BeaconsViewController.h"

@interface BeaconsViewController ()

@property (strong, nonatomic) NSArray *beaconModelsArray;
@property (strong, nonatomic) NSMutableArray *regionsArray;

@end

@implementation BeaconsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    self.beaconAnalyserManagedObjectContext = appDelegate.beaconAnalyserManagedObjectContext;

    self.regionsArray = [NSMutableArray new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshBeaconsTableView];
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.beaconModelsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"beaconListTableViewCellIdentifier"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"beaconListTableViewCellIdentifier"];
    }
    
    BeaconModel *beaconModel = [self.beaconModelsArray objectAtIndex:indexPath.row];
    
    if (beaconModel.name && ![beaconModel.name isEqualToString:@""]) {
        [cell.textLabel setText:[NSString stringWithFormat:@"%@, Actual Proximity: %@",beaconModel.name, beaconModel.beaconData.actualProximity]];
    } else {
        [cell.textLabel setText:[NSString stringWithFormat:@"%@, %@, %@, %@",beaconModel.proximityUUID, beaconModel.major, beaconModel.minor, beaconModel.beaconData.actualProximity]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BeaconModel *beaconModel = [self.beaconModelsArray objectAtIndex:indexPath.row];
    
    BeaconDetailViewController *beaconDetailViewController = [BeaconDetailViewController new];
    [beaconDetailViewController setBeaconModel:beaconModel];
    
    [self.navigationController pushViewController:beaconDetailViewController animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    BeaconModel *beaconModel = [self.beaconModelsArray objectAtIndex:indexPath.row];
    
    SCLAlertView *alertView = [Utils initCustomAlert];
    [alertView addButton:@"Yes" actionBlock:^(void) {
        [self.beaconAnalyserManagedObjectContext deleteObject:beaconModel];
        [DatabaseHelper saveCoreData:self.beaconAnalyserManagedObjectContext];
        [self refreshBeaconsTableView];
    }];
    [alertView showEdit:@"" subTitle:[NSString stringWithFormat:@"Are you sure to delete beacon %@", beaconModel.name] closeButtonTitle:@"No" duration:0.0f];
    [alertView alertIsDismissed:^{
    }];
}

#pragma mark - Bussiness

- (void)refreshBeaconsTableView {
    self.beaconModelsArray = [DatabaseHelper getObjectsForEntity:@"Beacon" withSortKey:nil andSortAscending:NO andContext:self.beaconAnalyserManagedObjectContext];
    
    [self.beaconListTableView reloadData];
}

#pragma mark - Actions

- (IBAction)addBeaconButtonTapped:(id)sender {
    NewBeaconViewController *newBeaconViewController = [NewBeaconViewController new];
    
    [self.navigationController pushViewController:newBeaconViewController animated:YES];
}

@end
