//
//  UserSettings.m
//  PlanAndDo
//
//  Created by Амин on 08.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "UserSettings.h"

@implementation UserSettings

-(instancetype)initWithID:(int)ID andStartPage:(NSString *)startPage
            andDateFormat:(NSString *)dateFormat
              andPageType:(NSString*)pageType
            andTimeFormat:(NSString *)timeFormat andStartDay:(NSString*)startDay andSyncStatus:(int)syncStatus
{
    if(self=[super init])
    {
        self.ID = ID;
        self.startPage=startPage;
        self.pageType = pageType;
        self.dateFormat=dateFormat;
        self.timeFormat=timeFormat;
        self.syncStatus = syncStatus;
        self.startDay = startDay;
    }
    return self;
}

@end

