//
//  SettingsViewController.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 13.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "SettingsViewController.h"
#import "KSSettingsCell.h"

@interface SettingsViewController()<UITableViewDelegate, UITableViewDataSource>
@end

@implementation SettingsViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
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

    
    switch (indexPath.row) {
        case 0:
            cell.paramNameLabel.text = @"Start page";
            break;
        case 1:
            cell.paramNameLabel.text = @"Format date";
            break;
        case 2:
            cell.paramNameLabel.text = @"Format time";
            break;
        case 3:
            cell.paramNameLabel.text = @"Start day";
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



@end
