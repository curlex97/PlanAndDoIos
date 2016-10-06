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
@interface LaunchScreenViewController ()

@end

@implementation LaunchScreenViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                           {
                               [[ApplicationManager userApplicationManager] loginWithEmail:[FileManager readUserEmailFromFile] andPassword:[FileManager readPassFromFile] completion:^(bool status)
                                {
                                    if(status)
                                    {
                                        [[ApplicationManager syncApplicationManager] syncWithCompletion:^(BOOL completed)
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
                           });


}

-(void)showmainPage
{
    TabletasksViewController * tasks=[[TabletasksViewController alloc] init];
    UINavigationController * navi=[[UINavigationController alloc] initWithRootViewController:tasks];
    AMSideBarViewController * tableTaskViewController=[AMSideBarViewController sideBarWithFrontVC:navi andBackVC:[[KSMenuViewController alloc] init]];
    tableTaskViewController.title=NM_TODAY;
    //[loginNavi addChildViewController:tableTaskViewController];
    //[login showViewController:tableTaskViewController sender:login];
    //[loginNavi.view addSubview:tableTaskViewController.view];
//    LoginViewController * login=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginViewController"];
    if([ApplicationManager userApplicationManager].authorisedUser.emailAdress.length==0)
    {
        LoginViewController * login=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [navi pushViewController:login animated:NO];
    }
    [self presentViewController:tableTaskViewController animated:NO completion:nil];
    //[tableTaskViewController t:[[UINavigationController alloc] initWithRootViewController:login] animated:NO completion:nil];
    //[tableTaskViewController reloadInputViews];
    
    //[login presentViewController:tableTaskViewController animated:NO completion:nil];
    //dispatch_semaphore_wait(s, DISPATCH_TIME_FOREVER);
    //[self.window makeKeyAndVisible];
    NSLog(@"111");
    //    [login presentViewController:tableTaskViewController animated:NO completion:^
    //     {
    //         dispatch_semaphore_signal(s);
    //     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

@end
