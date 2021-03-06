//
//  ATModel.m
//  ActiveTouchExample
//
//  Created by Lucas Medeiros on 11/02/13.
//  Copyright (c) 2013 ActiveTouch. All rights reserved.
//

#import "ATModel.h"
#import <CouchCocoa/CouchCocoa.h>
#import "ATDatabaseContainer.h"
#import "ATModel.h"
#import "MTLJSONAdapter.h"

@implementation ATModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{ @"_id" : @"_id", @"_rev" : @"_rev"};
}

+ (id)findByID:(NSString *)_id
{
    CouchDocument *document = [[[ATDatabaseContainer sharedInstance] database] documentWithID:_id];
    if (!document || [[[document properties] objectForKey:@"_deleted"] boolValue]) {
        return nil;
    }
    id model = [MTLJSONAdapter modelOfClass:[self class] fromJSONDictionary:[document properties] error:nil];
    return model;
}

+ (void)allWithLimit:(NSUInteger)limit
            skipping:(NSUInteger)skip

    withSuccessBlock:(void (^)(NSArray *))successBlock withErrorBlock:(void (^)(NSError *))errorBlock
{
    NSString *documentDesign = [self documentDesignName];
    NSString *viewName = [self viewName];
    CouchDatabase *database = [[ATDatabaseContainer sharedInstance] database];
    CouchDesignDocument *colletionDesign = [database designDocumentWithName:documentDesign];
    CouchQuery *query = [colletionDesign queryViewNamed:viewName];
    query.limit = limit;
    query.skip = skip;
    RESTOperation *operation = [query start];
    [operation onCompletion:^{
        
        if (operation.error) {
            errorBlock(operation.error);
        } else {
            
            NSMutableArray *collection = [NSMutableArray array];
            for (CouchQueryRow* row in query.rows) {
                id model = [self findByID:[row documentID]];
                if (model) {
                    [collection addObject:model];
                }
            }
            successBlock(collection);
            
        }
        
    }];
}

+ (void)allWithSuccessBlock:(void (^)(NSArray *))successBlock withErrorBlock:(void (^)(NSError *))errorBlock
{
    NSString *documentDesign = [self documentDesignName];
    NSString *viewName = [self viewName];
    CouchDatabase *database = [[ATDatabaseContainer sharedInstance] database];
    CouchDesignDocument *colletionDesign = [database designDocumentWithName:documentDesign];
    CouchQuery *query = [colletionDesign queryViewNamed:viewName];
    RESTOperation *operation = [query start];
    [operation onCompletion:^{
        
        if (operation.error) {
            errorBlock(operation.error);
        } else {
            
            NSMutableArray *collection = [NSMutableArray array];
            for (CouchQueryRow* row in query.rows) {
                id model = [self findByID:[row documentID]];
                if (model) {
                    [collection addObject:model];
                }
            }
            successBlock(collection);
            
        }
        
    }];
}

- (void)createWithSuccessBlock:(void (^)(void))successBlock withErrorBlock:(void (^)(NSError *))errorBlock
{
    if ([self isValid]) {
    
        CouchDocument *document = [[[ATDatabaseContainer sharedInstance] database] untitledDocument];
        RESTOperation *operation = [document putProperties:[MTLJSONAdapter JSONDictionaryFromModel:self]];
        [operation onCompletion:^{
            
            if (operation.error) {
                errorBlock(operation.error);
            } else {
                
                NSString *identifier = [[[operation responseBody] fromJSON] objectForKey:@"id"];
                NSString *revision = [[[operation responseBody] fromJSON] objectForKey:@"rev"];
                
                __id = identifier;
                __rev = revision;
                
                successBlock();
            }
            
        }];
        [operation start];
        
    } else {
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:@"validation failed" forKey:NSLocalizedDescriptionKey];
        NSError *error = [[NSError alloc] initWithDomain:@"com.activetouch.model.validation" code:500 userInfo:details];
        errorBlock(error);
    }
}

- (void)destroyWithSuccessBlock:(void (^)(void))successBlock withErrorBlock:(void (^)(NSError *))errorBlock
{
    CouchDocument *document = [[[ATDatabaseContainer sharedInstance] database] documentWithID:__id];
    RESTOperation *operation = [document DELETE];
    [operation onCompletion:^{
        if (operation.error) {
            errorBlock(operation.error);
        } else {
            successBlock();
        }
    }];
    [operation start];
}

- (void)updateWithSuccessBlock:(void (^)(void))successBlock withErrorBlock:(void (^)(NSError *))errorBlock
{
    if ([self isValid]) {
        
        CouchDocument *document = [[[ATDatabaseContainer sharedInstance] database] documentWithID:__id];
        RESTOperation *operation = [document putProperties:[MTLJSONAdapter JSONDictionaryFromModel:self]];
        [operation onCompletion:^{
            
            if (operation.error) {
                errorBlock(operation.error);
            } else {
                successBlock();
            }
            
        }];
        [operation start];
        
    } else {
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:@"validation failed" forKey:NSLocalizedDescriptionKey];
        NSError *error = [[NSError alloc] initWithDomain:@"com.activetouch.model.validation" code:500 userInfo:details];
        errorBlock(error);
    }
}

- (BOOL)isValid
{
    return YES;
}

- (NSDictionary *)dictionaryValue
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryValue]];
    [self removeValueFromKey:@"_id" inDictionaryIfItsNil:dictionary];
    [self removeValueFromKey:@"_rev" inDictionaryIfItsNil:dictionary];
    [dictionary setObject:[[self class] description] forKey:@"active_touch_model_class"];
    return dictionary;
}

- (void)removeValueFromKey:(NSString *)key inDictionaryIfItsNil:(NSMutableDictionary *)dictionary
{
    if ([[dictionary objectForKey:key] isKindOfClass:[NSNull class]]) {
        [dictionary removeObjectForKey:key];
    }
}

+  (void)registerViews
{
    NSString *documentDesign = [self documentDesignName];
    NSString *viewName = [self viewName];
    
    CouchDesignDocument *design = [[[ATDatabaseContainer sharedInstance] database] designDocumentWithName:documentDesign];
    [design defineViewNamed:viewName mapBlock:^(NSDictionary *doc, TDMapEmitBlock emit) {
        id className = [doc objectForKey:@"active_touch_model_class"];
        if ([[[self class] description] isEqualToString:className]) {
            emit([self orderValuesFromDictionary:doc], doc);
        }
    } version:@"1.0"];
}

+ (NSString *)documentDesignName
{
    return [NSString stringWithFormat:@"%@_document_design", [[[self class] description] lowercaseString]];
}

+ (NSString *)viewName
{
    return [NSString stringWithFormat:@"%@_all_view", [[[self class] description] lowercaseString]];
}

+ (NSArray *)sortOrder
{
    return @[@"_id"];
}

+ (NSArray *)orderValuesFromDictionary:(NSDictionary *)documentProperties
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSString  *key in [self sortOrder]) {
        [array addObject:[documentProperties objectForKey:key]];
    }
    return array;
}

@end
