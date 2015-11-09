//
//  TOPItem.m
//  Topsies
//
//  Created by Felipe on 11/5/15.
//  Copyright © 2015 Felipe's Apps. All rights reserved.
//

#import "TOPItem.h"

@implementation TOPItem

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

- (void)awakeFromInsert
{
    [super awakeFromInsert];
    
    self.dateCreated = [NSDate date];
    
    // Create an NSUUID object - and get its string representation
    NSUUID *uuid = [[NSUUID alloc] init];
    NSString *key = [uuid UUIDString];
    self.itemKey = key;
}

- (UIImage *)scoreImageForKey:(NSString *)key
{
    NSDictionary *ratingImages = @{ @"0" : [UIImage imageNamed:@"NoStar.png"],
                                    @"1" : [UIImage imageNamed:@"OneStar.png"],
                                    @"2" : [UIImage imageNamed:@"TwoStar.png"],
                                    @"3" : [UIImage imageNamed:@"ThreeStar.png"],
                                    @"4" : [UIImage imageNamed:@"FourStar.png"],
                                    @"5" : [UIImage imageNamed:@"FiveStar.png"]};
    
    if (self.score) {
        self.scoreImage = ratingImages[[NSString stringWithFormat:@"%d", self.score]];
        
        return self.scoreImage;
    }
    
    return nil;
}

@end
