//
//  ApplicationDefines.h
//  PlanAndDo
//
//  Created by Arthur Chistyak on 29.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#ifndef ApplicationDefines_h
#define ApplicationDefines_h




// NOTIFICATION CENTER
//===================================================================================================================================

#define NC_SYNC_COMPLETED @"SyncCompleted"
#define NC_SYNC_USER @"SyncUser"
#define NC_SYNC_SETTINGS @"SyncSettings"
#define NC_SYNC_CATEGORIES @"SyncCategories"
#define NC_SYNC_TASKS @"SyncTasks"
#define NC_SYNC_SUBTASKS @"SyncSubTasks"

#define NC_TASK_ADD @"TaskAdd"
#define NC_TASK_EDIT @"TaskEdit"

#define NC_SIDE_RIGHT @"SideRight"
#define NC_SIDE_LEFT @"SideLeft"
#define NC_BACK_CONTROLLER_APPEARED @"BackViewControllerWillApeared"
#define NC_FRONT_CONTROLLER_APPEARED @"FrontViewControllerWillApeared"

#define NC_EMAIL_CHANGED @"EmailChanged"

//===================================================================================================================================





// COLORS
//===================================================================================================================================

#define CLR_ROOT_GRADIENT_LEFT_RED (61.0/255.0)
#define CLR_ROOT_GRADIENT_LEFT_GREEN (93.0/255.0)
#define CLR_ROOT_GRADIENT_LEFT_BLUE (108.0/255.0)
#define CLR_ROOT_GRADIENT_LEFT_ALPHA (1.0)

#define CLR_ROOT_GRADIENT_RIGHT_RED (40.0/255.0)
#define CLR_ROOT_GRADIENT_RIGHT_GREEN (70.0/255.0)
#define CLR_ROOT_GRADIENT_RIGHT_BLUE (183.0/255.0)
#define CLR_ROOT_GRADIENT_RIGHT_ALPHA (1.0)

#define CLR_ROOT_GRADIENT_START_POINT_X 0.0
#define CLR_ROOT_GRADIENT_START_POINT_Y 0.5
#define CLR_ROOT_GRADIENT_END_POINT_X 1.0
#define CLR_ROOT_GRADIENT_END_POINT_Y 0.5

//===================================================================================================================================





// CORE DATA
//===================================================================================================================================

#define CD_DATABASE_NAME @"PlanAndDo"
#define CD_DATABASE_EXT @"momd"
#define CD_DATABASE_SQLITE @"PlanAndDo.sqlite"

//===================================================================================================================================





// FILE SYSTEM
//===================================================================================================================================

#define FS_TOKEN @"token.txt"

//===================================================================================================================================




// INTERNET
//===================================================================================================================================

#define URL_API @"https://plan-and-do.pro/api"
#define URL_SENDTYPE @"POST"

//===================================================================================================================================




// DATE AND TIME
//===================================================================================================================================

#define DT_ABBREVIATION_ZONE @"GMT"

//===================================================================================================================================








#endif /* ApplicationDefines_h */
