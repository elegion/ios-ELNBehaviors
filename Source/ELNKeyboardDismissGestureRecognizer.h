//
//  ELNKeyboardDismissGestureRecognizer.h
//  ELNBehaviors
//
//  Created by Dmitry Nesterenko on 30.03.16.
//  Copyright © 2016 e-legion. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ELNKeyboardDismissGestureRecognizer : UIGestureRecognizer

@property (nonatomic, copy) BOOL (^ _Nullable shouldDismissKeyboardHandler)(NSSet<UITouch *> *touches, UIEvent *event);

- (instancetype)initWithShouldDismissKeyboardHandler:(BOOL (^ _Nullable)(NSSet<UITouch *> *touches, UIEvent *event))shouldDismissKeyboardHandler;

@end

NS_ASSUME_NONNULL_END
