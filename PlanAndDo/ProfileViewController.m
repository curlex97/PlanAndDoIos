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
#import "KSSettingsCell.h"
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
    [[ApplicationManager syncApplicationManager] syncUserWithCompletion:^(bool completed)
    {
        if(completed)
        {
            self.user = [[ApplicationManager userApplicationManager] authorisedUser];
            [super reloadData];
        }
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"KSSettingsCell"owner:self options:nil];
    KSSettingsCell * cell=[nib objectAtIndex:0];
    cell.textLabel.text=self.items[indexPath.row];
    cell.textLabel.textColor=[UIColor colorWithRed:CLR_PROFILE_TEXTLABEL green:CLR_PROFILE_TEXTLABEL blue:CLR_PROFILE_TEXTLABEL alpha:CLR_PROFILE_TEXTLABEL_ALPHA];
    
    if(indexPath.row==0)
    {
        cell.paramValueLabel.text=self.user.userName;
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
        cell.paramValueLabel.text=stars;
        cell.imageView.image=[UIImage imageNamed:@"password"];
    }
    else if(indexPath.row==2)
    {
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.paramValueLabel.text=self.user.emailAdress;
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
        [alertController addTextFieldWithConfigurationHandler:nil];
        UIAlertAction * okAction=[UIAlertAction actionWithTitle:TL_OK style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                                  {
                                      self.user.userName=alertController.textFields.firstObject.text;
                                      [[ApplicationManager userApplicationManager] updateUser:self.user completion:nil];
                                      [self.tableView reloadData];
                                  }];
        
        [alertController addAction:okAction];
        [self.parentViewController presentViewController:alertController animated:YES completion:nil];
    }
    else if(indexPath.row==1)
    {
        NewPasswordViewController * newPassViewController=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NewPasswordViewController"];
        if(newPassViewController)
        {
            [self.navigationController pushViewController:newPassViewController animated:YES];
        }
    }
    else if(indexPath.row==2)
    {
        ChangeEmailViewController * changeEmail=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChangeEmailViewController"];
        
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
                                            [alertController addTextFieldWithConfigurationHandler:nil];
                                            UIAlertAction * cancelAction=[UIAlertAction actionWithTitle:TL_CANCEL style:UIAlertActionStyleCancel handler:nil];
                                            UIAlertAction * deleteAction=[UIAlertAction actionWithTitle:TL_DELETE style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action)
                                                                          {
                                                                              if(/* DISABLES CODE */ (NO))
                                                                              {
                                                                                  [ApplicationManager cleanLocalDataBase];
                                                                                  [self.tableView reloadData];
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
        [[ApplicationManager userApplicationManager] logout];
        LoginViewController * login=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:login] animated:YES completion:^
         {
             TabletasksViewController * tasksViewController=[[TabletasksViewController alloc] init];
             UINavigationController * navi=[[UINavigationController alloc] initWithRootViewController:tasksViewController];
             AMSideBarViewController * sider=(AMSideBarViewController *)self.navigationController.parentViewController;
             [sider setNewFrontViewController:navi];
         }];

//        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:login] animated:YES completion:^
//         {

        
//         }];
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

    self.user = [[ApplicationManager userApplicationManager] authorisedUser];
    UIBarButtonItem * menuButton=[[UIBarButtonItem alloc] initWithImage:[UIImage imageWithImage:[UIImage imageNamed:@"Menu"] scaledToSize:CGSizeMake(40, 40)] style:UIBarButtonItemStyleDone target:self action:@selector(menuTapped)];
    self.navigationItem.leftBarButtonItem=menuButton;
    
    self.title=NM_PROFILE;
    self.items=[NSArray arrayWithObjects:@"Name",@"Password",@"Email",@"Delete all tasks and categories",@"Log out", nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];//
    // Dispose of any resources that can be recreated.
}


@end
