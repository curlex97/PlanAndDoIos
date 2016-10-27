//
//  AppDelegate.m
//  PlanAndDo
//
//  Created by Arthur Chistyak on 08.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "AppDelegate.h"
#import "AMSideBarViewController.h"
#import "AMAndroidSideBarViewController.h"
#import "BaseViewController.h"
#import "KSApplicationColor.h"
#import "LoginViewController.h"
#import "FileManager.h"
#import "ApplicationManager.h"
#import "TabletasksViewController.h"
#import "KSMenuViewController.h"
#import "LaunchScreenViewController.h"
#import "ViewController.h"
#import "KSSplitViewController.h"
#import "EditTaskViewController.h"
#import "KSNotificationView.h"

@interface AppDelegate ()<UIGestureRecognizerDelegate>
@property AMSideBarViewController *sideBarViewController;
@property (nonatomic)BaseTask * taskFromNotification;
@property (nonatomic)KSNotificationView * notView;
@property (nonatomic)NSLayoutConstraint * top;
@property (nonatomic)NSLayoutConstraint * left;
@property (nonatomic)NSLayoutConstraint * right;
@property (nonatomic)UIPanGestureRecognizer * pan;
@property (nonatomic)CGPoint tapPoint;
@property (nonatomic)CGPoint startPoint;
@property (nonatomic)NSTimer * timer;
@property (nonatomic)double time;
@property (nonatomic)BOOL direction;
@end

@implementation AppDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    self.tapPoint=[gestureRecognizer locationInView:self.window.rootViewController.view];
    self.startPoint=CGPointMake(0, 0);
    
    self.timer=[NSTimer scheduledTimerWithTimeInterval:0.01
                                                target:self
                                              selector:@selector(timerTick)
                                              userInfo:nil
                                               repeats:YES];
    self.time=0.0;
    [self.timer fire];
    
    return YES;
}

-(void)timerTick
{
    self.time+=0.01;
}

-(void)moveFrontViewOnPosition:(double)xPos
{
    self.left.constant=xPos;
    self.right.constant=xPos;
    UIView * rootView;
    if([[UIDevice currentDevice].model isEqualToString:@"iPad"])
    {
        EditTaskViewController * editViewController=[[EditTaskViewController alloc] init];
        editViewController.task=self.taskFromNotification;
        KSSplitViewController * spliter=(KSSplitViewController *)self.window.rootViewController;
        UINavigationController * naviVC=spliter.details;
        rootView=naviVC.viewControllers.lastObject.view;
    }
    else
    {
        AMSideBarViewController * sider=(AMSideBarViewController *)self.window.rootViewController;
        UINavigationController * naviVC=(UINavigationController *)sider.frontViewController;
        [naviVC.viewControllers.lastObject.view addSubview:self.notView];
        rootView=naviVC.viewControllers.lastObject.view;
    }
    [rootView layoutSubviews];
}

-(void)gesturePan
{
    CGPoint location=[self.pan locationInView:self.window.rootViewController.view];
    
    
    [self moveFrontViewOnPosition:location.x-self.tapPoint.x];
    
    if(self.pan.state==UIGestureRecognizerStateEnded)
    {
        
        if(location.x>self.tapPoint.x)
        {
            self.direction=YES;
        }
        else
        {
            self.direction=NO;
        }
        
        if(self.time>=0.2)
        {
            if(self.left.constant<0)
            {
                self.direction=NO;
            }
            else
            {
                self.direction=YES;
            }
        }
        
        [self.timer invalidate];
        [self gestureSwipe];
    }
    
}

-(void)gestureSwipe
{
    if(self.direction)
    {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^
         {
             [self moveFrontViewOnPosition:self.window.rootViewController.view.bounds.size.width];
         } completion:^(BOOL end)
         {
            if(end)
            {
                [self.notView removeFromSuperview];
            }
         }];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NC_FRONT_CONTROLLER_APPEARED object:nil];
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^
         {
             [self moveFrontViewOnPosition:-self.window.rootViewController.view.bounds.size.width];
         } completion:^(BOOL end)
         {
             if(end)
             {
                 [self.notView removeFromSuperview];
             }
         }];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSDictionary * userInfo=nil;
    if (launchOptions[UIApplicationLaunchOptionsLocalNotificationKey])
    {
        userInfo=[launchOptions[UIApplicationLaunchOptionsLocalNotificationKey] userInfo];
    }
    LaunchScreenViewController * launch=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LaunchScreenViewController"];
    launch.options=userInfo;
    self.window.rootViewController=launch;
    [self.window makeKeyAndVisible];
    
    self.pan=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gesturePan)];
    self.pan.delegate=self;
    self.notView=[[[NSBundle mainBundle] loadNibNamed:@"NotificationView" owner:self options:nil] firstObject];
    
    [self.notView addGestureRecognizer:self.pan];
    UIButton * notificationButton=[[UIButton alloc] initWithFrame:self.notView.frame];
    [notificationButton addTarget:self action:@selector(notificationDidTap) forControlEvents:UIControlEventTouchUpInside];
    [self.notView addSubview:notificationButton];
    self.notView.translatesAutoresizingMaskIntoConstraints=NO;
    [self.notView addConstraint:[NSLayoutConstraint
                                 constraintWithItem:notificationButton
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                 toItem:self.notView
                                 attribute:NSLayoutAttributeBottom
                                 multiplier:1.0f
                                 constant:0.0]];
    
    [self.notView addConstraint:[NSLayoutConstraint
                                 constraintWithItem:notificationButton
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                 toItem:self.notView
                                 attribute:NSLayoutAttributeTop
                                 multiplier:1.0f
                                 constant:0.0]];
    
    [self.notView addConstraint:[NSLayoutConstraint
                                 constraintWithItem:notificationButton
                                 attribute:NSLayoutAttributeTrailing
                                 relatedBy:NSLayoutRelationEqual
                                 toItem:self.notView
                                 attribute:NSLayoutAttributeTrailing
                                 multiplier:1.0f
                                 constant:0.0]];
    
    [self.notView addConstraint:[NSLayoutConstraint
                                 constraintWithItem:notificationButton
                                 attribute:NSLayoutAttributeLeading
                                 relatedBy:NSLayoutRelationEqual
                                 toItem:self.notView
                                 attribute:NSLayoutAttributeLeading
                                 multiplier:1.0f
                                 constant:0.0]];
    
    UIButton * closeButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 16.0, 16.0)];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"Сross"] forState:UIControlStateNormal];
    //closeButton.backgroundColor=[UIColor whiteColor];
    [closeButton addTarget:self action:@selector(notifiationDidClose) forControlEvents:UIControlEventTouchUpInside];
    [self.notView addSubview:closeButton];
    closeButton.translatesAutoresizingMaskIntoConstraints=NO;
    [closeButton addConstraint:[NSLayoutConstraint
                                constraintWithItem:closeButton
                                attribute:NSLayoutAttributeWidth
                                relatedBy:NSLayoutRelationEqual
                                toItem:nil
                                attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1.0f
                                constant:16.0]];
    
    [closeButton addConstraint:[NSLayoutConstraint
                                constraintWithItem:closeButton
                                attribute:NSLayoutAttributeHeight
                                relatedBy:NSLayoutRelationEqual
                                toItem:nil
                                attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1.0f
                                constant:16.0]];
    [self.notView addConstraint:[NSLayoutConstraint
                                 constraintWithItem:closeButton
                                 attribute:NSLayoutAttributeCenterY
                                 relatedBy:NSLayoutRelationEqual
                                 toItem:self.notView
                                 attribute:NSLayoutAttributeCenterY
                                 multiplier:1.0f
                                 constant:0.0]];
    
    [self.notView addConstraint:[NSLayoutConstraint
                                 constraintWithItem:closeButton
                                 attribute:NSLayoutAttributeTrailing
                                 relatedBy:NSLayoutRelationEqual
                                 toItem:self.notView
                                 attribute:NSLayoutAttributeTrailing
                                 multiplier:1.0f
                                 constant:-16.0]];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
 
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

-(void)notificationDidTap
{
    UIView * rootView;
    if([[UIDevice currentDevice].model isEqualToString:@"iPad"])
    {
        EditTaskViewController * editViewController=[[EditTaskViewController alloc] init];
        editViewController.task=self.taskFromNotification;
        KSSplitViewController * spliter=(KSSplitViewController *)self.window.rootViewController;
        UINavigationController * naviVC=spliter.details;
        rootView=naviVC.viewControllers.lastObject.view;
        if([naviVC.viewControllers.lastObject isKindOfClass:[TabletasksViewController class]])
        {
            [naviVC pushViewController:editViewController animated:YES];
        }
        else
        {
            TabletasksViewController * tasksViewController=[[TabletasksViewController alloc] init];
        
            tasksViewController.category=self.taskFromNotification.categoryID?[[ApplicationManager sharedApplication].categoryApplicationManager categoryWithId:self.taskFromNotification.categoryID]:nil;
            naviVC = [[UINavigationController alloc] initWithRootViewController:tasksViewController];
            [naviVC pushViewController:editViewController animated:YES];
        
            spliter.details=naviVC;
        }
    }
    else
    {
        EditTaskViewController * editViewController=[[EditTaskViewController alloc] init];
        editViewController.task=self.taskFromNotification;
        AMSideBarViewController * sider=(AMSideBarViewController *)self.window.rootViewController;
        UINavigationController * frontVC=(UINavigationController *)sider.frontViewController;
        rootView=frontVC.viewControllers.lastObject.view;
        if([frontVC.viewControllers.lastObject isKindOfClass:[TabletasksViewController class]])
        {
            [frontVC pushViewController:editViewController animated:YES];
        }
        else
        {
            TabletasksViewController * tasksViewController=[[TabletasksViewController alloc] init];
        
            tasksViewController.category=self.taskFromNotification.categoryID?[[ApplicationManager sharedApplication].categoryApplicationManager categoryWithId:self.taskFromNotification.categoryID]:nil;
            frontVC = [[UINavigationController alloc] initWithRootViewController:tasksViewController];
            [frontVC pushViewController:editViewController animated:YES];
        
            [sider setNewFrontViewController:frontVC];
        }
    }
    self.top.constant=-50.0;
    [UIView animateWithDuration:0.5 animations:^
     {
         [rootView layoutIfNeeded];
     } completion:^(BOOL finished)
     {
         if(finished)
         {
             [self.notView removeFromSuperview];
         }
     }];
}

-(void)notifiationDidClose
{
    UIView * rootView;
    if([[UIDevice currentDevice].model isEqualToString:@"iPad"])
    {
        EditTaskViewController * editViewController=[[EditTaskViewController alloc] init];
        editViewController.task=self.taskFromNotification;
        KSSplitViewController * spliter=(KSSplitViewController *)self.window.rootViewController;
        UINavigationController * naviVC=spliter.details;
        rootView=naviVC.viewControllers.lastObject.view;
    }
    else
    {
        EditTaskViewController * editViewController=[[EditTaskViewController alloc] init];
        editViewController.task=self.taskFromNotification;
        AMSideBarViewController * sider=(AMSideBarViewController *)self.window.rootViewController;
        UINavigationController * frontVC=(UINavigationController *)sider.frontViewController;
        rootView=frontVC.viewControllers.lastObject.view;
    }
    self.top.constant=-50.0;
    [UIView animateWithDuration:0.5 animations:^
     {
         [rootView layoutIfNeeded];
     } completion:^(BOOL finished)
     {
         if(finished)
         {
             [self.notView removeFromSuperview];
         }
     }];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [self.notView removeFromSuperview];
    UIApplicationState state = [application applicationState];
    self.taskFromNotification=[[ApplicationManager sharedApplication].tasksApplicationManager taskWithId:[[notification.userInfo objectForKey:@"ID"] intValue]];
    UIView * rootView;
    if (state == UIApplicationStateActive)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale=[NSLocale systemLocale];
        self.notView.headerLabel.text=self.taskFromNotification.name;
        [dateFormatter setDateFormat:[[ApplicationManager sharedApplication].settingsApplicationManager.settings.timeFormat isEqualToString:@"24"]?@"HH:mm":@"hh:mm"];
        self.notView.timeLabel.text = [dateFormatter stringFromDate:self.taskFromNotification.completionTime];

        if([[UIDevice currentDevice].model isEqualToString:@"iPad"])
        {
            KSSplitViewController * spliter=(KSSplitViewController *)self.window.rootViewController;
            UINavigationController * naviVC=(UINavigationController *)spliter.details;
            self.notView.translatesAutoresizingMaskIntoConstraints=NO;
            [naviVC.viewControllers.lastObject.view addSubview:self.notView];
            rootView=naviVC.viewControllers.lastObject.view;
        }
        else
        {
            AMSideBarViewController * sider=(AMSideBarViewController *)self.window.rootViewController;
            UINavigationController * naviVC=(UINavigationController *)sider.frontViewController;
            self.notView.translatesAutoresizingMaskIntoConstraints=NO;
            [naviVC.viewControllers.lastObject.view addSubview:self.notView];
            rootView=naviVC.viewControllers.lastObject.view;
        }
        [self.notView addConstraint:[NSLayoutConstraint
                                     constraintWithItem:self.notView
                                     attribute:NSLayoutAttributeHeight
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                     attribute:NSLayoutAttributeNotAnAttribute
                                     multiplier:1.0f
                                     constant:50.0]];
        
        self.top=[NSLayoutConstraint
                  constraintWithItem:self.notView
                  attribute:NSLayoutAttributeTop
                  relatedBy:NSLayoutRelationEqual
                  toItem:rootView
                  attribute:NSLayoutAttributeTop
                  multiplier:1.0f
                  constant:-50.0];
        [rootView addConstraint:self.top];
        
        self.right=[NSLayoutConstraint
                    constraintWithItem:self.notView
                    attribute:NSLayoutAttributeTrailing
                    relatedBy:NSLayoutRelationEqual
                    toItem:rootView
                    attribute:NSLayoutAttributeTrailing
                    multiplier:1.0f
                    constant:0.0];
        [rootView addConstraint:self.right];
        
        self.left=[NSLayoutConstraint
                   constraintWithItem:self.notView
                   attribute:NSLayoutAttributeLeading
                   relatedBy:NSLayoutRelationEqual
                   toItem:rootView
                   attribute:NSLayoutAttributeLeading
                   multiplier:1.0f
                   constant:0.0];
        [rootView addConstraint:self.left];
        [rootView layoutIfNeeded];
        self.top.constant=0.0;
        [UIView animateWithDuration:0.5 animations:^
         {
             [rootView layoutIfNeeded];
         }];

    }
    else if(state == UIApplicationStateInactive)
    {
        if([[UIDevice currentDevice].model isEqualToString:@"iPad"])
        {
            KSSplitViewController * spliter=(KSSplitViewController *)self.window.rootViewController;
            TabletasksViewController * tasksViewController=[[TabletasksViewController alloc] init];
            EditTaskViewController * editViewController=[[EditTaskViewController alloc] init];
            editViewController.task=self.taskFromNotification;
            
            tasksViewController.category=self.taskFromNotification.categoryID?[[ApplicationManager sharedApplication].categoryApplicationManager categoryWithId:self.taskFromNotification.categoryID]:nil;
            UINavigationController* tasksNav = [[UINavigationController alloc] initWithRootViewController:tasksViewController];
            [tasksNav pushViewController:editViewController animated:YES];
            
            spliter.details=tasksNav;
        }
        else
        {
            AMSideBarViewController * sider=(AMSideBarViewController *)self.window.rootViewController;
            TabletasksViewController * tasksViewController=[[TabletasksViewController alloc] init];
            EditTaskViewController * editViewController=[[EditTaskViewController alloc] init];
            editViewController.task=self.taskFromNotification;
            
            tasksViewController.category=self.taskFromNotification.categoryID?[[ApplicationManager sharedApplication].categoryApplicationManager categoryWithId:self.taskFromNotification.categoryID]:nil;
            UINavigationController* tasksNav = [[UINavigationController alloc] initWithRootViewController:tasksViewController];
            [tasksNav pushViewController:editViewController animated:YES];
            
            [sider setNewFrontViewController:tasksNav];
        }
    }
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
    
    //application.applicationIconBadgeNumber = 0;
}
#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "localhost.PlanAndDo" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"PlanAndDo" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"PlanAndDo.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
