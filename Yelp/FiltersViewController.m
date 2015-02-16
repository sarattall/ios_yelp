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

@interface FiltersViewController () <UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate>

@property (nonatomic, readonly) NSDictionary *filters;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSMutableSet *selectedCategories;

@property (nonatomic, assign) NSInteger categoriesSection;
@property (nonatomic, assign) NSInteger distanceSection;
@property (nonatomic, assign) NSInteger sortBySection;
@property (nonatomic, assign) NSInteger mostPopularSection;

@property (nonatomic, assign) BOOL dealsEnabled;

-(void) initCategories;

@end

@implementation FiltersViewController

#pragma mark View Controller Lifecycle

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.selectedCategories = [NSMutableSet set];
        
        self.categoriesSection = 0;
        self.distanceSection = 1;
        self.sortBySection = 2;
        self.mostPopularSection = 3;
        
        [self initCategories];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
      @{@"name" : @"African", @"code": @"african" },
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
        cell.radioButtonTitles = @[@"A", @"B", @"C"];
        cell.selectedButtonIndex = 1;
        return cell;
    } else if (section == self.distanceSection) {
        return nil;
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
        return 0;
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
