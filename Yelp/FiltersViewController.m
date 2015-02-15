//
//  FiltersViewController.m
//  Yelp
//
//  Created by Sarat Tallamraju on 2/14/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "FiltersViewController.h"

@interface FiltersViewController ()

@property (strong, nonatomic) NSMutableDictionary *filters;

@end

@implementation FiltersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(onCancelButton)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filter"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(onFilterButton)];
}

- (void) onCancelButton {
    NSLog(@"cancel button pressed");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) onFilterButton {
    NSLog(@"filter button pressed");
    [self.delegate filtersViewController: self didChangeFilters:self.filters];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
