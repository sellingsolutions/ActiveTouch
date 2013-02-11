//
//  ATRuntimeHelper.m
//  ActiveTouchExample
//
//  Created by Lucas Medeiros on 11/02/13.
//  Copyright (c) 2013 ActiveTouch. All rights reserved.
//

#import "ATRuntimeHelper.h"
#import "ATModel.h"
#import <objc/runtime.h>

@implementation ATRuntimeHelper

+ (NSArray *)classesThatInheritFromATModel
{
    unsigned int classCount;
    Class *classList = objc_copyClassList(&classCount);
    
    NSMutableArray *classes = [NSMutableArray array];
    for (int index = 0; index < classCount; index++) {
        
        Class class = classList[index];
        NSString *classString = [NSString stringWithCString:class_getName(class) encoding:NSUTF8StringEncoding];
        Class superClass = class_getSuperclass(class);
        NSString *superClassString = [NSString stringWithCString:class_getName(superClass) encoding:NSUTF8StringEncoding];
        if ([superClassString isEqualToString:@"ATModel"]) {
            [classes addObject:NSClassFromString(classString)];
        }
    
    }
    return classes;
}

@end
