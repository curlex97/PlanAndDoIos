//
//  KSIPhoneMenuViewController.m
//  PlanAndDo
//
//  Created by Амин on 14.10.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "KSIPhoneMenuViewController.h"

@interface KSIPhoneMenuViewController ()
@property (nonatomic)AMSideBarViewController * parentController;
@property (nonatomic)UITextField * addCategoryTextField;
@property (nonatomic)UIView * addCategoryAccessoryView;
@property (nonatomic)NSLayoutConstraint * accessoryBottom;
@end

@implementation KSIPhoneMenuViewController

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [super searchBarCancelButtonClicked:searchBar];
    self.parentController.hiden=NO;
    [UIView animateWithDuration:0.5 animations:^
     {
         searchBar.frame=CGRectMake(8, 8, 255, 30);
         self.addCategoryButton.frame=CGRectMake(233, 0, 30, 30);
     }];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar;
{
    [super searchBarShouldBeginEditing:searchBar];
    searchBar.frame=CGRectMake(searchBar.frame.origin.x, searchBar.frame.origin.y, [UIScreen mainScreen].bounds.size.width-searchBar.frame.origin.x*2, searchBar.frame.size.height);
    self.parentController.hiden=YES;
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    [self gestureRecognizerAction];
    if([self.addCategoryTextField isFirstResponder])
    {
        [self.addCategoryTextField resignFirstResponder];
        self.parentController.hiden=NO;
        [UIView animateWithDuration:0.5 animations:^
         {
             self.searchBar.frame=CGRectMake(8, 8, 255, 30);
             self.addCategoryButton.frame=CGRectMake(233, 0, 30, 30);
         }];
        self.addCategoryTextField.text=@"";
    }
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.searchBar resignFirstResponder];
    if(self.state==KSBaseMenuStateSearch)
    {
        
        UINavigationController * frontNavigationViewController=(UINavigationController *)self.parentController.frontViewController;
        
        for(UIViewController* child in [frontNavigationViewController childViewControllers])
            [child.navigationController popViewControllerAnimated:YES];
        
        BaseTask* task = self.tableTasks[indexPath.row];
        
        EditTaskViewController* editTaskVC = [[EditTaskViewController alloc] init];
        editTaskVC.title = TL_EDIT;
        editTaskVC.task = task;
        [frontNavigationViewController pushViewController:editTaskVC animated:NO];
        //[self.parentController setNewFrontViewController:[[UINavigationController alloc] initWithRootViewController:[[EditTaskViewController alloc] init]]];
        
        self.parentController.hiden=NO;
        [self.parentController side];
        
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
            [self.parentController setNewFrontViewController:categoryTasksNav];
        }
    }
    
    else if(indexPath.section == 2 && indexPath.row == 1)
    {
        SettingsViewController * settingsViewController=[[SettingsViewController alloc] init];
        
        if(settingsViewController)
        {
            settingsViewController.title=NM_SETTINGS;
            UINavigationController* settingsNav = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
            [self.parentController setNewFrontViewController:settingsNav];
        }
    }
    else
    {
        ProfileViewController * profileViewController=[[ProfileViewController alloc] init];
        
        if(profileViewController)
        {
            UINavigationController* navi = [[UINavigationController alloc] initWithRootViewController:profileViewController];
            [self.parentController setNewFrontViewController:navi];
        }
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if(self.state!=KSBaseMenuStateEdit)
    {
        [[ApplicationManager categoryApplicationManager] addCateroty:[[KSCategory alloc] initWithID:self.categories.lastObject.ID+1 andName:textField.text andSyncStatus:[NSDate date].timeIntervalSince1970] completion:nil];
        self.categories=[NSMutableArray arrayWithArray:[[ApplicationManager categoryApplicationManager] allCategories]];
        textField.text=@"";
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:self.categories.count-1 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
    }
    else
    {
        //KSCategory* cat = self.categories[self.managedIndexPath.row];
        //cat.name=textField.text;
        self.categories[self.managedIndexPath.row].name=textField.text;
        [[ApplicationManager categoryApplicationManager] updateCateroty:self.categories[self.managedIndexPath.row] completion:nil];
        self.categories=[NSMutableArray arrayWithArray:[[ApplicationManager categoryApplicationManager] allCategories]];
        
        self.state=KSBaseMenuStateNormal;
        [self.tableView reloadData];
        textField.text=@"";
    }
    self.parentController.hiden=NO;
    [UIView animateWithDuration:0.5 animations:^
     {
         self.searchBar.frame=CGRectMake(8, 8, 255, 30);
         self.addCategoryButton.frame=CGRectMake(233, 0, 30, 30);
     }];
    
    return YES;
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
        
        if(indexPath.row<=self.categories.count && indexPath.section==1)
        {
            UILabel * label=[[UILabel alloc] initWithFrame:CGRectMake(55, 8, 100, 30)];
            label.textColor=[UIColor whiteColor];
            label.text=[self.categories[indexPath.row] name];
            NSLog(@"%@",self.categories[0].name);
            [cell addSubview:label];
        }
        else if(indexPath.section==2)
        {
            if(indexPath.row==0)
            {
                UIImageView * profileImageView=[[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 30, 30)];
                profileImageView.image=[UIImage imageNamed:NM_PROFILE];
                //[cell addSubview:profileImageView];
                cell.textLabel.text=NM_PROFILE;
                cell.imageView.image=[UIImage imageNamed:NM_PROFILE];
            }
            else
            {
                UIImageView * profileImageView=[[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 30, 30)];
                profileImageView.image=[UIImage imageNamed:NM_SETTINGS];
                //[cell addSubview:profileImageView];
                cell.textLabel.text=NM_SETTINGS;
                cell.imageView.image=[UIImage imageNamed:NM_SETTINGS];
                //tableView.separatorColor=[UIColor colorWithRed:38.0/255.0 green:53.0/255.0 blue:61.0/255.0 alpha:1.0];
            }
            
            cell.backgroundColor=[UIColor colorWithRed:38.0/255.0 green:53.0/255.0 blue:61.0/255.0 alpha:1.0];
        }
    }
    return cell;
}

-(void)longPressDidUsed:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint p = [gestureRecognizer locationInView:self.tableView];
    
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];
    if (indexPath != nil && gestureRecognizer.state == UIGestureRecognizerStateBegan && indexPath.section==1)
    {
        UIAlertController * alertController=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction * deleteAction=[UIAlertAction actionWithTitle:TL_DELETE style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action)
                                      {
                                          UIAlertController * alertController=[UIAlertController alertControllerWithTitle:@"Delete Category" message:@"If you delete a category, delete all the tasks and lists that are in it" preferredStyle:UIAlertControllerStyleAlert];
                                          UIAlertAction * cancelAction=[UIAlertAction actionWithTitle:TL_CANCEL style:UIAlertActionStyleCancel handler:nil];
                                          UIAlertAction * deleteAction=[UIAlertAction actionWithTitle:TL_DELETE style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action)
                                                                        {
                                                                            dispatch_async(dispatch_get_main_queue(), ^
                                                                                           {
                                                                                               UINavigationController * frontNVC=(UINavigationController *)self.parentController.frontViewController;
                                                                                               TabletasksViewController * frontVC=frontNVC.viewControllers.firstObject;
                                                                                               
                                                                                               
                                                                                               for(BaseTask* task in [[ApplicationManager tasksApplicationManager] allTasksForCategory:self.categories[indexPath.row]])
                                                                                               {
                                                                                                   [[ApplicationManager tasksApplicationManager] deleteTask:task completion:nil];
                                                                                               }
                                                                                               
                                                                                               [[ApplicationManager categoryApplicationManager] deleteCateroty:self.categories[indexPath.row] completion:^(bool completed)
                                                                                                {
                                                                                                    if(completed)
                                                                                                    {
                                                                                                        self.categories=[NSMutableArray arrayWithArray:[ApplicationManager categoryApplicationManager].allCategories];
                                                                                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^
                                                                                                                       {
                                                                                                                           [self.tableView reloadData];
                                                                                                                       });
                                                                                                    }
                                                                                                }];
                                                                                               
                                                                                               if(self.categories[indexPath.row].ID==frontVC.category.ID)
                                                                                               {
                                                                                                   SEL selector = NSSelectorFromString(@"todayDidTap");
                                                                                                   ((void (*)(id, SEL))[frontVC methodForSelector:selector])(frontVC, selector);
                                                                                               }
                                                                                               
                                                                                               [self.categories removeObjectAtIndex:indexPath.row];
                                                                                               //self.categories=[NSMutableArray arrayWithArray:[ApplicationManager categoryApplicationManager].allCategories];
                                                                                               [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                                                                                               
                                                                                               
                                                                                               if(self.categories.count==0)
                                                                                               {
                                                                                                   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^
                                                                                                                  {
                                                                                                                      [self.tableView reloadData];
                                                                                                                  });
                                                                                               }
                                                                                           });
                                                                            
                                                                        }];
                                          [alertController addAction:cancelAction];
                                          [alertController addAction:deleteAction];
                                          [self.parentController presentViewController:alertController animated:YES completion:nil];
                                      }];
        
        UIAlertAction * editAction=[UIAlertAction actionWithTitle:TL_EDIT style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                    {
                                        self.addCategoryTextField.text=[self.categories[indexPath.row] name];
                                        self.managedIndexPath=indexPath;
                                        self.state=KSBaseMenuStateEdit;
                                        [self addCategoryDidTap];
                                    }];
        
        UIAlertAction * cancelAction=[UIAlertAction actionWithTitle:TL_CANCEL style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:editAction];
        [alertController addAction:deleteAction];
        [alertController addAction:cancelAction];
        [self.parentController presentViewController:alertController animated:YES completion:nil];
    }
}

-(void)addCategoryDidTap
{
    [self.addCategoryTextField becomeFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.addCategoryAccessoryView=[[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.view.bounds.size.width, 44)];
    self.addCategoryAccessoryView.backgroundColor=[UIColor colorWithRed:32.0/255.0 green:45.0/255.0 blue:52.0/255.0 alpha:1.0];
    self.addCategoryTextField=[[UITextField alloc] initWithFrame:CGRectMake(16, 8, self.navigationController.toolbar.frame.size.width-32, 30)];
    self.addCategoryTextField.borderStyle=UITextBorderStyleRoundedRect;
    self.addCategoryTextField.backgroundColor=[UIColor colorWithRed:227.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1.0];
    self.addCategoryTextField.delegate=self;
    [self.addCategoryAccessoryView addSubview:self.addCategoryTextField];
    
    [self.view addSubview:self.addCategoryAccessoryView];
    self.parentController=(AMSideBarViewController *)self.parentViewController;
    
    self.addCategoryTextField.translatesAutoresizingMaskIntoConstraints=NO;
    [self.addCategoryAccessoryView addConstraint:[NSLayoutConstraint
                                                  constraintWithItem:self.addCategoryTextField
                                                  attribute:NSLayoutAttributeBottom
                                                  relatedBy:NSLayoutRelationEqual
                                                  toItem:self.addCategoryAccessoryView
                                                  attribute:NSLayoutAttributeBottom
                                                  multiplier:1.0f
                                                  constant:-8.0]];
    
    [self.addCategoryAccessoryView addConstraint:[NSLayoutConstraint
                                                  constraintWithItem:self.addCategoryTextField
                                                  attribute:NSLayoutAttributeTop
                                                  relatedBy:NSLayoutRelationEqual
                                                  toItem:self.addCategoryAccessoryView
                                                  attribute:NSLayoutAttributeTop
                                                  multiplier:1.0f
                                                  constant:8.0]];
    
    [self.addCategoryAccessoryView addConstraint:[NSLayoutConstraint
                                                  constraintWithItem:self.addCategoryTextField
                                                  attribute:NSLayoutAttributeTrailing
                                                  relatedBy:NSLayoutRelationEqual
                                                  toItem:self.addCategoryAccessoryView
                                                  attribute:NSLayoutAttributeTrailing
                                                  multiplier:1.0f
                                                  constant:-16.0]];
    
    [self.addCategoryAccessoryView addConstraint:[NSLayoutConstraint
                                                  constraintWithItem:self.addCategoryTextField
                                                  attribute:NSLayoutAttributeLeading
                                                  relatedBy:NSLayoutRelationEqual
                                                  toItem:self.addCategoryAccessoryView
                                                  attribute:NSLayoutAttributeLeading
                                                  multiplier:1.0f
                                                  constant:16.0]];
    
    self.addCategoryAccessoryView.translatesAutoresizingMaskIntoConstraints=NO;
    
    self.accessoryBottom=[NSLayoutConstraint
                          constraintWithItem:self.addCategoryAccessoryView
                          attribute:NSLayoutAttributeBottom
                          relatedBy:NSLayoutRelationEqual
                          toItem:self.view
                          attribute:NSLayoutAttributeBottom
                          multiplier:1.0f
                          constant:44.0];
    [self.view addConstraint:self.accessoryBottom];
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:self.addCategoryAccessoryView
                              attribute:NSLayoutAttributeTrailing
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeTrailing
                              multiplier:1.0f
                              constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:self.addCategoryAccessoryView
                              attribute:NSLayoutAttributeLeading
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeLeading
                              multiplier:1.0f
                              constant:0.0]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuSideRight) name:NC_SIDE_RIGHT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuSideLeft) name:NC_SIDE_LEFT object:nil];

}

-(void)menuSideRight
{
    NSLog(TL_RIGHT);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShown:) name:UIKeyboardWillShowNotification object:nil];
}

-(void)menuSideLeft
{
    NSLog(TL_LEFT);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)keyboardWillHide:(NSNotification*) not
{
    self.tap.enabled=NO;
    self.pan.enabled=NO;
    self.bottom.constant=0.0;
    self.accessoryBottom.constant=45.0;
    [UIView animateWithDuration:1 animations:^
     {
         [self.view layoutIfNeeded];
     } completion:nil];
}

-(void)keyboardWillShown:(NSNotification*) not
{
    self.tap.enabled=YES;
    self.pan.enabled=YES;
    self.parentController.hiden=YES;
    [UIView animateWithDuration:0.5 animations:^
     {
         self.searchBar.frame=CGRectMake(self.searchBar.frame.origin.x, self.searchBar.frame.origin.y, [UIScreen mainScreen].bounds.size.width-self.searchBar.frame.origin.x*2, self.searchBar.frame.size.height);
         self.addCategoryButton.frame=CGRectMake([UIScreen mainScreen].bounds.size.width-self.searchBar.frame.origin.x-30, 0, 30, 30);
     }];
    
    if(self.state!=KSBaseMenuStateSearch)
    {
        NSDictionary * info=[not userInfo];
        NSValue* aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGSize keyboardSize = [aValue CGRectValue].size;
        
        self.accessoryBottom.constant=-keyboardSize.height;
        self.bottom.constant=-keyboardSize.height;
        [UIView animateWithDuration:1 animations:^
         {
             [self.view layoutIfNeeded];
         } completion:nil];
    }
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
