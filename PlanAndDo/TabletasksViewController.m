//
//  TabletasksViewController.m
//  PlanAndDo
//
//  Created by Амин on 13.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "TabletasksViewController.h"
#import "TaskTableViewCell.h"
#import "AddTaskViewController.h"

@interface TabletasksViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation TabletasksViewController

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"KSTaskCell"owner:self options:nil];
    TaskTableViewCell * cell=[nib objectAtIndex:0];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(void)addTaskTapped
{
    [self.navigationController pushViewController:[[AddTaskViewController alloc] init] animated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.toolbarHidden=NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    UIBarButtonItem * addButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTaskTapped)];
    self.navigationItem.rightBarButtonItem=addButton;
    //NSLog(@"%@",self.navigationController.)
    //    UISegmentedControl * segment =[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Completed",@"Overdue", nil]];
    //    segment.tintColor=[UIColor colorWithRed:39.0/255.0 green:69.0/255.0 blue:83.0/255.0 alpha:1.0];
    //    [segment setSelectedSegmentIndex:0];
    //    segment.frame=CGRectMake(20, 8, self.view.bounds.size.width-40, 30);
    // [self.view addSubview:segment];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
