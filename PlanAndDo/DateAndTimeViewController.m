//
//  DateAndTimeViewController.m
//  PlanAndDo
//
//  Created by Амин on 15.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "DateAndTimeViewController.h"

@interface DateAndTimeViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic)UIDatePicker * dateTimePicker;
@end

@implementation DateAndTimeViewController

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier=@"reuseble cell";
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    if(indexPath.row==0)
        cell.textLabel.text=@"Date";
    else
        cell.textLabel.text=@"Time";
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"Date & Time";
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
