//
//  ADAppointmentTableViewCell.h
//  AppointDemo
//
//  Created by Vijay Tholpadi on 2/28/15.
//  Copyright (c) 2015 TheGeekProjekt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADAppointmentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *appointmentNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dueOnTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *dueDateTextLabel;
@property (weak, nonatomic) IBOutlet UIView *categoryColorBadgeView;
@property (weak, nonatomic) IBOutlet UIButton *taskCompletedButton;
- (IBAction)markAsCompletedPressed:(id)sender;

@end
