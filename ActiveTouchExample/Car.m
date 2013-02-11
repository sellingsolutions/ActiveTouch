//
//  Car.m
//  ActiveTouchExample
//
//  Created by Lucas Medeiros on 11/02/13.
//  Copyright (c) 2013 ActiveTouch. All rights reserved.
//

#import "Car.h"

@implementation Car

+ (NSDictionary *)externalRepresentationKeyPathsByPropertyKey
{
    return @{
             @"model" : @"model",
             @"year" : @"year"
            };
}

@end