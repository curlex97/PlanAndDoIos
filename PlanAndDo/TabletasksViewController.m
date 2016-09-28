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

static bool firstLoad = true;

@interface TabletasksViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic)UISegmentedControl * segment;
@property (nonatomic)UIBarButtonItem * currentBoxItem;
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
    
    if(self.boxType != KSBoxTypeArchive || self.segment.selectedSegmentIndex)
    {
        cell.leftButtons = @[[MGSwipeButton buttonWithTitle:@"Complete" backgroundColor:[UIColor greenColor] callback:^BOOL(MGSwipeTableCell *sender) {
            NSLog(@"Complete");
            task.status = YES;
            [[ApplicationManager tasksApplicationManager] updateTask:task];
            [self.tasks removeObject:task];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [tableView reloadData];
            });
            return YES;
        }]];
        cell.leftSwipeSettings.transition = MGSwipeDirectionLeftToRight;
    }
    cell.rightButtons = @[[MGSwipeButton buttonWithTitle:@"Delete" backgroundColor:[UIColor redColor] callback:^BOOL(MGSwipeTableCell *sender) {
        NSLog(@"Delete");
        [[ApplicationManager tasksApplicationManager] deleteTask:task];
        [self.tasks removeObject:task];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [tableView reloadData];
        });
        
        return YES;
    }]];
    
    cell.rightSwipeSettings.transition = MGSwipeDirectionRightToLeft;
    cell.taskHeaderLabel.text = task.name;
    switch (task.priority) {
        case KSTaskDefaultPriority:
            cell.taskPriorityLabel.text = @"Low priority";
            cell.taskPriorityLabel.textColor=[UIColor colorWithRed:145.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0];
            break;
        case KSTaskHighPriority:
            cell.taskPriorityLabel.text = @"Mid priority";
            cell.taskPriorityLabel.textColor=[UIColor colorWithRed:245.0/255.0 green:166.0/255.0 blue:35.0/255.0 alpha:1.0];
            break;
        case KSTaskVeryHighPriority:
            cell.taskPriorityLabel.text = @"High priority";
            cell.taskPriorityLabel.textColor=[UIColor colorWithRed:241.0/255.0 green:17.0/255.0 blue:44.0/255.0 alpha:1.0];
            break;
    }
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:task.completionTime];
    
    cell.taskDateLabel.text = [NSString stringWithFormat:@"%li/%li/%li", [components day], [components month], [components year]];
    cell.taskTimeLabel.text = [NSString stringWithFormat:@"%li:%li", [components hour], [components minute]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    EditTaskViewController * editTaskViewController=[[EditTaskViewController alloc] init];
    editTaskViewController.task = self.tasks[indexPath.row];
    editTaskViewController.title = @"Edit";
    [self.navigationController pushViewController:editTaskViewController animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(void)addTaskTapped
{
    [self.navigationController pushViewController:[[AddTaskViewController alloc] initWithCategory:self.category] animated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.toolbarHidden=NO;
}

-(void)setStartPageForLoad
{
    if(!firstLoad) return;
    
    NSString* startPage = [[[[ApplicationManager userApplicationManager] authorisedUser] settings] startPage];
    NSArray* boxes = [[NSArray alloc] initWithObjects:@"Today", @"Tomorrow", @"Week", @"Backlog", @"Archive", nil];
    for(NSString* box in boxes)
    {
        if([box isEqualToString:startPage])
        {
            if([startPage isEqualToString:@"Today"]) self.boxType = KSBoxTypeToday;
            if([startPage isEqualToString:@"Tomorrow"]) self.boxType = KSBoxTypeTomorrow;
            if([startPage isEqualToString:@"Week"]) self.boxType = KSBoxTypeWeek;
            if([startPage isEqualToString:@"Backlog"]) self.boxType = KSBoxTypeBacklog;
            if([startPage isEqualToString:@"Archive"]) self.boxType = KSBoxTypeArchive;
            return;
        }
    }
    
    for(KSCategory* cat in [[ApplicationManager categoryApplicationManager] allCategories])
    {
        if([cat.name isEqualToString:startPage])
        {
            self.category = cat;
            break;
        }
    }
    firstLoad = false;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setStartPageForLoad];
    
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    
    UIBarButtonItem * addButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTaskTapped)];
    self.navigationItem.rightBarButtonItem=addButton;
    
    UIBarButtonItem * menuButton=[[UIBarButtonItem alloc] initWithImage:[UIImage imageWithImage:[UIImage imageNamed:@"Menu"] scaledToSize:CGSizeMake(40, 40)] style:UIBarButtonItemStylePlain target:self action:@selector(menuTapped)];
    self.navigationItem.leftBarButtonItem=menuButton;
    
    UIBarButtonItem * today=[[UIBarButtonItem alloc] initWithImage:[UIImage imageWithImage:[UIImage imageNamed:@"Today"] scaledToSize:CGSizeMake(BAR_BUTTON_SIZE_WIDTH, BAR_BUTTON_SIZE_HEIGHT)] style:UIBarButtonItemStyleDone target:self action:@selector(todayDidTap)];
    
    today.image = [today.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [today setTintColor:[UIColor colorWithRed:145.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0]];
    
    self.navigationController.toolbar.clearsContextBeforeDrawing=YES;
    
    UIBarButtonItem * tomorrow=[[UIBarButtonItem alloc] initWithImage:[UIImage imageWithImage:[UIImage imageNamed:@"Tomorrow"] scaledToSize:CGSizeMake(BAR_BUTTON_SIZE_WIDTH+10, BAR_BUTTON_SIZE_HEIGHT)] style:UIBarButtonItemStyleDone target:self action:@selector(tomorrowDidTap)];
    
    tomorrow.image = [tomorrow.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [tomorrow setTintColor:[UIColor colorWithRed:145.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0]];
    
    self.navigationController.toolbar.clearsContextBeforeDrawing=YES;
    
    UIBarButtonItem * week=[[UIBarButtonItem alloc] initWithImage:[UIImage imageWithImage:[UIImage imageNamed:@"Week"] scaledToSize:CGSizeMake(BAR_BUTTON_SIZE_WIDTH, BAR_BUTTON_SIZE_HEIGHT)] style:UIBarButtonItemStyleDone target:self action:@selector(weekDidTap)];
    
    week.image = [week.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [week setTintColor:[UIColor colorWithRed:145.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0]];
    
    self.navigationController.toolbar.clearsContextBeforeDrawing=YES;
    
    UIBarButtonItem * backLog=[[UIBarButtonItem alloc] initWithImage:[UIImage imageWithImage:[UIImage imageNamed:@"Backlog"] scaledToSize:CGSizeMake(BAR_BUTTON_SIZE_WIDTH, BAR_BUTTON_SIZE_HEIGHT)] style:UIBarButtonItemStyleDone target:self action:@selector(backLogDidTap)];
    
    backLog.image = [backLog.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [backLog setTintColor:[UIColor colorWithRed:145.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0]];
    
    self.navigationController.toolbar.clearsContextBeforeDrawing=YES;
    
    UIBarButtonItem * archive=[[UIBarButtonItem alloc] initWithImage:[UIImage imageWithImage:[UIImage imageNamed:@"Archive"] scaledToSize:CGSizeMake(BAR_BUTTON_SIZE_WIDTH, BAR_BUTTON_SIZE_HEIGHT)] style:UIBarButtonItemStyleDone target:self action:@selector(archiveDidTap)];
    
    archive.image = [archive.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [archive setTintColor:[UIColor colorWithRed:145.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0]];
    
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
    
    [self reloadCoreData];
  
    [self.currentBoxItem setTintColor:[UIColor colorWithRed:39.0/255.0 green:70.0/255.0 blue:83.0/255.0 alpha:1.0]];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:@"TaskAdd" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:@"TaskEdit" object:nil];

    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self refreshData:nil];
}


-(void)reloadCoreData
{
    if(!self.category)
    {
        switch (self.boxType)
        {
            case KSBoxTypeToday:
                self.tasks = [NSMutableArray arrayWithArray:[[ApplicationManager tasksApplicationManager] allTasksForToday]];
                self.title = @"Today";
                self.currentBoxItem=self.toolbarItems[1];
                break;
            case KSBoxTypeTomorrow:
                self.tasks = [NSMutableArray arrayWithArray:[[ApplicationManager tasksApplicationManager] allTasksForTomorrow]];
                self.title = @"Tomorrow";
                self.currentBoxItem=self.toolbarItems[3];
                break;
            case KSBoxTypeWeek:
                self.tasks = [NSMutableArray arrayWithArray:[[ApplicationManager tasksApplicationManager] allTasksForWeek]];
                self.currentBoxItem=self.toolbarItems[5];
                self.title = @"Week";
                break;
            case KSBoxTypeArchive:
                self.tasks = [NSMutableArray arrayWithArray:[[ApplicationManager tasksApplicationManager] allTasksForArchive]];
                self.currentBoxItem=self.toolbarItems[7];
                self.title = @"Archive";
                self.navigationItem.rightBarButtonItem=nil;
                break;
            case KSBoxTypeBacklog:
                self.tasks = [NSMutableArray arrayWithArray:[[ApplicationManager tasksApplicationManager] allTasksForBacklog]];
                self.currentBoxItem=self.toolbarItems[9];
                self.title = @"Backlog";
                break;
                
        }
    }
    else
    {
        self.tasks = [NSMutableArray arrayWithArray:[[[TasksCoreDataManager alloc] init] allTasksForCategory:self.category]];
        self.title = self.category.name;
    }
    
    if(![self.title length])
    {
        self.boxType = KSBoxTypeToday;
        self.title = @"Today";
        self.currentBoxItem=self.toolbarItems[1];
    }
    
    else
    {
        if(self.boxType == KSBoxTypeArchive) [self addSegmentControl];
        else [self removeSegmentControl];
    }

}

-(void)refreshData:(NSNotification *)not
{
    [self reloadCoreData];
    [self.tableView reloadData];
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
    if(self.segment.selectedSegmentIndex)
        self.tasks = [NSMutableArray arrayWithArray:[self overdueTasks:[[ApplicationManager tasksApplicationManager] allTasksForArchive]]];
    else
        self.tasks = [NSMutableArray arrayWithArray:[self completedTasks:[[ApplicationManager tasksApplicationManager] allTasksForArchive]]];
    
    [self.tableView reloadData];
}

-(void)todayDidTap
{
    self.tasks = [NSMutableArray arrayWithArray:[[ApplicationManager tasksApplicationManager] allTasksForToday]];;
    self.title = @"Today";
    self.boxType = KSBoxTypeToday;
    self.category=nil;
    [self removeSegmentControl];
    [self.currentBoxItem setTintColor:[UIColor colorWithRed:145.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0]];
    self.currentBoxItem=self.toolbarItems[1];
    [self.currentBoxItem setTintColor:[UIColor colorWithRed:39.0/255.0 green:69.0/255.0 blue:83.0/255.0 alpha:1.0]];
    if(!self.navigationItem.rightBarButtonItem)
    {
        UIBarButtonItem * addButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTaskTapped)];
        self.navigationItem.rightBarButtonItem=addButton;
    }
    [self.tableView reloadData];
}

-(void)tomorrowDidTap
{
    self.tasks = [NSMutableArray arrayWithArray:[[ApplicationManager tasksApplicationManager] allTasksForTomorrow]];
    self.title = @"Tomorrow";
    self.boxType = KSBoxTypeTomorrow;
    self.category=nil;
    [self removeSegmentControl];
    [self.currentBoxItem setTintColor:[UIColor colorWithRed:145.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0]];
    self.currentBoxItem=self.toolbarItems[3];
    [self.currentBoxItem setTintColor:[UIColor colorWithRed:39.0/255.0 green:69.0/255.0 blue:83.0/255.0 alpha:1.0]];
    if(!self.navigationItem.rightBarButtonItem)
    {
        UIBarButtonItem * addButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTaskTapped)];
        self.navigationItem.rightBarButtonItem=addButton;
    }
    [self.tableView reloadData];
}

-(void)weekDidTap
{
    self.tasks = [NSMutableArray arrayWithArray:[[ApplicationManager tasksApplicationManager] allTasksForWeek]];
    self.title = @"Week";
    self.category=nil;
    self.boxType = KSBoxTypeWeek;
    [self removeSegmentControl];
    [self.currentBoxItem setTintColor:[UIColor colorWithRed:145.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0]];
    self.currentBoxItem=self.toolbarItems[5];
    [self.currentBoxItem setTintColor:[UIColor colorWithRed:39.0/255.0 green:69.0/255.0 blue:83.0/255.0 alpha:1.0]];
    if(!self.navigationItem.rightBarButtonItem)
    {
        UIBarButtonItem * addButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTaskTapped)];
        self.navigationItem.rightBarButtonItem=addButton;
    }
    [self.tableView reloadData];
}

-(void)backLogDidTap
{
    self.tasks = [NSMutableArray arrayWithArray:[[ApplicationManager tasksApplicationManager] allTasksForBacklog]];
    self.title = @"Backlog";
    self.category=nil;
    self.boxType = KSBoxTypeBacklog;
    [self removeSegmentControl];
    [self.currentBoxItem setTintColor:[UIColor colorWithRed:145.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0]];
    self.currentBoxItem=self.toolbarItems[7];
    [self.currentBoxItem setTintColor:[UIColor colorWithRed:39.0/255.0 green:69.0/255.0 blue:83.0/255.0 alpha:1.0]];
    if(!self.navigationItem.rightBarButtonItem)
    {
        UIBarButtonItem * addButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTaskTapped)];
        self.navigationItem.rightBarButtonItem=addButton;
    }
    [self.tableView reloadData];
}

-(void)archiveDidTap
{
    self.tasks = [NSMutableArray arrayWithArray:[self completedTasks:[[ApplicationManager tasksApplicationManager] allTasksForArchive]]];
    self.title = @"Archive";
    self.category=nil;
    self.boxType = KSBoxTypeArchive;
    [self addSegmentControl];
    [self.currentBoxItem setTintColor:[UIColor colorWithRed:145.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0]];
    self.currentBoxItem=self.toolbarItems[9];
    [self.currentBoxItem setTintColor:[UIColor colorWithRed:39.0/255.0 green:69.0/255.0 blue:83.0/255.0 alpha:1.0]];
    if(self.navigationItem.rightBarButtonItem)
    {
        self.navigationItem.rightBarButtonItem=nil;
    }
    [self.tableView reloadData];
}

-(NSArray*) completedTasks:(NSArray*)array
{
    NSMutableArray* tasks = [NSMutableArray array];
    for(BaseTask* t in array)
        if(t.status) [tasks addObject:t];
    return tasks;
}

-(NSArray*) overdueTasks:(NSArray*)array
{
    NSMutableArray* tasks = [NSMutableArray array];
    for(BaseTask* t in array)
        if(!t.status) [tasks addObject:t];
    return tasks;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
