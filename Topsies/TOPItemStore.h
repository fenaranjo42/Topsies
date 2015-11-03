//
//  ItemStore.h
//  Topsies
//
//  Created by Felipe on 10/28/15.
//  Copyright © 2015 Felipe's Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TOPItem;

@interface TOPItemStore : NSObject

@property (nonatomic, readonly, copy) NSArray *allItems;

+ (instancetype)sharedStore;

- (TOPItem *)createItem;

- (void)removeItem:(TOPItem *)item;

- (void)moveItemAtIndex:(NSUInteger)fromIndex
                toIndex:(NSUInteger)toIndex;

- (BOOL)saveChanges;

@end
