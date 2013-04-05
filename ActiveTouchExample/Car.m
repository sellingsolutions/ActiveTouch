//
//  Car.m
//  ActiveTouchExample
//
//  Created by Lucas Medeiros on 11/02/13.
//  Copyright (c) 2013 ActiveTouch. All rights reserved.
//

#import "Car.h"

@implementation Car

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"model" : @"model",
             @"year" : @"year"
             };

}

+ (NSArray *)sortOrder
{
    return @[@"model", @"year"];
}

@end
