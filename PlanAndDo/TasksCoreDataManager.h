//
//  TasksCoreDataManager.h
//  PlanAndDo
//
//  Created by Arthur Chistyak on 17.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "CoreDataManager.h"
#import "BaseTask.h"
#import "KSTask.h"
#import "KSTaskCollection.h"

@interface TasksCoreDataManager : CoreDataManager

-(NSArray<BaseTask *>*) allTasks;
-(NSArray<BaseTask *>*) allTasksForToday;
-(NSArray<BaseTask *>*) allTasksForTomorrow;
-(NSArray<BaseTask *>*) allTasksForWeek;
-(NSArray<BaseTask *>*) allTasksForArchive;
-(NSArray<BaseTask *>*) allTasksForBacklog;

-(BaseTask*)taskWithId:(int)Id;

-(void) updateTask:(BaseTask*)task;
-(void)addTask:(BaseTask*)task;
-(void)deleteTask:(BaseTask*)task;

@end
