//
//  CategoryApplicationManager.h
//  PlanAndDo
//
//  Created by Arthur Chistyak on 22.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KSCategory.h"
#import "CategoryApiManager.h"
#import "CategoryCoreDataManager.h"

@interface CategoryApplicationManager : NSObject

-(NSArray<KSCategory*>*) allCategories;

-(void)addCateroty:(KSCategory*)category;

-(void)updateCateroty:(KSCategory*)category;

-(void)deleteCateroty:(KSCategory*)category;

-(KSCategory*)categoryWithId:(int)Id;

@end
