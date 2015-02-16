//
//  Business.m
//  Yelp
//
//  Created by Sarat Tallamraju on 2/14/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "Business.h"

@implementation Business

- (id) initWithDictionary:(NSDictionary *)business {
    
    self = [super init];
    
    if (self) {
        self.name = business[@"name"];
        self.imageUrl = business[@"image_url"];
        self.ratingImageUrl = business[@"rating_img_url"];
        self.numReviews = [business[@"review_count"] integerValue];
        
        NSArray *catagories = business[@"categories"];
        NSMutableString *catagoriesString = [NSMutableString stringWithString:@""];
        for (NSArray *catagory in catagories) {
            NSMutableString *cat = [NSMutableString stringWithFormat: @", %@", catagory[0]];
            [catagoriesString appendString: cat];
        }
        self.categories = [catagoriesString substringFromIndex: 2];
        
        NSArray *address = [business valueForKeyPath: @"location.address"];
        NSString *street = nil;
        if ([address count] > 0) {
            street = address[0];
        }
        NSString *neighborhood = [business valueForKeyPath: @"location.neighborhoods"][0];
        if (street == nil) {
            self.address = neighborhood;
        } else {
            self.address = [NSString stringWithFormat: @"%@, %@", street, neighborhood];
        }
        
        float milesPerMeter = 0.000621371;
        self.distance = [business[@"distance"] integerValue] * milesPerMeter;
    }
    
    return self;
}

+ (NSArray *)businessesWithDictionaries: (NSArray *) dictionaries {
    NSMutableArray *businesses = [NSMutableArray array];
    for (NSDictionary *business in dictionaries) {
        [businesses addObject: [[Business alloc] initWithDictionary: business]];
    }
    return businesses;
}

- (NSString *) getDistanceString {
    return [NSString stringWithFormat: @"%.1f mi", (float)self.distance];
}


- (NSString *) getNumReviewsString {
    NSString *reviews = @"review";
    if (self.numReviews > 1) {
        reviews = @"reviews";
    }
    return [NSString stringWithFormat: @"%ld %@", (long)self.numReviews, reviews];
}

@end
