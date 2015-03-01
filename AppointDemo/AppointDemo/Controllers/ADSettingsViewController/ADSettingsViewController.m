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

@property (nonatomic,strong)NSMutableDictionary *categoriesDictionary;


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
    [self.addCategoriesTextField setDelegate:self];
    
    self.categoriesTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    self.categoriesDictionary = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults]objectForKey:@"TaskCategories"]];
    
    self.sortDescriptorsButton.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)initiaizeViewValues {
    if ([[[NSUserDefaults standardUserDefaults]stringForKey:@"SelectedSortDescriptor"] isEqualToString:@"name"]) {
        [self.sortDescriptorsButton.titleLabel setText:@"Name"];
    }else if([[[NSUserDefaults standardUserDefaults]stringForKey:@"SelectedSortDescriptor"] isEqualToString:@"dueDate"]) {
        [self.sortDescriptorsButton.titleLabel setText:@"Due Date"];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [self initiaizeViewValues];
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
    return [self.categoriesDictionary count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    
    NSArray *keysArray = [self.categoriesDictionary allKeys];
    
    
    cell.textLabel.text = [keysArray objectAtIndex:indexPath.row];
    
    SEL labelColor = NSSelectorFromString([self.categoriesDictionary objectForKey:[keysArray objectAtIndex:indexPath.row]]);
    [cell setBackgroundColor:[UIColor performSelector:labelColor]];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
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

#pragma mark UITextField delegate methods
- (IBAction)categoryTextFieldEditingDidEnd:(id)sender {
    if (self.addCategoriesTextField.text.length != 0) {
        [self.addCategoriesTextField resignFirstResponder];
        
        UIActionSheet *colorActionSheet = [[UIActionSheet alloc]initWithTitle:@"Choose a color" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"RedColor", @"GreenColor", @"Bluecolor", nil];
        colorActionSheet.tag = 1;
        [colorActionSheet showInView:self.view];
    }
}

- (IBAction)disableNotificationsButtonPressed:(id)sender {
    
    if (self.disableAllNotificationsButton.selected) {
        [self.disableAllNotificationsButton setSelected:NO];
    }else {
        [self.disableAllNotificationsButton setSelected:YES];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.addCategoriesTextField resignFirstResponder];
    return YES;
}

- (IBAction)sortDescriptorButtonPressed:(id)sender {
    UIActionSheet *sortDescriptorActionSheet = [[UIActionSheet alloc]initWithTitle:@"Sort by" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Due Date", @"Name", nil];
    sortDescriptorActionSheet.tag = 0;
    [sortDescriptorActionSheet showInView:self.view];
}


#pragma mark UIActionSheetDelegate methods
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 0) {
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
    }else if(actionSheet.tag == 1){
        
        NSString *colorString;
        if (buttonIndex == 0) {
            colorString = @"redColor";
        }else if(buttonIndex == 1){
            colorString = @"greenColor";
        }else if(buttonIndex == 2){
            colorString = @"blueColor";
        }
        
        [self.categoriesDictionary setObject:colorString forKey:self.addCategoriesTextField.text];
        [[NSUserDefaults standardUserDefaults] setObject:self.categoriesDictionary forKey:@"TaskCategories"];
    }
    [self initiaizeViewValues];
    [self.categoriesTableView reloadData];
}

-(UIColor*)colorBasedOnValue:(NSString*)valueString{
    return [UIColor greenColor];
}
@end
