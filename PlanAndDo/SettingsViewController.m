//
//  SettingsViewController.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 13.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "SettingsViewController.h"
#import "KSSettingsCell.h"
#import "FormatDateViewController.h"
#import "FormatTimeViewController.h"
#import "StartDayViewController.h"
#import "StartPageViewController.h"
#import "UIImage+ACScaleImage.h"
#import "AMSideBarViewController.h"

@interface SettingsViewController()<UITableViewDelegate, UITableViewDataSource>
@end

@implementation SettingsViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UIBarButtonItem * menuButton=[[UIBarButtonItem alloc] initWithImage:[UIImage imageWithImage:[UIImage imageNamed:@"Menu"] scaledToSize:CGSizeMake(40, 40)] style:UIBarButtonItemStyleDone target:self action:@selector(menuTapped)];
    self.navigationItem.leftBarButtonItem=menuButton;

}

-(void)menuTapped
{
    AMSideBarViewController * sider=(AMSideBarViewController *)self.navigationController.parentViewController;
    [sider side];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"KSSettingsCell"owner:self options:nil];
    KSSettingsCell * cell=[nib objectAtIndex:0];
    
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.textColor=[UIColor colorWithRed:98.0/255.0 green:98.0/255.0 blue:98.0/255.0 alpha:1.0];
    
    switch (indexPath.row)
    {
        case 0:
            cell.textLabel.text = @"Start page";
            break;
        case 1:
            cell.textLabel.text = @"Format date";
            break;
        case 2:
            cell.textLabel.text = @"Format time";
            break;
        case 3:
            cell.textLabel.text = @"Start day";
            break;
        default:
            break;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
            
        case 0:
            [self.navigationController pushViewController:[[StartPageViewController alloc] init] animated:YES];
            break;
            
        case 1:
            [self.navigationController pushViewController:[[FormatDateViewController alloc] init] animated:YES];
            break;
            
        case 2:
            [self.navigationController pushViewController:[[FormatTimeViewController alloc] init] animated:YES];
            break;
            
        case 3:
            [self.navigationController pushViewController:[[StartDayViewController alloc] init] animated:YES];
            break;
            
        default:
            break;
    }
}


@end
