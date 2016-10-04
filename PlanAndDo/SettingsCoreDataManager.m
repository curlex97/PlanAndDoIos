//
//  SettingsCoreDataManager.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 19.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "SettingsCoreDataManager.h"
#import "ApplicationDefines.h"

@implementation SettingsCoreDataManager

-(UserSettings *)settings
{
    UserSettings* settings = nil;
    NSError* error = nil;
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:CD_TABLE_SETTINGS];
    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if(!error)
    {
        for(NSManagedObject* managedSettings in results)
        {
            NSUInteger ID = [[managedSettings valueForKey:CD_ROW_ID] integerValue];
            NSString* startPage = (NSString*)[managedSettings valueForKey:CD_ROW_START_PAGE];
            NSString* pageType = (NSString*)[managedSettings valueForKey:CD_ROW_PAGE_TYPE];
            NSString* dateFormat = (NSString*)[managedSettings valueForKey:CD_ROW_DATE_FORMAT];
            NSString* startDay = (NSString*)[managedSettings valueForKey:CD_ROW_START_DAY];
            NSString* timeFormat = (NSString*)[managedSettings valueForKey:CD_ROW_TIME_FORMAT];
            int syncStatus = [[managedSettings valueForKey:CD_ROW_SETTINGS_SYNC_STATUS] intValue];
            
            settings = [[UserSettings alloc] initWithID:ID andStartPage:startPage andDateFormat:dateFormat andPageType:pageType andTimeFormat:timeFormat andStartDay:startDay andSyncStatus:syncStatus];
            
        }
    }
    
    return settings;
}

-(UserSettings *)settingsForSync
{
    UserSettings* settings = nil;
    NSError* error = nil;
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:CD_TABLE_SETTINGS];
    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if(!error)
    {
        for(NSManagedObject* managedSettings in results)
        {
            
            bool localSync = [[managedSettings valueForKey:CD_ROW_LOCAL_SYNC] boolValue];
            if(!localSync)
            {
                NSUInteger ID = [[managedSettings valueForKey:CD_ROW_ID] integerValue];
                NSString* startPage = (NSString*)[managedSettings valueForKey:CD_ROW_START_PAGE];
                NSString* pageType = (NSString*)[managedSettings valueForKey:CD_ROW_PAGE_TYPE];
                NSString* dateFormat = (NSString*)[managedSettings valueForKey:CD_ROW_DATE_FORMAT];
                NSString* startDay = (NSString*)[managedSettings valueForKey:CD_ROW_START_DAY];
                NSString* timeFormat = (NSString*)[managedSettings valueForKey:CD_ROW_TIME_FORMAT];
                int syncStatus = [[managedSettings valueForKey:CD_ROW_SETTINGS_SYNC_STATUS] intValue];
                
                settings = [[UserSettings alloc] initWithID:ID andStartPage:startPage andDateFormat:dateFormat andPageType:pageType andTimeFormat:timeFormat andStartDay:startDay andSyncStatus:syncStatus];
            }
            
        }
    }
    
    return settings;
}

-(void)updateSettings:(UserSettings *)settings
{
    NSError* error = nil;
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:CD_TABLE_SETTINGS];
    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if(!error)
    {
        if(![results count]) [self setSettings:settings];
        
        else
        {
            for(NSManagedObject* managedSettings in results)
            {
                NSUInteger ID = [[managedSettings valueForKey:CD_ROW_ID] integerValue];
                if(ID == [settings ID])
                {
                    [managedSettings setValue:[NSNumber numberWithInteger:[settings ID]] forKey:CD_ROW_ID];
                    [managedSettings setValue:[settings startPage] forKey:CD_ROW_START_PAGE];
                    [managedSettings setValue:[settings dateFormat] forKey:CD_ROW_DATE_FORMAT];
                    [managedSettings setValue:[settings pageType] forKey:CD_ROW_PAGE_TYPE];
                    [managedSettings setValue:[settings timeFormat] forKey:CD_ROW_TIME_FORMAT];
                    [managedSettings setValue:[NSNumber numberWithInteger:[[NSDate date] timeIntervalSince1970]] forKey:CD_ROW_SETTINGS_SYNC_STATUS];
                    [managedSettings setValue:[NSNumber numberWithBool:NO] forKey:CD_ROW_LOCAL_SYNC];
                    [managedSettings setValue:[settings startDay] forKey:CD_ROW_START_DAY];

                    
                    [self.managedObjectContext save:nil];
                }
            }
        }
    }
}

-(void)setSettings:(UserSettings *)settings
{
    
    NSError* error = nil;
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:CD_TABLE_SETTINGS];
    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if(!error)
    {
        if(![results count])
        {
            NSManagedObjectContext* managedObjectContext = self.managedObjectContext;
            NSEntityDescription* entity = [NSEntityDescription entityForName:CD_TABLE_SETTINGS inManagedObjectContext:managedObjectContext];
            NSManagedObject* object = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:managedObjectContext];
            [object setValue:[NSNumber numberWithInteger:[settings ID]] forKey:CD_ROW_ID];
            [object setValue:[settings startPage] forKey:CD_ROW_START_PAGE];
            [object setValue:[settings dateFormat] forKey:CD_ROW_DATE_FORMAT];
            [object setValue:[settings pageType] forKey:CD_ROW_PAGE_TYPE];
            [object setValue:[settings timeFormat] forKey:CD_ROW_TIME_FORMAT];
            [object setValue:[NSNumber numberWithInteger:[settings syncStatus]] forKey:CD_ROW_SETTINGS_SYNC_STATUS];
            [object setValue:[NSNumber numberWithBool:NO] forKey:CD_ROW_LOCAL_SYNC];
            [object setValue:[settings startDay] forKey:CD_ROW_START_DAY];

            [managedObjectContext save:nil];
        }
        
        else [self updateSettings:settings];
    }
    
}


-(void)cleanTable
{
    [super cleanTable:CD_TABLE_SETTINGS];
}



// SYNC


-(void)syncUpdateSettings:(UserSettings *)settings
{
    NSError* error = nil;
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:CD_TABLE_SETTINGS];
    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if(!error)
    {
        if(![results count]) [self syncSetSettings:settings];
        
        else
        {
            for(NSManagedObject* managedSettings in results)
            {
                NSUInteger ID = [[managedSettings valueForKey:CD_ROW_ID] integerValue];
                if(ID == [settings ID])
                {
                    [managedSettings setValue:[NSNumber numberWithInteger:[settings ID]] forKey:CD_ROW_ID];
                    [managedSettings setValue:[settings startPage] forKey:CD_ROW_START_PAGE];
                    [managedSettings setValue:[settings dateFormat] forKey:CD_ROW_DATE_FORMAT];
                    [managedSettings setValue:[settings pageType] forKey:CD_ROW_PAGE_TYPE];
                    [managedSettings setValue:[settings timeFormat] forKey:CD_ROW_TIME_FORMAT];
                    [managedSettings setValue:[NSNumber numberWithInteger:[settings syncStatus]] forKey:CD_ROW_SETTINGS_SYNC_STATUS];
                    [managedSettings setValue:[NSNumber numberWithBool:YES] forKey:CD_ROW_LOCAL_SYNC];
                    [managedSettings setValue:[settings startDay] forKey:CD_ROW_START_DAY];
                    
                    
                    [self.managedObjectContext save:nil];
                }
            }
        }
    }
}

-(void)syncSetSettings:(UserSettings *)settings
{
    
    NSError* error = nil;
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:CD_TABLE_SETTINGS];
    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if(!error)
    {
        if(![results count])
        {
            NSManagedObjectContext* managedObjectContext = self.managedObjectContext;
            NSEntityDescription* entity = [NSEntityDescription entityForName:CD_TABLE_SETTINGS inManagedObjectContext:managedObjectContext];
            NSManagedObject* object = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:managedObjectContext];
            [object setValue:[NSNumber numberWithInteger:[settings ID]] forKey:CD_ROW_ID];
            [object setValue:[settings startPage] forKey:CD_ROW_START_PAGE];
            [object setValue:[settings dateFormat] forKey:CD_ROW_DATE_FORMAT];
            [object setValue:[settings pageType] forKey:CD_ROW_PAGE_TYPE];
            [object setValue:[settings timeFormat] forKey:CD_ROW_TIME_FORMAT];
            [object setValue:[NSNumber numberWithInteger:[settings syncStatus]] forKey:CD_ROW_SETTINGS_SYNC_STATUS];
            [object setValue:[NSNumber numberWithBool:YES] forKey:CD_ROW_LOCAL_SYNC];
            [object setValue:[settings startDay] forKey:CD_ROW_START_DAY];
            
            [managedObjectContext save:nil];
        }
        
        else [self syncUpdateSettings:settings];
    }
    
}



@end
