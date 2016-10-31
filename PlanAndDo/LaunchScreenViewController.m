//
//  LaunchScreenViewController.m
//  PlanAndDo
//
//  Created by Student on 10/5/16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "LaunchScreenViewController.h"
#import "TabletasksViewController.h"
#import "ApplicationManager.h"
#import "FileManager.h"
#import "AMSideBarViewController.h"
#import "KSMenuViewController.h"
#import "LoginViewController.h"
#import "KSApplicationColor.h"
#import "KSIPhoneMenuViewController.h"
#import "KSSplitViewController.h"
#import "KSIPadViewController.h"
#import "EditTaskViewController.h"

@interface LaunchScreenViewController ()

@end

@implementation LaunchScreenViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
//                           {
                               [[ApplicationManager sharedApplication].userApplicationManager loginWithEmail:[FileManager readUserEmailFromFile] andPassword:[FileManager readPassFromFile] completion:^(bool status)
                                {
                                    if(status)
                                    {
                                        [[ApplicationManager sharedApplication].syncApplicationManager syncWithCompletion:^(BOOL completed)
                                         {
                                             dispatch_async(dispatch_get_main_queue(), ^
                                                            {
                                                                [self showmainPage];
                                                            });
                                         }];
                                    }
                                    else
                                    {
                                        dispatch_async(dispatch_get_main_queue(), ^
                                                       {
                                                           [self showmainPage];
                                                       });
                                    }
                                }];
//                           });


}

-(void)showmainPage
{
    TabletasksViewController * tasks=[[TabletasksViewController alloc] init];
    UINavigationController * navi=[[UINavigationController alloc] initWithRootViewController:tasks];
    
    CAGradientLayer * gradient=[KSApplicationColor sharedColor].rootGradient;
    CGFloat height = navi.navigationBar.frame.size.height+[UIApplication sharedApplication].statusBarFrame.size.height;
    gradient.frame=CGRectMake(0, 0, [UIApplication sharedApplication].statusBarFrame.size.width, height);
    
    UIGraphicsBeginImageContext([gradient frame].size);
    
    [gradient renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    outputImage = [outputImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1, 0, 1) resizingMode:UIImageResizingModeStretch];
    [[UINavigationBar appearance] setBackgroundImage:outputImage forBarMetrics:UIBarMetricsDefault];
    
    if(self.options && [ApplicationManager sharedApplication].userApplicationManager.authorisedUser.emailAdress.length!=0)
    {
        EditTaskViewController * editTaskVC=[[EditTaskViewController alloc] init];
        editTaskVC.title = TL_EDIT;
        editTaskVC.task = [[ApplicationManager sharedApplication].tasksApplicationManager taskWithId:[[self.options objectForKey:@"ID"] intValue]];
        [navi pushViewController:editTaskVC animated:NO];
        if([[UIDevice currentDevice].model isEqualToString:@"iPad"])
        {
            KSIPadViewController * menu=[[KSIPadViewController alloc] init];
            tasks.delegate=menu;
            KSSplitViewController * split=[[KSSplitViewController alloc] initWithMenuVC:menu andDetailsVC:navi];
            [UIApplication sharedApplication].keyWindow.rootViewController=split;
            [ApplicationManager registerUserNotifications];
            [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
        }
        else
        {
            KSIPhoneMenuViewController * menu=[[KSIPhoneMenuViewController alloc] init];
            tasks.delegate=menu;
            AMSideBarViewController * tableTaskViewController=[AMSideBarViewController sideBarWithFrontVC:navi andBackVC:menu];
            [UIApplication sharedApplication].keyWindow.rootViewController=tableTaskViewController;
            [ApplicationManager registerUserNotifications];
            [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
        }
        return;
    }
    
    if([ApplicationManager sharedApplication].userApplicationManager.authorisedUser.emailAdress.length==0)
    {
        NSString * name=[[UIDevice currentDevice].model isEqualToString:@"iPad"]?@"IPad":@"Main";
        LoginViewController * login=[[UIStoryboard storyboardWithName:name bundle:nil] instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [navi pushViewController:login animated:NO];
    }
    
    if([[UIDevice currentDevice].model isEqualToString:@"iPad"])
    {
        KSIPadViewController * menu=[[KSIPadViewController alloc] init];
        tasks.delegate=menu;
        KSSplitViewController * split=[[KSSplitViewController alloc] initWithMenuVC:menu andDetailsVC:navi];
        [UIApplication sharedApplication].keyWindow.rootViewController=split;
        [ApplicationManager registerUserNotifications];
        [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
    }
    else
    {
        KSIPhoneMenuViewController * menu=[[KSIPhoneMenuViewController alloc] init];
        tasks.delegate=menu;
        AMSideBarViewController * tableTaskViewController=[AMSideBarViewController sideBarWithFrontVC:navi andBackVC:menu];
    
        [UIApplication sharedApplication].keyWindow.rootViewController=tableTaskViewController;
        [ApplicationManager registerUserNotifications];
        [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
