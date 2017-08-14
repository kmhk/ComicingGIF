//
//  CMCExpandableCollectionViewFlowLayout.m
//  ComicingGif
//
//  Created by Ahmed Sulaiman on 7/20/17.
//  Copyright © 2017 Com. All rights reserved.
//

#import "CMCExpandableCollectionViewFlowLayout.h"

@interface CMCExpandableCollectionViewFlowLayout()

// Containers for keeping track of changing items
@property (nonatomic, strong) NSMutableArray *insertedIndexPaths;
@property (nonatomic, strong) NSMutableArray *removedIndexPaths;
@property (nonatomic, strong) NSMutableArray *insertedSectionIndices;
@property (nonatomic, strong) NSMutableArray *removedSectionIndices;

// Caches for keeping current/previous attributes
@property (nonatomic, strong) NSMutableDictionary *currentCellAttributes;
@property (nonatomic, strong) NSMutableDictionary *currentSupplementaryAttributesByKind;
@property (nonatomic, strong) NSMutableDictionary *cachedCellAttributes;
@property (nonatomic, strong) NSMutableDictionary *cachedSupplementaryAttributesByKind;

@end

@implementation CMCExpandableCollectionViewFlowLayout

- (id)init {
    self = [super init];
    if (self) {
        self.currentCellAttributes = [NSMutableDictionary dictionary];
        self.currentSupplementaryAttributesByKind = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    
    // Deep-copy attributes in current cache
    self.cachedCellAttributes = [[NSMutableDictionary alloc] initWithDictionary:self.currentCellAttributes
                                                                      copyItems:YES];
    self.cachedSupplementaryAttributesByKind = [NSMutableDictionary dictionary];
    [self.currentSupplementaryAttributesByKind enumerateKeysAndObjectsUsingBlock:^(NSString *kind, NSMutableDictionary * attribByPath, BOOL *stop) {
        NSMutableDictionary * cachedAttribByPath = [[NSMutableDictionary alloc] initWithDictionary:attribByPath
                                                                                         copyItems:YES];
        [self.cachedSupplementaryAttributesByKind setObject:cachedAttribByPath forKey:kind];
    }];
}

- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray * attributes = [super layoutAttributesForElementsInRect:rect];
    // Always cache all visible attributes so we can use them later when computing final/initial animated attributes
    // Never clear the cache as certain items may be removed from the attributes array prior to being animated out
    [attributes enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *attributes, NSUInteger idx, BOOL *stop) {
        
        if (attributes.representedElementCategory == UICollectionElementCategoryCell) {
            [self.currentCellAttributes setObject:attributes
                                           forKey:attributes.indexPath];
        } else if (attributes.representedElementCategory == UICollectionElementCategorySupplementaryView) {
            NSMutableDictionary *supplementaryAttribuesByIndexPath = [self.currentSupplementaryAttributesByKind
                                                                      objectForKey:attributes.representedElementKind];
            if (supplementaryAttribuesByIndexPath == nil) {
                supplementaryAttribuesByIndexPath = [NSMutableDictionary dictionary];
                [self.currentSupplementaryAttributesByKind setObject:supplementaryAttribuesByIndexPath
                                                              forKey:attributes.representedElementKind];
            }
            
            // Set correct frame for footer view
            UICollectionViewLayoutAttributes *suppViewAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                                                                        atIndexPath:[attributes indexPath]];
            [attributes setFrame:[suppViewAttributes frame]];
            
            
            [supplementaryAttribuesByIndexPath setObject:attributes
                                                  forKey:attributes.indexPath];
        }
    }];
    return attributes;
}

- (UICollectionViewLayoutAttributes*)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes* cellAttributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    UICollectionViewLayoutAttributes* supViewAttributes;
    BOOL isHeader = [kind isEqualToString:UICollectionElementKindSectionHeader];
    supViewAttributes = [super layoutAttributesForSupplementaryViewOfKind:kind atIndexPath:indexPath];
    CGRect cellRect = [cellAttributes frame];
    if(!isHeader){
        [supViewAttributes setFrame:CGRectMake(cellRect.origin.x + 10, cellRect.size.height + 15, cellRect.size.width, 30)];
    }
    return supViewAttributes;
}

#pragma mark - Main Items

- (UICollectionViewLayoutAttributes*)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    UICollectionViewLayoutAttributes *attributes = [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
    
    if ([self.insertedIndexPaths containsObject:itemIndexPath]) {
        attributes = [[self.currentCellAttributes objectForKey:itemIndexPath] copy];
        attributes.center = CGPointMake(CGRectGetMinX(self.collectionView.bounds) + 60, CGRectGetMidY(self.collectionView.bounds));
    } else if ([self.insertedSectionIndices containsObject:@(itemIndexPath.section)]) {
        attributes = [[self.currentCellAttributes objectForKey:itemIndexPath] copy];
        attributes.transform3D = CATransform3DMakeTranslation(-self.collectionView.bounds.size.width, 0, 0);
    }
    return attributes;
}

- (UICollectionViewLayoutAttributes*)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    UICollectionViewLayoutAttributes *attributes = [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
    
    if ([self.removedIndexPaths containsObject:itemIndexPath] || [self.removedSectionIndices containsObject:@(itemIndexPath.section)]) {
        attributes = [[self.cachedCellAttributes objectForKey:itemIndexPath] copy];
        attributes.center = CGPointMake(CGRectGetMinX(self.collectionView.bounds) + 50, CGRectGetMidY(self.collectionView.bounds));
    }
    return attributes;
}

#pragma mark - Supplementary Items

- (UICollectionViewLayoutAttributes*)initialLayoutAttributesForAppearingSupplementaryElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)elementIndexPath {
    UICollectionViewLayoutAttributes *attributes = [super initialLayoutAttributesForAppearingSupplementaryElementOfKind:elementKind
                                                                                                            atIndexPath:elementIndexPath];    
    
    if ([self.insertedSectionIndices containsObject:@(elementIndexPath.section)]) {
        attributes = [[[self.currentSupplementaryAttributesByKind objectForKey:elementKind] objectForKey:elementIndexPath] copy];
        attributes.transform3D = CATransform3DMakeTranslation(-self.collectionView.bounds.size.width, 0, 0);
    } else {
        NSIndexPath *prevPath = [self previousIndexPathForIndexPath:elementIndexPath accountForItems:NO];
        attributes = [[[self.cachedSupplementaryAttributesByKind objectForKey:elementKind] objectForKey:prevPath] copy];
    }
    return attributes;
}

- (UICollectionViewLayoutAttributes*)finalLayoutAttributesForDisappearingSupplementaryElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)elementIndexPath {
    UICollectionViewLayoutAttributes *attributes = [super finalLayoutAttributesForDisappearingSupplementaryElementOfKind:elementKind atIndexPath:elementIndexPath];
    
    if ([self.removedSectionIndices containsObject:@(elementIndexPath.section)]) {
        attributes = [[[self.cachedSupplementaryAttributesByKind objectForKey:elementKind] objectForKey:elementIndexPath] copy];
        
        CATransform3D transform = CATransform3DMakeTranslation(0, self.collectionView.bounds.size.height, 0);
        transform = CATransform3DRotate(transform, M_PI*0.2, 0, 0, 1);
        attributes.transform3D = transform;
        attributes.alpha = 0.0f;
    } else {
        // Keep it right where it is
        attributes = [[[self.currentCellAttributes objectForKey:elementKind] objectForKey:elementIndexPath] copy];
    }
    return attributes;
}

- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems {
    [super prepareForCollectionViewUpdates:updateItems];
    
    // Keep track of updates to items and sections so we can use this information for animation
    self.insertedIndexPaths     = [NSMutableArray array];
    self.removedIndexPaths      = [NSMutableArray array];
    self.insertedSectionIndices = [NSMutableArray array];
    self.removedSectionIndices  = [NSMutableArray array];
    
    [updateItems enumerateObjectsUsingBlock:^(UICollectionViewUpdateItem *updateItem, NSUInteger idx, BOOL *stop) {
        if (updateItem.updateAction == UICollectionUpdateActionInsert) {
            // If the update item's index path has an "item" value of NSNotFound, it means it was a section update, not an individual item.
            
            if (updateItem.indexPathAfterUpdate.item == NSNotFound) {
                [self.insertedSectionIndices addObject:@(updateItem.indexPathAfterUpdate.section)];
            } else {
                [self.insertedIndexPaths addObject:updateItem.indexPathAfterUpdate];
            }
            
        } else if (updateItem.updateAction == UICollectionUpdateActionDelete) {
            
            if (updateItem.indexPathBeforeUpdate.item == NSNotFound) {
                [self.removedSectionIndices addObject:@(updateItem.indexPathBeforeUpdate.section)];
            } else {
                [self.removedIndexPaths addObject:updateItem.indexPathBeforeUpdate];
            }
        }
    }];
}

- (void)finalizeCollectionViewUpdates {
    [super finalizeCollectionViewUpdates];
    self.insertedIndexPaths     = nil;
    self.removedIndexPaths      = nil;
    self.insertedSectionIndices = nil;
    self.removedSectionIndices  = nil;
}

#pragma mark - Helpers

- (NSIndexPath*)previousIndexPathForIndexPath:(NSIndexPath *)indexPath accountForItems:(BOOL)checkItems {
    __block NSInteger section = indexPath.section;
    __block NSInteger item = indexPath.item;
    
    [self.removedSectionIndices enumerateObjectsUsingBlock:^(NSNumber *rmSectionIdx, NSUInteger idx, BOOL *stop) {
        if ([rmSectionIdx integerValue] <= section) {
            section++;
        }
    }];
    if (checkItems) {
        [self.removedIndexPaths enumerateObjectsUsingBlock:^(NSIndexPath *rmIndexPath, NSUInteger idx, BOOL *stop) {
            if ([rmIndexPath section] == section && [rmIndexPath item] <= item) {
                item++;
            }
        }];
    }
    [self.insertedSectionIndices enumerateObjectsUsingBlock:^(NSNumber *insSectionIdx, NSUInteger idx, BOOL *stop) {
        if ([insSectionIdx integerValue] < [indexPath section]) {
            section--;
        }
    }];
    if (checkItems) {
        [self.insertedIndexPaths enumerateObjectsUsingBlock:^(NSIndexPath *insIndexPath, NSUInteger idx, BOOL *stop) {
            if ([insIndexPath section] == [indexPath section] && [insIndexPath item] < [indexPath item]) {
                item--;
            }
        }];
    }
    return [NSIndexPath indexPathForItem:item inSection:section];
}

@end
