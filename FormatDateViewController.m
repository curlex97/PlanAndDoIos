//
//  FormatDateViewController.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 15.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "FormatDateViewController.h"
#import "KSCheckSettingsTableViewCell.h"

@interface FormatDateViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation FormatDateViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"Format date";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"KSCheckSettingsTableViewCell"owner:self options:nil];
    KSCheckSettingsTableViewCell * cell=[nib objectAtIndex:0];
    
    switch (indexPath.row) {
        case 0:
            cell.paramNameLabel.text = @"DD/MM/YY";
            break;
        case 1:
            cell.paramNameLabel.text = @"MM/DD/YY";
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
