//
//  Business.h
//  Yelp
//
//  Created by Sarat Tallamraju on 2/14/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Business : NSObject

@property (strong, nonatomic) NSString *imageUrl;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *ratingImageUrl;
@property (assign, nonatomic) NSInteger numReviews;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *categories;
@property (assign, nonatomic) CGFloat distance;

+ (NSArray *)businessesWithDictionaries: (NSArray *) dictionaries;

- (NSString *)getNumReviewsString;
- (NSString *)getDistanceString;

- (id)initWithDictionary: (NSDictionary *) business;

@end
