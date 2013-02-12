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

@implementation ATModel


+ (id)findByID:(NSString *)_id
{
    CouchDocument *document = [[[ATDatabaseContainer sharedInstance] database] documentWithID:_id];
    id model = [[self alloc] initWithExternalRepresentation:[document properties]];
    return model;
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
                NSString *className = [row.value objectForKey:@"active_touch_model_class"];
                Class class = NSClassFromString(className);
                id model = [[class alloc] initWithExternalRepresentation:row.value];
                [collection addObject:model];
            }
            successBlock(collection);
            
        }
        
    }];
}

- (void)createWithSuccessBlock:(void (^)(void))successBlock withErrorBlock:(void (^)(NSError *))errorBlock
{
    if ([self isValid]) {
    
        CouchDocument *document = [[[ATDatabaseContainer sharedInstance] database] untitledDocument];
        RESTOperation *operation = [document putProperties:[self externalRepresentation]];
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

}

- (void)updateWithSuccessBlock:(void (^)(void))successBlock withErrorBlock:(void (^)(NSError *))errorBlock
{
}

- (BOOL)isValid
{
    return YES;
}

- (NSDictionary *)externalRepresentation
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:[super externalRepresentation]];
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

+  (void)registerView
{
    NSString *documentDesign = [self documentDesignName];
    NSString *viewName = [self viewName];
    
    CouchDesignDocument *design = [[[ATDatabaseContainer sharedInstance] database] designDocumentWithName:documentDesign];
    [design defineViewNamed:viewName mapBlock:^(NSDictionary *doc, TDMapEmitBlock emit) {
        id className = [doc objectForKey:@"active_touch_model_class"];
        if ([[[self class] description] isEqualToString:className]) {
            emit(className, doc);
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

@end
