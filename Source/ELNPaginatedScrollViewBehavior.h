//
//  ELNPaginatedScrollViewBehavior.h
//  ELNBehaviors
//
//  Created by Dmitry Nesterenko on 29.03.16.
//  Copyright © 2016 e-legion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ELNPaginatedScrollViewBehavior : NSObject

/// Sets up a timer to automatically scroll to next page.
/// Auto scroll is disabled if time interval equals to 0.
///
/// Default value is 0.
@property (nonatomic, assign) NSTimeInterval autoScrollTimeInterval;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)initWithPageControl:(UIPageControl *)pageControl scrollView:(UIScrollView *)scrollView NS_DESIGNATED_INITIALIZER;

- (void)setCurrentPageIndex:(NSInteger)currentPageIndex animated:(BOOL)animated;

@end
