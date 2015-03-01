//
//  ADAppointmentDetailViewController.m
//  AppointDemo
//
//  Created by Vijay Tholpadi on 2/28/15.
//  Copyright (c) 2015 TheGeekProjekt. All rights reserved.
//

#import "ADAppointmentDetailViewController.h"

@interface ADAppointmentDetailViewController ()
@property (weak, nonatomic) IBOutlet UINavigationBar *customNavigationBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *customNavigationItem;
@property (weak, nonatomic) IBOutlet UIDatePicker *UIDatePickerControl;

@end

@implementation ADAppointmentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.taskNotificationCheckbox setImage:[UIImage imageNamed:@"emptyRadioButton"] forState:UIControlStateNormal];
    [self.taskNotificationCheckbox setImage:[UIImage imageNamed:@"filledRadioButton"] forState:UIControlStateSelected];
    
    [self setupNavigationBar];
    [self setupView];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
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

-(void)setupNavigationBar{
    
    UIBarButtonItem *leftSideButton;
    UIBarButtonItem *rightSideButton;
    
    if (self.isAddingTask) {
        self.customNavigationItem.title = @"Add Task";
        leftSideButton = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonPressed)];
        
        rightSideButton = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonPressed)];
    }else {
        self.customNavigationItem.title = @"Task";
        leftSideButton = [[UIBarButtonItem alloc]initWithTitle:@"< Back" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed)];
        
        rightSideButton = [[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editButtonPressed)];
    }
    
    self.customNavigationItem.leftBarButtonItems = [NSArray arrayWithObjects:leftSideButton, nil];
    self.customNavigationItem.rightBarButtonItems = [NSArray arrayWithObjects:rightSideButton, nil];
}

-(void)setupView{
    
    self.tasknameTextField.text = [self.currentTask name];
    self.categoryTextField.text = [self.currentTask category];
    NSDate *date = [NSDate date];
    self.UIDatePickerControl.date = date;
    if ([[self.currentTask notifyTask] boolValue]) {
        [self.taskNotificationCheckbox setSelected:YES];
    }

    if (!self.isAddingTask) {
        self.tasknameTextField.enabled = NO;
        self.categoryTextField.enabled = NO;
        
        self.UIDatePickerControl.date = [self.currentTask dueDate];
        self.UIDatePickerControl.userInteractionEnabled = NO;
        self.UIDatePickerControl.alpha = 0.4f;
    }
}
#pragma BarButtonItem methods
-(void)cancelButtonPressed {
    [self.delegate addTaskDidCancelTask:self.currentTask];
}

-(void)saveButtonPressed {
    [self.currentTask setName:self.tasknameTextField.text];
    [self.currentTask setCategory:self.categoryTextField.text];
    //    [self.currentTask setIsTaskCompleted:0];
    //    [self.currentTask setNotifyTask:0];
    //    [self.currentTask setCategoryColor:@""];
    
    NSDate *date = self.UIDatePickerControl.date;
    [self.currentTask setDueDate:date];
    
    [self.currentTask setNotifyTask:[NSNumber numberWithBool:self.taskNotificationCheckbox.selected]];
    if ([[self.currentTask notifyTask]boolValue]) {
        if ([self.tasknameTextField.text length] != 0) {
            UILocalNotification *localNotification = [[UILocalNotification alloc]init];
            localNotification.fireDate = date;
            localNotification.alertBody = self.tasknameTextField.text;
            localNotification.soundName = UILocalNotificationDefaultSoundName;
            
            localNotification.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@%@%lu",date, [self.tasknameTextField.text substringToIndex:([self.tasknameTextField.text length] -1)], (unsigned long)[self.tasknameTextField.text length]], @"uniqueSig", nil];
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        }
    }
#warning Need to handle a situation where the user might click on back after clicking on save.
    
    if (self.isAddingTask) {
        [self.delegate addTaskDidSaveOnEdit:NO];
    }else{
        [self.delegate addTaskDidSaveOnEdit:YES];
    }
}

-(void)backButtonPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)editButtonPressed {
    self.tasknameTextField.enabled = YES;
    self.categoryTextField.enabled = YES;
    self.UIDatePickerControl.userInteractionEnabled = YES;
    self.UIDatePickerControl.alpha = 1.0f;
    
    self.customNavigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonPressed)];
    
    NSString *uniqueID = [NSString stringWithFormat:@"%@%@%lu",self.UIDatePickerControl.date, [self.tasknameTextField.text substringToIndex:([self.tasknameTextField.text length] -1)], (unsigned long)[self.tasknameTextField.text length]];
  
    NSMutableArray *Arr=[[NSMutableArray alloc] initWithArray:[[UIApplication sharedApplication]scheduledLocalNotifications]];
    for (int k=0;k<[Arr count];k++) {
        UILocalNotification *not=[Arr objectAtIndex:k];
        NSString *DateString=[not.userInfo valueForKey:@"uniqueSig"];
        if([DateString isEqualToString:uniqueID])
        {
            [[UIApplication sharedApplication] cancelLocalNotification:not];
        }
    }
}

- (IBAction)notifyTaskButtonPressed:(id)sender {
    if (self.taskNotificationCheckbox.selected) {
        [self.taskNotificationCheckbox setSelected:NO];
    }else {
        [self.taskNotificationCheckbox setSelected:YES];
    }
}
@end
