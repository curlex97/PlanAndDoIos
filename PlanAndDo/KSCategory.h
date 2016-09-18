//
//  KSCategory.h
//  PlanAndDo
//
//  Created by Arthur Chistyak on 18.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "KSObject.h"

@interface KSCategory : KSObject

@property NSString* name;

-(instancetype)initWithID:(NSUInteger)ID andName:(NSString *)name andSyncStatus:(int)syncStatus;


@end
