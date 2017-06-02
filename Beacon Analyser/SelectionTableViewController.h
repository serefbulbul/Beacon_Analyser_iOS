//
//  SelectionTableViewController.h
//  iSales
//
//  Created by Osman SÖYLEMEZ on 09/06/15.
//  Copyright (c) 2015 Boran ASLAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectionTableViewDelegate <NSObject>

- (void)didSelectRowAtIndex:(int)index;

@end


@interface SelectionTableViewController : UITableViewController

@property (weak, nonatomic) id<SelectionTableViewDelegate> delegate;
@property (strong, nonatomic) NSArray *selectionArray;
@property (strong, nonatomic) NSMutableArray *selectedArray;
@property (nonatomic) BOOL isMultiSelection;

@end
