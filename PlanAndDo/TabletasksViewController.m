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
#import "AMSideBarViewController.h"
#import "UIImage+ACScaleImage.h"
#import "EditTaskViewController.h"
#import "ApplicationManager.h"

@interface TabletasksViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic)UISegmentedControl * segment;
@end

@implementation TabletasksViewController

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tasks.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"KSTaskCell"owner:self options:nil];
    TaskTableViewCell * cell=[nib objectAtIndex:0];
    BaseTask* task = self.tasks[indexPath.row];
    
    cell.leftButtons = @[[MGSwipeButton buttonWithTitle:@"Complete" backgroundColor:[UIColor greenColor] callback:^BOOL(MGSwipeTableCell *sender) {
        NSLog(@"Complete");
        //rows --;
       // [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [tableView reloadData];
        });
        return YES;
    }]];
    cell.leftSwipeSettings.transition = MGSwipeDirectionLeftToRight;
    
    cell.rightButtons = @[[MGSwipeButton buttonWithTitle:@"Delete" backgroundColor:[UIColor redColor] callback:^BOOL(MGSwipeTableCell *sender) {
        NSLog(@"Delete");
       // rows--;
      //  [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [tableView reloadData];
        });

        return YES;
    }]];
    
    cell.rightSwipeSettings.transition = MGSwipeDirectionRightToLeft;
    cell.taskHeaderLabel.text = task.name;
    switch (task.priority) {
        case KSTaskHighPriority:cell.taskPriorityLabel.text = @"Normal priority"; break;
        case KSTaskDefaultPriority:cell.taskPriorityLabel.text = @"Default priority"; break;
        case KSTaskVeryHighPriority:cell.taskPriorityLabel.text = @"High priority"; break;
    }
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:task.completionTime];
    
    cell.taskDateLabel.text = [NSString stringWithFormat:@"%li/%li/%li", [components day], [components month], [components year]];
    cell.taskTimeLabel.text = [NSString stringWithFormat:@"%li:%li", [components hour], [components minute]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditTaskViewController * editTaskViewController=[[EditTaskViewController alloc] init];
    editTaskViewController.task = self.tasks[indexPath.row];
    [self.navigationController pushViewController:editTaskViewController animated:YES];
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
    
    if(!self.category)
    {
        switch (self.boxType) {
            case KSBoxTypeToday: self.tasks = [[ApplicationManager tasksApplicationManager] allTasksForToday]; break;
            case KSBoxTypeTomorrow: self.tasks = [[ApplicationManager tasksApplicationManager] allTasksForTomorrow]; break;
            case KSBoxTypeWeek: self.tasks = [[ApplicationManager tasksApplicationManager] allTasksForWeek]; break;
            case KSBoxTypeArchive: self.tasks = [[ApplicationManager tasksApplicationManager] allTasksForArchive]; break;
            case KSBoxTypeBacklog: self.tasks = [[ApplicationManager tasksApplicationManager] allTasksForBacklog]; break;
        }
    }
    else self.tasks = [[[TasksCoreDataManager alloc] init] allTasksForCategory:self.category];
    
    if(![self.title length])
    {
        self.boxType = KSBoxTypeToday;
        self.title = @"Today";
    }
    
    else
    {
        if(self.boxType == KSBoxTypeArchive) [self addSegmentControl];
        else [self removeSegmentControl];
    }
    
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
    self.tasks = [[ApplicationManager tasksApplicationManager] allTasksForToday];
    self.title = @"Today";
    self.boxType = KSBoxTypeToday;
    [self removeSegmentControl];
    [self.tableView reloadData];
}

-(void)tomorrowDidTap
{
    self.tasks = [[ApplicationManager tasksApplicationManager] allTasksForTomorrow];
    self.title = @"Tomorrow";
    self.boxType = KSBoxTypeTomorrow;
    [self removeSegmentControl];
    [self.tableView reloadData];
}

-(void)weekDidTap
{
    self.tasks = [[ApplicationManager tasksApplicationManager] allTasksForWeek];
    self.title = @"Week";
    self.boxType = KSBoxTypeWeek;
    [self removeSegmentControl];
    [self.tableView reloadData];
}

-(void)backLogDidTap
{
    self.tasks = [[ApplicationManager tasksApplicationManager] allTasksForBacklog];
    self.title = @"Backlog";
    self.boxType = KSBoxTypeBacklog;
    [self removeSegmentControl];
    [self.tableView reloadData];
}

-(void)archiveDidTap
{
    self.tasks = [[ApplicationManager tasksApplicationManager] allTasksForArchive];
    self.title = @"Archive";
    self.boxType = KSBoxTypeArchive;
    [self addSegmentControl];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
