//
//  KSTaskCollection.h
//  PlanAndDo
//
//  Created by Амин on 08.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTask.h"

@interface KSTaskCollection : BaseTask

@property (nonatomic)NSMutableArray<KSShortTask *> * subTasks;

-(instancetype)initWithID:(int)ID andName:(NSString *)name
                andStatus:(BOOL)status
      andTaskReminderTime:(NSDate*) taskReminderTime
          andTaskPriority:(KSTaskPriority)priority
            andCategoryID:(int)categoryID
             andCreatedAt:(NSDate*)createdAt
        andCompletionTime:(NSDate*)completionTime
            andSyncStatus:(int)syncStatus
              andSubTasks:(NSMutableArray<KSShortTask*>*)subTasks;
@end
