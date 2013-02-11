//
//  ATModelIntegrationSpec.m
//  ActiveTouchExample
//
//  Created by Lucas Medeiros on 11/02/13.
//  Copyright 2013 ActiveTouch. All rights reserved.
//

#import "Car.h"
#import "ATModel.h"
#import "ATDatabaseCleaner.h"
#import "ATDatabaseContainer.h"
#import <CouchCocoa/CouchCocoa.h>
#import "CMFactory.h"
#import "Kiwi.h"

SPEC_BEGIN(ATModelIntegrationSpec)

beforeAll(^{
    [ATDatabaseCleaner openTestDatabaseNamed:@"active_touch_example_test"];
});

beforeEach(^{
    [ATDatabaseCleaner cleanDatabase];
});

afterAll(^{
    [ATDatabaseCleaner removeDatabase];
});

describe(@"ATModel", ^{
   
    describe(@".allWithSuccessBlock:withErrorBlock", ^{
       
        __block NSArray *cars;
        __block NSArray *expectedCars;
        __block NSError *expectedError;
        
        beforeEach(^{
            
            CMFactory *carsFactory = [CMFactory forClass:[Car class]];
            [carsFactory addToField:@"model" sequenceValue:^(NSUInteger sequence) {
                return [NSString stringWithFormat:@"Model%d", sequence];
            }];
            cars = [carsFactory buildWithCapacity:5];
            
            for(Car *car in cars) {
                
                CouchDocument *document = [[[ATDatabaseContainer sharedInstance] database] untitledDocument];
                RESTOperation *operation = [document putProperties:[car externalRepresentation]];
                [operation start];
                [operation onCompletion:^{
                    if (!operation.error) {
                        NSLog(@"Car with model: %@, was saved", car.model);
                    }
                }];
                    
            }
            [Car allWithSuccessBlock:^(NSArray *collection) {
                expectedCars = collection;
            } withErrorBlock:^(NSError *error) {
                expectedError = error;
            }];
            
        });
        
        specify(^{
            [[expectFutureValue(expectedCars) shouldEventually] beNonNil];
        });
        
        specify(^{
            [[expectFutureValue(theValue([expectedCars count])) shouldEventually] equal:theValue([cars count])];
        });
        
        specify(^{
            [[expectFutureValue(expectedError) shouldEventually] beNil];
        });
        
    });
    
});

SPEC_END


