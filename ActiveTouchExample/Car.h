//
//  Car.h
//  ActiveTouchExample
//
//  Created by Lucas Medeiros on 11/02/13.
//  Copyright (c) 2013 ActiveTouch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATModel.h"

@interface Car : ATModel

@property (nonatomic, copy) NSString *model;
@property (nonatomic, copy) NSString *year;

@end
