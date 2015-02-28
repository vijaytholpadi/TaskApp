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

@end

@implementation ADAppointmentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupNavigationBar];
    [self setupView];
    
    self.tasknameTextField.text = [self.currentTask name];
    self.categoryTextField.text = [self.currentTask category];
    self.dueDateTextField.text = [NSString stringWithFormat:@"%@", [self.currentTask dueDate]];
    
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
    if (!self.isAddingTask) {
        self.tasknameTextField.enabled = NO;
        self.dueDateTextField.enabled = NO;
        self.categoryTextField.enabled = NO;
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
    
    NSString *dateString = self.dueDateTextField.text;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:dateString];
    [self.currentTask setDueDate:dateFromString];
    
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
    self.dueDateTextField.enabled = YES;
    self.categoryTextField.enabled = YES;
    
    self.customNavigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonPressed)];
}
@end
