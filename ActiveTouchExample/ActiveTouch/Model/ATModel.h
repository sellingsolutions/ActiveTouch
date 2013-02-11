//
//  ATModel.h
//  ActiveTouchExample
//
//  Created by Lucas Medeiros on 11/02/13.
//  Copyright (c) 2013 ActiveTouch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle.h"

@interface ATModel : MTLModel

@property (nonatomic, copy, readonly) NSString *_id;
@property (nonatomic, copy, readonly) NSString *_rev;


+ (void)registerView;
+ (void)allWithSuccessBlock:(void(^)(NSArray *collection))successBlock withErrorBlock:(void(^)(NSError *error))errorBlock;
+ (id)findByID:(NSString *)_id;

- (void)createWithSuccessBlock:(void(^)(void))successBlock withErrorBlock:(void(^)(NSError *error))errorBlock;
- (void)destroyWithSuccessBlock:(void(^)(void))successBlock withErrorBlock:(void(^)(NSError *error))errorBlock;
- (void)updateWithSuccessBlock:(void(^)(void))successBlock withErrorBlock:(void(^)(NSError *error))errorBlock;
- (BOOL)isValid;

@end
