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

-(void)addCategoryDidTap
{
    EditCategoryViewController * editController=[[EditCategoryViewController alloc] init];
    editController.categories=self.categories;
    
    editController.modalPresentationStyle=UIModalPresentationFormSheet;
    [self presentViewController:editController animated:YES completion:nil];
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
        
        if(task.taskReminderTime.timeIntervalSince1970>task.completionTime.timeIntervalSince1970-200)
        {
            [cell.ringImageView setHidden:YES];
        }
        else
        {
            [cell.ringImageView setHidden:NO];
        }
        
        cell.leftButtons = @[[MGSwipeButton buttonWithTitle:TL_COMPLETE backgroundColor:[UIColor colorWithRed:39.0/255.0 green:174.0/255.0 blue:97.0/255.0 alpha:1.0] callback:^BOOL(MGSwipeTableCell *sender)
                              {
                                  [[ApplicationManager sharedApplication].notificationManager cancelNotificationsForKey:[NSString stringWithFormat:@"%d",task.ID]];
                                  task.status = YES;
                                  [[ApplicationManager sharedApplication].tasksApplicationManager updateTask:task completion:nil];
                                  [self.allTasks removeObject:task];
                                  [self.tableTasks removeObject:task];
                                  [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
                                  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                      [tableView reloadData];
                                  });
                                  return YES;
                              }]];
        cell.leftSwipeSettings.transition = MGSwipeDirectionLeftToRight;
        
        cell.rightButtons = @[[MGSwipeButton buttonWithTitle:TL_DELETE backgroundColor:[UIColor redColor] callback:^BOOL(MGSwipeTableCell *sender)
        {
            [[ApplicationManager sharedApplication].notificationManager cancelNotificationsForKey:[NSString stringWithFormat:@"%d",task.ID]];
            
            
            if([task isKindOfClass:[KSTaskCollection class]])
            {
                KSTaskCollection* col = (KSTaskCollection*)task;
                for(KSShortTask* sub in [[ApplicationManager sharedApplication].subTasksApplicationManager allSubTasksForTask:col])
                    [[ApplicationManager sharedApplication].subTasksApplicationManager deleteSubTask:sub forTask:col completion:nil];
            }
            
            
            [[ApplicationManager sharedApplication].tasksApplicationManager deleteTask:task completion:nil];
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
        else if(tomorrowComponents.day==components.day && tomorrowComponents.month==components.month && tomorrowComponents.year==components.year)
        {
            date=@"Tomorrow";
            cell.taskDateLabel.text = date;
        }
        else
        {
            date=[ApplicationManager sharedApplication].settingsApplicationManager.settings.dateFormat;
            [dateFormatter setDateFormat:date];
            cell.taskDateLabel.text = [dateFormatter stringFromDate:task.completionTime];
        }
        
        [dateFormatter setDateFormat:[[ApplicationManager sharedApplication].settingsApplicationManager.settings.timeFormat isEqualToString:@"24"]?@"HH:mm":@"hh:mm"];
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
                    boxImage=[UIImage imageNamed:@"w1"];
                    boxImage = [boxImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                    cell.textLabel.text=NM_TODAY;
                    cell.imageView.image=boxImage;
                    [cell.imageView setTintColor:[UIColor whiteColor]];
                    break;
                case 1:
                    boxImage=[UIImage imageNamed:@"w2"];
                    boxImage = [boxImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                    cell.textLabel.text=NM_TOMORROW;
                    cell.imageView.image=boxImage;
                    [cell.imageView setTintColor:[UIColor whiteColor]];
                    break;
                case 2:
                    boxImage=[UIImage imageNamed:@"w3"];
                    boxImage = [boxImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                    cell.textLabel.text=NM_WEEK;
                    cell.imageView.image=boxImage;
                    [cell.imageView setTintColor:[UIColor whiteColor]];
                    break;
                case 3:
                    boxImage=[UIImage imageNamed:@"w4"];
                    boxImage = [boxImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                    cell.textLabel.text=NM_BACKLOG;
                    cell.imageView.image=boxImage;
                    [cell.imageView setTintColor:[UIColor whiteColor]];
                    break;
                case 4:
                    boxImage=[UIImage imageNamed:@"w5"];
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
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KSSplitViewController * spliter=(KSSplitViewController *)self.parentViewController;
    [self.searchBar resignFirstResponder];
    if(self.state==KSBaseMenuStateSearch)
    {
        for(UIViewController* child in [spliter.details childViewControllers])
            [child.navigationController popViewControllerAnimated:YES];
        
        BaseTask* task = self.tableTasks[indexPath.row];
        
        EditTaskViewController* editTaskVC = [[EditTaskViewController alloc] init];
        editTaskVC.title = TL_EDIT;
        editTaskVC.task = task;
        [spliter.details pushViewController:editTaskVC animated:NO];
    }
    else if(indexPath.section==0)
    {
        TabletasksViewController * categoryTasksViewController=[[TabletasksViewController alloc] init];
        if(categoryTasksViewController)
        {
            categoryTasksViewController.boxType=indexPath.row;
            UINavigationController* categoryTasksNav = [[UINavigationController alloc] initWithRootViewController:categoryTasksViewController];
            spliter.details=categoryTasksNav;
        }
    }
    else if(indexPath.section == 1)
    {
        KSCategory* category = self.categories[indexPath.row];
        TabletasksViewController * categoryTasksViewController=[[TabletasksViewController alloc] init];
        
        if(categoryTasksViewController)
        {
            categoryTasksViewController.title=[category name];
            categoryTasksViewController.category = category;
            UINavigationController* categoryTasksNav = [[UINavigationController alloc] initWithRootViewController:categoryTasksViewController];
            spliter.details=categoryTasksNav;
        }
    }
    
    else if(indexPath.section == 2 && indexPath.row == 1)
    {
        SettingsViewController * settingsViewController=[[SettingsViewController alloc] init];
        
        if(settingsViewController)
        {
            settingsViewController.title=NM_SETTINGS;
            UINavigationController* settingsNav = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
            spliter.details=settingsNav;
        }
    }
    else
    {
        ProfileViewController * profileViewController=[[ProfileViewController alloc] init];
        
        if(profileViewController)
        {
            UINavigationController* navi = [[UINavigationController alloc] initWithRootViewController:profileViewController];
            spliter.details=navi;
        }
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)keyboardWillHide:(NSNotification*) not
{
    self.tap.enabled=NO;
    self.pan.enabled=NO;
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
