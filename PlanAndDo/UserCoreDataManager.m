//
//  UserCoreDataManager.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 19.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "UserCoreDataManager.h"
#import "SettingsCoreDataManager.h"
#import "FileManager.h"
#import "ApplicationDefines.h"

@implementation UserCoreDataManager

-(KSAuthorisedUser *)authorisedUser
{
    KSAuthorisedUser* user = nil;
    NSError* error = nil;
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:CD_TABLE_USER];
    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if(!error)
    {
        for(NSManagedObject* managedUser in results)
        {
            NSUInteger ID = [[managedUser valueForKey:CD_ROW_ID] integerValue];
            NSString* name = (NSString*)[managedUser valueForKey:CD_ROW_NAME];
            NSString* email = (NSString*)[managedUser valueForKey:CD_ROW_EMAIL];
            NSDate* createDate = (NSDate*)[managedUser valueForKey:CD_ROW_CREATED_AT];
            NSDate* lastVisit = (NSDate*)[managedUser valueForKey:CD_ROW_LAST_VISIT_DATE];
            int syncStatus = [[managedUser valueForKey:CD_ROW_USER_SYNC_STATUS] intValue];
            NSString* token = [FileManager readTokenFromFile];
            
            UserSettings* settings = [[[SettingsCoreDataManager alloc] init] settings];

            user = [[KSAuthorisedUser alloc] initWithUserID:ID andUserName:name andEmailAdress:email andCreatedDeate:createDate andLastVisitDate:lastVisit andSyncStatus:syncStatus andAccessToken:token andUserSettings:settings];
            
        }
    }
    return user;
}

-(KSAuthorisedUser *)authorisedUserForSync
{
    KSAuthorisedUser* user = nil;
    NSError* error = nil;
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:CD_TABLE_USER];
    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if(!error)
    {
        for(NSManagedObject* managedUser in results)
        {
            bool localSync = [[managedUser valueForKey:CD_ROW_LOCAL_SYNC] boolValue];
            if(!localSync)
            {
                NSUInteger ID = [[managedUser valueForKey:CD_ROW_ID] integerValue];
                NSString* name = (NSString*)[managedUser valueForKey:CD_ROW_NAME];
                NSString* email = (NSString*)[managedUser valueForKey:CD_ROW_EMAIL];
                NSDate* createDate = (NSDate*)[managedUser valueForKey:CD_ROW_CREATED_AT];
                NSDate* lastVisit = (NSDate*)[managedUser valueForKey:CD_ROW_LAST_VISIT_DATE];
                int syncStatus = [[managedUser valueForKey:CD_ROW_USER_SYNC_STATUS] intValue];
                NSString* token = [FileManager readTokenFromFile];
                
                UserSettings* settings = [[[SettingsCoreDataManager alloc] init] settings];
                
                user = [[KSAuthorisedUser alloc] initWithUserID:ID andUserName:name andEmailAdress:email andCreatedDeate:createDate andLastVisitDate:lastVisit andSyncStatus:syncStatus andAccessToken:token andUserSettings:settings];
            }
 
        }
    }
    return user;
}

-(void)setUser:(KSAuthorisedUser *)user
{
    NSError* error = nil;
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:CD_TABLE_USER];
    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if(!error)
    {
        if(![results count])
        {
            NSEntityDescription* entity = [NSEntityDescription entityForName:CD_TABLE_USER inManagedObjectContext:self.managedObjectContext];
            NSManagedObject* object = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
            [object setValue:[NSNumber numberWithInteger:[user ID]] forKey:CD_ROW_ID];
            [object setValue:[user userName] forKey:CD_ROW_NAME];
            [object setValue:[user emailAdress] forKey:CD_ROW_EMAIL];
            [object setValue:[user createdAt] forKey:CD_ROW_CREATED_AT];
            [object setValue:[user lastVisit] forKey:CD_ROW_LAST_VISIT_DATE];
            [object setValue:[NSNumber numberWithInteger:[user syncStatus]] forKey:CD_ROW_USER_SYNC_STATUS];
            [object setValue:[NSNumber numberWithBool:NO] forKey:CD_ROW_LOCAL_SYNC];

            [self.managedObjectContext save:nil];
        }
        else
        {
            [self updateUser:user];
        }
    }
}

-(void)updateUser:(KSAuthorisedUser *)user
{
    NSError* error = nil;
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:CD_TABLE_USER];
    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if(!error)
    {
        if(![results count]) [self setUser:user];
        
        else
        {
            for(NSManagedObject* managedUser in results)
            {
                [managedUser setValue:[NSNumber numberWithInteger:[user ID]] forKey:CD_ROW_ID];
                [managedUser setValue:[user userName] forKey:CD_ROW_NAME];
                [managedUser setValue:[user emailAdress] forKey:CD_ROW_EMAIL];
                [managedUser setValue:[user createdAt] forKey:CD_ROW_CREATED_AT];
                [managedUser setValue:[user lastVisit] forKey:CD_ROW_LAST_VISIT_DATE];
                [managedUser setValue:[NSNumber numberWithInteger:[[NSDate date] timeIntervalSince1970]] forKey:CD_ROW_USER_SYNC_STATUS];
                [managedUser setValue:[NSNumber numberWithBool:NO] forKey:CD_ROW_LOCAL_SYNC];

                [self.managedObjectContext save:nil];
            }
        }
    }

}

-(void)cleanTable
{
    [super cleanTable:CD_TABLE_USER];
}

// SYNC

-(void)syncSetUser:(KSAuthorisedUser *)user
{
    NSError* error = nil;
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:CD_TABLE_USER];
    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if(!error)
    {
        if(![results count])
        {
            NSEntityDescription* entity = [NSEntityDescription entityForName:CD_TABLE_USER inManagedObjectContext:self.managedObjectContext];
            NSManagedObject* object = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
            [object setValue:[NSNumber numberWithInteger:[user ID]] forKey:CD_ROW_ID];
            [object setValue:[user userName] forKey:CD_ROW_NAME];
            [object setValue:[user emailAdress] forKey:CD_ROW_EMAIL];
            [object setValue:[user createdAt] forKey:CD_ROW_CREATED_AT];
            [object setValue:[user lastVisit] forKey:CD_ROW_LAST_VISIT_DATE];
            [object setValue:[NSNumber numberWithInteger:[user syncStatus]] forKey:CD_ROW_USER_SYNC_STATUS];
            [object setValue:[NSNumber numberWithBool:YES] forKey:CD_ROW_LOCAL_SYNC];
            
            [self.managedObjectContext save:nil];
        }
        else
        {
            [self syncUpdateUser:user];
        }
    }
}

-(void)syncUpdateUser:(KSAuthorisedUser *)user
{
    NSError* error = nil;
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:CD_TABLE_USER];
    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if(!error)
    {
        if(![results count]) [self syncSetUser:user];
        
        else
        {
            for(NSManagedObject* managedUser in results)
            {
                [managedUser setValue:[NSNumber numberWithInteger:[user ID]] forKey:CD_ROW_ID];
                [managedUser setValue:[user userName] forKey:CD_ROW_NAME];
                [managedUser setValue:[user emailAdress] forKey:CD_ROW_EMAIL];
                [managedUser setValue:[user createdAt] forKey:CD_ROW_CREATED_AT];
                [managedUser setValue:[user lastVisit] forKey:CD_ROW_LAST_VISIT_DATE];
                [managedUser setValue:[NSNumber numberWithInteger:[user syncStatus]] forKey:CD_ROW_USER_SYNC_STATUS];
                [managedUser setValue:[NSNumber numberWithBool:YES] forKey:CD_ROW_LOCAL_SYNC];
                
                [self.managedObjectContext save:nil];
            }
        }
    }
    
}




@end
