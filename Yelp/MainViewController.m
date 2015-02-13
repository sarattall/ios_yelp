//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MainViewController.h"
#import "YelpClient.h"
#import "BusinessTableViewCell.h"

NSString * const kYelpConsumerKey = @"uZY39nHLbLy1irQfsaPNOg";
NSString * const kYelpConsumerSecret = @"nMdu_55OOXVYxrNt_Qy1jnY0bos";
NSString * const kYelpToken = @"c6xcH9pqfHerwQgFSiNaZCYxqoCIp8iW";
NSString * const kYelpTokenSecret = @"WYVH7YXhqrcxRrawNROKbbjR5Dw";

@interface MainViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) YelpClient *client;
@property (nonatomic, strong) NSArray *businesses;

@property (nonatomic, strong) NSString *cellName;

@end

@implementation MainViewController

#pragma mark View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set table params.
    self.cellName = @"BusinessTableViewCell";
    UINib *cellNib = [UINib nibWithNibName:self.cellName bundle:nil];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:cellNib forCellReuseIdentifier:self.cellName];
}

#pragma mark Table Listeners

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BusinessTableViewCell *tvc = [self.tableView dequeueReusableCellWithIdentifier: self.cellName forIndexPath:indexPath];
    tvc.title = self.businesses[indexPath.row][@"name"];
    return tvc;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.businesses count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Selected row %ld in section %ld", (long)indexPath.row, (long)indexPath.section);
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark Constructor

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey
                                               consumerSecret:kYelpConsumerSecret
                                                  accessToken:kYelpToken
                                                 accessSecret:kYelpTokenSecret];
        
        [self.client searchWithTerm:@"Thai" success:^(AFHTTPRequestOperation *operation, id response) {
            NSLog(@"response: %@", response);
            self.businesses = response[@"businesses"];
            [self.tableView reloadData];
            NSLog(@"businesses: %@", self.businesses);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error: %@", [error description]);
        }];
    }
    return self;
}

@end
