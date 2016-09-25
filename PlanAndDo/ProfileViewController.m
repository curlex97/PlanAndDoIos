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

@interface ProfileViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (nonatomic)NSArray<NSString *> * items;
@property (nonatomic)NSString * userName;
@end

@implementation ProfileViewController

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.tableView reloadData];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.userName=textField.text;
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell=[[UITableViewCell alloc] init];
    cell.textLabel.text=self.items[indexPath.row];
    cell.textLabel.textColor=[UIColor colorWithRed:98.0/255.0 green:98.0/255.0 blue:98.0/255.0 alpha:1.0];
    UILabel * label=[[UILabel alloc] initWithFrame:CGRectMake(cell.bounds.size.width-140, 0, 200, cell.bounds.size.height)];
    label.textColor=[UIColor colorWithRed:98.0/255.0 green:98.0/255.0 blue:98.0/255.0 alpha:1.0];
    

    
    if(indexPath.row==0)
    {
        label.text=self.userName;
        label.textAlignment=NSTextAlignmentRight;
        [cell setAccessoryView:label];
    }
    else if(indexPath.row==1)
    {
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        label.text=@"************";
        label.textAlignment=NSTextAlignmentRight;
        [cell setAccessoryView:label];
    }
    else if(indexPath.row==2)
    {
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        label.text=@"example@gmail.com";
        label.textAlignment=NSTextAlignmentRight;
        [cell setAccessoryView:label];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row==0)
    {
        UIAlertController * alertController=[UIAlertController alertControllerWithTitle:@"Change name" message:@"Test" preferredStyle:UIAlertControllerStyleAlert];
//        UITextField * nameField=[[UITextField alloc] initWithFrame:CGRectMake(8, 0, alertController.view.bounds.size.width-8, 30)];
//        nameField.backgroundColor=[UIColor blackColor];
//        [alertController.view addSubview:nameField];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField)
         {
             textField.delegate=self;
//             dispatch_async(dispatch_get_main_queue(), ^
//             {
//                 [[self.tableView cellForRowAtIndexPath:indexPath] setNeedsLayout];
//             });
         }];
        UIAlertAction * okAction=[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                                      {
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
