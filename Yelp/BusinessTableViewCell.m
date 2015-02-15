//
//  BusinessTableViewCell.m
//  Yelp
//
//  Created by Sarat Tallamraju on 2/11/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "BusinessTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation BusinessTableViewCell

- (void)awakeFromNib {
    // self.titleLabel.preferredMaxLayoutWidth = self.titleLabel.frame.size.width;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) layoutSubviews {
    [super layoutSubviews];
    // self.titleLabel.preferredMaxLayoutWidth = self.titleLabel.frame.size.width;
}

- (void) setBusiness: (Business *) business {
    self.titleLabel.text = business.name;
    [self.thumbnail setImageWithURL: [NSURL URLWithString: business.imageUrl]];
    [self.stars setImageWithURL: [NSURL URLWithString: business.ratingImageUrl]];
    self.reviews.text = [business getNumReviewsString];
    self.dollar.text = @"$$";
    self.address.text = business.address;
    self.descriptionLabel.text = business.categories;
    self.miles.text = [business getDistanceString];
}

@end
