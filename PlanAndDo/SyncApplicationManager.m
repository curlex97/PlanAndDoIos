//
//  SyncApplicationManager.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 22.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "SyncApplicationManager.h"
#import "ApplicationDefines.h"
#import "UserApplicationManager.h"
#import "FileManager.h"
#import "SettingsApplicationManager.h"
#import "CategoryApplicationManager.h"

@implementation SyncApplicationManager

-(void)syncWithCompletion:(void (^)(bool))completed
{
    [self syncStatusWithCompletion:^(bool status) {
        [self syncUserWithCompletion:^(bool status) {
            [self syncSettingsWithCompletion:^(bool status) {
                [self syncCategoriesWithCompletion:^(bool status) {
                    [self syncTasksWithCompletion:^(bool status) {
                        [self syncSubTasksWithCompletion:^(bool status) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:NC_SYNC_COMPLETED object:nil];
                            completed(true);
                        }];
                    }];
                }];
            }];
        }];
    }];
}

-(void)syncUserWithCompletion:(void (^)(bool))completed
{
    [[[UserApiManager alloc] init] syncUserWithCompletion:^(NSDictionary* dictionary) {
        
        NSString* status = [dictionary valueForKeyPath:@"status"];
        
        if([status containsString:@"suc"])
        {
            NSUInteger ID = [[dictionary valueForKeyPath:@"data.id"] integerValue];
            NSString* userName = [dictionary valueForKeyPath:@"data.name"];
            int syncStatus = [[dictionary valueForKeyPath:@"data.user_sync_status"] intValue];
            NSString* email = [dictionary valueForKeyPath:@"data.email"];
            NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:[[dictionary valueForKeyPath:@"data.created_at"] intValue]];
            NSDate *lastVisitDate = [NSDate dateWithTimeIntervalSince1970:[[dictionary valueForKeyPath:@"data.lastvisit_date"] intValue]];

            KSAuthorisedUser* user = [[KSAuthorisedUser alloc] initWithUserID:ID andUserName:userName andEmailAdress:email andCreatedDeate:createDate andLastVisitDate:lastVisitDate andSyncStatus:syncStatus andAccessToken:[FileManager readTokenFromFile] andUserSettings:nil];
            
            [[[UserCoreDataManager alloc] init] syncSetUser:user];
            [[NSNotificationCenter defaultCenter] postNotificationName:NC_SYNC_USER object:nil];

            completed(true);
        }
        completed(false);

    
    }];
}

-(void)syncSettingsWithCompletion:(void (^)(bool))completed
{
    [[[SettingsApiManager alloc] init] syncSettingsWithCompletion:^(NSDictionary* dictionary) {
        
        NSString* status = [dictionary valueForKeyPath:@"status"];
        
        if([status containsString:@"suc"])
        {
        
            NSUInteger settingsID = [[dictionary valueForKeyPath:@"data.id"] integerValue];
            NSString* startPage = [dictionary valueForKeyPath:@"data.start_page"];
            NSString* dateFormat = [dictionary valueForKeyPath:@"data.date_format"];
            NSString* timeFormat = [dictionary valueForKeyPath:@"data.time_format"];
            NSString* pageType = [dictionary valueForKeyPath:@"data.page_type"];
            NSString* startDay = [dictionary valueForKeyPath:@"data.start_day"];
            int syncStatus = [[dictionary valueForKeyPath:@"data.settings_sync_status"] intValue];
            
            UserSettings *settings = [[UserSettings alloc] initWithID:settingsID andStartPage:startPage andDateFormat:dateFormat andPageType:pageType andTimeFormat:timeFormat andStartDay:startDay andSyncStatus:syncStatus];
            [[[SettingsCoreDataManager alloc] init] syncSetSettings:settings];
            [[NSNotificationCenter defaultCenter] postNotificationName:NC_SYNC_SETTINGS object:nil];
            completed(true);
        }
        completed(false);
        
    }];
}

-(void)syncCategoriesWithCompletion:(void (^)(bool))completed
{
    [[[CategoryApiManager alloc] init] syncCategoriesWithCompletion:^(NSDictionary* dictionary) {
        
        NSString* status = [dictionary valueForKeyPath:@"status"];
        
        if([status containsString:@"suc"])
        {
        
            NSArray* defCats = (NSArray*)[dictionary valueForKeyPath:@"data"];
            
            for(NSDictionary* defaultCategory in defCats)
            {
                NSUInteger catID = [[defaultCategory valueForKeyPath:@"id"] integerValue];
                NSString* catName = [defaultCategory valueForKeyPath:@"category_name"];
                int catSyncStatus = [[defaultCategory valueForKeyPath:@"category_sync_status"] intValue];
                
                KSCategory* category = [[KSCategory alloc] initWithID:catID andName:catName andSyncStatus:catSyncStatus];
                
                if(![[[CategoryCoreDataManager alloc] init] categoryWithId:(int)category.ID])
                    [[[CategoryCoreDataManager alloc] init] syncAddCateroty:category];
                else
                    [[[CategoryCoreDataManager alloc] init] syncUpdateCateroty:category];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:NC_SYNC_CATEGORIES object:nil];
            completed(true);
        }
        completed(false);
        
        
    }];
}

-(void)syncTasksWithCompletion:(void (^)(bool))completed
{
    [[[TasksApiManager alloc] init] syncTasksWithCompletion:^(NSDictionary* dictionary) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NC_SYNC_TASKS object:nil];
        completed(YES);
    }];
}

-(void)syncSubTasksWithCompletion:(void (^)(bool))completed
{
    [[[SubTasksApiManager alloc] init] syncSubTasksWithCompletion:^(NSDictionary* dictionary) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NC_SYNC_SUBTASKS object:nil];
        completed(YES);
    }];
}


-(void) syncStatusWithCompletion:(void (^)(bool))completed
{
    
    [[[SyncApiManager alloc] init] syncStatusWithCompletion:^(NSDictionary * json)
     {
         [[NSNotificationCenter defaultCenter] postNotificationName:NC_SYNC_STATUS object:nil];
         completed(YES);
     }];
}





@end
