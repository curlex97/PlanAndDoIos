//
//  CategoryTasksViewController.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 20.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//
#import "TabletasksViewController.h"
#import "CategoryTasksViewController.h"
#import "TaskTableViewCell.h"
#import "AddTaskViewController.h"
#import "AMSideBarViewController.h"
#import "UIImage+ACScaleImage.h"

int rowss = 2;

@interface CategoryTasksViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic)UISegmentedControl * segment;
@end

@implementation CategoryTasksViewController

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return rowss;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"KSTaskCell"owner:self options:nil];
    TaskTableViewCell * cell=[nib objectAtIndex:0];
    
    
    cell.leftButtons = @[[MGSwipeButton buttonWithTitle:@"Complete" backgroundColor:[UIColor greenColor] callback:^BOOL(MGSwipeTableCell *sender) {
        NSLog(@"Complete");
        rowss --;
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [tableView reloadData];
        });
        return YES;
    }]];
    cell.leftSwipeSettings.transition = MGSwipeDirectionLeftToRight;
    
    cell.rightButtons = @[[MGSwipeButton buttonWithTitle:@"Delete" backgroundColor:[UIColor redColor] callback:^BOOL(MGSwipeTableCell *sender) {
        NSLog(@"Delete");
        rowss--;
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [tableView reloadData];
        });
        
        return YES;
    }]];
    
    cell.rightSwipeSettings.transition = MGSwipeDirectionRightToLeft;
    

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
    
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    
    UIBarButtonItem * addButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTaskTapped)];
    self.navigationItem.rightBarButtonItem=addButton;
    
    UIBarButtonItem * menuButton=[[UIBarButtonItem alloc] initWithImage:[UIImage imageWithImage:[UIImage imageNamed:@"Menu"] scaledToSize:CGSizeMake(40, 40)] style:UIBarButtonItemStyleDone target:self action:@selector(menuTapped)];
    self.navigationItem.leftBarButtonItem=menuButton;

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

-(void)menuTapped
{
    AMSideBarViewController * sider=(AMSideBarViewController *)self.navigationController.parentViewController;
    [sider side];
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
    TabletasksViewController * tableTasksViewController=[[TabletasksViewController alloc] init];
    tableTasksViewController.title=@"Today";
    tableTasksViewController.boxType = KSBoxTypeToday;
    UINavigationController* categoryTasksNav = [[UINavigationController alloc] initWithRootViewController:tableTasksViewController];
    AMSideBarViewController* sideBar = (AMSideBarViewController*)self.navigationController.parentViewController;
    [sideBar setNewFrontViewController:categoryTasksNav];
    
}

-(void)tomorrowDidTap
{
    TabletasksViewController * tableTasksViewController=[[TabletasksViewController alloc] init];
    tableTasksViewController.title=@"Tomorrow";
    tableTasksViewController.boxType = KSBoxTypeTomorrow;
    UINavigationController* categoryTasksNav = [[UINavigationController alloc] initWithRootViewController:tableTasksViewController];
    AMSideBarViewController* sideBar = (AMSideBarViewController*)self.navigationController.parentViewController;
    [sideBar setNewFrontViewController:categoryTasksNav];
    
}

-(void)weekDidTap
{
    TabletasksViewController * tableTasksViewController=[[TabletasksViewController alloc] init];
    tableTasksViewController.title=@"Week";
    tableTasksViewController.boxType = KSBoxTypeWeek;
    UINavigationController* categoryTasksNav = [[UINavigationController alloc] initWithRootViewController:tableTasksViewController];
    AMSideBarViewController* sideBar = (AMSideBarViewController*)self.navigationController.parentViewController;
    [sideBar setNewFrontViewController:categoryTasksNav];
    
}

-(void)backLogDidTap
{
    TabletasksViewController * tableTasksViewController=[[TabletasksViewController alloc] init];
    tableTasksViewController.title=@"Backlog";
    tableTasksViewController.boxType = KSBoxTypeBacklog;
    UINavigationController* categoryTasksNav = [[UINavigationController alloc] initWithRootViewController:tableTasksViewController];
    AMSideBarViewController* sideBar = (AMSideBarViewController*)self.navigationController.parentViewController;
    [sideBar setNewFrontViewController:categoryTasksNav];
    
}

-(void)archiveDidTap
{
    TabletasksViewController * tableTasksViewController=[[TabletasksViewController alloc] init];
    tableTasksViewController.title=@"Archive";
    tableTasksViewController.boxType = KSBoxTypeArchive;
    UINavigationController* categoryTasksNav = [[UINavigationController alloc] initWithRootViewController:tableTasksViewController];
    AMSideBarViewController* sideBar = (AMSideBarViewController*)self.navigationController.parentViewController;
    [sideBar setNewFrontViewController:categoryTasksNav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
