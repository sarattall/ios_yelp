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
#import "UIImageView+AFNetworking.h"
#import "Business.h"
#import "FiltersViewController.h"
#import "SVProgressHUD.h"

NSString * const kYelpConsumerKey = @"uZY39nHLbLy1irQfsaPNOg";
NSString * const kYelpConsumerSecret = @"nMdu_55OOXVYxrNt_Qy1jnY0bos";
NSString * const kYelpToken = @"c6xcH9pqfHerwQgFSiNaZCYxqoCIp8iW";
NSString * const kYelpTokenSecret = @"WYVH7YXhqrcxRrawNROKbbjR5Dw";

@interface MainViewController () <UISearchBarDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) YelpClient *client;
@property (nonatomic, strong) NSArray *businesses;

@property (nonatomic, strong) NSString *cellName;
@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) NSString *currentSearchTerm;

-(void) searchForBusinessesWithQuery: (NSString *)query params: (NSDictionary *)params;

@end

@implementation MainViewController

-(void) searchForBusinessesWithQuery: (NSString *)query params: (NSDictionary *)params {
    [SVProgressHUD show];
    [self.client searchWithTerm: query params: params success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"response: %@", response);
        self.businesses = [Business businessesWithDictionaries: response[@"businesses"]];
        [self.tableView reloadData];
        // NSLog(@"businesses: %@", self.businesses);
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus: @"Network Error"];
    }];
}

-(void) executeSearch: (UISearchBar *)searchBar {
    self.currentSearchTerm = searchBar.text;
    [self searchForBusinessesWithQuery: searchBar.text params:nil];
    [searchBar resignFirstResponder];
}

-(void) cancelSearch: (UISearchBar *)searchBar {
    self.currentSearchTerm = nil;
    [searchBar resignFirstResponder];
}

-(void) searchBarDidEndEditing: (UISearchBar *)searchBar {
    NSLog(@"search bar done editing");
    [self executeSearch:searchBar];
}

-(void) searchBarSearchButtonClicked: (UISearchBar *)searchBar {
    NSLog(@"search bar search button clicked");
    [self executeSearch:searchBar];
}

-(void) searchBarCancelButtonClicked: (UISearchBar *)searchBar {
    NSLog(@"search bar cancel button clicked");
    [self cancelSearch:searchBar];
}

#pragma mark View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set table params.
    self.cellName = @"BusinessTableViewCell";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    UINib *cellNib = [UINib nibWithNibName:self.cellName bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:self.cellName];
    
    self.title = @"Yelp";
    
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.showsCancelButton = YES;
    self.searchBar.placeholder = @"Search";
    self.searchBar.delegate = self;
    self.navigationItem.titleView = self.searchBar;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filters"
                                                                             style: UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(onFilterButton)];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

#pragma mark Filters

-(void) onFilterButton {
    NSLog(@"Filter button clicked");
    
    FiltersViewController *vc = [[FiltersViewController alloc] init];
    vc.delegate = self;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController: vc];
    
    [self presentViewController: nvc animated:YES completion:nil];
}

-(void) filtersViewController:(FiltersViewController *)filtersViewController didChangeFilters:(NSDictionary *)filters {
    NSLog(@"Filters changed: %@", filters);
    NSString *searchTerm = @"Restaurants";
    if (self.currentSearchTerm) {
        self.searchBar.text = self.currentSearchTerm;
        searchTerm = self.currentSearchTerm;
    }
    [self searchForBusinessesWithQuery: searchTerm params: filters];
}

#pragma mark Table Listeners

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BusinessTableViewCell *tvc = [self.tableView dequeueReusableCellWithIdentifier: self.cellName forIndexPath:indexPath];
    Business *business = self.businesses[indexPath.row];
    [tvc setBusiness: business];
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
        
        [self searchForBusinessesWithQuery: @"Restaurants" params: nil];
    }
    return self;
}

@end
