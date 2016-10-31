//
//  ProfileViewController.m
//  PlanAndDo
//
//  Created by Student on 9/23/16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIImage+ACScaleImage.h"
#import "AMSideBarViewController.h"
#import "ChangeEmailViewController.h"
#import "ApplicationManager.h"
#import "LoginViewController.h"
#import "TabletasksViewController.h"
#import "FileManager.h"
#import "NewPasswordViewController.h"

@interface ProfileViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic)NSArray<NSString *> * items;
@property (nonatomic)KSAuthorisedUser * user;
@property (nonatomic)KSProfileState state;
@property (nonatomic)BOOL isLoginPresented;
@end

@implementation ProfileViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(void)reloadData
{
    self.user = [ApplicationManager sharedApplication].userApplicationManager.authorisedUser;
    [super reloadData];
}

-(void)refreshDidSwipe
{
    self.user = [ApplicationManager sharedApplication].userApplicationManager.authorisedUser;
    [super refreshDidSwipe];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"KSSettingsCell"owner:self options:nil];
//    KSSettingsCell * cell=[nib objectAtIndex:0];
    UITableViewCell * cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.textLabel.text=self.items[indexPath.row];
    cell.textLabel.textColor=[UIColor colorWithRed:CLR_PROFILE_TEXTLABEL green:CLR_PROFILE_TEXTLABEL blue:CLR_PROFILE_TEXTLABEL alpha:CLR_PROFILE_TEXTLABEL_ALPHA];
    
    if(indexPath.row==0)
    {
        cell.detailTextLabel.text=self.user.userName;
        cell.imageView.image=[UIImage imageNamed:@"name"];
    }
    else if(indexPath.row==1)
    {
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        NSMutableString * stars=[NSMutableString string];
        NSString * pass=[FileManager readPassFromFile];
        for(NSUInteger i=0;i<pass.length; ++i)
        {
            [stars appendFormat:@"*"];
        }
        cell.detailTextLabel.text=stars;
        cell.imageView.image=[UIImage imageNamed:@"password"];
    }
    else if(indexPath.row==2)
    {
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.text=self.user.emailAdress;
        cell.imageView.image=[UIImage imageNamed:@"email"];
    }
    else if(indexPath.row==3)
    {
        cell.imageView.image=[UIImage imageNamed:@"delete"];
    }
    else
    {
        cell.imageView.image=[UIImage imageNamed:@"log out"];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row==0)
    {
        UIAlertController * alertController=[UIAlertController alertControllerWithTitle:TL_PROFILE_CHANGE_NAME_TITLE message:TL_PROFILE_CHANGE_NAME_MSG preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField)
        {
            textField.text=self.user.userName;
        }];
        UIAlertAction * okAction=[UIAlertAction actionWithTitle:TL_OK style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                                  {
                                      if(alertController.textFields.firstObject.text.length)
                                      {
                                          self.user.userName=alertController.textFields.firstObject.text;
                                          [[ApplicationManager sharedApplication].userApplicationManager updateUser:self.user completion:nil];
                                          [self.tableView reloadData];
                                      }
                                  }];
        
        [alertController addAction:okAction];
        [self.parentViewController presentViewController:alertController animated:YES completion:nil];
    }
    else if(indexPath.row==1)
    {
        NewPasswordViewController * newPassViewController=[self.baseStoryboard instantiateViewControllerWithIdentifier:@"NewPasswordViewController"];
        if(newPassViewController)
        {
            newPassViewController.title=@"New password";
            [self.navigationController pushViewController:newPassViewController animated:YES];
        }
    }
    else if(indexPath.row==2)
    {
        ChangeEmailViewController * changeEmail=[self.baseStoryboard instantiateViewControllerWithIdentifier:@"ChangeEmailViewController"];
        if(changeEmail)
        {
            [self.navigationController pushViewController:changeEmail animated:YES];
        }
    }
    else if(indexPath.row==3)
    {
        //delete all tasks
        UIAlertController * alertController=[UIAlertController alertControllerWithTitle:TL_PROFILE_DELETE_TITLE message:TL_PROFILE_DELETE_MSG preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cancelAction=[UIAlertAction actionWithTitle:TL_CANCEL style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction * continueAction=[UIAlertAction actionWithTitle:TL_CONTINUE style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action)
                                        {
                                            UIAlertController * alertController=[UIAlertController alertControllerWithTitle:TL_ENTER_PASSWORD message:@"" preferredStyle:UIAlertControllerStyleAlert];
                                            [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField)
                                            {
                                                textField.secureTextEntry=YES;
                                            }];
                                            UIAlertAction * cancelAction=[UIAlertAction actionWithTitle:TL_CANCEL style:UIAlertActionStyleCancel handler:nil];
                                            UIAlertAction * deleteAction=[UIAlertAction actionWithTitle:TL_DELETE style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action)
                                                                          {
                                                                              if([alertController.textFields.firstObject.text isEqualToString:[FileManager readPassFromFile]])
                                                                              {
                                                                                  [[ApplicationManager sharedApplication].notificationManager cancelAllNotifications];
                                                                                  [self.navigationController.parentViewController.view addSubview:self.loadContentView];
                                                                                  NSArray * tasks=[ApplicationManager sharedApplication].tasksApplicationManager.allTasks;
                                                                                  for(BaseTask * task in tasks)
                                                                                  {
                                                                                      [[ApplicationManager sharedApplication].tasksApplicationManager deleteTask:task completion:nil];
                                                                                  }
                                                                                  
                                                                                  __block NSUInteger categoryCount=0;
                                                                                  NSArray * categories=[ApplicationManager sharedApplication].categoryApplicationManager.allCategories;
                                                                                  for(KSCategory * category in categories)
                                                                                  {
                                                                                     if(![category.name isEqualToString:@"Personal"] &&
                                                                                        ![category.name isEqualToString:@"Shopping"] &&
                                                                                        ![category.name isEqualToString:@"Work"])
                                                                                     {
                                                                                         
                                                                                        [[NSNotificationCenter defaultCenter] postNotificationName:@"CategoryIsDeleted" object:category];
                                                                                      [[ApplicationManager sharedApplication].categoryApplicationManager deleteCateroty:category completion:^(bool completed)
                                                                                       {
                                                                                           
                                                                                           if(completed)
                                                                                           {
                                                                                              ++categoryCount;
                                                                                              if(categoryCount==categories.count-3)
                                                                                              {
                                                                                                  dispatch_async(dispatch_get_main_queue(), ^
                                                                                                  {                                                                                                  [self.loadContentView removeFromSuperview];
                                                                                                  });
                                                                                              }
                                                                                           }
                                                                                           else
                                                                                           {
                                                                                               dispatch_async(dispatch_get_main_queue(), ^
                                                                                                {                                                                                                  [self.loadContentView removeFromSuperview];
                                                                                                });
                                                                                           }
                                                                                       }];
                                                                                     }
                                                                                  }
                                                                                  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                                                                                  {
                                                                                      if(self.loadContentView.superview)
                                                                                      {
                                                                                          [self.loadContentView removeFromSuperview];
                                                                                      }
                                                                                  });
                                                                                  [self.tableView reloadData];
                                                                              }
                                                                              else
                                                                              {
                                                                                  UIAlertController * alertController=[UIAlertController alertControllerWithTitle:@"Error" message:@"Incorrect password" preferredStyle:UIAlertControllerStyleAlert];
                                                                                  UIAlertAction * cancelAction=[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
                                                                                  [alertController addAction:cancelAction];
                                                                                  [self.parentViewController presentViewController:alertController animated:YES completion:nil];
                                                                              }
                                                                                  
                                                                          }];
                                            [alertController addAction:cancelAction];
                                            [alertController addAction:deleteAction];
                                            
                                            [self.parentViewController presentViewController:alertController animated:YES completion:nil];
                                        }];
        [alertController addAction:cancelAction];
        [alertController addAction:continueAction];
        [self.parentViewController presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        [[ApplicationManager sharedApplication].userApplicationManager logout] ;
        LoginViewController * login=[self.baseStoryboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:login] animated:YES completion:^
         {
             TabletasksViewController * tasksViewController=[[TabletasksViewController alloc] init];
             UINavigationController * navi=[[UINavigationController alloc] initWithRootViewController:tasksViewController];
             if([[UIDevice currentDevice].model isEqualToString:@"iPad"])
             {
                 KSSplitViewController * spliter=(KSSplitViewController *)self.navigationController.parentViewController;
                 spliter.details=navi;
             }
             else
             {
                 AMSideBarViewController * sider=(AMSideBarViewController *)self.navigationController.parentViewController;
                 [sider setNewFrontViewController:navi];
             }
         }];

    }
}

-(void) refreshData:(NSNotification*)not
{
    [self.tableView reloadData];
}

-(void)menuTapped
{
    AMSideBarViewController * sider=(AMSideBarViewController *)self.navigationController.parentViewController;
    [sider side];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:NC_EMAIL_CHANGED object:nil];

    self.user = [ApplicationManager sharedApplication].userApplicationManager.authorisedUser;
    UIBarButtonItem * menuButton=[[UIBarButtonItem alloc] initWithImage:[UIImage imageWithImage:[UIImage imageNamed:@"Menu"] scaledToSize:CGSizeMake(40, 40)] style:UIBarButtonItemStyleDone target:self action:@selector(menuTapped)];
    self.navigationItem.leftBarButtonItem=menuButton;
    
    self.title=NM_PROFILE;
    self.items=[NSArray arrayWithObjects:@"Name",@"Password",@"Email",@"Delete all tasks and categories",@"Log out", nil];
    
    if([[UIDevice currentDevice].model isEqualToString:@"iPad"])
    {
        self.navigationItem.leftBarButtonItem=nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];//
    // Dispose of any resources that can be recreated.
}


@end
