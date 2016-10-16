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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
