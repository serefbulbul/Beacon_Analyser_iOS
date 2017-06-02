//
//  ADSPopupViewController.h
//  NumpadTextViewSample
//
//  Created by Boran ASLAN on 12/06/15.
//  Copyright (c) 2015 adesso. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADSPopupViewControllerDelegate <NSObject>

@optional

- (void)popupDidDismissWithObject:(NSObject *)object;

@end

@interface ADSPopupViewController : UIViewController

@property (weak, nonatomic) id<ADSPopupViewControllerDelegate> delegate;
@property (assign, nonatomic) CGRect contentViewSize;

- (void)presentPopupViewController:(UIViewController *)contentViewController on:(UIView *)sourceView;
- (void)disableCloseButton:(BOOL)active;
- (void)closePopupViewWithObject:(NSObject *)object;
- (void)scrollAnimationYPosition:(float)yPosition;

@end
