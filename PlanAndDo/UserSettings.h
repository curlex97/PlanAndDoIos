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
@property (nonatomic)NSString * pageType;
@property (nonatomic)NSString * dateFormat;
@property (nonatomic)NSString * timeFormat;

-(instancetype)initWithStartPage:(NSString *)startPage
                     andPageType:(NSString *)pageType
                   andDateFormat:(NSString *)dateFormat
                   andTimeFormat:(NSString *)timeFormat;

@end
