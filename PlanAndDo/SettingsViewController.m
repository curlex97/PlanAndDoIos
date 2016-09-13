//
//  SettingsViewController.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 13.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "SettingsViewController.h"

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
    UITableViewCell* cell = [[UITableViewCell alloc] init];
    
    switch (indexPath.row) {
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



@end
