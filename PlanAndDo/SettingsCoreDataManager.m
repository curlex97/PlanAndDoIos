//
//  SettingsCoreDataManager.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 19.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "SettingsCoreDataManager.h"

@implementation SettingsCoreDataManager

-(UserSettings *)settings
{
    UserSettings* settings = nil;
    NSError* error = nil;
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Settings"];
    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if(!error)
    {
        for(NSManagedObject* managedSettings in results)
        {
            NSUInteger ID = [[managedSettings valueForKey:@"id"] integerValue];
            NSString* startPage = (NSString*)[managedSettings valueForKey:@"start_page"];
            NSString* dateFormat = (NSString*)[managedSettings valueForKey:@"date_format"];
            NSString* timeFormat = (NSString*)[managedSettings valueForKey:@"time_format"];
            int syncStatus = [[managedSettings valueForKey:@"settings_sync_status"] intValue];
            
            settings = [[UserSettings alloc] initWithID:ID andStartPage:startPage andDateFormat:dateFormat andTimeFormat:timeFormat andSyncStatus:syncStatus];
            
        }
    }
    
    return settings;
}

-(void)updateSettings:(UserSettings *)settings
{
    NSError* error = nil;
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Settings"];
    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if(!error)
    {
        if(![results count]) [self setSettings:settings];
        
        else
        {
            for(NSManagedObject* managedSettings in results)
            {
                NSUInteger ID = [[managedSettings valueForKey:@"id"] integerValue];
                if(ID == [settings ID])
                {
                    [managedSettings setValue:[NSNumber numberWithInteger:[settings ID]] forKey:@"id"];
                    [managedSettings setValue:[settings startPage] forKey:@"start_page"];
                    [managedSettings setValue:[settings dateFormat] forKey:@"date_format"];
                    [managedSettings setValue:[settings timeFormat] forKey:@"time_format"];
                    [managedSettings setValue:[NSNumber numberWithInteger:[settings syncStatus]] forKey:@"settings_sync_status"];
                    [managedSettings setValue:[NSNumber numberWithBool:NO] forKey:@"local_sync"];

                    [self.managedObjectContext save:nil];
                }
            }
        }
    }
}

-(void)setSettings:(UserSettings *)settings
{
    
    NSError* error = nil;
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Settings"];
    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if(!error)
    {
        if(![results count])
        {
            NSManagedObjectContext* managedObjectContext = self.managedObjectContext;
            NSEntityDescription* entity = [NSEntityDescription entityForName:@"Settings" inManagedObjectContext:managedObjectContext];
            NSManagedObject* object = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:managedObjectContext];
            [object setValue:[NSNumber numberWithInteger:[settings ID]] forKey:@"id"];
            [object setValue:[settings startPage] forKey:@"start_page"];
            [object setValue:[settings dateFormat] forKey:@"date_format"];
            [object setValue:[settings timeFormat] forKey:@"time_format"];
            [object setValue:[NSNumber numberWithInteger:[settings syncStatus]] forKey:@"settings_sync_status"];
            [object setValue:[NSNumber numberWithBool:NO] forKey:@"local_sync"];

            [managedObjectContext save:nil];
        }
        
        else [self updateSettings:settings];
    }
    
}

@end
