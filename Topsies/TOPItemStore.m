//
//  ItemStore.m
//  Topsies
//
//  Created by Felipe on 10/28/15.
//  Copyright © 2015 Felipe's Apps. All rights reserved.
//

#import "TOPItemStore.h"
#import "TOPItem.h"
#import "TOPImageStore.h"

@interface TOPItemStore ()

@property (nonatomic) NSMutableArray *privateItems;

@end

@implementation TOPItemStore

#pragma mark - Initializers

+ (instancetype)sharedStore
{
    static TOPItemStore *sharedStore;
    
    // Make it thread-safe
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
    return sharedStore;
}

// If a programmer calls [[TOPItemStore alloc] init], throw an Exception
- (instancetype)init
{
    [NSException raise:@"Singleton" format:@"Use + [TOPItemStore sharedStore]"];
    
    return nil;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        NSString *path = [self itemArchivePath];
        _privateItems = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        // If the array hadn't been saved previously, create a new empty one
        if (!_privateItems) {
            _privateItems = [[NSMutableArray alloc] init];
        }
    }
    
    return self;
}

#pragma mark - Archiving

- (NSString *)itemArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    // Get the ONE document directory from that list
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:@"items.archive"];
}

- (BOOL)saveChanges
{
    NSString *path = [self itemArchivePath];
    
    return [NSKeyedArchiver archiveRootObject:self.privateItems toFile:path];
}

#pragma mark - Methods

- (NSArray *)allItems
{
    return [self.privateItems copy];
}

- (TOPItem *)createItem
{
    TOPItem *item = [[TOPItem alloc] init];
    
    [self.privateItems addObject:item];
    
    return item;
}

- (void)removeItem:(TOPItem *)item
{
    NSString *key = item.itemKey;
    [[TOPImageStore sharedStore] deleteImageForKey:key];
    
    [self.privateItems removeObjectIdenticalTo:item];
}

- (void)moveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
    if (fromIndex == toIndex) {
        return;
    }
    
    // Get pointer to object being moved so you can re-insert it
    TOPItem *item = self.privateItems[fromIndex];
    
    // Remove item from array
    [self.privateItems removeObjectAtIndex:fromIndex];
    
    // Insert item in array at new location
    [self.privateItems insertObject:item atIndex:toIndex];
}


@end
