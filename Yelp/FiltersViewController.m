//
//  FiltersViewController.m
//  Yelp
//
//  Created by Sarat Tallamraju on 2/14/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "FiltersViewController.h"
#import "SwitchCell.h"
#import "RadioCell.h"

@interface FiltersViewController () <UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate, RadioCellDelegate>

@property (nonatomic, readonly) NSDictionary *filters;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSMutableSet *selectedCategories;

@property (nonatomic, assign) NSInteger categoriesSection;
@property (nonatomic, assign) NSInteger distanceSection;
@property (nonatomic, assign) NSInteger sortBySection;
@property (nonatomic, assign) NSInteger mostPopularSection;

@property (nonatomic, assign) BOOL dealsEnabled;
@property (nonatomic, assign) NSInteger sortByValue;
@property (nonatomic, assign) NSInteger distanceIndex;

-(void) initCategories;

@end

@implementation FiltersViewController

#pragma mark View Controller Lifecycle

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.selectedCategories = [NSMutableSet set];
        
        self.mostPopularSection = 0;
        self.distanceSection = 1;
        self.sortBySection = 2;
        self.categoriesSection = 3;
        
        [self initCategories];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Filters";
    // self.navigationItem.titleView.backgroundColor = [UIColor whiteColor];
    // UILabel *titleLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 100, 20)];
    // self.navigationItem.titleView = titleLabel;
    // titleLabel.text = @"Filters";
    // titleLabel.backgroundColor = [UIColor whiteColor];
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib: [UINib nibWithNibName: @"SwitchCell" bundle:nil] forCellReuseIdentifier: @"SwitchCell"];
    [self.tableView registerNib: [UINib nibWithNibName: @"RadioCell" bundle:nil] forCellReuseIdentifier: @"RadioCell"];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(onCancelButton)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Apply"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(onApplyButton)];
}

- (void) initCategories {
    self.categories =
    @[
      @{@"name" : @"Thai", @"code": @"thai" },
      @{@"name" : @"Mexican", @"code": @"mexican" },
      @{@"name" : @"American, Traditional", @"code": @"tradamerican" },
      @{@"name" : @"Italian", @"code": @"italian" },
      @{@"name" : @"Pizza", @"code": @"pizza" },
      ];
}

#pragma mark Table Listeners

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    if (section == self.categoriesSection) {
        SwitchCell *cell = [self.tableView dequeueReusableCellWithIdentifier: @"SwitchCell" forIndexPath:indexPath];
        
        cell.on = [self.selectedCategories containsObject: self.categories[indexPath.row]];
        cell.delegate = self;
        cell.titleLabel.text = self.categories[indexPath.row][@"name"];
        
        return cell;
        
    } else if (section == self.sortBySection) {
        RadioCell *cell = [self.tableView dequeueReusableCellWithIdentifier: @"RadioCell" forIndexPath:indexPath];
        cell.delegate = self;
        cell.radioButtonTitles = @[@"Best Match", @"Distance", @"Highest Rated"];
        cell.selectedButtonIndex = self.sortByValue;
        return cell;
    } else if (section == self.distanceSection) {
        RadioCell *cell = [self.tableView dequeueReusableCellWithIdentifier: @"RadioCell" forIndexPath:indexPath];
        cell.delegate = self;
        cell.radioButtonTitles = @[@"Auto", @"1 mile", @"5 miles"];
        cell.selectedButtonIndex = self.distanceIndex;
        return cell;
    } else if (section == self.mostPopularSection) {
        SwitchCell *cell = [self.tableView dequeueReusableCellWithIdentifier: @"SwitchCell" forIndexPath:indexPath];
        
        // cell.on = [self.selectedCategories containsObject: self.categories[indexPath.row]];
        cell.on = self.dealsEnabled;
        cell.delegate = self;
        cell.titleLabel.text = @"Deals";
        return cell;
    }
    
    return nil;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == self.categoriesSection) {
        return [self.categories count];
    } else if (section == self.sortBySection) {
        return 1;
    } else if (section == self.distanceSection) {
        return 1;
    } else if (section == self.mostPopularSection) {
        return 1;
    }
    
    return 0;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == self.categoriesSection) {
        return @"Categories";
    } else if (section == self.sortBySection) {
        return @"Sort by";
    } else if (section == self.distanceSection) {
        return @"Distance";
    } else if (section == self.mostPopularSection) {
        return @"Most Popular";
    }
    
    return [NSString stringWithFormat: @"Section %ld", section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Selected row %ld in section %ld", (long)indexPath.row, (long)indexPath.section);
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark Switch Cell

- (void) switchCell:(SwitchCell *)switchCell didUpdateValue:(BOOL)value {
    NSIndexPath *indexPath = [self.tableView indexPathForCell: switchCell];
    NSInteger section = indexPath.section;
    
    if (section == self.categoriesSection) {
        NSLog(@"Category Switch cell updated value");
        if (value) {
            [self.selectedCategories addObject: self.categories[indexPath.row]];
        } else {
            [self.selectedCategories removeObject: self.categories[indexPath.row]];
        }
        
    } else if (section == self.sortBySection) {
        return;
    } else if (section == self.distanceSection) {
        return;
    } else if (section == self.mostPopularSection) {
        NSLog(@"Deals toggled");
        self.dealsEnabled = value;
        return;
    }
}

#pragma mark Radio Cell

- (void) radioCell:(RadioCell *)radioCell selectedRadioButtonIndex:(NSInteger)index {
    // NSLog(@"Radio cell clicked at index: %ld", (long) index);
    NSIndexPath *indexPath = [self.tableView indexPathForCell: radioCell];
    NSInteger section = indexPath.section;
    
    if (section == self.categoriesSection) {
    } else if (section == self.sortBySection) {
        self.sortByValue = index;
        return;
    } else if (section == self.distanceSection) {
        self.distanceIndex = index;
        return;
    } else if (section == self.mostPopularSection) {
    }
}

#pragma mark Buttons

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
    
    if (self.dealsEnabled) {
        [filters setObject: @1 forKey:@"deals_filter"];
    }
    
    if (self.distanceIndex) {
        NSNumber *distanceValue;
        if (self.distanceIndex == 1) {
            distanceValue = [NSNumber numberWithDouble: 1.0];
        } else {
            distanceValue = [NSNumber numberWithDouble: 5.0];
        }
        
        NSNumber *radius = [NSNumber numberWithDouble: ([distanceValue doubleValue] / 0.000621371 )];
        [filters setObject: radius forKey:@"radius_filter"];
    }
    
    [filters setObject: @(self.sortByValue) forKey: @"sort"];
    
    return filters;
}

- (void) onCancelButton {
    NSLog(@"cancel button pressed");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) onApplyButton {
    NSLog(@"apply button pressed");
    [self.delegate filtersViewController: self didChangeFilters:self.filters];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
