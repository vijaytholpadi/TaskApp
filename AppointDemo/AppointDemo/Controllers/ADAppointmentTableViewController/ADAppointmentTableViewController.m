//
//  ADAppointmentTableViewController.m
//  AppointDemo
//
//  Created by Vijay Tholpadi on 2/28/15.
//  Copyright (c) 2015 TheGeekProjekt. All rights reserved.
//

#import "ADAppointmentTableViewController.h"
#import "ADSettingsViewController.h"
#import "ADAppointmentDetailViewController.h"

static NSString *ADAppointmentTableViewCellIdentifier = @"ADAppointmentTableViewCell";

@interface ADAppointmentTableViewController ()

@end

@implementation ADAppointmentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *addAppointmentButton = [[UIBarButtonItem alloc]initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(addAppointmentButtonPressed)];
    
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc]initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(settingsButtonPressed)];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects: addAppointmentButton, settingsButton, nil];
    
    UINib *ADAppointmentTableViewCellNib = [UINib nibWithNibName:@"ADAppointmentTableViewCell" bundle:nil];
    [self.tableView registerNib:ADAppointmentTableViewCellNib forCellReuseIdentifier:ADAppointmentTableViewCellIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 10;
}


 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ADAppointmentTableViewCellIdentifier forIndexPath:indexPath];
 
 // Configure the cell...
     cell.separatorInset = UIEdgeInsetsMake(0.0f, 15.0f, 0.0f, 15.0f);
 return cell;
 }
 
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.0f;
}

 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }


 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


#pragma navigation bar button item methods
-(void)addAppointmentButtonPressed {
    ADAppointmentDetailViewController *AddAppointmentVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ADAppointmentDetailViewController"];
    AddAppointmentVC.isAddingTask = YES;
    [self presentViewController:AddAppointmentVC animated:YES completion:nil];
}

-(void)settingsButtonPressed {
    ADSettingsViewController *settingsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ADSettingsViewController"];
    [self.navigationController pushViewController:settingsVC animated:YES];
}
@end
