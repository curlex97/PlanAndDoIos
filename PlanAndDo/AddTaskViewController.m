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
@property (nonatomic)UILabel * priorityLabel;
@end

@implementation AddTaskViewController

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
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
        default:
            priorityCell=[[[NSBundle mainBundle] loadNibNamed:@"PriorityCell"owner:self options:nil] objectAtIndex:0];
            [priorityCell.prioritySlider addTarget:self action:@selector(sliderDidSlide:) forControlEvents:UIControlEventValueChanged];
            self.priorityLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 25, 13)];
            self.priorityLabel.center=[self getThumbCenter:priorityCell.prioritySlider];
            [priorityCell addSubview:self.priorityLabel];
            cell=priorityCell;
            break;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

-(CGPoint)getThumbCenter:(UISlider *)slider
{
    CGRect trackRect = [slider trackRectForBounds:slider.bounds];
    CGRect thumbRect = [slider thumbRectForBounds:slider.bounds
                                        trackRect:trackRect
                                            value:slider.value];
    
    return CGPointMake(thumbRect.origin.x + slider.frame.origin.x, slider.frame.origin.y - 20);
}

-(void)sliderDidSlide:(UISlider *)slider
{
    
    self.priorityLabel.center =[self getThumbCenter:slider];
    if(slider.value<0.5)
    {
        slider.value=0.0;
        self.priorityLabel.text=@"low";
    }
    else if(slider.value>=0.5 && slider.value<1.5)
    {
        slider.value=1.0;
        self.priorityLabel.text=@"mid";
    }
    else
    {
        slider.value=2.0;
        self.priorityLabel.text=@"high";
    }
    NSLog(@"%f",slider.value);
}

-(void)segmentDidTap
{
    [self.tableView reloadData];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"Add";
   self.segment =[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Task",@"List", nil]];
    self.segment.tintColor=[UIColor colorWithRed:39.0/255.0 green:69.0/255.0 blue:83.0/255.0 alpha:1.0];
    [self.segment setSelectedSegmentIndex:0];
    self.segment.frame=CGRectMake(20, 8, self.view.bounds.size.width-40, 30);
    [self.segment addTarget:self action:@selector(segmentDidTap) forControlEvents:UIControlEventValueChanged];
    UIView * segmentBackgroundView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 46)];
    [segmentBackgroundView addSubview:self.segment];
    self.tableView.tableHeaderView=segmentBackgroundView;
    
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
}
@end
