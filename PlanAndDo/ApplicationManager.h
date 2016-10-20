//
//  ApplicationManager.h
//  PlanAndDo
//
//  Created by Arthur Chistyak on 21.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TasksApplicationManager.h"
#import "SubTasksApplicationManager.h"
#import "UserApplicationManager.h"
#import "SettingsApplicationManager.h"
#import "CategoryApplicationManager.h"
#import "SyncApplicationManager.h"
#import "ApplicationDefines.h"
#import "KSNotificationManager.h"


@interface ApplicationManager : NSObject

+(TasksApplicationManager*) tasksApplicationManager;

+(SubTasksApplicationManager*) subTasksApplicationManager;

+(UserApplicationManager*) userApplicationManager;

+(SettingsApplicationManager*) settingsApplicationManager;

+(CategoryApplicationManager*) categoryApplicationManager;

+(SyncApplicationManager*) syncApplicationManager;

+(KSNotificationManager *) notificationManager;

+(void) cleanLocalDataBase;

+(void)registerUserNotifications;

@end
