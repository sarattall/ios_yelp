//
//  FiltersViewController.m
//  Yelp
//
//  Created by Sarat Tallamraju on 2/14/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "FiltersViewController.h"
#import "SwitchCell.h"

@interface FiltersViewController () <UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate>

@property (nonatomic, readonly) NSDictionary *filters;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSMutableSet *selectedCategories;

-(void) initCategories;

@end

@implementation FiltersViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.selectedCategories = [NSMutableSet set];
        [self initCategories];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UINib *cellNib = [UINib nibWithNibName:@"SwitchCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier: @"SwitchCell"];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(onCancelButton)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Apply"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(onApplyButton)];
}

- (NSDictionary *) filters {
    NSMutableDictionary *filters = [NSMutableDictionary dictionary];
    
    if (self.selectedCategories.count > 0) {
        NSMutableArray *codes = [NSMutableArray array];
        for (NSDictionary *category in self.selectedCategories) {
            [codes addObject: category[@"code"]];
        }
        
        NSString *categoriesFilter = [codes componentsJoinedByString: @","];
        [filters setObject: categoriesFilter forKey: @"category_filter"];
    }
    
    return filters;
}

#pragma mark Table Listeners

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SwitchCell *cell = [self.tableView dequeueReusableCellWithIdentifier: @"SwitchCell" forIndexPath:indexPath];
    
    cell.on = [self.selectedCategories containsObject: self.categories[indexPath.row]];
    cell.delegate = self;
    cell.titleLabel.text = self.categories[indexPath.row][@"name"];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.categories count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Selected row %ld in section %ld", (long)indexPath.row, (long)indexPath.section);
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark Switch Cell

- (void) switchCell:(SwitchCell *)switchCell didUpdateValue:(BOOL)value {
    NSLog(@"Switch cell updated value");
    NSIndexPath *indexPath = [self.tableView indexPathForCell: switchCell];
    
    if (value) {
        [self.selectedCategories addObject: self.categories[indexPath.row]];
    } else {
        [self.selectedCategories removeObject: self.categories[indexPath.row]];
    }
    
}

#pragma mark Buttons

- (void) onCancelButton {
    NSLog(@"cancel button pressed");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) onApplyButton {
    NSLog(@"apply button pressed");
    [self.delegate filtersViewController: self didChangeFilters:self.filters];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initCategories {
    self.categories =
    @[
      @{@"name" : @"Thai", @"code": @"thai" },
      @{@"name" : @"Mexican", @"code": @"mexican" },
      @{@"name" : @"African", @"code": @"african" },
      @{@"name" : @"American, Traditional", @"code": @"tradamerican" },
      @{@"name" : @"Italian", @"code": @"italian" },
      @{@"name" : @"Pizza", @"code": @"pizza" },
      ];
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
