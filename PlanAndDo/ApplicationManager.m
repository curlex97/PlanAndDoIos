//
//  ApplicationManager.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 21.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "ApplicationManager.h"
#import "FileManager.h"
#import "Reachability.h"

@implementation ApplicationManager

+(TasksApplicationManager *)tasksApplicationManager
{
    return [[TasksApplicationManager alloc] init];
}

+(SubTasksApplicationManager *)subTasksApplicationManager
{
    return [[SubTasksApplicationManager alloc] init];
}

+(UserApplicationManager *)userApplicationManager
{
    return [[UserApplicationManager alloc] init];
}

+(SettingsApplicationManager *)settingsApplicationManager
{
    return [[SettingsApplicationManager alloc] init];
}

+(CategoryApplicationManager *)categoryApplicationManager
{
    return [[CategoryApplicationManager alloc] init];
}

+(SyncApplicationManager *)syncApplicationManager
{
    return [[SyncApplicationManager alloc] init];
}

//+(void)startInternetManaging
//{
//    Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(reachabilityChanged:)
//                                                 name:kReachabilityChangedNotification
//                                               object:nil];
//    
//    [reach startNotifier];
//}
//
//+(void)reachabilityChanged:(NSNotification *)not
//{
//    Reachability* reach=[not object];
//    
//    if(reach.isReachableViaWiFi)
//    {
//        [[ApplicationManager syncApplicationManager] syncWithCompletion:nil];
//    }
//    else if(reach.isReachableViaWWAN)
//    {
//        [[ApplicationManager syncApplicationManager] syncWithCompletion:nil];
//    }
//    else
//    {
//        //no internet
//        NSLog(@"%@",reach);
//    }
//    
//    NSLog(@"%@",[UIApplication sharedApplication].keyWindow.rootViewController.childViewControllers.lastObject);
//}

+(void)cleanLocalDataBase
{
    [[[CategoryApplicationManager alloc] init] cleanTable];
    [[[SettingsApplicationManager alloc] init] cleanTable];
    [[[UserApplicationManager alloc] init] cleanTable];
    [[[SubTasksApplicationManager alloc] init] cleanTable];
    [[[TasksApplicationManager alloc] init] cleanTable];
    [FileManager writeTokenToFile:@""];
    [FileManager writeLastSyncTimeToFile:@""];
    [FileManager writeUserEmailToFile:@""];
    [FileManager writePassToFile:@""];
}

@end
