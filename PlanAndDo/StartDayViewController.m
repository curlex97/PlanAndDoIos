//
//  StartDayViewController.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 15.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "StartDayViewController.h"
#import "KSCheckSettingsTableViewCell.h"
#import "ApplicationManager.h"

@interface StartDayViewController () <UITableViewDelegate, UITableViewDataSource>
@property UserSettings* settings;

@end

@implementation StartDayViewController

-(void)reloadData
{
    self.settings = [[[ApplicationManager sharedApplication].userApplicationManager authorisedUser] settings];
    [super reloadData];
}

-(void)refreshDidSwipe
{
    self.settings = [[[ApplicationManager sharedApplication].userApplicationManager authorisedUser] settings];
    [super refreshDidSwipe];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title= NM_START_DAY;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.settings = [[[ApplicationManager sharedApplication].userApplicationManager authorisedUser] settings];

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
            cell.paramNameLabel.text = TL_MONDAY;
            cell.accessoryType=[self.settings.startDay.lowercaseString isEqualToString:TL_MONDAY.lowercaseString] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
            break;
        case 1:
            cell.paramNameLabel.text = TL_SUNDAY;
            cell.accessoryType=[self.settings.startDay.lowercaseString isEqualToString:TL_SUNDAY.lowercaseString] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
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
    
    NSString* day = indexPath.row ? TL_SUNDAY.lowercaseString : TL_MONDAY.lowercaseString;
    
    UserSettings* updatedSettings = [[UserSettings alloc] initWithID:self.settings.ID andStartPage:self.settings.startPage andDateFormat:self.settings.dateFormat andPageType:self.settings.pageType andTimeFormat:self.settings.timeFormat andStartDay:day andSyncStatus:[[NSDate date] timeIntervalSince1970]];
    
    [[ApplicationManager sharedApplication].settingsApplicationManager updateSettings:updatedSettings completion:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
