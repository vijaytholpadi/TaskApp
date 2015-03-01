//
//  ADAppointmentTableViewCell.m
//  AppointDemo
//
//  Created by Vijay Tholpadi on 2/28/15.
//  Copyright (c) 2015 TheGeekProjekt. All rights reserved.
//

#import "ADAppointmentTableViewCell.h"

@implementation ADAppointmentTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.taskCompletedButton setBackgroundImage:[UIImage imageNamed:@"emptyRadioButton"] forState:UIControlStateNormal];
    [self.taskCompletedButton setBackgroundImage:[UIImage imageNamed:@"filledRadioButton"] forState:UIControlStateSelected];

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - self delegate Methods
- (IBAction)markTaskAsCompletedPressed:(id)sender {
    if (self.taskCompletedButton.selected) {
        [self.taskCompletedButton setSelected:NO];
    }else {
        [self.taskCompletedButton setSelected:YES];
    }
    [self.delegate didchangeTaskCompletionStatusAtCell:self toComplete:self.taskCompletedButton.selected];
    
}


@end
