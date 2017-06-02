//
//  SelectionButton.h
//  iSales
//
//  Created by Osman SÖYLEMEZ on 09/06/15.
//  Copyright (c) 2015 Boran ASLAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectionPopoverController.h"
#import "SelectionTableViewController.h"

typedef void(^CompletionBlock)(int index);
typedef void(^CompletionBlockForMultiSelection)(NSArray *indexArray);

@interface SelectionButton : UIButton<SelectionTableViewDelegate,UIPopoverControllerDelegate>{
    CompletionBlock didSelectRowAtIndex;
    CompletionBlockForMultiSelection didSelectRows;
    BOOL isMultiSelection;
}

- (void) setSelectionArray:(NSArray *)array Completion:(CompletionBlock) block;
- (void) setMultiSelectionArray:(NSArray *)array Completion:(CompletionBlockForMultiSelection) block;

@end
