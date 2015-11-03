//
//  Item.h
//  Topsies
//
//  Created by Felipe on 10/28/15.
//  Copyright © 2015 Felipe's Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TOPItem : NSObject <NSCoding>

@property (nonatomic, copy) NSString *itemName;
@property (nonatomic, copy) NSString *restaurantName;
@property (nonatomic) int score;
@property (nonatomic) int valueInDollars;
@property (nonatomic, readonly, strong) NSDate *dateCreated;
@property (nonatomic, copy) NSString *itemKey;
@property (nonatomic, strong) UIImage *thumbnail;
@property (nonatomic, strong) UIImage *scoreImage;

+ (instancetype)randomItem;

- (instancetype)initWithName:(NSString *)name restaurantName:(NSString *)restaurantName valueInDollars:(int)value;

- (instancetype)initWithName:(NSString *)name;

- (void)setThumbnailFromImage:(UIImage *)image;

- (UIImage *)scoreImageForKey:(NSString *)key;

@end
