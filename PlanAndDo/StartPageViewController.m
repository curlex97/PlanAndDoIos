//
//  StartPageViewController.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 15.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "StartPageViewController.h"
#import "KSCheckSettingsTableViewCell.h"


@interface StartPageViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic)UISegmentedControl * segment;
@property NSArray* categories;
@end

@implementation StartPageViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"Start page";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.categories = [NSArray array];
    self.segment =[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Task",@"List", nil]];
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
    return self.segment.selectedSegmentIndex  ? 5 : self.categories.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"KSCheckSettingsTableViewCell"owner:self options:nil];
    KSCheckSettingsTableViewCell * cell=[nib objectAtIndex:0];
    
    if(self.segment.selectedSegmentIndex)
    {
        switch (indexPath.row) {
            case 0:
                cell.paramNameLabel.text = @"Today";
                break;
            case 1:
                cell.paramNameLabel.text = @"Tomorrow";
                break;
            case 2:
                cell.paramNameLabel.text = @"Week";
                break;
            case 3:
                cell.paramNameLabel.text = @"Month";
                break;
            case 4:
                cell.paramNameLabel.text = @"Archive";
                break;
            default:
                break;
        }
    }
    
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

@end
