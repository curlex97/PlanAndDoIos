//
//  SettingsApplicationManager.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 22.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "SettingsApplicationManager.h"
#import "ApplicationManager.h"
#import "SyncApplicationManager.h"

@implementation SettingsApplicationManager

-(UserSettings *)settings
{
    return [[[SettingsCoreDataManager alloc] init] settings];
}

-(void)setSettings:(UserSettings *)settings completion:(void (^)(bool))completed
{
    [[[SettingsCoreDataManager alloc] init] setSettings:settings];
    [[[SyncApplicationManager alloc] init] syncSettingsWithCompletion:^(bool status) {
        [[[SettingsApiManager alloc] init] updateSettingsAsync:[[[SettingsCoreDataManager alloc] init] settingsForSync] forUser:[[ApplicationManager sharedApplication].userApplicationManager authorisedUser]  completion:^(NSDictionary* dictionary){
            if(completed) completed(YES);
            [[NSNotificationCenter defaultCenter] postNotificationName:NC_SYNC_SETTINGS object:nil];
        }];
    }];
}

-(void)updateSettings:(UserSettings *)settings completion:(void (^)(bool))completed
{
    [[[SettingsCoreDataManager alloc] init] updateSettings:settings];
    [[[SyncApplicationManager alloc] init] syncSettingsWithCompletion:^(bool status)
    {
        if(status)
        {
            [[[SettingsApiManager alloc] init] updateSettingsAsync:[[[SettingsCoreDataManager alloc] init] settingsForSync] forUser:[[ApplicationManager sharedApplication].userApplicationManager authorisedUser]  completion:^(NSDictionary* dictionary){
                if(completed) completed(YES);
            [[NSNotificationCenter defaultCenter] postNotificationName:NC_SYNC_SETTINGS object:nil];
            }];
        }
    }];
}

-(void)recieveSettingsFromDictionary:(NSDictionary *)dictionary
{
    NSString* status = [dictionary valueForKeyPath:@"status"];
    
    if([status containsString:@"suc"])
    {
        
        int settingsID = [[dictionary valueForKeyPath:@"data.id"] intValue];
        NSString* startPage = [dictionary valueForKeyPath:@"data.start_page"];
        NSString* dateFormat = [dictionary valueForKeyPath:@"data.date_format"];
        NSString* timeFormat = [dictionary valueForKeyPath:@"data.time_format"];
        NSString* pageType = [dictionary valueForKeyPath:@"data.page_type"];
        NSString* startDay = [dictionary valueForKeyPath:@"data.start_day"];
        int syncStatus = [[dictionary valueForKeyPath:@"data.settings_sync_status"] intValue];
        
        [SyncApplicationManager updateLastSyncTime:syncStatus];
        
        
        UserSettings *settings = [[UserSettings alloc] initWithID:settingsID andStartPage:startPage andDateFormat:dateFormat andPageType:pageType andTimeFormat:timeFormat andStartDay:startDay andSyncStatus:syncStatus];
        
        UserSettings* localSettings = [[[SettingsCoreDataManager alloc] init] settings];
        
        if(!localSettings) [[[SettingsCoreDataManager alloc] init] syncSetSettings:settings];
        else if(localSettings.syncStatus < settings.syncStatus) [[[SettingsCoreDataManager alloc] init] syncUpdateSettings:settings];
        
        if([ApplicationManager sharedApplication].userApplicationManager.authorisedUser)
        {
            [ApplicationManager sharedApplication].userApplicationManager.authorisedUser.settings = [[[SettingsCoreDataManager alloc] init] settings];
        }

    }
}

-(void) cleanTable
{
    return [[[SettingsCoreDataManager alloc] init] cleanTable];
}

-(NSString *)timeWith:(NSDateComponents *)components
{
    NSString * time;
    if([self.settings.timeFormat isEqualToString:@"24H"])
    {
        time=[NSString stringWithFormat:@"%li:%@%li", (long)[components hour],[components minute]<10?@"0":@"", (long)[components minute]];
    }
    else
    {
        time=[NSString stringWithFormat:@"%li:%@%li", ((long)[components hour])/2,[components minute]<10?@"0":@"", (long)[components minute]];
    }
    return time;
}

@end
