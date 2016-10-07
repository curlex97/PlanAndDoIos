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

-(void)addCateroty:(KSCategory*)category completion:(void (^)(bool))completed;

-(void)updateCateroty:(KSCategory*)category completion:(void (^)(bool))completed;

-(void)deleteCateroty:(KSCategory*)category completion:(void (^)(bool))completed;

-(KSCategory*)categoryWithId:(int)Id;

-(void) cleanTable;

-(void) recieveCategoriesFromDictionary:(NSDictionary*)dictionary;

@end
