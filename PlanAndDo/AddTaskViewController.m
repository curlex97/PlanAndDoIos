//
//  AddTaskViewController.m
//  PlanAndDo
//
//  Created by Амин on 14.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "AddTaskViewController.h"
#import "PriorityCell.h"

@interface AddTaskViewController ()
@property (nonatomic)UISegmentedControl * segment;
@property (nonatomic)UILabel * priorityDescLabel;
@property (nonatomic)UISlider * slider;
@property (nonatomic)UIPanGestureRecognizer * pan;
@property (nonatomic)float lastValue;
@end

@implementation AddTaskViewController

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    cell.textLabel.textColor=[UIColor colorWithRed:145.0/255.0 green:145.0/255.0  blue:145.0/255.0  alpha:1.0];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    PriorityCell * priorityCell;
    switch (indexPath.row)
    {
        case 0:
            cell.textLabel.text=@"Head";
            break;
        case 1:
            cell.textLabel.text=@"Category";
            break;
        case 2:
            cell.textLabel.text=self.segment.selectedSegmentIndex==0?@"Description":@"Edit list";
            break;
        case 3:
            cell.textLabel.text=@"Date & Time";
            break;
    }
    return cell;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 55;
//}

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
    }
    else if(self.slider.value>=0.5 && self.slider.value<1.5)
    {
        self.slider.value=1.0;
        self.priorityDescLabel.text=@"mid";
    }
    else
    {
        self.slider.value=2.0;
        self.priorityDescLabel.text=@"high";
    }
    self.priorityDescLabel.center=[self getThumbCenter:self.slider];
    NSLog(@"%f",slider.value);
}

-(void)segmentDidTap
{
    [self.tableView reloadData];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    //self.pan=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gesturePan)];
    //self.pan.delegate=self;
    
    self.title=@"Add";
   self.segment =[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Task",@"List", nil]];
    self.segment.tintColor=[UIColor colorWithRed:39.0/255.0 green:69.0/255.0 blue:83.0/255.0 alpha:1.0];
    [self.segment setSelectedSegmentIndex:0];
    self.segment.frame=CGRectMake(20, 8, self.view.bounds.size.width-40, 30);
    [self.segment addTarget:self action:@selector(segmentDidTap) forControlEvents:UIControlEventValueChanged];
    UIView * segmentBackgroundView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 46)];
    [segmentBackgroundView addSubview:self.segment];
    self.tableView.tableHeaderView=segmentBackgroundView;
    
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
}
@end
