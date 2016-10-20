//
//  KSNotificationManager.h
//  PlanAndDo
//
//  Created by Амин on 20.10.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KSNotificationManager : NSObject
+(KSNotificationManager *)sharedManager;

-(void)addLocalNotificationWithTitle:(NSString *)title
                             andBody:(NSString *)body
                            andImage:(NSString *)imagePath
                         andFireDate:(NSDate *)date
                         andUserInfo:(NSDictionary *)userInfo
                              forKey:(NSString *)key;
-(void)sheduleAllNotifications;
-(void)cancelAllNotifications;
-(void)cancelNotificationForKey:(NSString *)key;
-(void)shedulenotificationForKey:(NSString *)key;
@end
