//
//  CMCExpandableCollectionView.m
//  ComicingGif
//
//  Created by Ahmed Sulaiman on 7/19/17.
//  Copyright © 2017 Com. All rights reserved.
//

#import "CMCExpandableCollectionView.h"

@interface CMCExpandableCollectionView () <UIGestureRecognizerDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *expandedSections;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@property (nonatomic, weak) id <UICollectionViewDataSource> customDataSource;

@end

@implementation CMCExpandableCollectionView

@dynamic delegate;

#pragma mark - Init Methods

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.allowsMultipleExpandedSections = NO;
    [self addGestureRecognizer:self.tapGestureRecognizer];
}

#pragma mark - Internal properties lazy initialization

- (NSMutableArray *)expandedSections {
    if (!_expandedSections) {
        _expandedSections = [NSMutableArray array];
        NSInteger maxI = [self.dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)]
        ? [self.dataSource numberOfSectionsInCollectionView:self] : 0;
        for (NSInteger i = 0; i < maxI; i++) {
            [_expandedSections addObject:@NO];
        }
    }
    return _expandedSections;
}

- (UITapGestureRecognizer *)tapGestureRecognizer {
    if (!_tapGestureRecognizer) {
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        _tapGestureRecognizer.delegate = self;
    }
    return _tapGestureRecognizer;
}

#pragma mark - Public Interface

- (id<UICollectionViewDataSource>)dataSource {
    return [super dataSource];
}

- (void)setDataSource:(id<UICollectionViewDataSource>)dataSource {
    _customDataSource = dataSource;
    [super setDataSource:self];
}

- (BOOL)isExpandedSection:(NSInteger)section {
    return [self.expandedSections[section] boolValue];
}

- (void)addExpandedSection:(BOOL)isExpanded {
    [self.expandedSections addObject:@(isExpanded)];
}

- (void)insertExpandedSection:(BOOL)isExpanded atIndex:(NSUInteger)index {
    if (index <= [self.expandedSections count]) {
        [self.expandedSections insertObject:@(isExpanded) atIndex:index];
    }
}

- (void)collapseAllSections {
    [_expandedSections removeAllObjects];
    _expandedSections = nil;
}

#pragma mark - Utils

- (NSArray *)indexPathsForSection:(NSInteger)section {
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (NSInteger i = 1, maxI = [self.customDataSource collectionView:self numberOfItemsInSection:section]; i < maxI; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForItem:i inSection:section]];
    }
    return [indexPaths copy];
}

- (NSArray *)expandedSectionIndexPaths {
    NSMutableArray *sectionIndexPaths = [NSMutableArray array];
    if (!self.allowsMultipleExpandedSections) {
        for (NSInteger i = 0; i < self.numberOfSections; i++) {
            if ([self isExpandedSection:i]) {
                [sectionIndexPaths addObject:[NSIndexPath indexPathForItem:0 inSection:i]];
            }
        }
    }
    return [sectionIndexPaths copy];
}

- (NSArray*)collapseIndexPathsForSectionIndexPaths:(NSArray*)sectionIndexPaths {
    NSArray* indexPaths = @[];
    for (NSIndexPath* sectionIndexPath in sectionIndexPaths) {
        indexPaths = [indexPaths arrayByAddingObjectsFromArray:[self indexPathsForSection:sectionIndexPath.section]];
    }
    return indexPaths;
}

- (void)updateExpandedSectionsForSectionIndexPaths:(NSArray*)sectionIndexPaths {
    for (NSIndexPath* sectionIndexPath in sectionIndexPaths) {
        self.expandedSections[sectionIndexPath.section] = @(NO);
    }
}

- (void)didCollapseItemsForSectionIndexPaths:(NSArray*)sectionIndexPaths {
    for (NSIndexPath* sectionIndexPath in sectionIndexPaths) {
        if ([self.delegate respondsToSelector:@selector(collectionView:didCollapseItemAtIndexPath:)]) {
            [self.delegate collectionView:self didCollapseItemAtIndexPath:sectionIndexPath];
        }
    }
}

- (void)collapseActiveSection {
    NSInteger tappedSection = ((NSIndexPath *)[self expandedSectionIndexPaths].firstObject).section;
    BOOL willOpen = ![self.expandedSections[tappedSection] boolValue];
    if (willOpen) {
        return;
    }
    
    NSArray* indexPaths = [self indexPathsForSection:tappedSection];
    NSArray* expandedSectionIndexPaths = willOpen ? [self expandedSectionIndexPaths] : @[];
    
    [self performBatchUpdates:^{
        [self deleteItemsAtIndexPaths:indexPaths];
        [self updateExpandedSectionsForSectionIndexPaths:expandedSectionIndexPaths];
        self.expandedSections[tappedSection] = @(willOpen);
    } completion:nil];
    
    if ([self.delegate respondsToSelector:@selector(collectionView:didCollapseItemAtIndexPath:)]) {
        NSIndexPath *indexPathToUpdate = [NSIndexPath indexPathForItem:0 inSection:tappedSection];
        [self.delegate collectionView:self didCollapseItemAtIndexPath:indexPathToUpdate];
    }
}

- (void)handleTapGesture:(UITapGestureRecognizer*)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint point = [sender locationInView:self];
        NSIndexPath* tappedCellPath = [self indexPathForItemAtPoint:point];
        
        NSLog(@"Tap with point %@ and item %ld", NSStringFromCGPoint(point), (long)tappedCellPath.item);
        if ([self isExpandedSection:tappedCellPath.section] && tappedCellPath.item == 0) {
            if ([self.delegate respondsToSelector:@selector(collectionView:firstItemDidSelectedWithIndexPath:)]) {
                [self.delegate collectionView:self firstItemDidSelectedWithIndexPath:tappedCellPath];
            }
            return;
        }
        
        if (tappedCellPath && (tappedCellPath.item == 0)) {
            NSInteger tappedSection = tappedCellPath.section;
            BOOL willOpen = ![self.expandedSections[tappedSection] boolValue];
            NSArray* indexPaths = [self indexPathsForSection:tappedSection];
            NSArray* expandedSectionIndexPaths = willOpen ? [self expandedSectionIndexPaths] : @[];
            
            [self performBatchUpdates:^{
                if (willOpen) {
                    [self deleteItemsAtIndexPaths:[self collapseIndexPathsForSectionIndexPaths:expandedSectionIndexPaths]];
                    [self insertItemsAtIndexPaths:indexPaths];
                } else {
                    [self deleteItemsAtIndexPaths:indexPaths];
                }
                [self updateExpandedSectionsForSectionIndexPaths:expandedSectionIndexPaths];
                self.expandedSections[tappedSection] = @(willOpen);
            } completion:nil];
            
            if (willOpen) {
                NSIndexPath* lastItemIndexPath = [NSIndexPath indexPathForItem:[self numberOfItemsInSection:tappedCellPath.section] - 1 inSection:tappedCellPath.section];
                UICollectionViewCell* firstItem = [self cellForItemAtIndexPath:tappedCellPath];
                UICollectionViewCell* lastItem = [self cellForItemAtIndexPath:lastItemIndexPath];
                CGFloat firstItemTop = firstItem.frame.origin.y;
                CGFloat lastItemBottom = lastItem.frame.origin.y + lastItem.frame.size.height;
                CGFloat height = self.bounds.size.height;
                
                if (lastItemBottom - self.contentOffset.y > height) {
                    if (lastItemBottom - firstItemTop > height) {
                        // using setContentOffset:animated: here because scrollToItemAtIndexPath:atScrollPosition:animated: is broken on iOS 6
                        [self setContentOffset:CGPointMake(0., firstItemTop) animated:YES];
                    } else {
                        [self setContentOffset:CGPointMake(0., lastItemBottom - height) animated:YES];
                    }
                }
                if ([self.delegate respondsToSelector:@selector(collectionView:didExpandItemAtIndexPath:)]) {
                    [self didCollapseItemsForSectionIndexPaths:expandedSectionIndexPaths];
                    [self.delegate collectionView:self didExpandItemAtIndexPath:tappedCellPath];
                }
            } else {
                if ([self.delegate respondsToSelector:@selector(collectionView:didCollapseItemAtIndexPath:)]) {
                    [self.delegate collectionView:self didCollapseItemAtIndexPath:tappedCellPath];
                }
            }
        }
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (gestureRecognizer == self.tapGestureRecognizer) {
        if (gestureRecognizer.state == UIGestureRecognizerStatePossible) {
            CGPoint point = [touch locationInView:self];
            NSIndexPath* tappedCellPath = [self indexPathForItemAtPoint:point];
            return tappedCellPath && (tappedCellPath.item == 0);
        }
        return NO;
    }
    return YES;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.customDataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)]
                                            ? [self.customDataSource numberOfSectionsInCollectionView:self] : 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger numberOfItemsInSection = [self.customDataSource respondsToSelector:@selector(collectionView:numberOfItemsInSection:)]
                                                                ? [self.customDataSource collectionView:self numberOfItemsInSection:section] : 0;
    return [self isExpandedSection:section] ? numberOfItemsInSection : MIN(1, numberOfItemsInSection);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.customDataSource respondsToSelector:@selector(collectionView:cellForItemAtIndexPath:)]
                                    ? [self.customDataSource collectionView:self cellForItemAtIndexPath:indexPath] : [UICollectionViewCell new];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    return [self.customDataSource respondsToSelector:@selector(collectionView:viewForSupplementaryElementOfKind:atIndexPath:)]
                            ? [self.customDataSource collectionView:self viewForSupplementaryElementOfKind:kind atIndexPath:indexPath] : nil;
}

@end
