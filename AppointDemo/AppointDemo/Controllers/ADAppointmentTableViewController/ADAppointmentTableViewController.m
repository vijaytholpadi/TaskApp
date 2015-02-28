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
#import "ADAppointmentTableViewCell.h"

#import "Task.h"

static NSString *ADAppointmentTableViewCellIdentifier = @"ADAppointmentTableViewCell";

@interface ADAppointmentTableViewController ()

@end

@implementation ADAppointmentTableViewController
@synthesize fetchedResultsController = _fetchedResultsController;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //    self.tableView.delegate = self;
    //    self.tableView.dataSource = self;
    
    UIBarButtonItem *addAppointmentButton = [[UIBarButtonItem alloc]initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(addAppointmentButtonPressed)];
    
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc]initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(settingsButtonPressed)];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects: addAppointmentButton, settingsButton, nil];
    //Remove the invisiable cells
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    UINib *ADAppointmentTableViewCellNib = [UINib nibWithNibName:@"ADAppointmentTableViewCell" bundle:nil];
    [self.tableView registerNib:ADAppointmentTableViewCellNib forCellReuseIdentifier:ADAppointmentTableViewCellIdentifier];
    
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"%@",error);
        abort();
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [[self.fetchedResultsController sections]count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    id <NSFetchedResultsSectionInfo> secInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [secInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADAppointmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ADAppointmentTableViewCellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Task *task = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.appointmentNameLabel.text = task.name;
    cell.dueDateTextLabel.text = [NSString stringWithFormat:@"%@",task.dueDate];
    cell.separatorInset = UIEdgeInsetsMake(0.0f, 15.0f, 0.0f, 15.0f);
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    //    if ([[[self.fetchedResultsController sections] objectAtIndex:section] isTaskCompleted]) {
    return @"Completed tasks";
    //    }else{
    return @"Pending tasks";
    //    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.0f;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Task *currentTask = (Task*)[self.fetchedResultsController objectAtIndexPath:indexPath];
    
    ADAppointmentDetailViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ADAppointmentDetailViewController"];
    detailVC.isAddingTask = NO;
    detailVC.delegate = self;
    detailVC.currentTask = currentTask;
    
    [self.navigationController pushViewController:detailVC animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        Task *taskToDelete = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self.managedObjectContext deleteObject:taskToDelete];
        
        NSError *error;
        if ([[self managedObjectContext] save:&error]) {
            NSLog(@"%@",error);
        }
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

#pragma mark Fetched Results Controller section
-(NSFetchedResultsController *)fetchedResultsController{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    //    // Specify criteria for filtering which objects to fetch
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"<#format string#>", <#arguments#>];
    //    [fetchRequest setPredicate:predicate];
    
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"isTaskCompleted" cacheName:nil];
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}

-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller{
    [self.tableView beginUpdates];
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    [self.tableView endUpdates];
}

-(void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type{
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
    
}

-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath{
    
    switch (type) {
        case NSFetchedResultsChangeInsert:{
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeDelete:{
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeUpdate: {
            Task *changedTask = [self.fetchedResultsController objectAtIndexPath:indexPath];
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            cell.textLabel.text = changedTask.name;
            break;
        }
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

#pragma mark navigation bar button item methods
-(void)addAppointmentButtonPressed {
    ADAppointmentDetailViewController *AddAppointmentVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ADAppointmentDetailViewController"];
    AddAppointmentVC.isAddingTask = YES;
    AddAppointmentVC.delegate = self;
    Task *newTask = (Task*)[NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:self.managedObjectContext];
    AddAppointmentVC.currentTask = newTask;
    [self presentViewController:AddAppointmentVC animated:YES completion:nil];
}

-(void)settingsButtonPressed {
    ADSettingsViewController *settingsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ADSettingsViewController"];
    [self.navigationController pushViewController:settingsVC animated:YES];
}

#pragma mark ADAppointmentDetailViewControllerDelegate methods
-(void)addTaskDidSaveOnEdit:(BOOL)editingMode{
    NSError *error;
    if ([[self managedObjectContext]save:&error]) {
        NSLog(@"%@",error);
    }
    if (editingMode) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)addTaskDidCancelTask:(Task *)taskToCancel{
    [self.managedObjectContext deleteObject:taskToCancel];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
