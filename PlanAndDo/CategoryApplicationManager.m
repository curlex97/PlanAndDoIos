//
//  CategoryApplicationManager.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 22.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "CategoryApplicationManager.h"
#import "ApplicationManager.h"

@implementation CategoryApplicationManager

-(NSArray<KSCategory *> *)allCategories
{
    return [[[CategoryCoreDataManager alloc] init] allCategories];
}

-(KSCategory *)categoryWithId:(int)Id
{
    return [[[CategoryCoreDataManager alloc] init] categoryWithId:Id];
}

-(void)addCateroty:(KSCategory *)category
{
    [[[CategoryCoreDataManager alloc] init] addCateroty:category];
    [[[CategoryApiManager alloc] init] addCategoryAsync:category forUser:[[ApplicationManager userApplicationManager] authorisedUser] completion:nil];
}

-(void)updateCateroty:(KSCategory *)category
{
    [[[CategoryCoreDataManager alloc] init] updateCateroty:category];
    [[[CategoryApiManager alloc] init] updateCategoryAsync:category forUser:[[ApplicationManager userApplicationManager] authorisedUser]  completion:nil];
}

-(void)deleteCateroty:(KSCategory *)category
{
    [[[CategoryCoreDataManager alloc] init] deleteCateroty:category];
    [[[CategoryApiManager alloc] init] deleteCategoryAsync:category forUser:[[ApplicationManager userApplicationManager] authorisedUser]  completion:nil];
}

-(void) cleanTable
{
    return [[[CategoryCoreDataManager alloc] init] cleanTable];
}

@end
