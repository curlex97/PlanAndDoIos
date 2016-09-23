//
//  SettingsCoreDataManager.h
//  PlanAndDo
//
//  Created by Arthur Chistyak on 19.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "CoreDataManager.h"
#import "UserSettings.h"


@interface SettingsCoreDataManager : CoreDataManager

// test 1 OK
-(UserSettings*) settings;

// test 1 OK
-(void)setSettings:(UserSettings*)settings;

// test 1 OK
-(void)updateSettings:(UserSettings*)settings;


-(void)cleanTable;

@end
