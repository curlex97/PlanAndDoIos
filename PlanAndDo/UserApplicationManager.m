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

@implementation UserApplicationManager

-(KSAuthorisedUser *)authorisedUser
{
    return [[[UserCoreDataManager alloc] init] authorisedUser];
}

-(void)setUser:(KSAuthorisedUser *)user
{
    [[[UserCoreDataManager alloc] init] setUser:user];
    [[[UserApiManager alloc] init] updateUserAsync:user completion:nil];
}

-(void)updateUser:(KSAuthorisedUser *)user
{
    [[[UserCoreDataManager alloc] init] updateUser:user];
    [[[UserApiManager alloc] init] updateUserAsync:user completion:nil];
}

-(void)registerAsyncWithEmail:(NSString *)email andUserName:(NSString *)userName andPassword:(NSString *)password completion:(void (^)(bool))completed
{
     [[[UserApiManager alloc] init] registerAsyncWithEmail:email andUserName:userName andPassword:password completion:^(NSDictionary* dictionary){
       
        NSString* status = [dictionary valueForKeyPath:@"status"];
        
        if([status containsString:@"suc"])
        {
            NSUInteger ID = [[dictionary valueForKeyPath:@"data.users.user_id"] integerValue];
            NSString* createDatestr = [dictionary valueForKeyPath:@"data.users.created_at"];
            NSString* lastVisitDatestr = [dictionary valueForKeyPath:@"data.users.lastvisit_date"];
            int syncStatus = [[dictionary valueForKeyPath:@"data.users.user_sync_status"] intValue];
            NSString* token = [dictionary valueForKeyPath:@"token"];
            
            NSDateFormatter *dateFormattercreate = [[NSDateFormatter alloc] init];
            [dateFormattercreate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *createDate = [dateFormattercreate dateFromString:createDatestr];
            
            NSDateFormatter *dateFormatterlast = [[NSDateFormatter alloc] init];
            [dateFormatterlast setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *lastVisitDate = [dateFormatterlast dateFromString:lastVisitDatestr];
            
            [self writeTokenToFile:token];
            
              ///////Settings/////////
            
            NSUInteger settingsID = [[dictionary valueForKeyPath:@"data.settings.id"] integerValue];
            NSString* startPage = [dictionary valueForKeyPath:@"data.settings.start_page"];
            NSString* dateFormat = [dictionary valueForKeyPath:@"data.settings.date_format"];
            NSString* timeFormat = [dictionary valueForKeyPath:@"data.settings.time_format"];
            NSString* pageType = [dictionary valueForKeyPath:@"data.settings.page_type"];

            UserSettings *settings = [[UserSettings alloc] initWithID:settingsID andStartPage:startPage andDateFormat:dateFormat andPageType:pageType andTimeFormat:timeFormat andSyncStatus:syncStatus];
            
            ///////////////////////////
            
            
            KSAuthorisedUser* user = [[KSAuthorisedUser alloc] initWithUserID:ID andUserName:userName andEmailAdress:email andCreatedDeate:createDate andLastVisitDate:lastVisitDate andSyncStatus:syncStatus andAccessToken:token andUserSettings:settings];
            
            [[[UserCoreDataManager alloc] init] setUser:user];
            
            
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

            
            
            completed(true);
        }
        completed(false);
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

            [self writeTokenToFile:token];
            
            KSAuthorisedUser* user = [[KSAuthorisedUser alloc] initWithUserID:ID andUserName:userName andEmailAdress:email andCreatedDeate:[NSDate date] andLastVisitDate:[NSDate date] andSyncStatus:0 andAccessToken:token andUserSettings:nil];
            
            [[[UserCoreDataManager alloc] init] setUser:user];
            
            completed(true);
        }
        completed(false);
    }];

}


-(void) writeTokenToFile:(NSString*)token
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"token.txt"];
    [token writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

-(NSString*) readTokenFromFile
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"token.txt"];
    return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
}

@end
