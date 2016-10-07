//
//  StartPageViewController.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 15.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "StartPageViewController.h"
#import "KSCheckSettingsTableViewCell.h"
#import "ApplicationManager.h"

@interface StartPageViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic)UISegmentedControl * segment;
@property NSArray* categories;
@property NSArray* boxes;
@property UserSettings* settings;
@end

@implementation StartPageViewController

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
    
    self.settings = [[[ApplicationManager userApplicationManager] authorisedUser] settings];
    
    self.title=NM_START_PAGE;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.categories = [NSArray arrayWithArray:[[ApplicationManager categoryApplicationManager] allCategories]];
    self.boxes = [[NSArray alloc] initWithObjects:NM_TODAY, NM_TOMORROW, NM_WEEK, NM_BACKLOG, NM_ARCHIVE, nil];
    
    self.segment =[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:NM_CATEGORY,NM_BOX, nil]];
    self.segment.tintColor=[UIColor colorWithRed:39.0/255.0 green:69.0/255.0 blue:83.0/255.0 alpha:1.0];
    [self.segment setSelectedSegmentIndex:0];
    self.segment.frame=CGRectMake(20, 8, self.view.bounds.size.width-40, 30);
    [self.segment addTarget:self action:@selector(segmentDidTap) forControlEvents:UIControlEventValueChanged];
    UIView * segmentBackgroundView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 46)];
    [segmentBackgroundView addSubview:self.segment];
    self.tableView.tableHeaderView=segmentBackgroundView;
    
}

-(void)segmentDidTap
{
    [self.tableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.segment.selectedSegmentIndex  ? self.boxes.count : self.categories.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"KSCheckSettingsTableViewCell"owner:self options:nil];
    KSCheckSettingsTableViewCell * cell=[nib objectAtIndex:0];
    cell.tintColor=[UIColor colorWithRed:40.0/255.0 green:69.0/255.0 blue:83.0/255.0 alpha:1.0];
    cell.paramNameLabel.text = self.segment.selectedSegmentIndex ? self.boxes[indexPath.row] : ((KSCategory*)self.categories[indexPath.row]).name;
    cell.accessoryType=[self.settings.startPage.lowercaseString isEqualToString:cell.paramNameLabel.text.lowercaseString] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    UserSettings* updatedSettings = self.segment.selectedSegmentIndex ?
    [[UserSettings alloc] initWithID:self.settings.ID andStartPage:self.boxes[indexPath.row] andDateFormat:self.settings.dateFormat andPageType:NM_BOX.lowercaseString andTimeFormat:self.settings.timeFormat andStartDay:self.settings.startDay andSyncStatus:[[NSDate date] timeIntervalSince1970]] :
    [[UserSettings alloc] initWithID:self.settings.ID andStartPage:((KSCategory*)self.categories[indexPath.row]).name andDateFormat:self.settings.dateFormat andPageType:NM_CATEGORY.lowercaseString andTimeFormat:self.settings.timeFormat andStartDay:self.settings.startDay andSyncStatus:[[NSDate date] timeIntervalSince1970]];
    
    [[ApplicationManager settingsApplicationManager] updateSettings:updatedSettings completion:nil];
 
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
