//
//  ATModel.m
//  ActiveTouchExample
//
//  Created by Lucas Medeiros on 11/02/13.
//  Copyright (c) 2013 ActiveTouch. All rights reserved.
//

#import "ATModel.h"

@implementation ATModel

+ (id)findByID:(NSString *)_id
{
    return nil;
}

+ (void)allWithSuccessBlock:(void (^)(NSArray *))successBlock withErrorBlock:(void (^)(NSError *))errorBlock
{

}

- (void)createWithSuccessBlock:(void (^)(void))successBlock withErrorBlock:(void (^)(NSError *))errorBlock
{

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
    [dictionary setObject:[[self class] description] forKey:@"active_touch_model_class"];
    return dictionary;
}

@end
