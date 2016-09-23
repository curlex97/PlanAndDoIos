//
//  CategoryCoreDataManager.h
//  PlanAndDo
//
//  Created by Arthur Chistyak on 19.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "CoreDataManager.h"
#import "KSCategory.h"

@interface CategoryCoreDataManager : CoreDataManager

// test 1 OK
-(NSArray<KSCategory*>*) allCategories;

-(KSCategory*)categoryWithId:(int)Id;

// test 1 OK
-(void)addCateroty:(KSCategory*)category;

// test 1 OK
-(void)updateCateroty:(KSCategory*)category;

// test 1 OK
-(void)deleteCateroty:(KSCategory*)category;

-(void)cleanTable;

@end
