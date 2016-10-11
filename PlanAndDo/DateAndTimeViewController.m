//
//  DateAndTimeViewController.m
//  PlanAndDo
//
//  Created by Амин on 15.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "DateAndTimeViewController.h"
#import "NSDate+LocalTime.h"

@interface DateAndTimeViewController ()
@property (nonatomic)UIDatePicker * dateTimePicker;
@property (nonatomic)UILabel * dateLabel;
@property (nonatomic)UILabel * timeLabel;
@end

@implementation DateAndTimeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=NM_DATE_AND_TIME;
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.dateLabel=[[UILabel alloc] initWithFrame:CGRectMake(CS_DATELABEL_X, CS_DATELABEL_Y, CS_DATELABEL_WIDTH, CS_DATELABEL_HEIGHT)];
    self.dateLabel.textColor=[UIColor colorWithRed:CLR_DATELABEL green:CLR_DATELABEL blue:CLR_DATELABEL alpha:CLR_DATELABEL_ALPHA];
    self.dateLabel.text=@"Date";
    
    self.timeLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-100, CS_TIMELABEL_Y, CS_TIMELABEL_WIDTH, CS_TIMELABEL_HEIGHT)];
    self.timeLabel.textColor=[UIColor colorWithRed:CLR_DATELABEL green:CLR_DATELABEL blue:CLR_DATELABEL alpha:CLR_DATELABEL_ALPHA];
    self.timeLabel.text=@"Time";
    [self.timeLabel setTextAlignment:NSTextAlignmentRight];
    
    UIBarButtonItem * doneItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneDidTap)];
    doneItem.tintColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = doneItem;
    
    self.dateTimePicker=[[UIDatePicker alloc] init];
    [self.view addSubview:self.dateTimePicker];
    [self.view addSubview:self.dateLabel];
    [self.view addSubview:self.timeLabel];
    
    self.dateTimePicker.translatesAutoresizingMaskIntoConstraints=NO;
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:self.dateTimePicker
                              attribute:NSLayoutAttributeBottom
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeBottom
                              multiplier:CO_MULTIPLER
                              constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:self.dateTimePicker
                              attribute:NSLayoutAttributeTrailing
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeTrailing
                              multiplier:CO_MULTIPLER
                              constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:self.dateTimePicker
                              attribute:NSLayoutAttributeLeading
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeLeading
                              multiplier:CO_MULTIPLER
                              constant:0.0]];
    
    self.timeLabel.translatesAutoresizingMaskIntoConstraints=NO;
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:self.timeLabel
                              attribute:NSLayoutAttributeTrailing
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeTrailing
                              multiplier:CO_MULTIPLER
                              constant:-8.0]];
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:self.timeLabel
                              attribute:NSLayoutAttributeTop
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeTop
                              multiplier:CO_MULTIPLER
                              constant:16.0]];

    self.dateTimePicker.timeZone=[NSTimeZone systemTimeZone];
    [self.dateTimePicker addTarget:self action:@selector(dateTimeValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.dateTimePicker.date = self.completionTime;
    [self dateTimeValueChanged:self.dateTimePicker];
    
}

-(void)dateTimeValueChanged:(UIDatePicker *)dateTimePicker
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:dateTimePicker.date];
    
    self.dateLabel.text = [NSString stringWithFormat:@"%li/%li/%li", (long)[components day], [components month], [components year]];
    self.timeLabel.text = [NSString stringWithFormat:@"%li:%@%li", (long)[components hour],[components minute]<10?@"0":@"", [components minute]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)doneDidTap
{
    if([self.parentController isKindOfClass:[AddTaskViewController class]])
    ((AddTaskViewController*)self.parentController).completionTime = self.dateTimePicker.date;
    
    if([self.parentController isKindOfClass:[EditTaskViewController class]])
        ((EditTaskViewController*)self.parentController).completionTime = self.dateTimePicker.date;
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
