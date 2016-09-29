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





// NAMES
//===================================================================================================================================

#define NM_CHANGE_EMAIL @"Change Email"
#define NM_DESCRIPTION @"Description"
#define NM_DATE_AND_TIME @"Date & Time"
#define NM_CREATE_ACCOUNT @"Create Account"
#define NM_NEW_PASSWORD @"New Password"
#define NM_DDMMYY @"DD/MM/YY"
#define NM_MMDDYY @"MM/DD/YY"
#define NM_12H @"12H"
#define NM_24H @"24H"
#define NM_12 @"12"
#define NM_24 @"24"

#define NM_TODAY @"Today"
#define NM_TOMORROW @"Tomorrow"
#define NM_WEEK @"Week"
#define NM_ARCHIVE @"Archive"
#define NM_BACKLOG @"Backlog"

#define NM_PROFILE @"Profile"
#define NM_SETTINGS @"Settings"
#define NM_FORMAT_DATE @"Format date"
#define NM_FORMAT_TIME @"Format time"
#define NM_EDIT_LIST @"Edit list"
#define NM_START_DAY @"Start day"
#define NM_START_PAGE @"Start page"


#define NM_BOX @"Box"
#define NM_CATEGORY @"Category"
#define NM_CATEGORIES @"Categories"
#define NM_CATEGORY_ADD @"Add category"

#define NM_TASK_HEAD @"Task"

#define NM_PRIORITY_SHORT_LOW @"low"
#define NM_PRIORITY_SHORT_MID @"mid"
#define NM_PRIORITY_SHORT_HIGH @"high"
#define NM_PRIORITY_LONG_LOW @"Default priority"
#define NM_PRIORITY_LONG_MID @"Normal priority"
#define NM_PRIORITY_LONG_HIGH @"High priority"
#define NM_PRIORITY @"Priority"

//===================================================================================================================================





// TITLES
//===================================================================================================================================

#define TL_PROFILE_DELETE_TITLE @"Delete all tasks and categories"
#define TL_PROFILE_DELETE_MSG @"If you remove all categories and tasks, you will be returned to factory settings. Do you want to continue?"
#define TL_PROFILE_CHANGE_NAME_TITLE @"Change name"
#define TL_PROFILE_CHANGE_NAME_MSG @""

#define TL_CANCEL @"Cancel"
#define TL_CONTINUE @"Continue"
#define TL_ENTER_PASSWORD @"Enter password"
#define TL_DELETE @"Delete"
#define TL_OK @"OK"
#define TL_COMPLETE @"Complete"
#define TL_EDIT @"Edit"
#define TL_RIGHT @"Right"
#define TL_LEFT @"Left"
#define TL_SUNDAY @"Sunday"
#define TL_MONDAY @"Monday"
#define TL_MENU @"Menu"
#define TL_COMPLETED @"Completed"
#define TL_OVERDUE @"Overdue"

//===================================================================================================================================




// COORDINATES AND SIZES
//===================================================================================================================================

#define CS_DATELABEL_X 8
#define CS_DATELABEL_Y 0
#define CS_DATELABEL_WIDTH 120
#define CS_DATELABEL_HEIGHT 50

#define CS_TIMELABEL_Y 0
#define CS_TIMELABEL_WIDTH 92
#define CS_TIMELABEL_HEIGHT 50

#define CS_TEXTFIELD_PADDING_LEFT 10

#define CS_LOGIN_GESTURE_MIN 0
#define CS_LOGIN_GESTURE_MAX 88
#define CS_CHANGE_EMAIL_GESTURE_MIN 0
#define CS_CHANGE_EMAIL_GESTURE_MAX 132


//===================================================================================================================================


// CONSTRAINTS
//===================================================================================================================================

#define CO_MULTIPLER 1.0f 

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

#define CLR_ROOT_GRADIENT_START_POINT_X (0.0)
#define CLR_ROOT_GRADIENT_START_POINT_Y (0.5)
#define CLR_ROOT_GRADIENT_END_POINT_X (1.0)
#define CLR_ROOT_GRADIENT_END_POINT_Y (0.5)

#define CLR_DATELABEL (145.0/255.0)
#define CLR_DATELABEL_ALPHA (1.0)

#define CLR_PROFILE_TEXTLABEL (98.0/255.0)
#define CLR_PROFILE_TEXTLABEL_ALPHA (1.0)

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
