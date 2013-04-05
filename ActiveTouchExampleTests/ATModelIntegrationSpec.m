//
//  ATModelIntegrationSpec.m
//  ActiveTouchExample
//
//  Created by Lucas Medeiros on 11/02/13.
//  Copyright 2013 ActiveTouch. All rights reserved.
//

#import "Car.h"
#import "ATModel.h"
#import "ATDatabaseTestRunner.h"
#import "ATDatabaseContainer.h"
#import <CouchCocoa/CouchCocoa.h>
#import "CMFactory.h"
#import "Kiwi.h"
#import "MTLJSONAdapter.h"

SPEC_BEGIN(ATModelIntegrationSpec)

beforeAll(^{
    [ATDatabaseTestRunner openTestDatabaseNamed:@"active_touch_example_test"];
});

beforeEach(^{
    [ATDatabaseContainer stub:@selector(sharedInstance) andReturn:[ATDatabaseTestRunner databaseContainer]];
    [ATDatabaseTestRunner cleanDatabase];
});

afterAll(^{
    [ATDatabaseTestRunner removeDatabase];
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
                
                CouchDocument *document = [[[ATDatabaseTestRunner databaseContainer] database] untitledDocument];
                RESTOperation *operation = [document putProperties:[MTLJSONAdapter JSONDictionaryFromModel:car]];
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
    
    describe(@".allWithLimit:skipping:withSuccessBlock:withErrorBlock", ^{
        
        __block NSArray *cars;
        __block NSArray *expectedCars;
        __block NSError *expectedError;
        
        beforeEach(^{
            
            CMFactory *carsFactory = [CMFactory forClass:[Car class]];
            [carsFactory addToField:@"model" sequenceValue:^(NSUInteger sequence) {
                return [NSString stringWithFormat:@"Model%d", sequence];
            }];
            cars = [carsFactory buildWithCapacity:10];
            
            for(Car *car in cars) {
                
                CouchDocument *document = [[[ATDatabaseTestRunner databaseContainer] database] untitledDocument];
                RESTOperation *operation = [document putProperties:[MTLJSONAdapter JSONDictionaryFromModel:car]];
                [operation start];
                [operation onCompletion:^{
                    if (!operation.error) {
                        NSLog(@"Car with model: %@, was saved", car.model);
                    }
                }];
                
            }
            [Car allWithLimit:5 skipping:0 withSuccessBlock:^(NSArray *collection) {
                expectedCars = collection;
            } withErrorBlock:^(NSError *error) {
                expectedError = error;
            }];
            
        });
        
        specify(^{
            [[expectFutureValue(expectedCars) shouldEventually] beNonNil];
        });
        
        specify(^{
            [[expectFutureValue(theValue([expectedCars count])) shouldEventually] equal:theValue(5)];
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
            CouchDatabase *database = [[ATDatabaseTestRunner databaseContainer] database];
            CouchDocument *document = [database untitledDocument];
            NSDictionary *externalRepresentation = [MTLJSONAdapter JSONDictionaryFromModel:expectedCar];
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
    
    describe(@"#updateWithSuccessBlock:withErrorBlock", ^{
        
        __block Car *car;
        __block BOOL updated;
        __block NSError *expectedError;
        
        beforeEach(^{
            
            updated = NO;
            
            CMFactory *factory = [CMFactory forClass:[Car class]];
            [factory addToField:@"model" value:^id{
                return @"Classic";
            }];
            [factory addToField:@"year" value:^id{
                return @"2011";
            }];
            car = [factory build];
            [car createWithSuccessBlock:^{
                
                car.model = @"Civic";
                [car updateWithSuccessBlock:^{
                    updated = YES;
                } withErrorBlock:^(NSError *error) {
                    
                }];
                
            } withErrorBlock:^(NSError *error) {
                expectedError = error;
            }];
            
        });
        
        specify(^{
            [[expectFutureValue(car.model) shouldEventually] equal:@"Civic"];
        });
        
        specify(^{
            [[expectFutureValue(theValue(updated)) shouldEventually] beTrue];
        });
        
        specify(^{
            [[expectFutureValue(expectedError) shouldEventually] beNil];
        });
        
    });
    
});

SPEC_END


