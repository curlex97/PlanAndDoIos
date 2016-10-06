//
//  EditTaskViewController.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 20.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "EditTaskViewController.h"
#import "PriorityCell.h"
#import "SelectCategoryViewController.h"
#import "DescriptionViewController.h"
#import "TaskListViewController.h"
#import "DateAndTimeViewController.h"
#import "ApplicationManager.h"
#import "KSSettingsCell.h"
#import "ApplicationManager.h"
#import "AMSideBarViewController.h"

@interface EditTaskViewController ()
@property (nonatomic)UISegmentedControl * segment;
@property (nonatomic)UILabel * priorityDescLabel;
@property (nonatomic)UISlider * slider;
@property (nonatomic)UIPanGestureRecognizer * pan;
@property (nonatomic)float lastValue;
@property (nonatomic)NSArray * methods;
@property (nonatomic)UITextField * textField;
@property (nonatomic)NSString * headerText;
@end

@implementation EditTaskViewController

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
            cell.paramValueLabel.text=self.category.name;
            break;
        case 3:
            if([self.task isKindOfClass:[KSTask class]])
            {
                cell.textLabel.text=NM_DESCRIPTION;
                cell.paramValueLabel.text = self.taskDesc;
            }
            else
            {
                cell.textLabel.text=NM_EDIT_LIST;
                cell.paramValueLabel.text = [NSString stringWithFormat:@"%lu tasks", (unsigned long)self.subTasks.count];
            }
            break;
        case 2:
            cell.textLabel.text=NM_DATE_AND_TIME;
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
                date=[NSString stringWithFormat:@"%li/%li/%li", components.day,components.month,components.year];
            }
            cell.paramValueLabel.text = [NSString stringWithFormat:@"%@ %li:%@%li", date, (long)[components hour],[components minute]<10?@"0":@"", [components minute]];
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
        self.priorityDescLabel.text=NM_PRIORITY_SHORT_LOW;
        [self.slider setThumbImage:[UIImage imageNamed:@"white ball"] forState:UIControlStateNormal];
        //self.slider.backgroundColor=[UIColor redColor];
    }
    else if(self.slider.value>=0.5 && self.slider.value<1.5)
    {
        self.slider.value=1.0;
        self.priorityDescLabel.text=NM_PRIORITY_SHORT_MID;
        [self.slider setThumbImage:[UIImage imageNamed:@"green ball"] forState:UIControlStateNormal];
    }
    else
    {
        self.slider.value=2.0;
        self.priorityDescLabel.text=NM_PRIORITY_SHORT_HIGH;
        [self.slider setThumbImage:[UIImage imageNamed:@"red ball"] forState:UIControlStateNormal];
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
    self.textField=[[UITextField alloc] initWithFrame:CGRectMake(8, 13, self.view.bounds.size.width-32, 31)];
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
    [self.navigationController pushViewController:categorySelect animated:YES];
}

-(void)listOrDescriptionDidTap
{
    if([self.task isKindOfClass:[KSTaskCollection class]])
    {
        TaskListViewController * tasksViewController =[[TaskListViewController alloc] init];
        KSTaskCollection* realTask = (KSTaskCollection*)self.task;
        tasksViewController.subTasks = [NSMutableArray arrayWithArray:self.subTasks];
        tasksViewController.task = realTask;
        tasksViewController.parentController = self;
        [self.navigationController pushViewController:tasksViewController animated:YES];
    }
    else if([self.task isKindOfClass:[KSTask class]])
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}



-(void)doneTapped
{
    if([self.task isKindOfClass:[KSTask class]])
    {
        KSTaskPriority priority = KSTaskDefaultPriority;
        
        switch ((int)self.slider.value) {
            case 0:priority = KSTaskDefaultPriority; break;
            case 1: priority = KSTaskHighPriority; break;
            case 2: priority = KSTaskVeryHighPriority; break;
        }
        
        KSTask* realTask = (KSTask*)self.task;
        realTask.completionTime = self.completionTime;
        realTask.taskDescription = self.taskDesc;
        realTask.categoryID = (int)self.category.ID;
        realTask.priority = priority;
        realTask.name = self.headerText;
        realTask.syncStatus = [[NSDate date] timeIntervalSince1970];
        
        [[ApplicationManager tasksApplicationManager] updateTask:realTask];
        [[NSNotificationCenter defaultCenter] postNotificationName:NC_TASK_EDIT object:realTask];
        
    }
    else if([self.task isKindOfClass:[KSTaskCollection class]])
    {
        KSTaskPriority priority = KSTaskDefaultPriority;
        
        switch ((int)self.slider.value) {
            case 0:priority = KSTaskDefaultPriority; break;
            case 1: priority = KSTaskHighPriority; break;
            case 2: priority = KSTaskVeryHighPriority; break;
        }
        
        KSTaskCollection* realTask = (KSTaskCollection*)self.task;
        realTask.completionTime = self.completionTime;
        realTask.subTasks = [NSMutableArray arrayWithArray:self.subTasks];
        realTask.categoryID = (int)self.category.ID;
        realTask.priority = priority;
        realTask.name = self.headerText;
        realTask.syncStatus = [[NSDate date] timeIntervalSince1970];
        
        for(KSShortTask* subTask in [[ApplicationManager subTasksApplicationManager] allSubTasksForTask:realTask]) [[ApplicationManager subTasksApplicationManager] deleteSubTask:subTask forTask:realTask];
        
        for(KSShortTask* subTask in self.subTasks) [[ApplicationManager subTasksApplicationManager] addSubTask:subTask forTask:realTask];
        
        
        [[ApplicationManager tasksApplicationManager] updateTask:realTask];
        [[NSNotificationCenter defaultCenter] postNotificationName:NC_TASK_EDIT object:realTask];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)cancelTapped
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subTasksChanged:) name:@"EditSubTasksChanged" object:nil];
    
    self.completionTime = self.task.completionTime;
    if([self.task isKindOfClass:[KSTask class]]) self.taskDesc = ((KSTask*)self.task).taskDescription;
    self.category = [[ApplicationManager categoryApplicationManager] categoryWithId:self.task.categoryID];
    
    if([self.task isKindOfClass:[KSTaskCollection class]])
    {
        KSTaskCollection* realTask = (KSTaskCollection*)self.task;
        self.subTasks = [NSMutableArray arrayWithArray:[[ApplicationManager subTasksApplicationManager] allSubTasksForTask:realTask]];
    }
    
    self.headerText = self.task.name;
    
    //self.pan=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gesturePan)];
    //self.pan.delegate=self;
    
    self.headerText=[self.task name];
    
    UIBarButtonItem * doneButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneTapped)];
    self.navigationItem.rightBarButtonItem=doneButton;
    
    UIBarButtonItem * cancelButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelTapped)];
    self.navigationItem.leftBarButtonItem=cancelButton;
    
    UIView * footerPriorityView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 56)];
    UILabel * priorityLable=[[UILabel alloc] initWithFrame:CGRectMake(15, 17, 62, 21)];
    priorityLable.text=NM_PRIORITY;
    priorityLable.textColor=[UIColor colorWithRed:145.0/255.0 green:145.0/255.0  blue:145.0/255.0  alpha:1.0];
    self.slider=[[UISlider alloc] initWithFrame:CGRectMake(100, 12, self.view.bounds.size.width-110, 31)];
    self.slider.minimumValue=0.0;
    self.slider.maximumValue=2.0;
    self.slider.value=0.0;
    self.slider.minimumTrackTintColor=[UIColor colorWithRed:145.0/255.0 green:145.0/255.0  blue:145.0/255.0  alpha:1.0];
    [self.slider addTarget:self action:@selector(sliderDidSlide:) forControlEvents:UIControlEventValueChanged];
    [self.slider setThumbImage:[UIImage imageNamed:@"white ball"] forState:UIControlStateNormal];
    self.lastValue=self.slider.value;
    
    self.priorityDescLabel=[[UILabel alloc] initWithFrame:CGRectMake(100, 43, 23, 13)];
    self.priorityDescLabel.text=NM_PRIORITY_SHORT_LOW;
    self.priorityDescLabel.font=[UIFont systemFontOfSize:10.0];
    self.priorityDescLabel.center=[self getThumbCenter:self.slider];
    self.priorityDescLabel.textColor=[UIColor colorWithRed:145.0/255.0 green:145.0/255.0  blue:145.0/255.0  alpha:1.0];
    [footerPriorityView addSubview:priorityLable];
    [footerPriorityView addSubview:self.slider];
    [footerPriorityView addSubview:self.priorityDescLabel];
    self.tableView.tableFooterView=footerPriorityView;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    
    switch (self.task.priority)
    {
        case KSTaskDefaultPriority: self.slider.value = 0; break;
        case KSTaskHighPriority: self.slider.value = 1; break;
        case KSTaskVeryHighPriority: self.slider.value = 2; break;
    }
    [self sliderDidSlide:self.slider];
    
    self.methods=[NSArray arrayWithObjects:@"headDidTap",@"categoryDidTap",@"dateTimeDidTap",@"listOrDescriptionDidTap", nil];
}


@end
