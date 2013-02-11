//
//  ATModelSpec.m
//  ActiveTouchExample
//
//  Created by Lucas Medeiros on 10/02/13.
//  Copyright 2013 ActiveTouch. All rights reserved.
//

#import "ATModel.h"
#import "MTLModel.h"
#import "Car.h"
#import "Kiwi.h"

SPEC_BEGIN(ATModelSpec)

describe(@"ATModel", ^{
   
    specify(^{
        [[ATModel should] respondToSelector:@selector(externalRepresentationKeyPathsByPropertyKey)];
    });
    
    specify(^{
        [[ATModel should] respondToSelector:@selector(findByID:)];
    });
    
    specify(^{
        [[ATModel should] respondToSelector:@selector(allWithSuccessBlock:withErrorBlock:)];
    });
    
    describe(@"instance", ^{
       
        __block ATModel *model;
        
        beforeEach(^{
            model = [[ATModel alloc] init];
        });
        
        specify(^{
            [[model should] respondToSelector:@selector(initWithExternalRepresentation:)];
        });
        
        specify(^{
            [[model should] respondToSelector:@selector(externalRepresentation)];
        });
        
        specify(^{
            [[model should] respondToSelector:@selector(_id)];
        });
        
        specify(^{
            [[model should] respondToSelector:@selector(_rev)];
        });
        
        specify(^{
            [[model should] respondToSelector:@selector(createWithSuccessBlock:withErrorBlock:)];
        });
        
        specify(^{
            [[model should] respondToSelector:@selector(destroyWithSuccessBlock:withErrorBlock:)];
        });
        
        specify(^{
            [[model should] respondToSelector:@selector(updateWithSuccessBlock:withErrorBlock:)];
        });
        
        specify(^{
            [[model should] respondToSelector:@selector(isValid)];
        });
        
    });
    
    describe(@"#initWithExternalRepresentation", ^{
       
        context(@"initializing object", ^{
           
            __block NSDictionary *externalRepresentation;
            __block Car *car;
            
            beforeEach(^{
                externalRepresentation = @{ @"_id" : @"1234", @"_rev" : @"4321", @"model" : @"Classic", @"year" : [NSDate date]};
                car = [[Car alloc] initWithExternalRepresentation:externalRepresentation];
            });
            
            it(@"should populate _id", ^{
                [[car._id should] equal:[externalRepresentation objectForKey:@"_id"]];
            });
            
            it(@"should populate _rev", ^{
                [[car._rev should] equal:[externalRepresentation objectForKey:@"_rev"]];
            });
            
            it(@"should populate model", ^{
                [[car.model should] equal:[externalRepresentation objectForKey:@"model"]];
            });
            
            it(@"should populate year", ^{
                [[car.year should] equal:[externalRepresentation objectForKey:@"year"]];
            });
            
        });
        
    });
    
    describe(@"#externalRepresentation", ^{
        
        __block NSDictionary *externalRepresentation;
        __block Car *car;
        
        beforeEach(^{
            NSDictionary *expectedRepresentantion = @{ @"_id" : @"1234", @"_rev" : @"4321", @"model" : @"Classic", @"year" : [NSDate date]};
            car = [[Car alloc] initWithExternalRepresentation:expectedRepresentantion];
            externalRepresentation = [car externalRepresentation];
        });
        
        it(@"should contain _id key", ^{
            [[[externalRepresentation objectForKey:@"_id"] should] equal:car._id];
        });
        
        it(@"should contain _rev key", ^{
            [[[externalRepresentation objectForKey:@"_rev"] should] equal:car._rev];
        });
        
        it(@"should contain model key", ^{
            [[[externalRepresentation objectForKey:@"model"] should] equal:car.model];
        });
        
        it(@"should contain year key", ^{
            [[[externalRepresentation objectForKey:@"year"] should] equal:car.year];
        });
        
        it(@"should contain active_touch_model_class key", ^{
            [[[externalRepresentation objectForKey:@"active_touch_model_class"] should] equal:[[Car class] description]];
        });
        
    });
    
});

SPEC_END


