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
#import "ApplicationManager.h"

@interface SettingsViewController()<UITableViewDelegate, UITableViewDataSource>
@property UserSettings* settings;
@end

@implementation SettingsViewController

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

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UIBarButtonItem * menuButton=[[UIBarButtonItem alloc] initWithImage:[UIImage imageWithImage:[UIImage imageNamed:TL_MENU] scaledToSize:CGSizeMake(40, 40)] style:UIBarButtonItemStyleDone target:self action:@selector(menuTapped)];
    self.navigationItem.leftBarButtonItem=menuButton;

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.settings = [[ApplicationManager settingsApplicationManager] settings];
    
    KSAuthorisedUser* user = [[ApplicationManager userApplicationManager] authorisedUser];
    user.settings = self.settings;
    [[ApplicationManager userApplicationManager] updateUser:user completion:nil];
    
    [self.tableView reloadData];
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
            cell.textLabel.text = NM_START_PAGE;
            cell.paramValueLabel.text = self.settings.startPage.capitalizedString;
            
            break;
        case 1:
            cell.textLabel.text = NM_FORMAT_DATE;
            cell.paramValueLabel.text = self.settings.dateFormat.uppercaseString;

            break;
        case 2:
            cell.textLabel.text = NM_FORMAT_TIME;
            cell.paramValueLabel.text = [NSString stringWithFormat:@"%@H", self.settings.timeFormat];

            break;
        case 3:
            cell.textLabel.text = NM_START_DAY;
            cell.paramValueLabel.text = self.settings.startDay.capitalizedString;

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
