//
//  SubTasksApiManager.h
//  PlanAndDo
//
//  Created by Arthur Chistyak on 21.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "ApiManager.h"
#import "KSShortTask.h"
#import "KSTaskCollection.h"
#import "KSTask.h"
#import "KSAuthorisedUser.h"

@interface SubTasksApiManager : ApiManager

-(void)addSubTaskAsync:(KSShortTask*)subTask toTask:(KSTaskCollection*)task forUser:(KSAuthorisedUser*)user;

-(void)updateSubTaskAsync:(KSShortTask*)subTask inTask:(KSTaskCollection*)task forUser:(KSAuthorisedUser*)user;

-(void)deleteSubTaskAsync:(KSShortTask*)subTask fromTask:(KSTaskCollection*)task forUser:(KSAuthorisedUser*)user;

@end
