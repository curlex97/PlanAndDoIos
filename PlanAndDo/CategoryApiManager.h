//
//  CategoryApiManager.h
//  PlanAndDo
//
//  Created by Arthur Chistyak on 21.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "ApiManager.h"
#import "KSCategory.h"
#import "KSAuthorisedUser.h"

@interface CategoryApiManager : ApiManager

-(void) addCategoryAsync:(KSCategory*)category forUser:(KSAuthorisedUser*)user;

-(void) updateCategoryAsync:(KSCategory*)category forUser:(KSAuthorisedUser*)user;

-(void) deleteCategoryAsync:(KSCategory*)category forUser:(KSAuthorisedUser*)user;

@end
