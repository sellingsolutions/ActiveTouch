//
//  ATDatabaseContainer.h
//  ActiveTouchExample
//
//  Created by Lucas Medeiros on 10/02/13.
//  Copyright (c) 2013 ActiveTouch. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CouchDatabase;

@interface ATDatabaseContainer : NSObject

@property (nonatomic, strong) CouchDatabase *database;

+ (id)sharedInstance;

- (void)openDatabaseWithName:(NSString *)databaseName;
- (void)closeDatabase;
- (void)closeServer;

@end
