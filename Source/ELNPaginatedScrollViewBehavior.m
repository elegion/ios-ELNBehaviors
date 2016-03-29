//
//  ELNPaginatedScrollViewBehavior.m
//  ELNBehaviors
//
//  Created by Dmitry Nesterenko on 29.03.16.
//  Copyright © 2016 e-legion. All rights reserved.
//

#import "ELNPaginatedScrollViewBehavior.h"

@interface ELNPaginatedScrollViewBehavior ()

@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) NSInteger currentPageIndex;
@property (nonatomic, weak) NSTimer *autoScrollTimer;

@end

@implementation ELNPaginatedScrollViewBehavior

#pragma mark - Object Lifecycle

- (void)dealloc {
    [self.pageControl removeTarget:self action:@selector(pageControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.scrollView removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset)) context:NULL];
}

#pragma mark - Initialization

- (instancetype)initWithPageControl:(UIPageControl *)pageControl scrollView:(UIScrollView *)scrollView {
    self = [super init];
    if (self) {
        self.pageControl = pageControl;
        [self.pageControl addTarget:self action:@selector(pageControlValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        self.scrollView = scrollView;
        [scrollView addObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset)) options:(NSKeyValueObservingOptions)0 context:NULL];
    }
    return self;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (object != self.scrollView) {
        return;
    }
    
    [self scrollViewDidScroll:self.scrollView];
}

#pragma mark - Scroll View

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.bounds.size.width;
    NSInteger page = (scrollView.contentOffset.x + pageWidth / 2) / pageWidth;
    page = MAX(0, page);
    page = MIN(self.pageControl.numberOfPages - 1, page);
    
    [self updateCurrentPageIndex:page];
}

#pragma mark - Pages Management

- (void)setCurrentPageIndex:(NSInteger)currentPageIndex {
    [self setCurrentPageIndex:currentPageIndex animated:NO];
}

- (void)setCurrentPageIndex:(NSInteger)currentPageIndex animated:(BOOL)animated {
    CGPoint contentOffsetForCurrentPage = CGPointMake(self.scrollView.bounds.size.width * currentPageIndex, 0);
    [self.scrollView setContentOffset:contentOffsetForCurrentPage animated:animated];
}

- (void)updateCurrentPageIndex:(NSInteger)currentPageIndex {
    if (_currentPageIndex == currentPageIndex) {
        return;
    }
    _currentPageIndex = currentPageIndex;
    
    self.pageControl.currentPage = currentPageIndex;
}

#pragma mark - Page Control

- (void)pageControlValueChanged:(UIPageControl *)sender {
    [self setCurrentPageIndex:sender.currentPage animated:YES];
}

#pragma mark - Auto Scroll

- (void)setAutoScrollTimeInterval:(NSTimeInterval)autoScrollTimeInterval {
    if (_autoScrollTimeInterval == autoScrollTimeInterval) {
        return;
    }
    _autoScrollTimeInterval = autoScrollTimeInterval;
    
    [self.autoScrollTimer invalidate];
    if (self.autoScrollTimeInterval > 0) {
        self.autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTimeInterval target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    }
}

- (void)timerFired:(NSTimer *)sender {
    if (self.scrollView.isTracking) {
        return;
    }
    
    NSInteger nextPageIndex = (self.currentPageIndex + 1) % self.pageControl.numberOfPages;
    [self setCurrentPageIndex:nextPageIndex animated:YES];
}

@end
