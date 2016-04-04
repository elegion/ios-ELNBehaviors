//
//  ELNPaginatedScrollViewBehavior.m
//  ELNBehaviors
//
//  Created by Dmitry Nesterenko on 29.03.16.
//  Copyright © 2016 e-legion. All rights reserved.
//

#import "ELNPaginatedScrollViewBehavior.h"

/// Weak timer decorator
@interface ELNPaginatedScrollViewBehaviorTimer : NSObject

@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ELNPaginatedScrollViewBehaviorTimer

- (instancetype)initWithTarget:(id)target selector:(SEL)selector {
    self = [super init];
    if (self) {
        self.target = target;
        self.selector = selector;
    }
    return self;
}

- (void)invalidate {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)scheduleTimerWithTimeInterval:(NSTimeInterval)ti userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:ti target:self selector:@selector(timerFired:) userInfo:userInfo repeats:yesOrNo];
}

- (void)timerFired:(NSTimer *)sender {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self.target performSelector:self.selector withObject:sender];
#pragma clang diagnostic pop
}

@end


@interface ELNPaginatedScrollViewBehavior ()

@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) IBOutlet  UIScrollView *scrollView;
@property (nonatomic, assign) NSInteger currentPageIndex;
@property (nonatomic, strong) ELNPaginatedScrollViewBehaviorTimer *autoScrollTimer;

@end

@implementation ELNPaginatedScrollViewBehavior

#pragma mark - Object Lifecycle

- (void)dealloc {
    // explicitly nil out properties to remove target/action and key-value observation
    // and reset timers
    self.pageControl = nil;
    self.scrollView = nil;
    self.autoScrollTimeInterval = 0;
}

#pragma mark - Initialization

- (instancetype)initWithPageControl:(UIPageControl *)pageControl scrollView:(UIScrollView *)scrollView {
    self = [super init];
    if (self) {
        self.pageControl = pageControl;
        self.scrollView = scrollView;
    }
    return self;
}

#pragma mark - Accessors

- (void)setPageControl:(UIPageControl *)pageControl {
    if (_pageControl == pageControl) {
        return;
    }
    
    [self.pageControl removeTarget:self action:@selector(pageControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    _pageControl = pageControl;
    [self.pageControl addTarget:self action:@selector(pageControlValueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)setScrollView:(UIScrollView *)scrollView {
    if (_scrollView == scrollView) {
        return;
    }
    
    [self.scrollView removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset)) context:NULL];
    _scrollView = scrollView;
    [self.scrollView addObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset)) options:(NSKeyValueObservingOptions)0 context:NULL];
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
        self.autoScrollTimer = [[ELNPaginatedScrollViewBehaviorTimer alloc] initWithTarget:self selector:@selector(timerFired:)];
        [self.autoScrollTimer scheduleTimerWithTimeInterval:self.autoScrollTimeInterval userInfo:nil repeats:YES];
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
