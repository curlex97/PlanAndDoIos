//
//  KSMenuViewController.m
//  PlanAndDo
//
//  Created by Амин on 17.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "KSMenuViewController.h"

@interface KSMenuViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic)NSArray<NSString *> * categories;
@end

@implementation KSMenuViewController

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0)
    {
        return 1;
    }
    else if(section==1)
    {
        return self.categories.count;
    }
    else
    {
        return 2;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section==1)
    {
        return @"Categories";
    }
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section==1)
    {
        UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
        view.backgroundColor=[UIColor colorWithRed:61.0/255.0 green:62.0/255.0 blue:61.0/255.0 alpha:1.0];
        
        UILabel * titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(25, 0, 100, 30)];
        titleLabel.textColor=[UIColor colorWithRed:163.0/255.0 green:167.0/255.0 blue:169.0/255.0 alpha:0.35];
        titleLabel.text=@"Category";
        titleLabel.font=[UIFont systemFontOfSize:12];
        
        UIButton * addCategoryButton=[[UIButton alloc] initWithFrame:CGRectMake(233, 0, 30, 30)];
        [addCategoryButton setImage:[UIImage imageNamed:@"Add"] forState:UIControlStateNormal];
        
        [view addSubview:addCategoryButton];
        [view addSubview:titleLabel];
        
        return view;
    }
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.backgroundColor=[UIColor colorWithRed:61.0/255.0 green:62.0/255.0 blue:61.0/255.0 alpha:1.0];
    cell.textLabel.textColor=[UIColor whiteColor];
    if(indexPath.row==0 && indexPath.section==0)
    {
        UISearchBar * searchBar=[[UISearchBar alloc] initWithFrame:CGRectMake(8, 8, 255, 30)];
        searchBar.searchBarStyle=UISearchBarStyleMinimal;
        [cell addSubview:searchBar];
    }
    else if(indexPath.row<=self.categories.count && indexPath.section==1)
    {
        UILabel * label=[[UILabel alloc] initWithFrame:CGRectMake(40, 8, 100, 30)];
        label.textColor=[UIColor whiteColor];
        label.text=self.categories[indexPath.row];
        [cell addSubview:label];
    }
    else if(indexPath.section==2)
    {
        if(indexPath.row==0)
        {
            cell.textLabel.text=@"Propfile";
        }
        else
        {
            cell.textLabel.text=@"Settings";
        }
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==1 && indexPath.row==self.categories.count-1)
    {
        return 90;
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
    [self.tableView setSeparatorColor:[UIColor colorWithRed:163.0/255.0 green:167.0/255.0 blue:169.0/255.0 alpha:0.35]];
    self.categories=[NSArray arrayWithObjects:@"Personal",@"Shopping",@"Working", nil];
    self.view.backgroundColor=[UIColor colorWithRed:61.0/255.0 green:62.0/255.0 blue:61.0/255.0 alpha:1.0];
    self.tableView.backgroundColor=[UIColor colorWithRed:61.0/255.0 green:62.0/255.0 blue:61.0/255.0 alpha:1.0];
    [self.view removeConstraint:self.top];
    [self.view addConstraint:[NSLayoutConstraint
                                   constraintWithItem:self.tableView
                                   attribute:NSLayoutAttributeTop
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.view
                                   attribute:NSLayoutAttributeTop
                                   multiplier:1.0f
                                   constant:20.f]];
    
    [[UITextField appearanceWhenContainedInInstancesOfClasses:[NSArray arrayWithObject:[UISearchBar class]]] setTextColor:[UIColor whiteColor]];
    //self.view.backgroundColor=[UIColor colorWithRed:(CGFloat) green:(CGFloat) blue:<#(CGFloat)#> alpha:<#(CGFloat)#>]
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
