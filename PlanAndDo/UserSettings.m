//
//  UserSettings.m
//  PlanAndDo
//
//  Created by Амин on 08.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "UserSettings.h"

@implementation UserSettings

-(instancetype)initWithStartPage:(NSString *)startPage
                     andPageType:(NSString *)pageType
                   andDateFormat:(NSString *)dateFormat
                   andTimeFormat:(NSString *)timeFormat
{
    if(self=[super init])
    {
        self.startPage=startPage;
        self.pageType=pageType;
        self.dateFormat=dateFormat;
        self.timeFormat=timeFormat;
    }
    return self;
}

@end

