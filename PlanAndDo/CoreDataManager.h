//
//  CoreDataManager.h
//  PlanAndDo
//
//  Created by Arthur Chistyak on 17.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

static NSManagedObjectContext* managedObjectContext;

@interface CoreDataManager : NSObject


-(NSArray*) fetch:(NSString*)table;

-(NSManagedObjectContext*) managedObjectContext;


-(void)getMany;

@end

