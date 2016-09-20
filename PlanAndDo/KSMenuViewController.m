//
//  KSMenuViewController.m
//  PlanAndDo
//
//  Created by Амин on 17.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "KSMenuViewController.h"
#import "AMSideBarViewController.h"
#import "TaskTableViewCell.h"
#import "AddTaskViewController.h"
#import "SettingsViewController.h"
#import "CategoryTasksViewController.h"
#import "EditTaskViewController.h"

@interface KSMenuViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (nonatomic)NSArray<NSString *> * categories;
@property (nonatomic)UISearchBar * searchBar;
@end

@implementation KSMenuViewController

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger result;
    if(self.state==KSMenuStateNormal)
    {
        if(section==0)
        {
            result = 0;
        }
        else if(section==1)
        {
            result = self.categories.count;
        }
        else
        {
            result = 2;
        }
    }
    else
    {
        result = 3;
    }
    return result;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger result;
    if(self.state==KSMenuStateNormal)
    {
        result=3;
    }
    else
    {
        result=1;
    }
    return result;
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section==1 && self.state==KSMenuStateNormal)
    {
        return @"Categories";
    }
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section==1 && self.state==KSMenuStateNormal)
    {
        UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
        view.backgroundColor=[UIColor colorWithRed:32.0/255.0 green:45.0/255.0 blue:52.0/255.0 alpha:1.0];
        
        UIImageView * imageView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 10, 10)];
        imageView.image=[UIImage imageNamed:@"Category"];
        
        UILabel * titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(25, 0, 100, 30)];
        titleLabel.textColor=[UIColor colorWithRed:163.0/255.0 green:167.0/255.0 blue:169.0/255.0 alpha:0.35];
        titleLabel.text=@"CATEGORY";
        titleLabel.font=[UIFont systemFontOfSize:12];
        
        UIButton * addCategoryButton=[[UIButton alloc] initWithFrame:CGRectMake(233, 0, 30, 30)];
        [addCategoryButton setImage:[UIImage imageNamed:@"Add category"] forState:UIControlStateNormal];
        
        [view addSubview:addCategoryButton];
        [view addSubview:titleLabel];
        [view addSubview:imageView];
        return view;
    }
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.backgroundColor=[UIColor colorWithRed:32.0/255.0 green:45.0/255.0 blue:52.0/255.0 alpha:1.0];
    cell.textLabel.textColor=[UIColor whiteColor];
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:57.0/255.0 green:75.0/255.0 blue:86.0/255.0 alpha:1.0];
    [cell setSelectedBackgroundView:bgColorView];
    
    
//    if(indexPath.row==0 && indexPath.section==0)
//    {
//        [cell addSubview:self.searchBar];
//    }
    
    if(self.state==KSMenuStateSearch)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"KSTaskCell"owner:self options:nil];
        TaskTableViewCell * customCell=nib[0];
        customCell.backgroundColor=[UIColor colorWithRed:32.0/255.0 green:45.0/255.0 blue:52.0/255.0 alpha:1.0];
        customCell.taskTimeLabel.backgroundColor=[UIColor colorWithRed:32.0/255.0 green:45.0/255.0 blue:52.0/255.0 alpha:1.0];
        
        customCell.taskTimeLabel.textColor=[UIColor whiteColor];
        customCell.taskDateLabel.textColor=[UIColor whiteColor];
        customCell.taskHeaderLabel.textColor=[UIColor whiteColor];
        customCell.taskPriorityLabel.textColor=[UIColor redColor];
        customCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        
        [customCell setSelectedBackgroundView:bgColorView];
        return customCell;
    }
    else
    {
        
    if(indexPath.row<=self.categories.count && indexPath.section==1)
    {
        UILabel * label=[[UILabel alloc] initWithFrame:CGRectMake(55, 8, 100, 30)];
        label.textColor=[UIColor whiteColor];
        label.text=self.categories[indexPath.row];
        [cell addSubview:label];
        if(indexPath.row==self.categories.count-1)
        {
            cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width, 0.f, 0.f);
        }
    }
    else if(indexPath.section==2)
    {
        if(indexPath.row==0)
        {
            UIImageView * profileImageView=[[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 30, 30)];
            profileImageView.image=[UIImage imageNamed:@"Profile"];
            //[cell addSubview:profileImageView];
            cell.textLabel.text=@"Propfile";
            cell.imageView.image=[UIImage imageNamed:@"Profile"];
        }
        else
        {
            UIImageView * profileImageView=[[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 30, 30)];
            profileImageView.image=[UIImage imageNamed:@"Settings"];
            //[cell addSubview:profileImageView];
            cell.textLabel.text=@"Settings";
            cell.imageView.image=[UIImage imageNamed:@"Settings"];
            //tableView.separatorColor=[UIColor colorWithRed:38.0/255.0 green:53.0/255.0 blue:61.0/255.0 alpha:1.0];
        }
        
        cell.backgroundColor=[UIColor colorWithRed:38.0/255.0 green:53.0/255.0 blue:61.0/255.0 alpha:1.0];
    }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.searchBar resignFirstResponder];
    if(self.state==KSMenuStateSearch)
    {
        AMSideBarViewController * sider=(AMSideBarViewController *)self.parentViewController;

        UINavigationController * frontNavigationViewController=(UINavigationController *)sider.frontViewController;
        
        for(UIViewController* child in [frontNavigationViewController childViewControllers])
            [child.navigationController popViewControllerAnimated:YES];
        
        [frontNavigationViewController pushViewController:[[EditTaskViewController alloc] init] animated:YES];
        
        sider.hiden=NO;
        [sider side];
        
    }
    
    else if(indexPath.section == 1)
    {
        
        NSString* str = self.categories[indexPath.row];
        CategoryTasksViewController * categoryTasksViewController=[[CategoryTasksViewController alloc] init];
        
        if(categoryTasksViewController)
        {
            categoryTasksViewController.title=str;
            UINavigationController* categoryTasksNav = [[UINavigationController alloc] initWithRootViewController:categoryTasksViewController];
            AMSideBarViewController* sideBar = (AMSideBarViewController*)self.parentViewController;
            [sideBar setNewFrontViewController:categoryTasksNav];
        }
    }
    
    else if(indexPath.section == 2 && indexPath.row == 1)
    {
        SettingsViewController * settingsViewController=[[SettingsViewController alloc] init];
        
        if(settingsViewController)
        {
            settingsViewController.title=@"Settings";
            UINavigationController* settingsNav = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
            AMSideBarViewController* sideBar = (AMSideBarViewController*)self.parentViewController;
            [sideBar setNewFrontViewController:settingsNav];
        }
    }
}

#pragma mark Search Bar delegate methods
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    searchBar.showsCancelButton=NO;
    searchBar.clearsContextBeforeDrawing=YES;
    AMSideBarViewController * sider=(AMSideBarViewController *)self.parentViewController;
    sider.hiden=NO;
    searchBar.frame=CGRectMake(8, 8, 255, 30);
    
    self.state=KSMenuStateNormal;
    [self.tableView reloadData];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar;
{
    AMSideBarViewController * sider=(AMSideBarViewController *)self.parentViewController;
    sider.hiden=YES;
    searchBar.frame=CGRectMake(searchBar.frame.origin.x, searchBar.frame.origin.y, [UIScreen mainScreen].bounds.size.width-searchBar.frame.origin.x*2, searchBar.frame.size.height);
    searchBar.showsCancelButton=YES;
    
    self.state=KSMenuStateSearch;
    [self.tableView reloadData];
    
    return YES;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.state==KSMenuStateSearch)
    {
        return 55;
    }
    else
    {
        return 45;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.state=KSMenuStateNormal;
    //self.tableView.separatorColor = [UIColor clearColor];
    
    self.searchBar=[[UISearchBar alloc] initWithFrame:CGRectMake(8, 8, 255, 30)];
    self.searchBar.searchBarStyle=UISearchBarStyleMinimal;
    self.searchBar.tintColor=[UIColor whiteColor];
    self.searchBar.barTintColor=[UIColor whiteColor];
    self.searchBar.delegate=self;
    
    UIView * searchBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 46)];
    [searchBarView addSubview:self.searchBar];
    
    self.tableView.tableHeaderView=searchBarView;
    [[UITextField appearanceWhenContainedInInstancesOfClasses:[NSArray arrayWithObject:[UISearchBar class]]] setTextColor:[UIColor whiteColor]];
    [self.refresh removeFromSuperview];
    [self.tableView setSeparatorColor:[UIColor colorWithRed:163.0/255.0 green:167.0/255.0 blue:169.0/255.0 alpha:0.35]];
    self.categories=[NSArray arrayWithObjects:@"Personal",@"Shopping",@"Working", nil];
    self.view.backgroundColor=[UIColor colorWithRed:32.0/255.0 green:45.0/255.0 blue:52.0/255.0 alpha:1.0];
    self.tableView.backgroundColor=[UIColor colorWithRed:32.0/255.0 green:45.0/255.0 blue:52.0/255.0 alpha:1.0];
    [self.view removeConstraint:self.top];
    [self.view addConstraint:[NSLayoutConstraint
                                   constraintWithItem:self.tableView
                                   attribute:NSLayoutAttributeTop
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.view
                                   attribute:NSLayoutAttributeTop
                                   multiplier:1.0f
                                   constant:20.f]];
    
    //self.view.backgroundColor=[UIColor colorWithRed:(CGFloat) green:(CGFloat) blue:<#(CGFloat)#> alpha:<#(CGFloat)#>]
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
