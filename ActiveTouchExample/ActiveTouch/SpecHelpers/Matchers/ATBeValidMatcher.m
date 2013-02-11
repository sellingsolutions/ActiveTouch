//
//  ATBeValidMatcher.m
//  ActiveTouchExample
//
//  Created by Lucas Medeiros on 11/02/13.
//  Copyright (c) 2013 ActiveTouch. All rights reserved.
//

#import "ATBeValidMatcher.h"
#import "ATModel.h"

@implementation ATBeValidMatcher

+ (NSArray *)matcherStrings
{
    return @[@"beValid"];
}

#pragma mark Matching

- (BOOL)evaluate {
    return [self.subject isValid];
}

#pragma mark Getting Failure Messages

- (NSString *)failureMessageForShould {
    return @"expected subject to be valid";
}

- (NSString *)failureMessageForShouldNot {
    return @"expected subject not to be valid";
}

- (void)beValid{};

@end
