//
//  RadioCell.m
//  Yelp
//
//  Created by Sarat Tallamraju on 2/15/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "RadioCell.h"

@class RadioButton;

@interface RadioCell()
@property (strong, nonatomic) IBOutlet UIButton *firstButton;
@property (strong, nonatomic) IBOutlet UIButton *secondButton;
@property (strong, nonatomic) IBOutlet UIButton *thirdButton;

- (IBAction)onRadioButtonSelected:(id)sender;
@end

@implementation RadioCell

- (void)awakeFromNib {
    // Initialization code
}

- (void) setRadioButtonTitles:(NSArray *)radioButtonTitles {
    _radioButtonTitles = radioButtonTitles;
    NSLog(@"Setting radio button titles: %@", radioButtonTitles);
    [self.firstButton setTitle: radioButtonTitles[0] forState: UIControlStateNormal];
    [self.secondButton setTitle: radioButtonTitles[1] forState: UIControlStateNormal];
    [self.thirdButton setTitle: radioButtonTitles[2] forState: UIControlStateNormal];
    
    [self setupButton: self.firstButton];
    [self setupButton: self.secondButton];
    [self setupButton: self.thirdButton];
}

- (void) setupButton: (UIButton *) button {
    [button setImage:[UIImage imageNamed:@"unchecked"] forState: UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"checked"] forState: UIControlStateSelected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) setSelectedButtonIndex:(NSInteger)selectedButtonIndex {
    _selectedButtonIndex = selectedButtonIndex;
    
    if (selectedButtonIndex == 0) {
        [self selectButton: self.firstButton];
    } else if (selectedButtonIndex == 1) {
        [self selectButton: self.secondButton];
    } else if (selectedButtonIndex == 2) {
        [self selectButton: self.thirdButton];
    }
}

- (NSInteger) selectButton: (UIButton *)button {
    // button.selected = YES;
    if (button == self.firstButton) {
        self.firstButton.selected = YES;
        self.secondButton.selected = NO;
        self.thirdButton.selected = NO;
        return 0;
    } else if (button == self.secondButton) {
        self.firstButton.selected = NO;
        self.secondButton.selected = YES;
        self.thirdButton.selected = NO;
        return 1;
    } else if (button == self.thirdButton) {
        self.firstButton.selected = NO;
        self.secondButton.selected = NO;
        self.thirdButton.selected = YES;
        return 2;
    } else {
        NSLog(@"radio button is a rando instance");
        return -100;
    }
}

- (IBAction)onRadioButtonSelected:(id)sender {
    UIButton *button = sender;
    NSInteger index = [self selectButton: button];
    [self.delegate radioCell: self selectedRadioButtonIndex: index];
}
@end
