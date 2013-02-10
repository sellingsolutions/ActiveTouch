#import "ATDatabaseContainer.h"
#import <CouchCocoa/CouchCocoa.h>
#import <CouchCocoa/CouchTouchDBServer.h>
#import "Kiwi.h"

SPEC_BEGIN(ATDatabaseContainerSpec)

describe(@"ATDatabaseContainer", ^{
   
    specify(^{
        [[ATDatabaseContainer should] respondToSelector:@selector(sharedInstance)];
    });
    
    specify(^{
        [[[ATDatabaseContainer sharedInstance] should] respondToSelector:@selector(database)];
    });
    
    describe(@"#openDatabaseNamed:", ^{
        
        __block CouchTouchDBServer *server;
        __block CouchDatabase *database;
        
        context(@"when database cannot be started", ^{
            
            beforeEach(^{
                server = [CouchTouchDBServer nullMock];
                database = [CouchDatabase nullMock];
                
                [CouchTouchDBServer stub:@selector(sharedInstance) andReturn:server];
                [server stub:@selector(databaseNamed:) andReturn:database];
                [database stub:@selector(ensureCreated:) andReturn:theValue(NO)];
                
            });
            
            specify(^{
                
                [[theBlock(^{
                    [[ATDatabaseContainer sharedInstance] openDatabaseWithName:@"my_app"];
                }) should] raiseWithName:@"ATDatabaseException" reason:@"Database was not initialized"];
                
            });
            
        });
       
        context(@"when starts successfully", ^{
            
            beforeEach(^{
                server = [CouchTouchDBServer nullMock];
                database = [CouchDatabase nullMock];
                
                [CouchTouchDBServer stub:@selector(sharedInstance) andReturn:server];
                [server stub:@selector(databaseNamed:) andReturn:database];
                [database stub:@selector(ensureCreated:) andReturn:theValue(YES)];
            });
            
            specify(^{
                [[ATDatabaseContainer sharedInstance] openDatabaseWithName:@"my_app"];
                [[[[ATDatabaseContainer sharedInstance] database] should] equal:database];
            });
            
        });
        
    });
    
    describe(@"#closeDatabase", ^{
       
        __block CouchTouchDBServer *server;
        __block CouchDatabase *database;
        
        beforeEach(^{
            server = [CouchTouchDBServer nullMock];
            database = [CouchDatabase nullMock];
            
            [CouchTouchDBServer stub:@selector(sharedInstance) andReturn:server];
            [server stub:@selector(databaseNamed:) andReturn:database];
            [database stub:@selector(ensureCreated:) andReturn:theValue(YES)];
            [[ATDatabaseContainer sharedInstance] openDatabaseWithName:@"my_app"];
            
        });
        
        specify(^{
            [[ATDatabaseContainer sharedInstance] closeDatabase];
            [[[ATDatabaseContainer sharedInstance] database] shouldBeNil];
        });
        
    });
    
    describe(@"#closeServer", ^{
        
        __block CouchTouchDBServer *server;
        __block CouchDatabase *database;
        
        beforeEach(^{
            server = [CouchTouchDBServer nullMock];
            database = [CouchDatabase nullMock];
            
            [CouchTouchDBServer stub:@selector(sharedInstance) andReturn:server];
            [server stub:@selector(databaseNamed:) andReturn:database];
            [database stub:@selector(ensureCreated:) andReturn:theValue(YES)];
            [[ATDatabaseContainer sharedInstance] openDatabaseWithName:@"my_app"];
            
        });
        
        specify(^{
            [[ATDatabaseContainer sharedInstance] closeServer];
            [[[ATDatabaseContainer sharedInstance] database] shouldBeNil];
        });
        
    });
    
});

SPEC_END