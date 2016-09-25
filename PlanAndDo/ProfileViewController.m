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

@interface ProfileViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic)NSArray<NSString *> * items;
@property (nonatomic)NSString * userName;
@property (nonatomic)KSProfileState state;
@end

@implementation ProfileViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"KSSettingsCell"owner:self options:nil];
    KSSettingsCell * cell=[nib objectAtIndex:0];
    cell.textLabel.text=self.items[indexPath.row];
    cell.textLabel.textColor=[UIColor colorWithRed:98.0/255.0 green:98.0/255.0 blue:98.0/255.0 alpha:1.0];
    
    if(indexPath.row==0)
    {
        cell.paramValueLabel.text=self.userName;
        cell.imageView.image=[UIImage imageNamed:@"name"];
    }
    else if(indexPath.row==1)
    {
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.paramValueLabel.text=@"************";
        cell.imageView.image=[UIImage imageNamed:@"password"];
    }
    else if(indexPath.row==2)
    {
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.paramValueLabel.text=@"example@gmail.com";
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
        UIAlertController * alertController=[UIAlertController alertControllerWithTitle:@"Change name" message:@"Test" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:nil];
        UIAlertAction * okAction=[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
        {
            self.userName=alertController.textFields.firstObject.text;
        }];
        
        [alertController addAction:okAction];
        [self.parentViewController presentViewController:alertController animated:YES completion:nil];
    }
    else if(indexPath.row==1)
    {

    }
    else if(indexPath.row==2)
    {

    }
    else if(indexPath.row==3)
    {
        //delete all tasks
        UIAlertController * alertController=[UIAlertController alertControllerWithTitle:@"Delete all tasks and categories" message:@"If you remove all categories and tasks, you will be returned to factory settings. Do you want to continue?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cancelAction=[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                                  {
                                  }];
        UIAlertAction * continueAction=[UIAlertAction actionWithTitle:@"Continue" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action)
        {
            UIAlertController * alertController=[UIAlertController alertControllerWithTitle:@"Enter password" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addTextFieldWithConfigurationHandler:nil];
            UIAlertAction * cancelAction=[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction * deleteAction=[UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action)
            {
                //delete all if password correct !
                //alertController.textFields.firstObject.text
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
        [self dismissViewControllerAnimated:YES completion:nil];
    }
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
    self.userName=@"John Doe";
    UIBarButtonItem * menuButton=[[UIBarButtonItem alloc] initWithImage:[UIImage imageWithImage:[UIImage imageNamed:@"Menu"] scaledToSize:CGSizeMake(40, 40)] style:UIBarButtonItemStyleDone target:self action:@selector(menuTapped)];
    self.navigationItem.leftBarButtonItem=menuButton;
    
    self.title=@"Profile";
    self.items=[NSArray arrayWithObjects:@"Name",@"Password",@"Email",@"Delete all tasks and categories",@"Log out", nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];//
    // Dispose of any resources that can be recreated.
}


@end
