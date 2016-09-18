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

-(NSArray<KSCategory*>*) allCategories;

-(void)addCateroty:(KSCategory*)category;
-(void)updateCateroty:(KSCategory*)category;
-(void)deleteCateroty:(KSCategory*)category;


@end
