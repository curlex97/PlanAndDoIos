//
//  KSSubTask.h
//  PlanAndDo
//
//  Created by Arthur Chistyak on 18.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "KSShortTask.h"

@interface KSSubTask : KSShortTask

@property (nonatomic) NSUInteger taskID;

-(instancetype)initWithID:(NSUInteger)ID andName:(NSString *)name andTaskID:(NSUInteger)taskID andStatus:(BOOL)status  andSyncStatus:(int)syncStatus;


@end
