//
//  RegionsViewController.m
//  Beacon Analyser
//
//  Created by Şeref Bülbül on 07/12/15.
//  Copyright © 2015 adesso TR. All rights reserved.
//

#import "RegionsViewController.h"

@interface RegionsViewController ()

@property (strong, nonatomic) NSArray *regionsArray;

@end

@implementation RegionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    self.beaconAnalyserManagedObjectContext = appDelegate.beaconAnalyserManagedObjectContext;
    
    [self insertDefaultRegions];
    [self setLongPressGesture];
    
    self.regionsArray = [NSArray new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshRegionsTableView];
}

- (void)setLongPressGesture {
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]
                                                                initWithTarget:self action:@selector(handleLongPress:)];
    [longPressGestureRecognizer setMinimumPressDuration:0.5]; //seconds
    [longPressGestureRecognizer setDelegate:self];
    [self.regionListTableView addGestureRecognizer:longPressGestureRecognizer];
}

- (void)insertDefaultRegions {
    RegionModel *kontaktRegionModel = [[DatabaseHelper searchObjectsForEntity:@"Region" withPredicate:[NSPredicate predicateWithFormat:@"name == %@", @"Kontakt"] andSortKey:nil andSortAscending:NO andContext:self.beaconAnalyserManagedObjectContext] firstObject];
    
    if (!kontaktRegionModel) {
        kontaktRegionModel = (RegionModel *)[DatabaseHelper insertNewEntityWithName:@"Region" andContext:self.beaconAnalyserManagedObjectContext];
        
        [kontaktRegionModel setName:@"Kontakt"];
        [kontaktRegionModel setProximityUUID:@"f7826da6-4fa2-4e98-8024-bc5b71e0893e"];
        [kontaktRegionModel setMajor:nil];
        [kontaktRegionModel setMinor:nil];
        [kontaktRegionModel setWillBeScanned:@(YES)];
        [DatabaseHelper saveCoreData:self.beaconAnalyserManagedObjectContext];
    }
    
    RegionModel *emRegionModel = [[DatabaseHelper searchObjectsForEntity:@"Region" withPredicate:[NSPredicate predicateWithFormat:@"name == %@", @"EmBeacon"] andSortKey:nil andSortAscending:NO andContext:self.beaconAnalyserManagedObjectContext] firstObject];
    
    if (!emRegionModel) {
        emRegionModel = (RegionModel *)[DatabaseHelper insertNewEntityWithName:@"Region" andContext:self.beaconAnalyserManagedObjectContext];
        
        [emRegionModel setName:@"EmBeacon"];
        [emRegionModel setProximityUUID:@"699ebc80-e1f3-11e3-9a0f-0cf3ee3bc012"];
        [emRegionModel setMajor:nil];
        [emRegionModel setMinor:nil];
        [emRegionModel setWillBeScanned:@(YES)];
        [DatabaseHelper saveCoreData:self.beaconAnalyserManagedObjectContext];
    }
    
    RegionModel *madRegionModel = [[DatabaseHelper searchObjectsForEntity:@"Region" withPredicate:[NSPredicate predicateWithFormat:@"name == %@", @"MadBeacon"] andSortKey:nil andSortAscending:NO andContext:self.beaconAnalyserManagedObjectContext] firstObject];
    
    if (!madRegionModel) {
        madRegionModel = (RegionModel *)[DatabaseHelper insertNewEntityWithName:@"Region" andContext:self.beaconAnalyserManagedObjectContext];
        
        [madRegionModel setName:@"MadBeacon"];
        [madRegionModel setProximityUUID:@"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"];
        [madRegionModel setMajor:nil];
        [madRegionModel setMinor:nil];
        [madRegionModel setWillBeScanned:@(YES)];
        [DatabaseHelper saveCoreData:self.beaconAnalyserManagedObjectContext];
    }
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.regionsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"regionListTableViewCellIdentifier"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"regionListTableViewCellIdentifier"];
    }
    
    RegionModel *regionModel = [self.regionsArray objectAtIndex:indexPath.row];
    
    [cell.textLabel setText:regionModel.name];
    
    if ([regionModel.willBeScanned boolValue]) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RegionModel *regionModel = [self.regionsArray objectAtIndex:indexPath.row];
    
    RegionDetailViewController *regionDetailViewController = [RegionDetailViewController new];
    [regionDetailViewController setRegionModel:regionModel];
    
    [self.navigationController pushViewController:regionDetailViewController animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    RegionModel *regionModel = [self.regionsArray objectAtIndex:indexPath.row];
    
    SCLAlertView *alertView = [Utils initCustomAlert];
    [alertView addButton:@"Yes" actionBlock:^(void) {
        [self.beaconAnalyserManagedObjectContext deleteObject:regionModel];
        [DatabaseHelper saveCoreData:self.beaconAnalyserManagedObjectContext];
        [self refreshRegionsTableView];
    }];
    [alertView showEdit:@"" subTitle:[NSString stringWithFormat:@"Are you sure to delete region %@", regionModel.name] closeButtonTitle:@"No" duration:0.0f];
    [alertView alertIsDismissed:^{
    }];
}

#pragma mark - Bussiness

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint point = [gestureRecognizer locationInView:self.regionListTableView];
    
    NSIndexPath *indexPath = [self.regionListTableView indexPathForRowAtPoint:point];
    RegionModel *selectedRegionModel = [self.regionsArray objectAtIndex:indexPath.row];
    
    if (indexPath && gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        SCLAlertView *alertView = [Utils initCustomAlert];
        [alertView addButton:@"Yes" actionBlock:^(void) {
            RegionModel *regionModel = (RegionModel *)[DatabaseHelper insertNewEntityWithName:@"Region" andContext:self.beaconAnalyserManagedObjectContext];
            
            [regionModel setName:[NSString stringWithFormat:@"%@ Copy", selectedRegionModel.name]];
            [regionModel setProximityUUID:selectedRegionModel.proximityUUID];
            [regionModel setMajor:selectedRegionModel.major];
            [regionModel setMinor:selectedRegionModel.minor];
            [regionModel setWillBeScanned:selectedRegionModel.willBeScanned];
            
            [DatabaseHelper saveCoreData:self.beaconAnalyserManagedObjectContext];
            [self refreshRegionsTableView];
        }];
        [alertView showEdit:@"" subTitle:[NSString stringWithFormat:@"Do you want to duplicate region %@", selectedRegionModel.name] closeButtonTitle:@"No" duration:0.0f];
        [alertView alertIsDismissed:^{
        }];
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - Bussiness

- (void)refreshRegionsTableView {
    self.regionsArray = [DatabaseHelper getObjectsForEntity:@"Region" withSortKey:nil andSortAscending:NO andContext:self.beaconAnalyserManagedObjectContext];
    
    [self.regionListTableView reloadData];
}

#pragma mark - Actions

- (IBAction)addRegionButtonTapped:(id)sender {
    NewRegionViewController *newRegionViewController = [NewRegionViewController new];
    
    [self.navigationController pushViewController:newRegionViewController animated:YES];
}

@end
