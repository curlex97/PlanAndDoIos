//
//  FormatDateViewController.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 15.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "FormatDateViewController.h"
#import "KSCheckSettingsTableViewCell.h"
#import "ApplicationManager.h"

@interface FormatDateViewController () <UITableViewDelegate, UITableViewDataSource>
@property UserSettings* settings;

@end

@implementation FormatDateViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title= NM_FORMAT_DATE;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.settings = [[[ApplicationManager userApplicationManager] authorisedUser] settings];

}

-(void)reloadData
{
    self.settings = [[[ApplicationManager userApplicationManager] authorisedUser] settings];
    [super reloadData];
}

-(void)refreshDidSwipe
{
    self.settings = [[[ApplicationManager userApplicationManager] authorisedUser] settings];
    [super refreshDidSwipe];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"KSCheckSettingsTableViewCell"owner:self options:nil];
    KSCheckSettingsTableViewCell * cell=[nib objectAtIndex:0];
    cell.tintColor=[UIColor colorWithRed:40.0/255.0 green:69.0/255.0 blue:83.0/255.0 alpha:1.0];
    switch (indexPath.row) {
        case 0:
            cell.paramNameLabel.text = NM_DDMMYY_H;
            cell.accessoryType=[[self.settings.dateFormat substringToIndex:1] isEqualToString:@"M"] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
            break;
        case 1:
            cell.paramNameLabel.text = NM_MMDDYY_H;
            cell.accessoryType=[[self.settings.dateFormat substringToIndex:1] isEqualToString:@"d"] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
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
    NSString* formatDate = indexPath.row ? NM_MMDDYY : NM_DDMMYY;
    
    UserSettings* updatedSettings = [[UserSettings alloc] initWithID:self.settings.ID andStartPage:self.settings.startPage andDateFormat:formatDate andPageType:self.settings.pageType andTimeFormat:self.settings.timeFormat andStartDay:self.settings.startDay andSyncStatus:[[NSDate date] timeIntervalSince1970]];
    
    [[ApplicationManager settingsApplicationManager] updateSettings:updatedSettings completion:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
