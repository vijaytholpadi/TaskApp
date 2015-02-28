//
//  ADSettingsViewController.m
//  AppointDemo
//
//  Created by Vijay Tholpadi on 2/28/15.
//  Copyright (c) 2015 TheGeekProjekt. All rights reserved.
//

#import "ADSettingsViewController.h"

@interface ADSettingsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *sortTasksOptionTextField;
@property (weak, nonatomic) IBOutlet UIButton *disableAllNotificationsButton;
@property (weak, nonatomic) IBOutlet UITextField *addCategoriesTextField;
- (IBAction)disableNotificationsButtonPressed:(id)sender;


@end

@implementation ADSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Settings";
    [self.disableAllNotificationsButton setImage:[UIImage imageNamed:@"emptyRadioButton"] forState:UIControlStateNormal];
    [self.disableAllNotificationsButton setImage:[UIImage imageNamed:@"filledRadioButton"] forState:UIControlStateSelected];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)disableNotificationsButtonPressed:(id)sender {
    
    if (self.disableAllNotificationsButton.selected) {
        [self.disableAllNotificationsButton setSelected:NO];
    }else {
        [self.disableAllNotificationsButton setSelected:YES];
    }
}
@end
