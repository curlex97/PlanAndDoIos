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
        [[[UserApiManager alloc] init] updateUserAsync:[[[UserCoreDataManager alloc] init] authorisedUserForSync] completion:^(NSDictionary* dictionary){
           [[NSNotificationCenter defaultCenter] postNotificationName:NC_SYNC_USER object:nil];
        }];
    }];
}

-(void)updateUser:(KSAuthorisedUser *)user
{
    [[[UserCoreDataManager alloc] init] updateUser:user];
    [[[SyncApplicationManager alloc] init] syncUserWithCompletion:^(bool status) {
        [[[UserApiManager alloc] init] updateUserAsync:[[[UserCoreDataManager alloc] init] authorisedUserForSync] completion:^(NSDictionary* dictionary){
            [[NSNotificationCenter defaultCenter] postNotificationName:NC_SYNC_USER object:nil];
        }];
    }];
    
}

-(void)registerAsyncWithEmail:(NSString *)email andUserName:(NSString *)userName andPassword:(NSString *)password completion:(void (^)(bool))completed
{
     [[[UserApiManager alloc] init] registerAsyncWithEmail:email andUserName:userName andPassword:password completion:^(NSDictionary* dictionary){
       
        NSString* status = [dictionary valueForKeyPath:@"status"];
        if([status containsString:@"succsess"])
        {
            [ApplicationManager cleanLocalDataBase];
            
            int ID = [[dictionary valueForKeyPath:@"data.users.user_id"] intValue];
            int syncStatus = [[dictionary valueForKeyPath:@"data.users.user_sync_status"] intValue];
            NSString* token = [dictionary valueForKeyPath:@"token"];
            NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:[[dictionary valueForKeyPath:@"data.users.created_at"] intValue]];
            NSDate *lastVisitDate = [NSDate dateWithTimeIntervalSince1970:[[dictionary valueForKeyPath:@"data.users.lastvisit_date"] intValue]];
            
            [FileManager writeTokenToFile:token];
            [FileManager writeUserEmailToFile:email];
            [FileManager writePassToFile:password];
              ///////Settings/////////
            
            int settingsID = [[dictionary valueForKeyPath:@"data.settings.id"] intValue];
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
                int catID = [[defaultCategory valueForKeyPath:@"id"] intValue];
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
        
        if([status containsString:@"succsess"])
        {
            int ID = [[dictionary valueForKeyPath:@"data.user_id"] intValue];
            NSString* userName = [dictionary valueForKeyPath:@"data.user_name"];
            NSString* token = [dictionary valueForKeyPath:@"data.token"];

            [FileManager writeTokenToFile:token];
            [FileManager writePassToFile:password];
            [FileManager writeUserEmailToFile:email];
            
            KSAuthorisedUser* user = [[KSAuthorisedUser alloc] initWithUserID:ID andUserName:userName andEmailAdress:email andCreatedDeate:[NSDate date] andLastVisitDate:[NSDate date] andSyncStatus:0 andAccessToken:token andUserSettings:nil];

            [[[UserCoreDataManager alloc] init] setUser:user];
            
            if(completed)
            {
                dispatch_async(dispatch_get_main_queue(), ^
                {
                        completed(true);
                });

            }
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
