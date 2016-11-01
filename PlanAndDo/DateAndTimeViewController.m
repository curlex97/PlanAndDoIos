//
//  DateAndTimeViewController.m
//  PlanAndDo
//
//  Created by Амин on 15.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "DateAndTimeViewController.h"
#import "NSDate+LocalTime.h"

@interface DateAndTimeViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic)UIDatePicker * dateTimePicker;
@property (nonatomic)UIToolbar * toolBar;
@property (nonatomic)DateAndTimeState state;
@property (nonatomic)NSDate * taskDate;
@property (nonatomic)NSDate * reminderDate;
@property (nonatomic)UITextField * nilTextField;
@property (nonatomic)UISwitch * recallSwitch;
@end

@implementation DateAndTimeViewController

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(void)swicthDidChanged
{
    if(self.recallSwitch.on)
    {
        self.nilTextField=[[UITextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [self.nilTextField setInputView:self.dateTimePicker];
        [self.nilTextField setInputAccessoryView:self.toolBar];
        [self.view addSubview:self.nilTextField];
        self.state=DateAndTimeStateRecall;
        self.dateTimePicker.datePickerMode=UIDatePickerModeCountDownTimer;
        self.dateTimePicker.minuteInterval=15;
        self.dateTimePicker.minimumDate=[NSDate dateWithTimeIntervalSince1970:0];
        self.dateTimePicker.timeZone=[NSTimeZone timeZoneWithAbbreviation:@"UTC"];
        self.dateTimePicker.date=self.reminderDate;
        [self.nilTextField becomeFirstResponder];
    }
    else
    {
        self.reminderDate=[NSDate dateWithTimeIntervalSince1970:0];
        [self doneButtonDidTap];
    }
        [self.tableView reloadData];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    if(indexPath.row==0)
    {
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:self.taskDate];
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
            NSDateFormatter * dateFormater=[[NSDateFormatter alloc] init];
            [dateFormater setDateFormat:@"d MMMM, yyyy"];
            date=[dateFormater stringFromDate:self.taskDate];
        }
        cell.textLabel.text = date;
        cell.textLabel.textColor=[UIColor colorWithRed:45.0/255.0 green:45.0/255.0 blue:45.0/255.0 alpha:1.0];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%li:%@%li", (long)[components hour],[components minute]<10?@"0":@"", [components minute]];
    }
    else
    {
        if(!self.recallSwitch.on)
        {
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        NSCalendar * calendar=[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
        calendar.timeZone=[NSTimeZone timeZoneWithAbbreviation:@"UTC"];
        NSDateComponents *components = [calendar components:NSCalendarUnitHour | NSCalendarUnitMinute fromDate:self.reminderDate];
        cell.textLabel.text=self.recallSwitch.on?@"Recall up to":@"Recall";
        cell.textLabel.textColor=self.recallSwitch.on?[UIColor colorWithRed:45.0/255.0 green:45.0/255.0 blue:45.0/255.0 alpha:1.0]:[UIColor colorWithRed:145.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0];
        
        cell.detailTextLabel.text=self.recallSwitch.on?[NSString stringWithFormat:@"%li hours %@%li min", (long)[components hour],[components minute]<10?@"0":@"", [components minute]]:@"";
        cell.textLabel.textColor=self.recallSwitch.on?[UIColor colorWithRed:45.0/255.0 green:45.0/255.0 blue:45.0/255.0 alpha:1.0]:[UIColor colorWithRed:145.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0];
        
        cell.accessoryView=self.recallSwitch;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.nilTextField=[[UITextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self.nilTextField setInputView:self.dateTimePicker];
    [self.nilTextField setInputAccessoryView:self.toolBar];
    [self.view addSubview:self.nilTextField];
    if(indexPath.row==0)
    {
        self.state=DateAndTimeStateNormal;
        self.dateTimePicker.datePickerMode=UIDatePickerModeDateAndTime;
        self.dateTimePicker.minuteInterval=1;
        self.dateTimePicker.date=self.taskDate;
        self.dateTimePicker.minimumDate=[NSDate date];
        self.dateTimePicker.timeZone=[NSTimeZone systemTimeZone];
        [self.nilTextField becomeFirstResponder];
    }
    else if(self.recallSwitch.on)
    {
        self.state=DateAndTimeStateRecall;
        self.dateTimePicker.datePickerMode=UIDatePickerModeCountDownTimer;
        self.dateTimePicker.minuteInterval=15;
        self.dateTimePicker.timeZone=[NSTimeZone timeZoneWithAbbreviation:@"UTC"];
        self.dateTimePicker.minimumDate=[NSDate dateWithTimeIntervalSince1970:0];
        self.dateTimePicker.date=self.reminderDate;
        [self.nilTextField becomeFirstResponder];
    }
}

-(void)doneButtonDidTap
{
    if(self.state==DateAndTimeStateNormal)
    {
        self.taskDate=self.dateTimePicker.date;
    }
    else
    {
        self.reminderDate=self.dateTimePicker.date;
        if(self.reminderDate.timeIntervalSince1970==0)
        {
            [self.recallSwitch setOn:NO];
        }
    }
    if(self.taskDate.timeIntervalSince1970<[NSDate date].timeIntervalSince1970 || (self.taskDate.timeIntervalSince1970-self.reminderDate.timeIntervalSince1970<[NSDate date].timeIntervalSince1970 && self.recallSwitch.on))
    {
        UIAlertController * alertController=[UIAlertController alertControllerWithTitle:@"Warning" message:@"Date or reminder time that you select are installed at the past time, you will not notify about this task!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * okAction=[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:okAction];
        [self.navigationController.parentViewController presentViewController:alertController animated:YES completion:nil];
    }
    [self.nilTextField resignFirstResponder];
    [self.nilTextField removeFromSuperview];
    self.nilTextField=nil;
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.title=NM_DATE_AND_TIME;
    self.view.backgroundColor=[UIColor whiteColor];
    
    UIBarButtonItem * doneItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneDidTap)];
    doneItem.tintColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = doneItem;
    
    self.dateTimePicker=[[UIDatePicker alloc] init];
    self.dateTimePicker.datePickerMode=UIDatePickerModeDateAndTime;
    
    self.toolBar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 35)];
    [self.toolBar setTintColor:[UIColor whiteColor]];
    UIBarButtonItem * doneButton=[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonDidTap)];
    [doneButton setTintColor:[UIColor colorWithRed:27.0/255.0 green:69.0/255.0 blue:83.0/255.0 alpha:1.0]];
    UIBarButtonItem * space=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [self.toolBar setItems:@[space, doneButton]];
    
    self.recallSwitch=[[UISwitch alloc] init];
    [self.recallSwitch setOn:self.completionReminderTime.timeIntervalSince1970>self.completionTime.timeIntervalSince1970-200?NO:YES];
    [self.recallSwitch addTarget:self action:@selector(swicthDidChanged) forControlEvents:UIControlEventValueChanged];
    
    self.reminderDate=self.completionReminderTime.timeIntervalSince1970<self.completionTime.timeIntervalSince1970-200?[NSDate dateWithTimeIntervalSince1970:self.completionTime.timeIntervalSince1970-self.completionReminderTime.timeIntervalSince1970]:[NSDate dateWithTimeIntervalSince1970:900];

    self.dateTimePicker.timeZone=[NSTimeZone systemTimeZone];
    [self.refresh removeFromSuperview];
    self.dateTimePicker.date = self.completionTime;
    self.dateTimePicker.minimumDate=[NSDate date];
    self.taskDate=self.completionTime;
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)doneDidTap
{
    if([self.parentController isKindOfClass:[AddTaskViewController class]])
    {
        ((AddTaskViewController*)self.parentController).completionTime = self.taskDate;
        ((AddTaskViewController*)self.parentController).reminderTime = self.recallSwitch.on?[NSDate dateWithTimeIntervalSince1970:self.taskDate.timeIntervalSince1970-self.reminderDate.timeIntervalSince1970]:self.taskDate;
        NSLog(@"%f",self.taskDate.timeIntervalSince1970);
        NSLog(@"%f",((AddTaskViewController*)self.parentController).reminderTime.timeIntervalSince1970);
    }
    
    if([self.parentController isKindOfClass:[EditTaskViewController class]])
    {
        ((EditTaskViewController*)self.parentController).completionTime = self.taskDate;
        ((EditTaskViewController*)self.parentController).reminderTime = self.recallSwitch.on?[NSDate dateWithTimeIntervalSince1970:self.taskDate.timeIntervalSince1970-self.reminderDate.timeIntervalSince1970]:self.taskDate;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
