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

@property (nonatomic,strong)NSMutableDictionary *categoriesDictionary;

@property (strong, nonatomic) NSArray *categoryArray;

@end

@implementation ADAppointmentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.taskNotificationCheckbox setBackgroundImage:[UIImage imageNamed:@"emptyRadioButton"] forState:UIControlStateNormal];
    [self.taskNotificationCheckbox setBackgroundImage:[UIImage imageNamed:@"filledRadioButton"] forState:UIControlStateSelected];
    
    [self setupNavigationBar];
    [self setupView];
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}


- (void)viewWillDisappear:(BOOL)animated {
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

- (void)setupNavigationBar {
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


- (void)setupView {
    self.tasknameTextField.text = [self.currentTask name];
    self.categoryTextField.text = [self.currentTask category];
    [self.categoryTextField setDelegate:self];
    
    NSDate *date = [NSDate date];
    self.UIDatePickerControl.date = date;
    if ([[self.currentTask notifyTask] boolValue]) {
        [self.taskNotificationCheckbox setSelected:YES];
    }
    
    if (!self.isAddingTask) {
        self.tasknameTextField.enabled = NO;
        self.categoryTextField.enabled = NO;
        [self.taskNotificationCheckbox setUserInteractionEnabled:NO];
        
        self.UIDatePickerControl.date = [self.currentTask dueDate];
        self.UIDatePickerControl.userInteractionEnabled = NO;
        self.UIDatePickerControl.alpha = 0.4f;
    }
}


#pragma BarButtonItem methods
- (void)cancelButtonPressed {
    [self.delegate addTaskDidCancelTask:self.currentTask editAttempted:NO];
}


- (void)saveButtonPressed {
    if (([self.tasknameTextField.text length] != 0) && ([self.categoryTextField.text length] != 0)) {
        [self.currentTask setName:self.tasknameTextField.text];
        [self.currentTask setCategory:self.categoryTextField.text];
        //    [self.currentTask setIsTaskCompleted:0];
        //    [self.currentTask setNotifyTask:0];
        //    [self.currentTask setCategoryColor:@""];
        
        NSDate *date = self.UIDatePickerControl.date;
        [self.currentTask setDueDate:date];
        
        [self.currentTask setCategory:self.categoryTextField.text];
        self.categoriesDictionary = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults]objectForKey:@"TaskCategories"]];
        
        [self.currentTask setCategoryColor:[self.categoriesDictionary objectForKey:self.categoryTextField.text]];
        
        [self.currentTask setNotifyTask:[NSNumber numberWithBool:self.taskNotificationCheckbox.selected]];
        if (self.taskNotificationCheckbox.selected) {
            if ([self.tasknameTextField.text length] != 0) {
                UILocalNotification *localNotification = [[UILocalNotification alloc]init];
                localNotification.fireDate = date;
                localNotification.alertBody = self.tasknameTextField.text;
                localNotification.soundName = UILocalNotificationDefaultSoundName;
                
                localNotification.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@%@%lu",date, [self.tasknameTextField.text substringToIndex:([self.tasknameTextField.text length] -1)], (unsigned long)[self.tasknameTextField.text length]], @"uniqueSig", nil];
                [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
                
                NSMutableArray *localNotificationBackupArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"localNotificationBackup"]];
                 NSData *data = [NSKeyedArchiver archivedDataWithRootObject:localNotification];
                [localNotificationBackupArray addObject:data];
                [[NSUserDefaults standardUserDefaults]setObject:localNotificationBackupArray forKey:@"localNotificationBackup"];
            }
        }
#warning Need to handle a situation where the user might click on back after clicking on save.
        if (self.isAddingTask) {
            [self.delegate addTaskDidSaveOnEdit:NO];
        } else {
            [self.delegate addTaskDidSaveOnEdit:YES];
        }
    } else {
        
        UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please fill in all the details before saving your task" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [errorAlert show];
    }
}


- (void)backButtonPressed {
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate addTaskDidCancelTask:self.currentTask editAttempted:YES];
}


- (void)editButtonPressed {
    self.tasknameTextField.enabled = YES;
    self.categoryTextField.enabled = YES;
    [self.taskNotificationCheckbox setUserInteractionEnabled:YES];
    self.UIDatePickerControl.userInteractionEnabled = YES;
    self.UIDatePickerControl.alpha = 1.0f;
    
    self.customNavigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonPressed)];
    
    NSString *uniqueID = [NSString stringWithFormat:@"%@%@%lu",self.UIDatePickerControl.date, [self.tasknameTextField.text substringToIndex:([self.tasknameTextField.text length] -1)], (unsigned long)[self.tasknameTextField.text length]];
    
    NSMutableArray *Arr=[[NSMutableArray alloc] initWithArray:[[UIApplication sharedApplication]scheduledLocalNotifications]];
    for (int k=0;k<[Arr count];k++) {
        UILocalNotification *not=[Arr objectAtIndex:k];
        NSString *uniqueString=[not.userInfo valueForKey:@"uniqueSig"];
        if([uniqueString isEqualToString:uniqueID]) {
            [[UIApplication sharedApplication] cancelLocalNotification:not];
            [[[NSUserDefaults standardUserDefaults] objectForKey:@"localNotificationBackup"] removeObject:not];
            [self.currentTask setNotifyTask:[NSNumber numberWithBool:NO]];
            [self.taskNotificationCheckbox setSelected:NO];
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


- (IBAction)categoryTextFieldEditingDidBegin:(id)sender {
    UIActionSheet *categoryActionSheet = [[UIActionSheet alloc]initWithTitle:@"Choose a category" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles: nil];
    
    self.categoryArray = [NSArray arrayWithArray:[[[NSUserDefaults standardUserDefaults]objectForKey:@"TaskCategories"] allKeys]];
    
    
    for (NSString *key in self.categoryArray) {
        [categoryActionSheet addButtonWithTitle:key];
    }
    
    [categoryActionSheet showInView:self.view];
    [self.categoryTextField resignFirstResponder];
    
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.categoryTextField resignFirstResponder];
}


#pragma mark UIActionSheetDelegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.categoryTextField setText:[self.categoryArray objectAtIndex:buttonIndex]];
    
    //Not working when called on category textField for some reason
    [self.tasknameTextField becomeFirstResponder];
    [self.tasknameTextField resignFirstResponder];
}


@end
