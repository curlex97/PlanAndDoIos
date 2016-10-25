//
//  KSNotificationManager.m
//  PlanAndDo
//
//  Created by Амин on 20.10.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "KSNotificationManager.h"

@interface KSNotificationManager()
@property (nonatomic)NSMutableDictionary * localNotifications;
@property (nonatomic)NSMutableArray<NSString *> * sheduledNotificationKeys;
@end

@implementation KSNotificationManager

//static KSNotificationManager * notificationControllerInstance;
//+(KSNotificationManager *)sharedManager
//{
//    static dispatch_once_t predicate;
//    dispatch_once(&predicate,^
//                  {
//                      notificationControllerInstance=[[KSNotificationManager alloc] init];
//                  });
//    return notificationControllerInstance;
//}
//
-(instancetype)init
{
    if(self=[super init])
    {
        self.localNotifications=[[NSMutableDictionary alloc] init];
        self.sheduledNotificationKeys=[[NSMutableArray alloc] init];
    }
    return self;
}

-(void)addLocalNotificationWithTitle:(NSString *)title
                             andBody:(NSString *)body
                            andImage:(NSString *)imagePath
                         andFireDate:(NSDate *)date
                         andUserInfo:(NSDictionary *)userInfo
                              forKey:(NSString *)key
{
    UILocalNotification * localNotification=[[UILocalNotification alloc] init];
    localNotification.fireDate = date;
    localNotification.alertBody = body;
    localNotification.alertTitle = title;
    localNotification.userInfo=userInfo;
    NSMutableArray * notificationForSinglKey=[self.localNotifications valueForKey:key];
    if(!notificationForSinglKey)
    {
        notificationForSinglKey=[[NSMutableArray alloc] init];
    }
    [notificationForSinglKey addObject:localNotification];
    [self.localNotifications setValue:notificationForSinglKey forKey:key];
}

-(void)sheduleAllNotifications
{
    NSArray * values=self.localNotifications.allValues;
    NSArray * keys=self.localNotifications.allKeys;
    for(NSUInteger i=0; i<values.count; ++i)
    {
        if(![self.sheduledNotificationKeys containsObject:keys[i]])
        {
            NSMutableArray * notificationsForSinglKey=[self.localNotifications valueForKey:keys[i]];
            for(UILocalNotification * notification in notificationsForSinglKey)
            {
                    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            }
            [self.sheduledNotificationKeys addObject:keys[i]];
        }
    }
}

-(void)cancelAllNotifications
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [self.sheduledNotificationKeys removeAllObjects];
}

-(void)cancelNotificationsForKey:(NSString *)key
{
    NSMutableArray * notificationsForSinglKey=[self.localNotifications objectForKey:key];
    for(UILocalNotification * notification in notificationsForSinglKey)
    {
         [[UIApplication sharedApplication] cancelLocalNotification:notification];
    }
    [self.sheduledNotificationKeys removeObject:key];
}

-(void)shedulenotificationsForKey:(NSString *)key
{
    
    if(![self.sheduledNotificationKeys containsObject:key])
    {
        NSMutableArray * notificationsForSinglKey=[self.localNotifications valueForKey:key];
        for(UILocalNotification * notification in notificationsForSinglKey)
        {
            if(notification)
            {
                    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            }
        }
        [self.sheduledNotificationKeys addObject:key];
    }
}

@end
