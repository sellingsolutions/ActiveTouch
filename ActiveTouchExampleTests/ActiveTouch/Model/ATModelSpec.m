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
        [[ATModel should] respondToSelector:@selector(JSONKeyPathsByPropertyKey)];
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
    
});

SPEC_END


