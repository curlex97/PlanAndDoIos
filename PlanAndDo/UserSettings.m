//
//  UserSettings.m
//  PlanAndDo
//
//  Created by Амин on 08.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "UserSettings.h"

@implementation UserSettings

-(instancetype)initWithID:(NSUInteger)ID andStartPage:(NSString *)startPage
            andDateFormat:(NSString *)dateFormat
            andTimeFormat:(NSString *)timeFormat andSyncStatus:(int)syncStatus
{
    if(self=[super init])
    {
        self.ID = ID;
        self.startPage=startPage;
        self.dateFormat=dateFormat;
        self.timeFormat=timeFormat;
        self.syncStatus = syncStatus;
    }
    return self;
}

@end

