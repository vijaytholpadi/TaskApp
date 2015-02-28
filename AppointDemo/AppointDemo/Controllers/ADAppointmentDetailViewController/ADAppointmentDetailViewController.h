//
//  ADAppointmentDetailViewController.h
//  AppointDemo
//
//  Created by Vijay Tholpadi on 2/28/15.
//  Copyright (c) 2015 TheGeekProjekt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"

@protocol ADAppointmentDetailViewControllerDelegate;

@interface ADAppointmentDetailViewController : UIViewController<UITextFieldDelegate>
@property (nonatomic,assign) BOOL isAddingTask;
@property (nonatomic,strong) Task *currentTask;
@property (nonatomic,weak) id <ADAppointmentDetailViewControllerDelegate>delegate;

@property (weak, nonatomic) IBOutlet UITextField *tasknameTextField;
@property (weak, nonatomic) IBOutlet UITextField *dueDateTextField;
@property (weak, nonatomic) IBOutlet UITextField *categoryTextField;
@property (weak, nonatomic) IBOutlet UIButton *taskNotificationCheckbox;

- (IBAction)notifyTaskButtonPressed:(id)sender;

@end

@protocol ADAppointmentDetailViewControllerDelegate <NSObject>

-(void)addTaskDidSaveOnEdit:(BOOL)editingMode;
-(void)addTaskDidCancelTask:(Task*)taskToCancel;

@end
