//
//  UserSettings.h
//  PlanAndDo
//
//  Created by Амин on 08.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "KSObject.h"

@interface UserSettings : KSObject

@property (nonatomic)NSString * startPage;
@property (nonatomic)NSString * dateFormat;
@property (nonatomic)NSString * timeFormat;
@property (nonatomic)NSString * pageType;

-(instancetype)initWithID:(NSUInteger)ID andStartPage:(NSString *)startPage
                   andDateFormat:(NSString *)dateFormat
              andPageType:(NSString*)pageType
                   andTimeFormat:(NSString *)timeFormat andSyncStatus:(int)syncStatus;

@end
