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

-(instancetype)initWithID:(NSUInteger)ID andStartPage:(NSString *)startPage
                   andDateFormat:(NSString *)dateFormat
                   andTimeFormat:(NSString *)timeFormat andSyncStatus:(int)syncStatus;

@end
