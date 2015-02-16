//
//  RadioCell.h
//  Yelp
//
//  Created by Sarat Tallamraju on 2/15/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadioButton.h"

@interface RadioCell : UITableViewCell

@property (nonatomic, strong) NSArray *radioButtonTitles;

@property (nonatomic, assign) NSInteger selectedButtonIndex;

@end
