//
//  KSIPadViewController.m
//  PlanAndDo
//
//  Created by Амин on 14.10.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "KSIPadViewController.h"

@interface KSIPadViewController ()

@end

@implementation KSIPadViewController

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [super searchBarCancelButtonClicked:searchBar];

}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar;
{
    [super searchBarShouldBeginEditing:searchBar];
    self.tap.enabled=YES;
    self.pan.enabled=YES;
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    [self gestureRecognizerAction];
//    if([self.addCategoryTextField isFirstResponder])
//    {
//        [self.addCategoryTextField resignFirstResponder];
//        self.parentController.hiden=NO;
//        [UIView animateWithDuration:0.5 animations:^
//         {
//             self.searchBar.frame=CGRectMake(8, 8, 255, 30);
//             self.addCategoryButton.frame=CGRectMake(233, 0, 30, 30);
//         }];
//        self.addCategoryTextField.text=@"";
//    }
    return YES;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger result;
    if(self.state!=KSBaseMenuStateSearch)
    {
        if(section==0)
        {
            result = 5;
        }
        else if(section==1)
        {
            result = self.categories.count;
        }
        else
        {
            result = 2;
        }
    }
    else
    {
        result = self.tableTasks.count;
    }
    return result;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.backgroundColor=[UIColor colorWithRed:32.0/255.0 green:45.0/255.0 blue:52.0/255.0 alpha:1.0];
    cell.textLabel.textColor=[UIColor whiteColor];
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:57.0/255.0 green:75.0/255.0 blue:86.0/255.0 alpha:1.0];
    [cell setSelectedBackgroundView:bgColorView];
    
    if(self.state==KSBaseMenuStateSearch)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"KSTaskCell"owner:self options:nil];
        TaskTableViewCell * cell=nib[0];
        cell.backgroundColor=[UIColor colorWithRed:32.0/255.0 green:45.0/255.0 blue:52.0/255.0 alpha:1.0];
        cell.taskTimeLabel.backgroundColor=[UIColor colorWithRed:32.0/255.0 green:45.0/255.0 blue:52.0/255.0 alpha:1.0];
        
        cell.taskTimeLabel.textColor=[UIColor whiteColor];
        cell.taskDateLabel.textColor=[UIColor whiteColor];
        cell.taskHeaderLabel.textColor=[UIColor whiteColor];
        cell.taskPriorityLabel.textColor=[UIColor redColor];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        
        [cell setSelectedBackgroundView:bgColorView];
        
        BaseTask* task = self.tableTasks[indexPath.row];
        
        cell.leftButtons = @[[MGSwipeButton buttonWithTitle:TL_COMPLETE backgroundColor:[UIColor colorWithRed:39.0/255.0 green:174.0/255.0 blue:97.0/255.0 alpha:1.0] callback:^BOOL(MGSwipeTableCell *sender)
                              {
                                  NSLog(TL_COMPLETE);
                                  task.status = YES;
                                  [[ApplicationManager tasksApplicationManager] updateTask:task completion:nil];
                                  [self.allTasks removeObject:task];
                                  [self.tableTasks removeObject:task];
                                  [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
                                  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                      [tableView reloadData];
                                  });
                                  return YES;
                              }]];
        cell.leftSwipeSettings.transition = MGSwipeDirectionLeftToRight;
        
        cell.rightButtons = @[[MGSwipeButton buttonWithTitle:TL_DELETE backgroundColor:[UIColor redColor] callback:^BOOL(MGSwipeTableCell *sender) {
            NSLog(TL_DELETE);
            
            
            if([task isKindOfClass:[KSTaskCollection class]])
            {
                KSTaskCollection* col = (KSTaskCollection*)task;
                for(KSShortTask* sub in [[ApplicationManager subTasksApplicationManager] allSubTasksForTask:col])
                    [[ApplicationManager subTasksApplicationManager] deleteSubTask:sub forTask:col completion:nil];
            }
            
            
            [[ApplicationManager tasksApplicationManager] deleteTask:task completion:nil];
            [self.allTasks removeObject:task];
            [self.tableTasks removeObject:task];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                           {
                               [tableView reloadData];
                           });
            
            return YES;
        }]];
        
        cell.rightSwipeSettings.transition = MGSwipeDirectionRightToLeft;
        cell.taskHeaderLabel.text = task.name;
        
        switch (task.priority)
        {
            case KSTaskDefaultPriority:
                cell.taskPriorityLabel.text = NM_PRIORITY_LONG_LOW;
                cell.taskPriorityLabel.textColor=[UIColor colorWithRed:145.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0];
                break;
            case KSTaskHighPriority:
                cell.taskPriorityLabel.text = NM_PRIORITY_LONG_MID;
                cell.taskPriorityLabel.textColor=[UIColor colorWithRed:245.0/255.0 green:166.0/255.0 blue:35.0/255.0 alpha:1.0];
                break;
            case KSTaskVeryHighPriority:
                cell.taskPriorityLabel.text = NM_PRIORITY_LONG_HIGH;
                cell.taskPriorityLabel.textColor=[UIColor colorWithRed:241.0/255.0 green:17.0/255.0 blue:44.0/255.0 alpha:1.0];
                break;
        }
        
        
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:task.completionTime];
        NSDateComponents *currentComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:[NSDate date]];
        NSDateComponents *tomorrowComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:[NSDate dateWithTimeIntervalSince1970:[NSDate date].timeIntervalSince1970 + 86400]];
        
        NSString * date;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale=[NSLocale systemLocale];
        if(currentComponents.day==components.day&&currentComponents.month==components.month&&currentComponents.year==components.year)
        {
            date=@"Today";
            cell.taskDateLabel.text = date;
        }
        else if(tomorrowComponents.day==components.day&&tomorrowComponents.month==components.month&&tomorrowComponents.year==components.year)
        {
            date=@"Tomorrow";
            cell.taskDateLabel.text = date;
        }
        else
        {
            date=[ApplicationManager settingsApplicationManager].settings.dateFormat;
            [dateFormatter setDateFormat:date];
            cell.taskDateLabel.text = [dateFormatter stringFromDate:task.completionTime];
        }
        
        [dateFormatter setDateFormat:[ApplicationManager settingsApplicationManager].settings.timeFormat];
        cell.taskTimeLabel.text = [dateFormatter stringFromDate:task.completionTime];
        return cell;
    }
    else
    {
        if(indexPath.section==0)
        {
            UIImage * boxImage;
            switch (indexPath.row)
            {
                case 0:
                    boxImage=[UIImage imageWithImage:[UIImage imageNamed:NM_TODAY] scaledToSize:CGSizeMake(BAR_BUTTON_SIZE_WIDTH, BAR_BUTTON_SIZE_HEIGHT)];
                    boxImage = [boxImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                    cell.textLabel.text=NM_TODAY;
                    cell.imageView.image=boxImage;
                    [cell.imageView setTintColor:[UIColor whiteColor]];
                    break;
                case 1:
                    boxImage=[UIImage imageWithImage:[UIImage imageNamed:NM_TOMORROW] scaledToSize:CGSizeMake(BAR_BUTTON_SIZE_WIDTH+10, BAR_BUTTON_SIZE_HEIGHT)];
                    boxImage = [boxImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                    cell.textLabel.text=NM_TOMORROW;
                    cell.imageView.image=boxImage;
                    [cell.imageView setTintColor:[UIColor whiteColor]];
                    break;
                case 2:
                    boxImage=[UIImage imageWithImage:[UIImage imageNamed:NM_WEEK] scaledToSize:CGSizeMake(BAR_BUTTON_SIZE_WIDTH, BAR_BUTTON_SIZE_HEIGHT)];
                    boxImage = [boxImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                    cell.textLabel.text=NM_WEEK;
                    cell.imageView.image=boxImage;
                    [cell.imageView setTintColor:[UIColor whiteColor]];
                    break;
                case 3:
                    boxImage=[UIImage imageWithImage:[UIImage imageNamed:NM_BACKLOG] scaledToSize:CGSizeMake(BAR_BUTTON_SIZE_WIDTH, BAR_BUTTON_SIZE_HEIGHT)];
                    boxImage = [boxImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                    cell.textLabel.text=NM_BACKLOG;
                    cell.imageView.image=boxImage;
                    [cell.imageView setTintColor:[UIColor whiteColor]];
                    break;
                case 4:
                    boxImage=[UIImage imageWithImage:[UIImage imageNamed:NM_ARCHIVE] scaledToSize:CGSizeMake(BAR_BUTTON_SIZE_WIDTH, BAR_BUTTON_SIZE_HEIGHT)];
                    boxImage = [boxImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                    cell.textLabel.text=NM_ARCHIVE;
                    cell.imageView.image=boxImage;
                    [cell.imageView setTintColor:[UIColor whiteColor]];
                    break;
            }
        }
        else if(indexPath.row<=self.categories.count && indexPath.section==1)
        {
            UILabel * label=[[UILabel alloc] initWithFrame:CGRectMake(55, 8, 100, 30)];
            label.textColor=[UIColor whiteColor];
            label.text=[self.categories[indexPath.row] name];
            [cell addSubview:label];
        }
        else if(indexPath.section==2)
        {
            if(indexPath.row==0)
            {
                cell.textLabel.text=NM_PROFILE;
                cell.imageView.image=[UIImage imageNamed:NM_PROFILE];
            }
            else
            {
                cell.textLabel.text=NM_SETTINGS;
                cell.imageView.image=[UIImage imageNamed:NM_SETTINGS];
            }
            
            cell.backgroundColor=[UIColor colorWithRed:38.0/255.0 green:53.0/255.0 blue:61.0/255.0 alpha:1.0];
        }
    }
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardWillHide:(NSNotification*) not
{
    self.tap.enabled=NO;
    self.pan.enabled=NO;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
