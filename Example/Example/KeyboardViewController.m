//
//  KeyboardViewController.m
//  Example
//
//  Created by Dmitry Nesterenko on 30.03.16.
//  Copyright © 2016 e-legion. All rights reserved.
//

#import "KeyboardViewController.h"
#import "../../Source/ELNKeyboardDismissGestureRecognizer.h"

@interface KeyboardViewController ()

@property (nonatomic, strong) IBOutlet UIButton *button;

@end

@implementation KeyboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ELNKeyboardDismissGestureRecognizer *gestureRecognizer = [[ELNKeyboardDismissGestureRecognizer alloc] initWithShouldDismissKeyboardHandler:^BOOL(NSSet<UITouch *> * _Nonnull touches, UIEvent * _Nonnull event) {
        return touches.anyObject.view != self.button;
    }];
    [self.view addGestureRecognizer:gestureRecognizer];
}

@end
