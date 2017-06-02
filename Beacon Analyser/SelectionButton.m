//
//  SelectionButton.m
//  iSales
//
//  Created by Osman SÖYLEMEZ on 09/06/15.
//  Copyright (c) 2015 Boran ASLAN. All rights reserved.
//

#import "SelectionButton.h"

@interface SelectionButton()

@property (strong, nonatomic) SelectionPopoverController *selectionPopoverController;
@property (strong, nonatomic) SelectionTableViewController *selectionTableViewController;

@end

@implementation SelectionButton

#pragma mark - SelectionButtonDelegate method

- (void)didSelectRowAtIndex:(int)index{    
    if (self.selectionPopoverController) {
        [self.selectionPopoverController dismissPopoverAnimated:YES];
        self.selectionPopoverController = nil;
        self.selectionTableViewController = nil;
    }
    
    didSelectRowAtIndex(index);
}

#pragma mark - UIPopoverControllerDelegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
    if (isMultiSelection) {
        didSelectRows(self.selectionTableViewController.selectedArray);
    }else{
        if (self.selectionTableViewController) {
            self.selectionTableViewController = nil;
        }
    }
    
    if (self.selectionPopoverController) {
        [self.selectionPopoverController dismissPopoverAnimated:YES];
        self.selectionPopoverController = nil;
    }
}

#pragma mark - Business

- (void) setSelectionArray:(NSArray *)array Completion:(CompletionBlock) block{
    isMultiSelection = NO;
    if (self.selectionTableViewController == nil) {
        self.selectionTableViewController = [[SelectionTableViewController alloc] initWithNibName:@"SelectionTableViewController" bundle:nil];
        self.selectionTableViewController.delegate = self;
        self.selectionTableViewController.isMultiSelection = NO;
        self.selectionTableViewController.selectionArray = array;
    }
    
    if (self.selectionPopoverController == nil) {
        self.selectionPopoverController = [[SelectionPopoverController alloc] initWithContentViewController:self.selectionTableViewController];
        [self.selectionPopoverController setDelegate:self];
        [self.selectionPopoverController presentPopoverFromRect:self.frame inView:self.superview permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
    
    didSelectRowAtIndex = block;
}

- (void) setMultiSelectionArray:(NSArray *)array Completion:(CompletionBlockForMultiSelection) block{
    isMultiSelection = YES;
    if (self.selectionTableViewController == nil) {
        self.selectionTableViewController = [[SelectionTableViewController alloc] initWithNibName:@"SelectionTableViewController" bundle:nil];
        self.selectionTableViewController.isMultiSelection = YES;
        self.selectionTableViewController.delegate = self;
        self.selectionTableViewController.selectionArray = array;
    }
    
    if (self.selectionPopoverController == nil) {
        self.selectionPopoverController = [[SelectionPopoverController alloc] initWithContentViewController:self.selectionTableViewController];
        [self.selectionPopoverController setDelegate:self];
        [self.selectionPopoverController presentPopoverFromRect:self.frame inView:self.superview permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
    
    didSelectRows = block;
}

@end
