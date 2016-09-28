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
    self.title=@"Date & Time";
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.dateLabel=[[UILabel alloc] initWithFrame:CGRectMake(8, 0, 120, 50)];
    self.dateLabel.textColor=[UIColor colorWithRed:145.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0];
    self.dateLabel.text=@"Date";
    
    self.timeLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-100, 0, 92, 50)];
    self.timeLabel.textColor=[UIColor colorWithRed:145.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0];
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
                              multiplier:1.0f
                              constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:self.dateTimePicker
                              attribute:NSLayoutAttributeTrailing
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeTrailing
                              multiplier:1.0f
                              constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:self.dateTimePicker
                              attribute:NSLayoutAttributeLeading
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeLeading
                              multiplier:1.0f
                              constant:0.0]];
    
    self.timeLabel.translatesAutoresizingMaskIntoConstraints=NO;
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:self.timeLabel
                              attribute:NSLayoutAttributeTrailing
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeTrailing
                              multiplier:1.0f
                              constant:-8.0]];
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:self.timeLabel
                              attribute:NSLayoutAttributeTop
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeTop
                              multiplier:1.0f
                              constant:16.0]];

    self.dateTimePicker.timeZone=[NSTimeZone localTimeZone];
    [self.dateTimePicker addTarget:self action:@selector(dateTimeValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.dateTimePicker.date = self.completionTime;
    [self dateTimeValueChanged:self.dateTimePicker];
    
}

-(void)dateTimeValueChanged:(UIDatePicker *)dateTimePicker
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:dateTimePicker.date];
    
    self.dateLabel.text = [NSString stringWithFormat:@"%li/%li/%li", [components day], [components month], [components year]];
    self.timeLabel.text = [NSString stringWithFormat:@"%li:%li", [components hour], [components minute]];
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
