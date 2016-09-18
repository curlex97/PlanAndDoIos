//
//  SubTasksCoreDataManager.h
//  PlanAndDo
//
//  Created by Arthur Chistyak on 19.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "CoreDataManager.h"
#import "KSShortTask.h"
#import "KSTaskCollection.h"

@interface SubTasksCoreDataManager : CoreDataManager

-(NSArray<KSShortTask*>*) allSubTasksForTask:(KSTaskCollection*)task;

-(void)addSubTask:(KSShortTask*)subTask forTask:(KSTaskCollection*)task;
-(void)updateSubTask:(KSShortTask*)subTask forTask:(KSTaskCollection*)task;
-(void)deleteSubTask:(KSShortTask*)subTask forTask:(KSTaskCollection*)task;

@end
