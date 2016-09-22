//
//  ApplicationManager.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 21.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "ApplicationManager.h"

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

@end
