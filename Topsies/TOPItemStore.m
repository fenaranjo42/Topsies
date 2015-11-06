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

@import CoreData;

@interface TOPItemStore ()

@property (nonatomic) NSMutableArray *privateItems;

@property (nonatomic, strong) NSMutableArray *allItemTypes;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSManagedObjectModel *model;

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
        
        // Read in Topsies.xcdatamodeld
        _model = [NSManagedObjectModel mergedModelFromBundles:nil];
        
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
        
        // Wher does the SQLite file go?
        NSString *path = self.itemArchivePath;
        NSURL *storeURL = [NSURL fileURLWithPath:path];
        
        NSError *error;
        
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
            [NSException raise:@"Open Failure" format:@"%@", [error localizedDescription]];
        }
        
        // Create the managed object context
        _context = [[NSManagedObjectContext alloc] initWithConcurrencyType: NSMainQueueConcurrencyType];
        _context.persistentStoreCoordinator = psc;
        
        [self loadAllItems];
    
    }
    
    return self;
}

#pragma mark - Saving

- (NSString *)itemArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    // Get the ONE document directory from that list
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:@"store.data"];
}

- (BOOL)saveChanges
{
    NSError *error;
    BOOL succesful = [self.context save:&error];
    
    if (!succesful) {
        NSLog(@"Error saving: %@", [error localizedDescription]);
    }
    
    return succesful;
}

- (void)loadAllItems
{
    if (!self.privateItems) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *e = [NSEntityDescription entityForName:@"TOPItem"
                                             inManagedObjectContext:self.context];
        request.entity = e;
        
        NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"orderingValue" ascending:YES];
        request.sortDescriptors = @[sd];
        
        NSError *error;
        NSArray *result = [self.context executeFetchRequest:request error:&error];
        if (!result) {
            [NSException raise:@"Fetch failed" format:@"Reason: %@", [error localizedDescription]];
        }
        
        self.privateItems = [[NSMutableArray alloc] initWithArray:result];
    }
}

#pragma mark - Methods

- (NSArray *)allItems
{
    return [self.privateItems copy];
}

- (TOPItem *)createItem
{
    double order;
    if ([self.allItems count] == 0) {
        order = 1.0;
    } else {
        order = [[self.privateItems lastObject] orderingValue] + 1.0;
    }
    NSLog(@"Adding after %d items, order = %.2f", [self.privateItems count], order);
    
    TOPItem *item = [NSEntityDescription insertNewObjectForEntityForName:@"TOPItem"
                                                  inManagedObjectContext:self.context];
    item.orderingValue = order;
    
    [self.privateItems addObject:item];
    
    return item;
}

- (void)removeItem:(TOPItem *)item
{
    NSString *key = item.itemKey;
    [[TOPImageStore sharedStore] deleteImageForKey:key];
    
    [self.context deleteObject:item];
    
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
    
    // Computing a new orderValue for the object that was moved
    double lowerBound = 0.0;
    
    // Is there an object before it in the array?
    if (toIndex > 0) {
        lowerBound = [self.privateItems[(toIndex - 1)] orderingValue];
    } else {
        lowerBound = [self.privateItems[1] orderingValue] - 2.0;
    }
    
    double upperBound = 0.0;
    
    // Is there an object after it in the array?
    if (toIndex < [self.privateItems count] -1) {
        upperBound = [self.privateItems[(toIndex + 1)] orderingValue];
    } else {
        upperBound = [self.privateItems[(toIndex - 1)] orderingValue] + 2.0;
    }
    
    double newOrderValue = (lowerBound + upperBound) / 2.0;
    
    NSLog(@"moving to order %f", newOrderValue);
    item.orderingValue = newOrderValue;
}

- (NSArray *)allItemTypes
{
    if (!_allItemTypes) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *e = [NSEntityDescription entityForName:@"TOPFoodItemType" inManagedObjectContext:self.context];
        request.entity = e;
        
        NSError *error;
        NSArray *result = [self.context executeFetchRequest:request error:&error];
        if (!result) {
            [NSException raise:@"Fetch failed" format:@"Reason: %@", [error localizedDescription]];
        }
        _allItemTypes = [result mutableCopy];
    }
    
    // Is this the first time the program is being run?
    if ([_allItemTypes count] == 0) {
        NSManagedObject *type;
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"TOPFoodItemType" inManagedObjectContext:self.context];
        [type setValue:@"Drink" forKey:@"label"];
        [_allItemTypes addObject:type];
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"TOPFoodItemType" inManagedObjectContext:self.context];
        [type setValue:@"Entree" forKey:@"label"];
        [_allItemTypes addObject:type];
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"TOPFoodItemType" inManagedObjectContext:self.context];
        [type setValue:@"Dessert" forKey:@"label"];
        [_allItemTypes addObject:type];
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"TOPFoodItemType" inManagedObjectContext:self.context];
        [type setValue:@"Appetizer" forKey:@"label"];
        [_allItemTypes addObject:type];
    }
    return _allItemTypes;
}

@end
