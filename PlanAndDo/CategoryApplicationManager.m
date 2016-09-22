//
//  CategoryApplicationManager.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 22.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "CategoryApplicationManager.h"

@implementation CategoryApplicationManager

-(NSArray<KSCategory *> *)allCategories
{
    return [[[CategoryCoreDataManager alloc] init] allCategories];
}

-(void)addCateroty:(KSCategory *)category
{
    [[[CategoryCoreDataManager alloc] init] addCateroty:category];
    [[[CategoryApiManager alloc] init] addCategoryAsync:category forUser:nil completion:nil];
}

-(void)updateCateroty:(KSCategory *)category
{
    [[[CategoryCoreDataManager alloc] init] updateCateroty:category];
    [[[CategoryApiManager alloc] init] updateCategoryAsync:category forUser:nil completion:nil];
}

-(void)deleteCateroty:(KSCategory *)category
{
    [[[CategoryCoreDataManager alloc] init] deleteCateroty:category];
    [[[CategoryApiManager alloc] init] deleteCategoryAsync:category forUser:nil completion:nil];
}

@end
