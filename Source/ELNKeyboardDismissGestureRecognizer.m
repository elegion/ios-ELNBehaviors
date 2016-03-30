//
//  ELNKeyboardDismissGestureRecognizer.m
//  ELNBehaviors
//
//  Created by Dmitry Nesterenko on 30.03.16.
//  Copyright © 2016 e-legion. All rights reserved.
//

#import "ELNKeyboardDismissGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@implementation ELNKeyboardDismissGestureRecognizer

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        self.cancelsTouchesInView = NO;
        self.delaysTouchesBegan = NO;
        self.delaysTouchesEnded = NO;
    }
    return self;
}

- (instancetype)initWithShouldDismissKeyboardHandler:(BOOL (^)(NSSet<UITouch *> * _Nonnull, UIEvent * _Nonnull))shouldDismissKeyboardHandler {
    self = [self init];
    if (self) {
        self.shouldDismissKeyboardHandler = shouldDismissKeyboardHandler;
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    BOOL viewCanBecomeFirstResponder = [touches.anyObject.view canBecomeFirstResponder];
    if (!viewCanBecomeFirstResponder && (self.shouldDismissKeyboardHandler == nil || self.shouldDismissKeyboardHandler(touches, event))) {
        [self.view endEditing:YES];
        self.state = UIGestureRecognizerStateRecognized;
        return;
    }

    self.state = UIGestureRecognizerStateFailed;
}

@end
