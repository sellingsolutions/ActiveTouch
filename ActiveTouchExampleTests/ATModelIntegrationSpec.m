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
    [ATDatabaseContainer stub:@selector(sharedInstance) andReturn:[ATDatabaseCleaner databaseContainer]];
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
                
                CouchDocument *document = [[[ATDatabaseCleaner databaseContainer] database] untitledDocument];
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
    
    describe(@".findById:", ^{
       
        __block Car *expectedCar;
        __block Car *car;
        
        beforeEach(^{
           
            CMFactory *factory = [CMFactory forClass:[Car class]];
            [factory addToField:@"model" value:^id{
               return @"Classic";
            }];
            [factory addToField:@"year" value:^id{
                return @"2011";
            }];
            expectedCar = [factory build];
            CouchDatabase *database = [[ATDatabaseCleaner databaseContainer] database];
            CouchDocument *document = [database untitledDocument];
            NSDictionary *externalRepresentation = [expectedCar externalRepresentation];
            RESTOperation *operation = [document putProperties:externalRepresentation];
            [operation start];
            [operation onCompletion:^{
                if (!operation.error) {
                    NSString *_id = [[[operation responseBody] fromJSON] objectForKey:@"id"];
                    car = [Car findByID:_id];
                }
            }];
            
        });
        
        specify(^{
            [[expectFutureValue(car) shouldEventually] beNonNil];
        });
        
        specify(^{
            [[expectFutureValue(car.model) shouldEventually] equal:expectedCar.model];
        });
        
        specify(^{
            [[expectFutureValue(car.year) shouldEventually] equal:expectedCar.year];
        });
        
    });
    
    describe(@"#createWithSuccessBlock:withErrorBlock", ^{
        
        __block Car *car;
        __block NSError *expectedError;
        
        beforeEach(^{
            
            CMFactory *factory = [CMFactory forClass:[Car class]];
            [factory addToField:@"model" value:^id{
                return @"Classic";
            }];
            [factory addToField:@"year" value:^id{
                return @"2011";
            }];
            car = [factory build];
            [car createWithSuccessBlock:^{
                
            } withErrorBlock:^(NSError *error) {
                expectedError = error;
            }];
            
        });
        
        specify(^{
            [[expectFutureValue(car._id) shouldEventually] beNonNil];
        });
        
        specify(^{
            [[expectFutureValue(car._rev) shouldEventually] beNonNil];
        });
        
        specify(^{
            [[expectFutureValue(expectedError) shouldEventually] beNil];
        });
        
    });
    
    describe(@"#destroyWithSuccessBlock:withErrorBlock", ^{
        
        __block Car *carToBeDestroyed;
        __block Car *retrievedCar;
        __block NSError *expectedError;
        
        beforeEach(^{
            
            CMFactory *factory = [CMFactory forClass:[Car class]];
            [factory addToField:@"model" value:^id{
                return @"Classic";
            }];
            [factory addToField:@"year" value:^id{
                return @"2011";
            }];
            carToBeDestroyed = [factory build];
            [carToBeDestroyed createWithSuccessBlock:^{
            
                [carToBeDestroyed destroyWithSuccessBlock:^{
                    retrievedCar = [Car findByID:carToBeDestroyed._id];
                    NSLog(@"Car destroyed");
                } withErrorBlock:^(NSError *error) {
                    expectedError = error;
                }];
                
            } withErrorBlock:^(NSError *error) {
                expectedError = error;
            }];
            
            
        });
        
        specify(^{
            [[expectFutureValue(retrievedCar) shouldEventually] beNil];
        });
        
        specify(^{
            [[expectFutureValue(expectedError) shouldEventually] beNil];
        });
        
    });
    
});

SPEC_END


