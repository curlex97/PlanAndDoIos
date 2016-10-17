//
//  EditCategoryViewController.m
//  PlanAndDo
//
//  Created by Амин on 16.10.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "EditCategoryViewController.h"

@interface EditCategoryViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation EditCategoryViewController

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.categories.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditCategoryTableViewCell * cell=[[EditCategoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text=self.categories[indexPath.row].name;
    cell.textLabel.textColor=[UIColor whiteColor];
    cell.backgroundColor=[UIColor colorWithRed:32.0/255.0 green:45.0/255.0 blue:52.0/255.0 alpha:1.0];
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.categories removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
}

-(void)refreshDidSwipe
{
    [self.categories removeAllObjects];
    
    self.categories=[NSMutableArray arrayWithArray:[ApplicationManager categoryApplicationManager].allCategories];
    [super refreshDidSwipe];
}

-(void)addButtonDidTap
{

}

-(void)cancelButtonDidTap
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    
//    UIGraphicsBeginImageContextWithOptions(CGSizeMake(36, 36), NO, 0.0);
//    UIImage *blank = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    [self.navigationController.navigationBar setBackgroundImage:blank forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.backgroundColor=[UIColor colorWithRed:32.0/255.0 green:45.0/255.0 blue:52.0/255.0 alpha:1.0];
    UIBarButtonItem * addButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonDidTap)];
    self.navigationItem.leftBarButtonItem=addButton;
    
    UIBarButtonItem * cancelButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonDidTap)];
    self.navigationItem.rightBarButtonItem=cancelButton;
    
    [self.tableView setSeparatorColor:[UIColor colorWithRed:163.0/255.0 green:167.0/255.0 blue:169.0/255.0 alpha:0.35]];
    self.tableView.backgroundColor=[UIColor colorWithRed:32.0/255.0 green:45.0/255.0 blue:52.0/255.0 alpha:1.0];
    self.view.backgroundColor=[UIColor colorWithRed:32.0/255.0 green:45.0/255.0 blue:52.0/255.0 alpha:1.0];
    self.refresh.tintColor=[UIColor whiteColor];
    self.tableView.editing=YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
