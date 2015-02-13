//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MainViewController.h"
#import "YelpClient.h"

NSString * const kYelpConsumerKey = @"uZY39nHLbLy1irQfsaPNOg";
NSString * const kYelpConsumerSecret = @"nMdu_55OOXVYxrNt_Qy1jnY0bos";
NSString * const kYelpToken = @"c6xcH9pqfHerwQgFSiNaZCYxqoCIp8iW";
NSString * const kYelpTokenSecret = @"WYVH7YXhqrcxRrawNROKbbjR5Dw";

@interface MainViewController ()

@property (nonatomic, strong) YelpClient *client;
@property (nonatomic, strong) NSArray *businesses;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
        
        [self.client searchWithTerm:@"Thai" success:^(AFHTTPRequestOperation *operation, id response) {
            // NSLog(@"response: %@", response);
            self.businesses = response[@"businesses"];
            NSLog(@"businesses: %@", self.businesses);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error: %@", [error description]);
        }];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

@end
