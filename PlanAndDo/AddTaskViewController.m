//
//  AddTaskViewController.m
//  PlanAndDo
//
//  Created by Амин on 14.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "AddTaskViewController.h"
#import "PriorityCell.h"
#import "SelectCategoryViewController.h"
#import "DescriptionViewController.h"
#import "TaskListViewController.h"
#import "DateAndTimeViewController.h"
#import "KSSettingsCell.h"
#import "ApplicationManager.h"
#import "UIImage+ACScaleImage.h"

@interface AddTaskViewController ()
@property (nonatomic)UISegmentedControl * segment;
@property (nonatomic)UILabel * priorityDescLabel;
@property (nonatomic)UISlider * slider;
@property (nonatomic)UIPanGestureRecognizer * pan;
@property (nonatomic)float lastValue;
@property (nonatomic)NSArray * methods;
@property (nonatomic)UITextField * textField;
@property (nonatomic)NSString * headerText;
@property int Id;
@end

@implementation AddTaskViewController

#define THUMB_WIDTH 40
#define THUMB_HEIGHT 41

-(instancetype)initWithCategory:(KSCategory *)category andDate:(NSDate *)date
{
    if(self=[super init])
    {
        self.category=category;
        self.completionTime=date;
    }
    return self;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"KSSettingsCell"owner:self options:nil];
    KSSettingsCell * cell=[nib objectAtIndex:0];
    
    cell.textLabel.textColor=[UIColor colorWithRed:145.0/255.0 green:145.0/255.0  blue:145.0/255.0  alpha:1.0];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    switch (indexPath.row)
    {
        case 0:
            cell.textLabel.text=self.headerText;
            cell.accessoryType=UITableViewCellAccessoryNone;
            break;
        case 1:
            cell.textLabel.text=NM_CATEGORY;
            cell.paramValueLabel.text = self.category.name;
            break;
        case 3:
            if(self.segment.selectedSegmentIndex==0)
            {
                cell.textLabel.text=@"Description";
                cell.paramValueLabel.text = self.taskDesc;
                cell.accessoryType=UITableViewCellAccessoryNone;
            }
            else
            {
                cell.textLabel.text=@"Edit list";
                cell.paramValueLabel.text = [NSString stringWithFormat:@"%lu tasks", (unsigned long)self.subTasks.count];
            }
            break;
        case 2:
            cell.textLabel.text=@"Date & Time";
            NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:self.completionTime];
            NSDateComponents *currentComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:[NSDate date]];
            NSDateComponents *tomorrowComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:[NSDate dateWithTimeIntervalSince1970:[NSDate date].timeIntervalSince1970 + 86400]];
            
            NSString * date;
            
            if(currentComponents.day==components.day&&currentComponents.month==components.month&&currentComponents.year==components.year)
            {
                date=@"Today";
            }
            else if(tomorrowComponents.day==components.day&&tomorrowComponents.month==components.month&&tomorrowComponents.year==components.year)
            {
                date=@"Tomorrow";
            }
            else
            {
                date=[NSString stringWithFormat:@"%li/%li/%li", (long)components.day,(long)components.month,(long)components.year];
            }
            cell.paramValueLabel.text = [NSString stringWithFormat:@"%@ %li:%@%li", date, (long)[components hour],[components minute]<10?@"0":@"", (long)[components minute]];
            break;
    }
    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self.tableView reloadData];
    [textField removeFromSuperview];
    return YES;
}

- (void)headTextFieldDidChange:(id)sender
{
    self.headerText=self.textField.text.length ? self.textField.text : NM_TASK_HEAD;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SEL selector = NSSelectorFromString(self.methods[indexPath.row]);
    ((void (*)(id, SEL))[self methodForSelector:selector])(self, selector);
}

-(CGPoint)getThumbCenter:(UISlider *)slider
{
    CGRect trackRect = [slider trackRectForBounds:slider.frame];
    CGRect thumbRect = [slider thumbRectForBounds:slider.frame
                                        trackRect:trackRect
                                            value:slider.value];
    
    return CGPointMake(thumbRect.origin.x+18, slider.frame.origin.y+40);
}

-(void)sliderDidSlide:(UISlider *)slider
{
    if(self.slider.value<0.5)
    {
        self.slider.value=0.0;
        self.priorityDescLabel.text=@"low";
        UIImage * image=[UIImage imageNamed:@"white ball"];
        [self.slider setThumbImage:[UIImage imageWithImage:image scaledToSize:CGSizeMake(THUMB_WIDTH, THUMB_HEIGHT)] forState:UIControlStateNormal];
        //self.slider.backgroundColor=[UIColor redColor];
    }
    else if(self.slider.value>=0.5 && self.slider.value<1.5)
    {
        self.slider.value=1.0;
        self.priorityDescLabel.text=@"mid";
        [self.slider setThumbImage:[UIImage imageWithImage:[UIImage imageNamed:@"green ball"] scaledToSize:CGSizeMake(THUMB_WIDTH, THUMB_HEIGHT)] forState:UIControlStateNormal];
    }
    else
    {
        self.slider.value=2.0;
        self.priorityDescLabel.text=@"high";
        [self.slider setThumbImage:[UIImage imageWithImage:[UIImage imageNamed:@"red ball"] scaledToSize:CGSizeMake(THUMB_WIDTH, THUMB_HEIGHT)] forState:UIControlStateNormal];
    }
    self.priorityDescLabel.center=[self getThumbCenter:self.slider];
    NSLog(@"%f",slider.value);
}

-(void)segmentDidTap
{
    [self.tableView reloadData];
}

-(void)headDidTap
{
    UITableViewCell * cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    self.textField=[[UITextField alloc] initWithFrame:cell.textLabel.frame];
    self.textField.backgroundColor=[UIColor whiteColor];
    self.textField.textColor=[UIColor colorWithRed:145.0/255.0 green:145.0/255.0  blue:145.0/255.0  alpha:1.0];
    self.textField.delegate=self;
    [self.textField addTarget:self action:@selector(headTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.textField.text=[self.headerText isEqualToString:NM_TASK_HEAD]?@"":self.headerText;
    [self.textField becomeFirstResponder];
    [cell addSubview:self.textField];
}

-(void)categoryDidTap
{
    SelectCategoryViewController * categorySelect=[[SelectCategoryViewController alloc] init];
    categorySelect.parentController = self;
    categorySelect.selectedCategory=self.category;
    [self.navigationController pushViewController:categorySelect animated:YES];
}

-(void)listOrDescriptionDidTap
{
    if(self.segment.selectedSegmentIndex)
    {
        TaskListViewController * tasksViewController =[[TaskListViewController alloc] init];
        KSTaskCollection* realTask = [[KSTaskCollection alloc] init];
        realTask.ID = self.Id;
        tasksViewController.subTasks = [NSMutableArray arrayWithArray:self.subTasks];
        tasksViewController.task = realTask;
        tasksViewController.parentController = self;
        [self.navigationController pushViewController:tasksViewController animated:YES];
    }
    else
    {
        DescriptionViewController * descController=[[DescriptionViewController alloc] init];
        descController.parentController = self;
        descController.text = self.taskDesc;
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:descController] animated:YES completion:nil];
    }
}

-(void)dateTimeDidTap
{
    DateAndTimeViewController * controller = [[DateAndTimeViewController alloc] init];
    controller.completionTime = self.completionTime;
    controller.parentController = self;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void) addSegmentControl
{
    self.segment =[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:NM_TASK_HEAD,NM_TASK_LIST, nil]];
    self.segment.tintColor=[UIColor colorWithRed:39.0/255.0 green:69.0/255.0 blue:83.0/255.0 alpha:1.0];
    [self.segment setSelectedSegmentIndex:0];
    self.segment.frame=CGRectMake(0, 0, 300.0, 29.0);
    [self.segment addTarget:self action:@selector(segmentDidTap) forControlEvents:UIControlEventValueChanged];
    
    UIView * segmentBackgroundView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 500, 46)];
    [segmentBackgroundView addSubview:self.segment];
    
    //segmentBackgroundView.translatesAutoresizingMaskIntoConstraints=NO;
    self.segment.translatesAutoresizingMaskIntoConstraints=NO;
    [segmentBackgroundView addConstraint:[NSLayoutConstraint
                                                  constraintWithItem:self.segment
                                                  attribute:NSLayoutAttributeCenterX
                                                  relatedBy:NSLayoutRelationEqual
                                                  toItem:segmentBackgroundView
                                                  attribute:NSLayoutAttributeCenterX
                                                  multiplier:1.0f
                                                  constant:0.0]];
    
    [segmentBackgroundView addConstraint:[NSLayoutConstraint
                                                  constraintWithItem:self.segment
                                                  attribute:NSLayoutAttributeCenterY
                                                  relatedBy:NSLayoutRelationEqual
                                                  toItem:segmentBackgroundView
                                                  attribute:NSLayoutAttributeCenterY
                                                  multiplier:1.0f
                                                  constant:0.0]];
    
    self.tableView.tableHeaderView=segmentBackgroundView;
}

-(void) removeSegmentControl
{
    self.tableView.tableHeaderView = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSDate *now = [NSDate date];
    self.Id = -1*now.timeIntervalSince1970;
    [self.tableView reloadData];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.headerText=NM_TASK_HEAD;
    self.title=NM_ADD_TASK;
    if(!self.completionTime)
    {
        self.completionTime = [NSDate date];
    }
    
    [self.refresh removeFromSuperview];
    
    UIBarButtonItem * doneItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneDidTap)];
    doneItem.tintColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = doneItem;
    
    UIView * footerPriorityView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 56)];
    UILabel * priorityLable=[[UILabel alloc] initWithFrame:CGRectMake(15, 17, 62, 21)];
    priorityLable.text=NM_PRIORITY;
    priorityLable.textColor=[UIColor colorWithRed:145.0/255.0 green:145.0/255.0  blue:145.0/255.0  alpha:1.0];
    self.slider=[[UISlider alloc] initWithFrame:CGRectMake(100, 12, self.tableView.bounds.size.width-110, 31)];
    self.slider.minimumValue=0.0;
    self.slider.maximumValue=2.0;
    self.slider.value=0.0;
    self.slider.minimumTrackTintColor=[UIColor colorWithRed:145.0/255.0 green:145.0/255.0  blue:145.0/255.0  alpha:1.0];
    [self.slider addTarget:self action:@selector(sliderDidSlide:) forControlEvents:UIControlEventValueChanged];
    [self.slider setThumbImage:[UIImage imageWithImage:[UIImage imageNamed:@"white ball"] scaledToSize:CGSizeMake(THUMB_WIDTH, THUMB_HEIGHT)] forState:UIControlStateNormal];
    self.lastValue=self.slider.value;
    
    self.priorityDescLabel=[[UILabel alloc] initWithFrame:CGRectMake(100, 43, 23, 13)];
    self.priorityDescLabel.text=NM_PRIORITY_SHORT_LOW;
    self.priorityDescLabel.font=[UIFont systemFontOfSize:10.0];
    self.priorityDescLabel.center=[self getThumbCenter:self.slider];
    self.priorityDescLabel.textColor=[UIColor colorWithRed:145.0/255.0 green:145.0/255.0  blue:145.0/255.0  alpha:1.0];
    self.priorityDescLabel.textAlignment=NSTextAlignmentCenter;
    
    [footerPriorityView addSubview:priorityLable];
    [footerPriorityView addSubview:self.slider];
    [footerPriorityView addSubview:self.priorityDescLabel];
    self.tableView.tableFooterView=footerPriorityView;
    [self addSegmentControl];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    
    self.methods=[NSArray arrayWithObjects:@"headDidTap",@"categoryDidTap",@"dateTimeDidTap",@"listOrDescriptionDidTap", nil];
}

-(void)doneDidTap
{
    if(self.segment.selectedSegmentIndex == 0)
    {
        KSTaskPriority priority = KSTaskDefaultPriority;
        
        switch ((int)self.slider.value) {
            case 0:priority = KSTaskDefaultPriority; break;
            case 1: priority = KSTaskHighPriority; break;
            case 2: priority = KSTaskVeryHighPriority; break;
        }
        
        
        KSTask* task = [[KSTask alloc] initWithID:self.Id  andName:self.headerText andStatus:NO andTaskReminderTime:self.completionTime andTaskPriority:priority andCategoryID:(int)self.category.ID andCreatedAt:[NSDate date] andCompletionTime:self.completionTime andSyncStatus:(int)(-1*self.Id) andTaskDescription:self.taskDesc];
        [[ApplicationManager tasksApplicationManager] addTask: task completion:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:NC_TASK_ADD object:task];
    }
    
    
    else
    {
        KSTaskPriority priority = KSTaskDefaultPriority;
        
        switch ((int)self.slider.value) {
            case 0:priority = KSTaskDefaultPriority; break;
            case 1: priority = KSTaskHighPriority; break;
            case 2: priority = KSTaskVeryHighPriority; break;
        }
        

        
        KSTaskCollection* task = [[KSTaskCollection alloc] initWithID:self.Id andName:self.headerText andStatus:NO andTaskReminderTime:self.completionTime andTaskPriority:priority andCategoryID:(int)self.category.ID andCreatedAt:[NSDate date] andCompletionTime:self.completionTime andSyncStatus:(int)self.Id andSubTasks:[NSMutableArray arrayWithArray:self.subTasks]];
        
        
        for(KSShortTask* subTask in [[ApplicationManager subTasksApplicationManager] allSubTasksForTask:task]) [[ApplicationManager subTasksApplicationManager] deleteSubTask:subTask forTask:task completion:nil];
        
        for(KSShortTask* subTask in self.subTasks) [[ApplicationManager subTasksApplicationManager] addSubTask:subTask forTask:task completion:nil];
        
        [[ApplicationManager tasksApplicationManager] addTask: task completion:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:NC_TASK_ADD object:task];
    }
    
//    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
//    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:3];
//    localNotification.alertBody = @"Your alert message";
//    localNotification.timeZone = [NSTimeZone defaultTimeZone];
//    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
