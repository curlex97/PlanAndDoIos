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
            NSUInteger ID = [[managedUser valueForKey:@"id"] integerValue];
            NSString* name = (NSString*)[managedUser valueForKey:@"name"];
            NSString* email = (NSString*)[managedUser valueForKey:@"email"];
            NSDate* createDate = (NSDate*)[managedUser valueForKey:@"created_at"];
            NSDate* lastVisit = (NSDate*)[managedUser valueForKey:@"lastvisit_date"];
            int syncStatus = [[managedUser valueForKey:@"user_sync_status"] intValue];
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
            bool localSync = [[managedUser valueForKey:@"local_sync"] boolValue];
            if(!localSync)
            {
                NSUInteger ID = [[managedUser valueForKey:@"id"] integerValue];
                NSString* name = (NSString*)[managedUser valueForKey:@"name"];
                NSString* email = (NSString*)[managedUser valueForKey:@"email"];
                NSDate* createDate = (NSDate*)[managedUser valueForKey:@"created_at"];
                NSDate* lastVisit = (NSDate*)[managedUser valueForKey:@"lastvisit_date"];
                int syncStatus = [[managedUser valueForKey:@"user_sync_status"] intValue];
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
            [object setValue:[NSNumber numberWithInteger:[user ID]] forKey:@"id"];
            [object setValue:[user userName] forKey:@"name"];
            [object setValue:[user emailAdress] forKey:@"email"];
            [object setValue:[user createdAt] forKey:@"created_at"];
            [object setValue:[user lastVisit] forKey:@"lastvisit_date"];
            [object setValue:[NSNumber numberWithInteger:[user syncStatus]] forKey:@"user_sync_status"];
            [object setValue:[NSNumber numberWithBool:NO] forKey:@"local_sync"];

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
                [managedUser setValue:[NSNumber numberWithInteger:[user ID]] forKey:@"id"];
                [managedUser setValue:[user userName] forKey:@"name"];
                [managedUser setValue:[user emailAdress] forKey:@"email"];
                [managedUser setValue:[user createdAt] forKey:@"created_at"];
                [managedUser setValue:[user lastVisit] forKey:@"lastvisit_date"];
                [managedUser setValue:[NSNumber numberWithInteger:[[NSDate date] timeIntervalSince1970]] forKey:@"user_sync_status"];
                [managedUser setValue:[NSNumber numberWithBool:NO] forKey:@"local_sync"];

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
            [object setValue:[NSNumber numberWithInteger:[user ID]] forKey:@"id"];
            [object setValue:[user userName] forKey:@"name"];
            [object setValue:[user emailAdress] forKey:@"email"];
            [object setValue:[user createdAt] forKey:@"created_at"];
            [object setValue:[user lastVisit] forKey:@"lastvisit_date"];
            [object setValue:[NSNumber numberWithInteger:[user syncStatus]] forKey:@"user_sync_status"];
            [object setValue:[NSNumber numberWithBool:YES] forKey:@"local_sync"];
            
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
                [managedUser setValue:[NSNumber numberWithInteger:[user ID]] forKey:@"id"];
                [managedUser setValue:[user userName] forKey:@"name"];
                [managedUser setValue:[user emailAdress] forKey:@"email"];
                [managedUser setValue:[user createdAt] forKey:@"created_at"];
                [managedUser setValue:[user lastVisit] forKey:@"lastvisit_date"];
                [managedUser setValue:[NSNumber numberWithInteger:[user syncStatus]] forKey:@"user_sync_status"];
                [managedUser setValue:[NSNumber numberWithBool:YES] forKey:@"local_sync"];
                
                [self.managedObjectContext save:nil];
            }
        }
    }
    
}




@end
