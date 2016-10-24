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
                      applicationInstance.tasksApplicationManager=[[TasksApplicationManager alloc] init];
                      applicationInstance.subTasksApplicationManager=[[SubTasksApplicationManager alloc] init];
                      applicationInstance.userApplicationManager=[[UserApplicationManager alloc] init];
                      applicationInstance.settingsApplicationManager=[[SettingsApplicationManager alloc] init];
                      applicationInstance.categoryApplicationManager=[[CategoryApplicationManager alloc] init];
                      applicationInstance.syncApplicationManager=[[SyncApplicationManager alloc] init];
                      applicationInstance.notificationManager=[KSNotificationManager sharedManager];
                  });
    return applicationInstance;
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
