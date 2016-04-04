//
//  ELNPaginatedScrollViewBehaviorTests.m
//  Tests
//
//  Created by Dmitry Nesterenko on 04.04.16.
//  Copyright © 2016 e-legion. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ELNPaginatedScrollViewBehavior.h"

@interface ELNPaginatedScrollViewBehaviorTests : XCTestCase

@end

@implementation ELNPaginatedScrollViewBehaviorTests

- (void)testAutoscrollTimerShouldChangeCurrentPageByTimeInterval {
    UIPageControl *pageControl = [UIPageControl new];
    pageControl.numberOfPages = 3;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * 3, scrollView.frame.size.height);
    ELNPaginatedScrollViewBehavior *behavior = [[ELNPaginatedScrollViewBehavior alloc] initWithPageControl:pageControl scrollView:scrollView];
    behavior.autoScrollTimeInterval = 0.1;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Test Autoscroll Timer Should Chane Current Page By TimeInterval"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.19 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        XCTAssertEqual(behavior.pageControl.currentPage, 1);
        [expectation fulfill];
    });
    
    [self waitForExpectationsWithTimeout:0.3 handler:^(NSError * _Nullable error) {
        // do nothing
    }];
}

- (void)testBehaviorIsReleasedWithConfiguredAutoScrollTimer {
    UIPageControl *pageControl = [UIPageControl new];
    UIScrollView *scrollView = [UIScrollView new];
    ELNPaginatedScrollViewBehavior *behavior = [[ELNPaginatedScrollViewBehavior alloc] initWithPageControl:pageControl scrollView:scrollView];
    
    // start timer
    behavior.autoScrollTimeInterval = 1;
    
    // release strong variable and preserve weak
    __weak __typeof__(behavior) weakBehavior = behavior;
    behavior = nil;
    
    XCTAssertNil(weakBehavior);
}

@end
