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
}

+ (void)cleanDatabase
{
    NSMutableArray *documents = [NSMutableArray array];
    CouchQuery *query = [[__container database] getAllDocuments];
    for (CouchQueryRow *row in query.rows) {
        [documents addObject:[[__container database] documentWithID:row.documentID]];
    }
    [[__container database] deleteDocuments:documents];
}

+ (void)removeDatabase
{
        [__container closeDatabase];
        [__container closeServer];
        __container = nil;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
        NSMutableString *path = [NSMutableString stringWithString:[paths objectAtIndex:0]];
        [path appendString:@"/TouchDB"];
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

@end
