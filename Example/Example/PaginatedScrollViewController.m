//
//  PaginatedScrollViewController.m
//  Example
//
//  Created by Dmitry Nesterenko on 30.03.16.
//  Copyright © 2016 e-legion. All rights reserved.
//

#import "PaginatedScrollViewController.h"
#import "CollectionViewCell.h"

static NSString * const kCellId = @"cell";

@interface PaginatedScrollViewController ()

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray<NSString *> *items;

@end

@implementation PaginatedScrollViewController

#pragma mark - Managing the View

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.items = @[@"1", @"2", @"3"];
}

#pragma mark - Configuring the View’s Layout Behavior

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.sectionInset = UIEdgeInsetsZero;
    layout.itemSize = self.collectionView.frame.size;
}

#pragma mark - Collection View

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return (NSInteger)self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellId forIndexPath:indexPath];
    cell.textLabel.text = self.items[(NSUInteger)indexPath.row];
    return cell;
}

@end
