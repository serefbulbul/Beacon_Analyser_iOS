//
//  SelectionTableViewController.m
//  iSales
//
//  Created by Osman SÖYLEMEZ on 09/06/15.
//  Copyright (c) 2015 Boran ASLAN. All rights reserved.
//

#import "SelectionTableViewController.h"

@interface SelectionTableViewController ()

@end

@implementation SelectionTableViewController

@synthesize selectionArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorColor = [UIColor colorWithRed:179 green:130 blue:63 alpha:1.0];
    self.selectedArray = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.selectionArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"SelectionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.font = [UIFont fontWithName:@"Lato-Regular" size:16.0];
    cell.textLabel.text = [self.selectionArray objectAtIndex:indexPath.row];    
    return cell;
}

#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.isMultiSelection) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            [self.selectedArray removeObject:[NSNumber numberWithInt:(int)indexPath.row]];
        } else {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [self.selectedArray addObject:[NSNumber numberWithInt:(int)indexPath.row]];
        }
    }else{
        if ([self.delegate respondsToSelector:@selector(didSelectRowAtIndex:)]) {
            [self.delegate didSelectRowAtIndex:(int)indexPath.row];
        }
    }
}

@end
