//
//  SwitchCell.h
//  Yelp
//
//  Created by Sarat Tallamraju on 2/14/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SwitchCell;

@protocol SwitchCellDelegate <NSObject>

-(void) switchCell: (SwitchCell *) switchCell didUpdateValue: (BOOL) value;

@end

@interface SwitchCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, assign) BOOL on;
@property (nonatomic, weak) id<SwitchCellDelegate> delegate;

- (void)setOn:(BOOL)on animated: (BOOL) animated;

@end
