//
//  AddTaskViewController.m
//  PlanAndDo
//
//  Created by Амин on 14.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "AddTaskViewController.h"

@implementation AddTaskViewController

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    cell.textLabel.textColor=[UIColor colorWithRed:145.0/255.0 green:145.0/255.0  blue:145.0/255.0  alpha:1.0];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    switch (indexPath.row)
    {
        case 0:
            cell.textLabel.text=@"Head";
            break;
        case 1:
            cell.textLabel.text=@"Category";
            break;
        case 2:
            cell.textLabel.text=@"Description";
            break;
        case 3:
            cell.textLabel.text=@"Date & Time";
            break;
        default:
            cell.textLabel.text=@"Priority";
            break;
    }
    return cell;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    UISegmentedControl * segment =[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Task",@"List", nil]];
    segment.tintColor=[UIColor colorWithRed:39.0/255.0 green:69.0/255.0 blue:83.0/255.0 alpha:1.0];
    [segment setSelectedSegmentIndex:0];
    segment.frame=CGRectMake(20, 8, self.view.bounds.size.width-40, 30);
    UIView * segmentBackgroundView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 46)];
    [segmentBackgroundView addSubview:segment];
    self.tableView.tableHeaderView=segmentBackgroundView;
    
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
}
@end
