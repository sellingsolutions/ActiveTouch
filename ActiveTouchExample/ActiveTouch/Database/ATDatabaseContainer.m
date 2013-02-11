//
//  ATDatabaseContainer.m
//  ActiveTouchExample
//
//  Created by Lucas Medeiros on 10/02/13.
//  Copyright (c) 2013 ActiveTouch. All rights reserved.
//

#import "ATDatabaseContainer.h"
#import <CouchCocoa/CouchCocoa.h>
#import "ATRuntimeHelper.h"
#import "ATModel.h"

@implementation ATDatabaseContainer

+ (id)sharedInstance
{
    static ATDatabaseContainer *__sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[ATDatabaseContainer alloc] init];
    });
    
    return __sharedInstance;
}

- (void)openDatabaseWithName:(NSString *)databaseName
{
    _database = [[CouchTouchDBServer sharedInstance] databaseNamed:databaseName];
    NSError *error;
    if (![_database ensureCreated:&error]) {
        @throw ([NSException exceptionWithName:@"ATDatabaseException" reason:@"Database was not initialized" userInfo:nil]);
    }
    [self registerViews];
}

- (void)registerViews
{
    NSArray *modelClasses = [ATRuntimeHelper classesThatInheritFromATModel];
    for (id modelClass in modelClasses) {
        [modelClass registerView];
        NSLog(@"Registering views for class: %@", [modelClass description]);
    }
}

- (void)closeDatabase
{
    _database = nil;
}

- (void)closeServer
{
    if (_database) {
        [self closeDatabase];
    }
    [[CouchTouchDBServer sharedInstance] close];
}

@end
