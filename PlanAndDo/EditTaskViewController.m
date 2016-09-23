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
            cell.paramNameLabel.text=self.headerText;
            cell.accessoryType=UITableViewCellAccessoryNone;
            break;
        case 1:
            cell.paramNameLabel.text=@"Category";
            break;
        case 2:
            if([self.task isKindOfClass:[KSTask class]])
            {
                cell.paramNameLabel.text=@"Description";
            }
            else
            {
                cell.paramNameLabel.text=@"Edit list";
            }
            break;
        case 3:
            cell.paramNameLabel.text=@"Date & Time";
            break;
    }
    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if(textField.text.length)
    {
        self.headerText=textField.text;
    }
    else
    {
        self.headerText=@"Head";
    }
    [self.tableView reloadData];
    [textField removeFromSuperview];
    return YES;
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
        [self.slider setThumbImage:[UIImage imageNamed:@"white ball"] forState:UIControlStateNormal];
        //self.slider.backgroundColor=[UIColor redColor];
    }
    else if(self.slider.value>=0.5 && self.slider.value<1.5)
    {
        self.slider.value=1.0;
        self.priorityDescLabel.text=@"mid";
        [self.slider setThumbImage:[UIImage imageNamed:@"green ball"] forState:UIControlStateNormal];
    }
    else
    {
        self.slider.value=2.0;
        self.priorityDescLabel.text=@"high";
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
    self.textField.text=[self.headerText isEqualToString:@"Head"]?@"":self.headerText;
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
    if(self.segment.selectedSegmentIndex)
    {
        TaskListViewController * tasksViewController =[[TaskListViewController alloc] init];
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
        
        [[ApplicationManager tasksApplicationManager] updateTask:realTask];
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
    
    self.completionTime = self.task.completionTime;
    if([self.task isKindOfClass:[KSTask class]]) self.taskDesc = ((KSTask*)self.task).taskDescription;
    self.category = [[ApplicationManager categoryApplicationManager] categoryWithId:self.task.categoryID];
    
    switch (self.task.priority) {
        case KSTaskDefaultPriority: self.slider.value = 0; break;
        case KSTaskHighPriority: self.slider.value = 1; break;
        case KSTaskVeryHighPriority: self.slider.value = 2; break;
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
    priorityLable.text=@"Priority";
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
    self.priorityDescLabel.text=@"low";
    self.priorityDescLabel.font=[UIFont systemFontOfSize:10.0];
    self.priorityDescLabel.center=[self getThumbCenter:self.slider];
    self.priorityDescLabel.textColor=[UIColor colorWithRed:145.0/255.0 green:145.0/255.0  blue:145.0/255.0  alpha:1.0];
    [footerPriorityView addSubview:priorityLable];
    [footerPriorityView addSubview:self.slider];
    [footerPriorityView addSubview:self.priorityDescLabel];
    self.tableView.tableFooterView=footerPriorityView;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    
    self.methods=[NSArray arrayWithObjects:@"headDidTap",@"categoryDidTap",@"listOrDescriptionDidTap",@"dateTimeDidTap", nil];
}


@end
