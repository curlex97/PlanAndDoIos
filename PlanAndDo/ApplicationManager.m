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

static ApplicationManager * applicationInstance;

+(ApplicationManager *)sharedApplication
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^
                  {
                      applicationInstance=[[ApplicationManager alloc] init];
                  });
    return applicationInstance;
}

-(TasksApplicationManager *)tasksApplicationManager
{
    if(_tasksApplicationManager)
    {
        return _tasksApplicationManager;
    }
    _tasksApplicationManager=[[TasksApplicationManager alloc] init];
    return _tasksApplicationManager;
}

-(SubTasksApplicationManager *)subTasksApplicationManager
{
    if(_subTasksApplicationManager)
    {
        return _subTasksApplicationManager;
    }
    _subTasksApplicationManager=[[SubTasksApplicationManager alloc] init];;
    return _subTasksApplicationManager;
}

-(UserApplicationManager *)userApplicationManager
{
    if(_userApplicationManager)
    {
        return _userApplicationManager;
    }
    _userApplicationManager=[[UserApplicationManager alloc] init];
    return _userApplicationManager;
}

-(SettingsApplicationManager *)settingsApplicationManager
{
    if(_settingsApplicationManager)
    {
        return _settingsApplicationManager;
    }
    _settingsApplicationManager=[[SettingsApplicationManager alloc] init];
    return _settingsApplicationManager;
}

-(CategoryApplicationManager *)categoryApplicationManager
{
    if(_categoryApplicationManager)
    {
        return _categoryApplicationManager;
    }
    _categoryApplicationManager=[[CategoryApplicationManager alloc] init];
    return _categoryApplicationManager;
}

-(SyncApplicationManager *)syncApplicationManager
{
    if(_syncApplicationManager)
    {
        return _syncApplicationManager;
    }
    _syncApplicationManager=[[SyncApplicationManager alloc] init];
    return _syncApplicationManager;
}

-(KSNotificationManager *)notificationManager
{
    if(_notificationManager)
    {
        return _notificationManager;
    }
    _notificationManager=[[KSNotificationManager alloc] init];
    return _notificationManager;
}

-(instancetype)init
{
    if(applicationInstance)
    {
        return nil;
    }
    else
    {
        return [super init];
    }
}

+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    if(applicationInstance)
    {
        return nil;
    }
    else
    {
        return [super allocWithZone:zone];
    }
}

-(void)cleanLocalDataBase
{
    [self.categoryApplicationManager cleanTable];
    [self.settingsApplicationManager cleanTable];
    [self.userApplicationManager cleanTable];
    [self.subTasksApplicationManager cleanTable];
    [self.tasksApplicationManager cleanTable];
    [FileManager writeTokenToFile:@""];
    [FileManager writeLastSyncTimeToFile:@""];
    [FileManager writeUserEmailToFile:@""];
    [FileManager writePassToFile:@""];
}

+(void)registerUserNotifications
{
    UIUserNotificationSettings * settings=[UIUserNotificationSettings settingsForTypes:
                                                            UIUserNotificationTypeBadge|
                                                            UIUserNotificationTypeSound|
                                                            UIUserNotificationTypeAlert
                                                                            categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
}
@end
