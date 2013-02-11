//
//  ATDatabaseCleaner.h
//  ActiveTouchExample
//
//  Created by Lucas Medeiros on 10/02/13.
//  Copyright (c) 2013 ActiveTouch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATDatabaseCleaner : NSObject

+ (void)openTestDatabaseNamed:(NSString *)databaseName;
+ (void)cleanDatabase;

@end
