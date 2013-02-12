//
//  ATDatabaseCleaner.m
//  ActiveTouchExample
//
//  Created by Lucas Medeiros on 10/02/13.
//  Copyright (c) 2013 ActiveTouch. All rights reserved.
//

#import "ATDatabaseCleaner.h"
#import "ATDatabaseContainer.h"
#import <CouchCocoa/CouchCocoa.h>
#import "Kiwi.h"

static ATDatabaseContainer *__container = nil;
static NSOperationQueue *__operationQueue = nil;

@implementation ATDatabaseCleaner

+ (ATDatabaseContainer *)databaseContainer
{
    return __container;
}

+ (void)openTestDatabaseNamed:(NSString *)databaseName
{
    __container = [[ATDatabaseContainer alloc] init];
    [ATDatabaseContainer stub:@selector(sharedInstance) andReturn:__container];
    [__container openDatabaseWithName:databaseName];
    __operationQueue = [NSOperationQueue mainQueue];
    [__operationQueue waitUntilAllOperationsAreFinished];
}

+ (void)cleanDatabase
{
    NSMutableArray *documents = [NSMutableArray array];
    CouchQuery *query = [[__container database] getAllDocuments];
    for (CouchQueryRow *row in query.rows) {
        [documents addObject:[[__container database] documentWithID:row.documentID]];
    }
    [__operationQueue addOperationWithBlock:^{
        [[__container database] deleteDocuments:documents];
    }];
}

+ (void)removeDatabase
{
    [__operationQueue addOperationWithBlock:^{
        [__container closeDatabase];
    }];
    [__operationQueue addOperationWithBlock:^{
        [__container closeServer];
    }];
    [__operationQueue addOperationWithBlock:^{
        __container = nil;
        __operationQueue = nil;
    }];
    [__operationQueue addOperationWithBlock:^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
        NSMutableString *path = [NSMutableString stringWithString:[paths objectAtIndex:0]];
        [path appendString:@"/TouchDB"];
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }];
}

@end
