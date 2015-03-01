//
//  ADSettingsViewController.m
//  AppointDemo
//
//  Created by Vijay Tholpadi on 2/28/15.
//  Copyright (c) 2015 TheGeekProjekt. All rights reserved.
//

#import "ADSettingsViewController.h"

@interface ADSettingsViewController ()
@property (weak, nonatomic) IBOutlet UIButton *sortDescriptorsButton;
@property (weak, nonatomic) IBOutlet UIButton *disableAllNotificationsButton;
@property (weak, nonatomic) IBOutlet UITextField *addCategoriesTextField;
- (IBAction)disableNotificationsButtonPressed:(id)sender;
- (IBAction)sortDescriptorButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *categoriesTableView;

@property (nonatomic,strong)NSMutableArray *categoriesArray;


@end

@implementation ADSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Settings";
    [self.disableAllNotificationsButton setImage:[UIImage imageNamed:@"emptyRadioButton"] forState:UIControlStateNormal];
    [self.disableAllNotificationsButton setImage:[UIImage imageNamed:@"filledRadioButton"] forState:UIControlStateSelected];
    [self.categoriesTableView setDelegate:self];
    [self.categoriesTableView setDataSource:self];
    self.categoriesTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    self.categoriesArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"TaskCategories"]];

    self.sortDescriptorsButton.titleLabel.textAlignment = NSTextAlignmentCenter;
}

-(void)viewDidAppear:(BOOL)animated{
    if ([[[NSUserDefaults standardUserDefaults]stringForKey:@"SelectedSortDescriptor"] isEqualToString:@"name"]) {
        [self.sortDescriptorsButton.titleLabel setText:@"Name"];
    }else if([[[NSUserDefaults standardUserDefaults]stringForKey:@"SelectedSortDescriptor"] isEqualToString:@"dueDate"]) {
        [self.sortDescriptorsButton.titleLabel setText:@"Due Date"];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableView Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.categoriesArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    
//    cell.textLabel.text = [[self.categoriesArray objectAtIndex:indexPath.row] key];
//    cell.imageView.backgroundColor = [self colorBasedOnValue:[[self.categoriesArray objectAtIndex:indexPath.row] valueForKey:cell.textLabel.text]];
    
    return cell;
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

- (IBAction)sortDescriptorButtonPressed:(id)sender {
    UIActionSheet *sortDescriptorActionSheet = [[UIActionSheet alloc]initWithTitle:@"Sort by" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Due Date", @"Name", nil];
    [sortDescriptorActionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *sortDescriptor;
    if (buttonIndex == 0) {
        sortDescriptor = @"dueDate";
        [self.sortDescriptorsButton.titleLabel setText:@"Due Date"];
    }else if (buttonIndex == 1){
        sortDescriptor = @"name";
        [self.sortDescriptorsButton.titleLabel setText:@"Name"];
    }
    [[NSUserDefaults standardUserDefaults]
     setObject:sortDescriptor forKey:@"SelectedSortDescriptor"];
}

-(UIColor*)colorBasedOnValue:(NSString*)valueString{
    return [UIColor greenColor];
}
@end
