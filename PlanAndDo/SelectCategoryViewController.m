//
//  SelectCategoryViewController.m
//  PlanAndDo
//
//  Created by Амин on 15.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "SelectCategoryViewController.h"
#import "ApplicationManager.h"

@interface SelectCategoryViewController ()<UITableViewDelegate, UITableViewDataSource>
@property NSArray<KSCategory *> * categories;
@end

@implementation SelectCategoryViewController

-(void)reloadData
{
    self.categories=[NSMutableArray arrayWithArray:[[ApplicationManager categoryApplicationManager] allCategories]];
    [super reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.categories.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier=@"reuseble cell";
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.tintColor=[UIColor colorWithRed:40.0/255.0 green:69.0/255.0 blue:83.0/255.0 alpha:1.0];
    if([self.categories[indexPath.row].name isEqualToString:self.selectedCategory.name])
    {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    KSCategory* category = self.categories[indexPath.row];
    
    cell.textLabel.text=[category name];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedCategory=self.categories[indexPath.row];
    [self.tableView reloadData];
    
    if([self.parentController isKindOfClass:[AddTaskViewController class]])
    ((AddTaskViewController*)self.parentController).category = self.categories[indexPath.row];
    
    if([self.parentController isKindOfClass:[EditTaskViewController class]])
        ((EditTaskViewController*)self.parentController).category = self.categories[indexPath.row];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.title = NM_CATEGORY;
    self.categories = [NSArray arrayWithArray:[[ApplicationManager categoryApplicationManager] allCategories]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
