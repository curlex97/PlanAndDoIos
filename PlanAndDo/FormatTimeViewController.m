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

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"Format time";
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
        
    
    switch (indexPath.row) {
        case 0:
            cell.paramNameLabel.text = @"24H";
            break;
        case 1:
            cell.paramNameLabel.text = @"12H";
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
    
    NSString* formatTime = indexPath.row ? @"12" : @"24";
    
    UserSettings* updatedSettings = [[UserSettings alloc] initWithID:self.settings.ID andStartPage:self.settings.startPage andDateFormat:self.settings.dateFormat andPageType:self.settings.pageType andTimeFormat:formatTime andStartDay:self.settings.startDay andSyncStatus:[[NSDate date] timeIntervalSince1970]];
    
    [[ApplicationManager settingsApplicationManager] updateSettings:updatedSettings];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
