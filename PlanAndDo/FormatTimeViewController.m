//
//  FormatTimeViewController.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 15.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "FormatTimeViewController.h"
#import "KSCheckSettingsTableViewCell.h"
#import "ApplicationManager.h"

@interface FormatTimeViewController () <UITableViewDelegate, UITableViewDataSource>
@property UserSettings* settings;

@end

@implementation FormatTimeViewController

-(void)reloadData
{
    [[ApplicationManager syncApplicationManager] syncSettingsWithCompletion:^(bool  completed)
     {
         if(completed)
         {
             self.settings = [[[ApplicationManager userApplicationManager] authorisedUser] settings];
             [super reloadData];
         }
     }];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title=NM_FORMAT_TIME;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    self.settings = [[[ApplicationManager userApplicationManager] authorisedUser] settings];

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
            cell.paramNameLabel.text = NM_24H;
            cell.accessoryType=[self.settings.timeFormat.lowercaseString containsString:NM_24] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
            break;
        case 1:
            cell.paramNameLabel.text = NM_12H;
            cell.accessoryType=[self.settings.timeFormat.lowercaseString containsString:NM_12] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
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
    
    NSString* formatTime = indexPath.row ? NM_12 : NM_24;
    
    UserSettings* updatedSettings = [[UserSettings alloc] initWithID:self.settings.ID andStartPage:self.settings.startPage andDateFormat:self.settings.dateFormat andPageType:self.settings.pageType andTimeFormat:formatTime andStartDay:self.settings.startDay andSyncStatus:[[NSDate date] timeIntervalSince1970]];
    
    [[ApplicationManager settingsApplicationManager] updateSettings:updatedSettings completion:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
