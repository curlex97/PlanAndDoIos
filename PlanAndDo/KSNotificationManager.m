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

static KSNotificationManager * notificationControllerInstance;
+(KSNotificationManager *)sharedManager
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^
                  {
                      notificationControllerInstance=[[KSNotificationManager alloc] init];
                  });
    return notificationControllerInstance;
}

-(instancetype)init
{
    if(notificationControllerInstance)
        return nil;
    return [super init];
    
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
    [self.localNotifications setValue:localNotification forKey:key];
}

-(void)sheduleAllNotifications
{
    NSArray * values=self.localNotifications.allValues;
    NSArray * keys=self.localNotifications.allKeys;
    for(NSUInteger i=0; i<values.count; ++i)
    {
        if(![self.sheduledNotificationKeys containsObject:keys[i]])
        {
            UILocalNotification * notification=[self.localNotifications valueForKey:keys[i]];
            if(notification.fireDate.timeIntervalSince1970<[NSDate date].timeIntervalSince1970)
            {
                [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
            }
            else
            {
                [self.sheduledNotificationKeys addObject:keys[i]];
                [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            }
        }
    }
}

-(void)cancelAllNotifications
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [self.sheduledNotificationKeys removeAllObjects];
}

-(void)cancelNotificationForKey:(NSString *)key
{
    [[UIApplication sharedApplication] cancelLocalNotification:[self.localNotifications objectForKey:key]];
    [self.sheduledNotificationKeys removeObject:key];
}

-(void)shedulenotificationForKey:(NSString *)key
{
    if(![self.sheduledNotificationKeys containsObject:key])
    {
        UILocalNotification * notification=[self.localNotifications valueForKey:key];
        if(notification)
        {
            if(notification.fireDate.timeIntervalSince1970<[NSDate date].timeIntervalSince1970)
            {
                [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
            }
            else
            {
                [self.sheduledNotificationKeys addObject:key];
                [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            }
        }
    }
}

@end
