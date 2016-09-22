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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    cell.textLabel.textColor=[UIColor colorWithRed:145.0/255.0 green:145.0/255.0  blue:145.0/255.0  alpha:1.0];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    switch (indexPath.row)
    {
        case 0:
            cell.textLabel.text=self.headerText;
            cell.accessoryType=UITableViewCellAccessoryNone;
            break;
        case 1:
            cell.textLabel.text=@"Category";
            break;
        case 2:
            if([self.task isKindOfClass:[KSTask class]])
            {
                cell.textLabel.text=@"Description";
                cell.accessoryType=UITableViewCellAccessoryNone;
            }
            else
            {
                cell.textLabel.text=@"Edit list";
            }
            break;
        case 3:
            cell.textLabel.text=@"Date & Time";
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
    self.textField=[[UITextField alloc] initWithFrame:CGRectMake(15, 6, self.view.bounds.size.width-32, 31)];
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
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:descController] animated:YES completion:nil];
    }
}

-(void)dateTimeDidTap
{
    DateAndTimeViewController * controller = [[DateAndTimeViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}



-(void)doneTapped
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)cancelTapped
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    
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
