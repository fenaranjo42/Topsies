//
//  TOPItem.h
//  Topsies
//
//  Created by Felipe on 11/5/15.
//  Copyright © 2015 Felipe's Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TOPItem : NSManagedObject

- (void)setThumbnailFromImage:(UIImage *)image;

- (UIImage *)scoreImageForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END

#import "TOPItem+CoreDataProperties.h"
