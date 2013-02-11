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

static ATDatabaseContainer *__container = nil;
static NSOperationQueue *__operationQueue;

@implementation ATDatabaseCleaner

+ (void)openTestDatabaseNamed:(NSString *)databaseName
{
    __container = [[ATDatabaseContainer alloc] init];
    [__container openDatabaseWithName:databaseName];
}

+ (void)cleanDatabase
{
    __operationQueue = [NSOperationQueue mainQueue];
    CouchQuery *query = [__container database].getAllDocuments;
    for (CouchQueryRow *row in query.rows) {
        CouchDocument *document = [[__container database] documentWithID:row.documentID];
        [__operationQueue addOperationWithBlock:^{
            [self removeDocument:document];
        }];
    }
    [__operationQueue addOperationWithBlock:^{
        [__container closeDatabase];
        [__container closeServer];
        __container = nil;
        __operationQueue = nil;
    }];
}

+ (void)removeDocument:(CouchDocument *)document
{
    RESTOperation *operation = [document DELETE];
    [operation start];
}

@end
