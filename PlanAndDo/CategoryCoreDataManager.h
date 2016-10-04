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

// test 1 OK
-(KSCategory*)categoryWithId:(int)Id;

// test 1 OK
-(void)addCateroty:(KSCategory*)category;

// test 1 OK
-(void)updateCateroty:(KSCategory*)category;

// test 1 OK
-(void)deleteCateroty:(KSCategory*)category;

-(void)cleanTable;


// SYNC

-(void)syncAddCateroty:(KSCategory *)category;

-(void)syncUpdateCateroty:(KSCategory*)category;

-(void)syncDeleteCateroty:(KSCategory*)category;

-(NSArray<KSCategory *> *)allCategoriesForSyncAdd;

-(NSArray<KSCategory *> *)allCategoriesForSyncUpdate;

-(NSArray<KSCategory *> *)allCategoriesForSyncDelete;

@end
