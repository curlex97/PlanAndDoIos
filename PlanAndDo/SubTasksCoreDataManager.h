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

// test 1 OK
-(NSArray<KSShortTask*>*) allSubTasksForTask:(KSTaskCollection*)task;

// test 1 OK
-(void)addSubTask:(KSShortTask*)subTask forTask:(KSTaskCollection*)task;

// test 1 OK
-(void)updateSubTask:(KSShortTask*)subTask forTask:(KSTaskCollection*)task;

// test 1 OK
-(void)deleteSubTask:(KSShortTask*)subTask forTask:(KSTaskCollection*)task;

-(void)cleanTable;

@end
