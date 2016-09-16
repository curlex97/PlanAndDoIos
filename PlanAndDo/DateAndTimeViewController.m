//
//  DateAndTimeViewController.m
//  PlanAndDo
//
//  Created by Амин on 15.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "DateAndTimeViewController.h"

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
    [self.dateTimePicker addTarget:self action:@selector(dateTimeValueChanged:) forControlEvents:UIControlEventValueChanged];
}

-(void)dateTimeValueChanged:(UIDatePicker *)dateTimePicker
{
    NSLog(@"%@",dateTimePicker);
    NSString * pickerDate=[[NSString stringWithFormat:@"%@",dateTimePicker.date] substringToIndex:10];
    if([[pickerDate substringToIndex:10] isEqualToString:[[NSString stringWithFormat:@"%@",[NSDate date]] substringToIndex:10]])
    {
        self.dateLabel.text=@"Today";
    }
    else
    {
        self.dateLabel.text=[pickerDate substringToIndex:10];
    }
    self.timeLabel.text=[[[NSString stringWithFormat:@"%@",dateTimePicker.date] substringFromIndex:10] substringToIndex:6];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
