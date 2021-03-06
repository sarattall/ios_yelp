//
//  BusinessTableViewCell.h
//  Yelp
//
//  Created by Sarat Tallamraju on 2/11/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Business.h"

@interface BusinessTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *thumbnail;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *miles;
@property (strong, nonatomic) IBOutlet UILabel *dollar;
@property (strong, nonatomic) IBOutlet UIImageView *stars;
@property (strong, nonatomic) IBOutlet UILabel *reviews;
@property (strong, nonatomic) IBOutlet UILabel *address;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;

- (void) setBusiness: (Business *) business;

@end
