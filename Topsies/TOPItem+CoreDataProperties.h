//
//  TOPItem+CoreDataProperties.h
//  Topsies
//
//  Created by Felipe on 11/5/15.
//  Copyright © 2015 Felipe's Apps. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "TOPItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface TOPItem (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *itemName;
@property (nullable, nonatomic, retain) NSString *restaurantName;
@property (nonatomic) int score;
@property (nonatomic) int valueInDollars;
@property (nullable, nonatomic, retain) NSDate *dateCreated;
@property (nullable, nonatomic, retain) NSString *itemKey;
@property (nonatomic) double orderingValue;
@property (nullable, nonatomic, retain) UIImage *thumbnail;
@property (nullable, nonatomic, retain) UIImage *scoreImage;
@property (nullable, nonatomic, retain) NSManagedObject *foodItemType;

@end

NS_ASSUME_NONNULL_END
