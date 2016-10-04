//
//  UserApplicationManager.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 22.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "UserApplicationManager.h"
#import "UserSettings.h"
#import "ApplicationManager.h"
#import "KSCategory.h"
#import "FileManager.h"
#import "SyncApplicationManager.h"

@implementation UserApplicationManager

-(KSAuthorisedUser *)authorisedUser
{
    return [KSAuthorisedUser currentUser] ? [KSAuthorisedUser currentUser] : [[[UserCoreDataManager alloc] init] authorisedUser];
}

-(void)setUser:(KSAuthorisedUser *)user
{
    [[[UserCoreDataManager alloc] init] setUser:user];
    [[[SyncApplicationManager alloc] init] syncUserWithCompletion:^(bool status) {
        [[[UserApiManager alloc] init] updateUserAsync:user completion:^(bool status){
           [[NSNotificationCenter defaultCenter] postNotificationName:NC_SYNC_USER object:nil];
        }];
    }];
}

-(void)updateUser:(KSAuthorisedUser *)user
{
    [[[UserCoreDataManager alloc] init] updateUser:user];
    [[[SyncApplicationManager alloc] init] syncUserWithCompletion:^(bool status) {
        [[[UserApiManager alloc] init] updateUserAsync:user completion:^(bool status){
            [[NSNotificationCenter defaultCenter] postNotificationName:NC_SYNC_USER object:nil];
        }];
    }];
    
}

-(void)registerAsyncWithEmail:(NSString *)email andUserName:(NSString *)userName andPassword:(NSString *)password completion:(void (^)(bool))completed
{
     [[[UserApiManager alloc] init] registerAsyncWithEmail:email andUserName:userName andPassword:password completion:^(NSDictionary* dictionary){
       
        NSString* status = [dictionary valueForKeyPath:@"status"];
        
        if([status containsString:@"suc"])
        {
            [ApplicationManager cleanLocalDataBase];
            
            NSUInteger ID = [[dictionary valueForKeyPath:@"data.users.user_id"] integerValue];
            int syncStatus = [[dictionary valueForKeyPath:@"data.users.user_sync_status"] intValue];
            NSString* token = [dictionary valueForKeyPath:@"token"];
            NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:[[dictionary valueForKeyPath:@"data.users.created_at"] intValue]];
            NSDate *lastVisitDate = [NSDate dateWithTimeIntervalSince1970:[[dictionary valueForKeyPath:@"data.users.lastvisit_date"] intValue]];
            
            [FileManager writeTokenToFile:token];
            
              ///////Settings/////////
            
            NSUInteger settingsID = [[dictionary valueForKeyPath:@"data.settings.id"] integerValue];
            NSString* startPage = [dictionary valueForKeyPath:@"data.settings.start_page"];
            NSString* dateFormat = [dictionary valueForKeyPath:@"data.settings.date_format"];
            NSString* timeFormat = [dictionary valueForKeyPath:@"data.settings.time_format"];
            NSString* pageType = [dictionary valueForKeyPath:@"data.settings.page_type"];
            NSString* startDay = [dictionary valueForKeyPath:@"data.settings.start_day"];

            
            UserSettings *settings = [[UserSettings alloc] initWithID:settingsID andStartPage:startPage andDateFormat:dateFormat andPageType:pageType andTimeFormat:timeFormat andStartDay:startDay andSyncStatus:syncStatus];
            
            ///////////////////////////
            
            
            KSAuthorisedUser* user = [[KSAuthorisedUser alloc] initWithUserID:ID andUserName:userName andEmailAdress:email andCreatedDeate:createDate andLastVisitDate:lastVisitDate andSyncStatus:syncStatus andAccessToken:token andUserSettings:settings];
            user.apiToken = token;

            [[[UserCoreDataManager alloc] init] setUser:user];
            [[[SettingsCoreDataManager alloc] init] setSettings:settings];
            
            
            ///////Categories//////////

            NSArray* defCats = (NSArray*)[dictionary valueForKeyPath:@"data.categories"];
            
            for(NSDictionary* defaultCategory in defCats)
            {
                NSUInteger catID = [[defaultCategory valueForKeyPath:@"id"] integerValue];
                NSString* catName = [defaultCategory valueForKeyPath:@"category_name"];
                int catSyncStatus = [[defaultCategory valueForKeyPath:@"data.users.user_sync_status"] intValue];

                [[ApplicationManager categoryApplicationManager] addCateroty:[[KSCategory alloc] initWithID:catID andName:catName andSyncStatus:catSyncStatus]];
                
            }
            
            ///////////////////////////

            
            if(completed) completed(true);
        }
        if(completed) completed(false);
    }];
}

-(void)loginWithEmail:(NSString *)email andPassword:(NSString *)password completion:(void (^)(bool))completed
{
    [[[UserApiManager alloc] init] loginAsyncWithEmail:email andPassword:password completion:^(NSDictionary* dictionary){
        
        NSString* status = [dictionary valueForKeyPath:@"status"];
        
        if([status containsString:@"suc"])
        {
            NSUInteger ID = [[dictionary valueForKeyPath:@"data.user_id"] integerValue];
            NSString* userName = [dictionary valueForKeyPath:@"data.user_name"];
            NSString* token = [dictionary valueForKeyPath:@"data.token"];

            [FileManager writeTokenToFile:token];
             
            KSAuthorisedUser* user = [[KSAuthorisedUser alloc] initWithUserID:ID andUserName:userName andEmailAdress:email andCreatedDeate:[NSDate date] andLastVisitDate:[NSDate date] andSyncStatus:0 andAccessToken:token andUserSettings:nil];
            
            [[[UserCoreDataManager alloc] init] setUser:user];
            
            if(completed) completed(true);
        }
        if(completed) completed(false);
    }];

}




-(void) cleanTable
{
    return [[[UserCoreDataManager alloc] init] cleanTable];
}

-(void)logout
{
    [ApplicationManager cleanLocalDataBase];
    [[[UserApiManager alloc] init] logout];		
}

@end
