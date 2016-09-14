//
//  BaseTableViewController.m
//  PlanAndDo
//
//  Created by Амин on 14.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()
@property NSLayoutConstraint *trailing;
@property NSLayoutConstraint *leading;
@property NSLayoutConstraint *bottom;
@property NSLayoutConstraint *top;

@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView=[[UITableView alloc] initWithFrame:self.view.bounds];
    self.refresh=[[UIRefreshControl alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2-15, 0, 40, 40)];
    self.tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView addSubview:self.refresh];
    [self.view addSubview:self.tableView];
    [self setConstraints];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setConstraints
{
    self.trailing =[NSLayoutConstraint
                    constraintWithItem:self.tableView
                    attribute:NSLayoutAttributeTrailing
                    relatedBy:NSLayoutRelationEqual
                    toItem:self.view
                    attribute:NSLayoutAttributeTrailing
                    multiplier:1.0f
                    constant:0.f];
    
    self.leading = [NSLayoutConstraint
                    constraintWithItem:self.tableView
                    attribute:NSLayoutAttributeLeading
                    relatedBy:NSLayoutRelationEqual
                    toItem:self.view
                    attribute:NSLayoutAttributeLeading
                    multiplier:1.0f
                    constant:0.f];
    
    self.bottom =[NSLayoutConstraint
                  constraintWithItem:self.tableView
                  attribute:NSLayoutAttributeBottom
                  relatedBy:NSLayoutRelationEqual
                  toItem:self.view
                  attribute:NSLayoutAttributeBottom
                  multiplier:1.0f
                  constant:0.f];
    
    self.top =[NSLayoutConstraint
               constraintWithItem:self.tableView
               attribute:NSLayoutAttributeTop
               relatedBy:NSLayoutRelationEqual
               toItem:self.view
               attribute:NSLayoutAttributeTop
               multiplier:1.0f
               constant:0.f];
    
    self.tableView.translatesAutoresizingMaskIntoConstraints=NO;
    [self.view addConstraint:self.trailing];
    [self.view addConstraint:self.leading];
    [self.view addConstraint:self.bottom];
    [self.view addConstraint:self.top];
}

@end
