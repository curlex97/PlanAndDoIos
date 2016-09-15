//
//  TabletasksViewController.m
//  PlanAndDo
//
//  Created by Амин on 13.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "TabletasksViewController.h"
#import "TaskTableViewCell.h"
#import "AddTaskViewController.h"

#import "UIImage+ACScaleImage.h"

#define BAR_BUTTON_SIZE 50

typedef NS_ENUM(NSInteger, KSBoxType)
{
    KSBoxTypeToday,
    KSBoxTypeTomorrow,
    KSBoxTypeWeek,
    KSBoxTypeBacklog,
    KSBoxTypeArchive
};


@interface TabletasksViewController ()<UITableViewDelegate, UITableViewDataSource>
@property KSBoxType boxType;
@property (nonatomic)UISegmentedControl * segment;
@end

@implementation TabletasksViewController

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"KSTaskCell"owner:self options:nil];
    TaskTableViewCell * cell=[nib objectAtIndex:0];
    
    switch (self.boxType) {
            
        case KSBoxTypeToday:
            cell.taskHeaderLabel.text = @"Today";
            break;
            
        case KSBoxTypeTomorrow:
            cell.taskHeaderLabel.text = @"Tomorrow";
            break;
            
        case KSBoxTypeWeek:
            cell.taskHeaderLabel.text = @"Week";
            break;
            
        case KSBoxTypeBacklog:
            cell.taskHeaderLabel.text = @"Backlog";
            break;
            
        case KSBoxTypeArchive:
            cell.taskHeaderLabel.text = @"Archive";
            cell.taskPriorityLabel.text = self.segment.selectedSegmentIndex ? @"Overdue" : @"Completed";
            break;
            
        default:
            break;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(void)addTaskTapped
{
    [self.navigationController pushViewController:[[AddTaskViewController alloc] init] animated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.toolbarHidden=NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.boxType = KSBoxTypeToday;
    self.title = @"Today";

    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    
    UIBarButtonItem * addButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTaskTapped)];
    self.navigationItem.rightBarButtonItem=addButton;
    
    UIBarButtonItem * today=[[UIBarButtonItem alloc] initWithImage:[UIImage imageWithImage:[UIImage imageNamed:@"Today"] scaledToSize:CGSizeMake(BAR_BUTTON_SIZE, BAR_BUTTON_SIZE)] style:UIBarButtonItemStyleDone target:self action:@selector(todayDidTap)];

    today.image = [today.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [today setTintColor:[UIColor colorWithRed:40.0/255.0 green:70.0/255.0 blue:83.0/255.0 alpha:1.0]];
    
    self.navigationController.toolbar.clearsContextBeforeDrawing=YES;
    
    UIBarButtonItem * tomorrow=[[UIBarButtonItem alloc] initWithImage:[UIImage imageWithImage:[UIImage imageNamed:@"Tomorrow"] scaledToSize:CGSizeMake(BAR_BUTTON_SIZE, BAR_BUTTON_SIZE)] style:UIBarButtonItemStyleDone target:self action:@selector(tomorrowDidTap)];
    
    tomorrow.image = [tomorrow.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [tomorrow setTintColor:[UIColor colorWithRed:40.0/255.0 green:70.0/255.0 blue:83.0/255.0 alpha:1.0]];
    
    self.navigationController.toolbar.clearsContextBeforeDrawing=YES;
    
    UIBarButtonItem * week=[[UIBarButtonItem alloc] initWithImage:[UIImage imageWithImage:[UIImage imageNamed:@"Week"] scaledToSize:CGSizeMake(BAR_BUTTON_SIZE, BAR_BUTTON_SIZE)] style:UIBarButtonItemStyleDone target:self action:@selector(weekDidTap)];
    
    week.image = [week.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [week setTintColor:[UIColor colorWithRed:40.0/255.0 green:70.0/255.0 blue:83.0/255.0 alpha:1.0]];
    
    self.navigationController.toolbar.clearsContextBeforeDrawing=YES;
    
    UIBarButtonItem * backLog=[[UIBarButtonItem alloc] initWithImage:[UIImage imageWithImage:[UIImage imageNamed:@"Backlog"] scaledToSize:CGSizeMake(BAR_BUTTON_SIZE, BAR_BUTTON_SIZE)] style:UIBarButtonItemStyleDone target:self action:@selector(backLogDidTap)];
    
    backLog.image = [backLog.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [backLog setTintColor:[UIColor colorWithRed:40.0/255.0 green:70.0/255.0 blue:83.0/255.0 alpha:1.0]];
    
    self.navigationController.toolbar.clearsContextBeforeDrawing=YES;
    
    UIBarButtonItem * archive=[[UIBarButtonItem alloc] initWithImage:[UIImage imageWithImage:[UIImage imageNamed:@"Archive"] scaledToSize:CGSizeMake(BAR_BUTTON_SIZE, BAR_BUTTON_SIZE)] style:UIBarButtonItemStyleDone target:self action:@selector(archiveDidTap)];
    
    archive.image = [archive.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [archive setTintColor:[UIColor colorWithRed:40.0/255.0 green:70.0/255.0 blue:83.0/255.0 alpha:1.0]];
    
    self.toolbarItems=[NSArray arrayWithObjects:
                       [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL],
                       today,
                       [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL],
                       tomorrow,
                       [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL],
                       week,
                       [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL],
                       backLog,
                       [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL],
                       archive,
                       [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL],
                       nil];

}

-(void) addSegmentControl
{
    self.segment =[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Completed",@"Overdue", nil]];
    self.segment.tintColor=[UIColor colorWithRed:39.0/255.0 green:69.0/255.0 blue:83.0/255.0 alpha:1.0];
    [self.segment setSelectedSegmentIndex:0];
    self.segment.frame=CGRectMake(20, 8, self.view.bounds.size.width-40, 30);
    [self.segment addTarget:self action:@selector(segmentDidTap) forControlEvents:UIControlEventValueChanged];
    UIView * segmentBackgroundView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 46)];
    [segmentBackgroundView addSubview:self.segment];
    self.tableView.tableHeaderView=segmentBackgroundView;
}

-(void) removeSegmentControl
{
    self.tableView.tableHeaderView = nil;
}

-(void) segmentDidTap
{
    [self.tableView reloadData];
}

-(void)todayDidTap
{
    self.title = @"Today";
    self.boxType = KSBoxTypeToday;
    [self removeSegmentControl];
    [self.tableView reloadData];
}

-(void)tomorrowDidTap
{
    self.title = @"Tomorrow";
    self.boxType = KSBoxTypeTomorrow;
    [self removeSegmentControl];
    [self.tableView reloadData];
}

-(void)weekDidTap
{
    self.title = @"Week";
    self.boxType = KSBoxTypeWeek;
    [self removeSegmentControl];
    [self.tableView reloadData];
}

-(void)backLogDidTap
{
    self.title = @"Backlog";
    self.boxType = KSBoxTypeBacklog;
    [self removeSegmentControl];
    [self.tableView reloadData];
}

-(void)archiveDidTap
{
    self.title = @"Archive";
    self.boxType = KSBoxTypeArchive;
    [self addSegmentControl];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
