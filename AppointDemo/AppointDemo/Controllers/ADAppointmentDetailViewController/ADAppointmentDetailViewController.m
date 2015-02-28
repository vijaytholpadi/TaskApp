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

#pragma BarButtonItem methods
-(void)cancelButtonPressed {
}

-(void)saveButtonPressed {
    
}

-(void)backButtonPressed {
    
}

-(void)editButtonPressed {
    
}
@end
