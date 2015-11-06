//
//  TOPImageTransformer.m
//  Topsies
//
//  Created by Felipe on 11/5/15.
//  Copyright © 2015 Felipe's Apps. All rights reserved.
//

#import "TOPImageTransformer.h"

#import <UIKit/UIKit.h>

@implementation TOPImageTransformer

 + (Class)transformedValueClass
{
    return [NSData class];
}

- (id)transformedValue:(id)value
{
    if (!value) {
        return nil;
    }
    
    if ([value isKindOfClass:[NSData class]]) {
        return value;
    }
    
    return UIImagePNGRepresentation(value);
}

- (id)reverseTransformedValue:(id)value
{
    return [UIImage imageWithData:value];
}


@end
