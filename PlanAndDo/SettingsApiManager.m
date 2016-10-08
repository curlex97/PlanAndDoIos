//
//  SettingsApiManager.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 21.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "SettingsApiManager.h"

#import "FileManager.h"
#import "UserApplicationManager.h"

@implementation SettingsApiManager

-(void)updateSettingsAsync:(UserSettings *)settings forUser:(KSAuthorisedUser *)user completion:(void (^)(NSDictionary*))completed
{
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    NSMutableDictionary* data = [NSMutableDictionary dictionary];

    [data setValue:settings.startPage.lowercaseString forKey:@"start_page"];
    [data setValue:settings.dateFormat.lowercaseString forKey:@"date_format"];
    [data setValue:settings.timeFormat.lowercaseString forKey:@"time_format"];
    [data setValue:settings.startDay.lowercaseString forKey:@"start_day"];
    [data setValue:[NSNumber numberWithInteger:settings.syncStatus] forKey:@"settings_sync_status"];

    [dic setValue:[NSNumber numberWithInteger:user.ID] forKey:@"user_id"];
    [dic setValue:[[[UIDevice currentDevice] identifierForVendor] UUIDString] forKey:@"device_id"];
    [dic setValue:[FileManager readTokenFromFile] forKey:@"token"];
    [dic setValue:@"setting" forKey:@"class"];
    [dic setValue:@"setSettings" forKey:@"method"];
    [dic setValue:data forKey:@"data"];
    
    [self dataByData:dic completion:^(NSData * data) {
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        if(completed) completed(json);
        if(!json)
        {
            NSString* str = [NSString stringWithUTF8String:[data bytes]];
            str = @"";
        }
    }];

}

-(void) syncSettingsWithCompletion:(void (^)(NSDictionary*))completed
{
    KSAuthorisedUser* user = [[[UserApplicationManager alloc] init] authorisedUser];
    
    NSMutableDictionary* puser = [NSMutableDictionary dictionary];
    NSMutableDictionary* inData = [NSMutableDictionary dictionary];
    
    NSNumber *number = [NSNumber numberWithInteger:[[FileManager readLastSyncTimeFromFile] intValue]];
    
    [inData setValue:number forKey:@"lst"];
    
    [puser setValue:[NSNumber numberWithInteger:user.ID] forKey:@"user_id"];
    [puser setValue:[[[UIDevice currentDevice] identifierForVendor] UUIDString] forKey:@"device_id"];
    [puser setValue:[FileManager readTokenFromFile] forKey:@"token"];
    [puser setValue:@"sync" forKey:@"class"];
    [puser setValue:@"syncSettings" forKey:@"method"];
    
    [puser setValue:inData forKey:@"data"];
    
    [self dataByData:puser completion:^(NSData * data)
    {
        if(!data && completed)
        {
            completed(nil);
            return;
        }
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        if(completed) completed(json);
    }];
}

@end
