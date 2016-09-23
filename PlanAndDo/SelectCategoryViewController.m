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
@property NSArray* categories;
@end

@implementation SelectCategoryViewController

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
    
    KSCategory* category = self.categories[indexPath.row];
    
    cell.textLabel.text=[category name];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.parentController.category = self.categories[indexPath.row];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.categories = [NSArray arrayWithArray:[[ApplicationManager categoryApplicationManager] allCategories]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
