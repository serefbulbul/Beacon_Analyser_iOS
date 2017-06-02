//
//  ADSPopupViewController.m
//  NumpadTextViewSample
//
//  Created by Boran ASLAN on 12/06/15.
//  Copyright (c) 2015 adesso. All rights reserved.
//

#import "ADSPopupViewController.h"
//#import "FXBlurView.h"

#define kPopupModalAnimationDuration 0.35

@interface ADSPopupViewController ()

@property (strong, nonatomic) IBOutlet UIViewController *contentViewController;
@property (strong, nonatomic) IBOutlet UIButton *closeButton;
@property (assign, nonatomic, getter=isCloseButtonDisabled) BOOL closeButtonDisabled;
//@property (strong, nonatomic) FXBlurView *blurView;
@end

@implementation ADSPopupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.isCloseButtonDisabled) {
        self.closeButton.enabled = !self.isCloseButtonDisabled;
    }
}


//- (void)initBlurView:(UIView *) sourceView{
//    if (!self.blurView) {
//        self.blurView = [[FXBlurView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
//        self.blurView.dynamic = NO;
//        self.blurView.underlyingView = sourceView;
//        self.blurView.blurRadius = 10.0f;
//        self.blurView.tintColor = [UIColor whiteColor];
//        [sourceView addSubview:self.blurView];
//    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)presentPopupViewController:(UIViewController *)contentViewController on:(UIView *)sourceView {
    self.contentViewController = contentViewController;
    self.view.frame = sourceView.bounds;
//    [self initBlurView:sourceView];
    
    UIView *contentView = contentViewController.view;
    contentView.frame = self.contentViewSize;
    
    contentView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
    contentView.layer.shadowPath = [UIBezierPath bezierPathWithRect:contentView.bounds].CGPath;
    contentView.layer.masksToBounds = NO;
    contentView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    contentView.clipsToBounds = YES;
    
    CGSize sourceSize = sourceView.bounds.size;
    CGSize popupSize = contentView.bounds.size;
    CGRect popupEndRect = CGRectMake((sourceSize.width - popupSize.width) / 2,
                                     (sourceSize.height - popupSize.height) / 2,
                                     popupSize.width,
                                     popupSize.height);
    
    contentView.frame = popupEndRect;
    contentView.alpha = 0.0f;
    
    [self.view addSubview:contentView];
    [sourceView addSubview:self.view];
    
    [UIView animateWithDuration:kPopupModalAnimationDuration animations:^{
        contentView.alpha = 1.0f;
    } completion:^(BOOL finished) {
    }];
    
    [self.view setBackgroundColor:[[UIColor clearColor] colorWithAlphaComponent:0.2]];
}

- (void)scrollAnimationYPosition:(float)yPosition{
    [UIView animateWithDuration:kPopupModalAnimationDuration animations:^{
        CGRect rect = self.view.frame;
        rect.origin.y = -yPosition;
        [self.view setFrame:rect];
    } completion:^(BOOL finished) {
    }];
}

- (IBAction)dismissPopupViewControllerWithanimation:(id)sender {
    [UIView animateWithDuration:kPopupModalAnimationDuration animations:^{
        self.view.alpha = 0.0f;
//        self.blurView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        self.contentViewController = nil;
//        [self.blurView removeFromSuperview];
//        self.blurView = nil;
    }];
}

- (void)disableCloseButton:(BOOL)active {
    self.closeButtonDisabled = active;
    if (self.closeButton) {
        self.closeButton.enabled = active;
    }
}

#pragma mark - close

- (void)closePopupViewWithObject:(NSObject *)object {
    [UIView animateWithDuration:kPopupModalAnimationDuration animations:^{
        self.view.alpha = 0.0f;
//        self.blurView.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (object && self.delegate) {
            [self.delegate popupDidDismissWithObject:object];
        }
        [self.view removeFromSuperview];
        self.contentViewController = nil;
//        [self.blurView removeFromSuperview];
//        self.blurView = nil;
    }];
}

@end