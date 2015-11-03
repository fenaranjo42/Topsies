//
//  Item.m
//  Topsies
//
//  Created by Felipe on 10/28/15.
//  Copyright © 2015 Felipe's Apps. All rights reserved.
//

#import "TOPItem.h"


@implementation TOPItem

#pragma mark - Initializers

+ (instancetype)randomItem
{
    // Create an immutable array of three adjectives
    NSArray *randomAdjectiveList = @[@"Delicious", @"Heart-Stopping", @"Hearty"];
    
    // Create an immutable array of three items
    NSArray *randomItemList = @[@"Beer", @"Hamburger", @"Salad"];
    
    // Get the index of a random adjective/noun from the list
    NSInteger adjectiveIndex = arc4random() % [randomAdjectiveList count];
    NSInteger itemIndex = arc4random() % [randomItemList count];
    
    NSString *randomName = [NSString stringWithFormat:@"%@ %@", randomAdjectiveList[adjectiveIndex], randomItemList[itemIndex]];
    
    int randomValue = arc4random() % 25;
    
    TOPItem *newItem = [[self alloc] initWithName:randomName
                                restaurantName:@"Topsies"
                                valueInDollars:randomValue];
    return newItem;
}

- (instancetype)initWithName:(NSString *)name restaurantName:(NSString *)restaurantName valueInDollars:(int)value
{
    self = [super init];
    
    if (self) {
        
        _itemName = name;
        _restaurantName = restaurantName;
        _valueInDollars = value;
        _dateCreated = [[NSDate alloc] init];
        
        // Create an NSUUID object - and get its string representation
        NSUUID *uuid = [[NSUUID alloc] init];
        NSString *key = [uuid UUIDString];
        _itemKey = key;
    }
    
    return self;
}

- (instancetype)initWithName:(NSString *)name
{
    return [self initWithName:name
               restaurantName:@""
               valueInDollars:0];
}

- (instancetype)init
{
    return [self initWithName:@"Item"];
}


#pragma mark - NSCoding 

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.itemName forKey:@"itemName"];
    [aCoder encodeObject:self.restaurantName forKey:@"restaurantName"];
    [aCoder encodeObject:self.dateCreated forKey:@"dateCreated"];
    [aCoder encodeObject:self.itemKey forKey:@"itemKey"];
    [aCoder encodeInt:self.valueInDollars forKey:@"valueInDollars"];
    [aCoder encodeObject:self.thumbnail forKey:@"thumbnail"];
    [aCoder encodeObject:self.scoreImage forKey:@"scoreImage"];

}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _itemName = [aDecoder decodeObjectForKey:@"itemName"];
        _restaurantName = [aDecoder decodeObjectForKey:@"restaurantName"];
        _dateCreated = [aDecoder decodeObjectForKey:@"dateCreated"];
        _itemKey = [aDecoder decodeObjectForKey:@"itemKey"];
        _valueInDollars = [aDecoder decodeIntForKey:@"valueInDollars"];
        _thumbnail = [aDecoder decodeObjectForKey:@"thumbnail"];
        _scoreImage = [aDecoder decodeObjectForKey:@"scoreImage"];
    }
    return self;
}

#pragma mark - Methods

- (NSString *)description
{
    NSString *descriptionString =
    [[NSString alloc] initWithFormat:@"%@: Worth $%d, eaten at %@",
     self.itemName,
     self.valueInDollars,
     self.restaurantName];
     
    return descriptionString;
}

- (void)setThumbnailFromImage:(UIImage *)image
{
    CGSize origImageSize = image.size;
    
    // The rectangle of the Thumbnail
    CGRect newRect = CGRectMake(0, 0, 110, 110);
    
    // Figure out a scaling ration to make sure we maintain the same aspect ratio
    float ratio = MAX(newRect.size.width / origImageSize.width, newRect.size.height / origImageSize.height);
    
    // Create a transparent bitmap context with a scaling factor equal to that of the screen
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0);
    
    // Create a path that is a rounded rectangle
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect cornerRadius:5.0];
    
    // Make all subsequent drawing clip to this rounded rectangle
    [path addClip];
    
    // Center the image in the thumbnail rectangle
    CGRect projectRect;
    projectRect.size.width = ratio * origImageSize.width;
    projectRect.size.height = ratio * origImageSize.height;
    projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.0;
    projectRect.origin.y = (newRect.size.height - projectRect.size.height) / 2.0;
    
    // Draw the image on it
    [image drawInRect:projectRect];
    
    // Get the image from the image context; keep it as our thumbnail
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    self.thumbnail = smallImage;
    
    // Cleanup image context resources; done
    UIGraphicsEndImageContext();
}

- (UIImage *)scoreImageForKey:(NSString *)key
{
    NSDictionary *ratingImages = @{ @"1" : [UIImage imageNamed:@"OneStar.png"],
                                    @"2" : [UIImage imageNamed:@"TwoStar.png"],
                                    @"3" : [UIImage imageNamed:@"ThreeStar.png"],
                                    @"4" : [UIImage imageNamed:@"FourStar.png"],
                                    @"5" : [UIImage imageNamed:@"FiveStar.png"]};
    
    if (_score) {
        _scoreImage = ratingImages[[NSString stringWithFormat:@"%d", self.score]];
    
        return _scoreImage;
    }
    
    return nil;
}

@end
