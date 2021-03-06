//
//  AMAndroidSideBarViewController.m
//  PlanAndDo
//
//  Created by Амин on 10.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "AMAndroidSideBarViewController.h"
#import "AMSideBarViewController.h"
#import "ApplicationManager.h"

@interface AMAndroidSideBarViewController () <UIGestureRecognizerDelegate>
@property (nonatomic)UIPanGestureRecognizer * pan;

@property (nonatomic)CGPoint tapPoint;
@property (nonatomic)CGPoint startPoint;
@property (nonatomic)NSTimer * timer;
@property (nonatomic)double time;

@property (nonatomic)SideDirection direction;
@end

@implementation AMAndroidSideBarViewController

#define MAX_OFFSET -290.0

#pragma mark - Gesture delegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    self.tapPoint=[gestureRecognizer locationInView:self.view];
    self.startPoint=self.frontViewController.view.frame.origin;
    
    self.timer=[NSTimer scheduledTimerWithTimeInterval:0.01
                                                target:self
                                              selector:@selector(timerTick)
                                              userInfo:nil
                                               repeats:YES];
    self.time=0.0;
    [self.timer fire];
    
    return YES;
}

#pragma mark - Life Cycle

-(void)setNewBackViewController:(UIViewController *)frontViewController
{
    if(self.backViewController)
    {
        [self.backViewController.view removeFromSuperview];
        [self.backViewController removeFromParentViewController];
    }
    
    self.backViewController=frontViewController;

    [self addChildViewController:self.backViewController];
    [self.view insertSubview:self.backViewController.view belowSubview:self.frontViewController.view];
    self.pan=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gesturePan)];
    self.pan.delegate=self;
    
    NSLog(@"%@",self.view.subviews);
    NSLog(@"%@",self.childViewControllers);
    [self.view addGestureRecognizer:self.pan];
}

+(AMAndroidSideBarViewController *)sideBarWithFrontVC:(UIViewController *)frontVC andBackVC:(UIViewController *)backVC
{
    AMAndroidSideBarViewController * sideBar=[[AMAndroidSideBarViewController alloc] init];
    sideBar.direction=SideDirectionLeft;
    NSMutableArray * array=[NSMutableArray array];
    for(int i=0;i<sideBar.view.subviews.count;++i)
    {
        [array addObject:sideBar.view.subviews[i]];
    }
    
    for(int i=0;i<sideBar.view.subviews.count;++i)
    {
        [array[i] removeFromSuperview];
    }
    
    sideBar.frontViewController=frontVC;
    sideBar.frontViewController.view.frame=CGRectMake(MAX_OFFSET,
                                                  sideBar.frontViewController.view.frame.origin.y,
                                                  sideBar.frontViewController.view.frame.size.width-50,
                                                  sideBar.frontViewController.view.frame.size.height);
    CGRect pathRect=sideBar.frontViewController.view.bounds;
    pathRect.size=sideBar.frontViewController.view.frame.size;
    sideBar.frontViewController.view.layer.shadowColor=[UIColor blackColor].CGColor;
    sideBar.frontViewController.view.layer.shadowPath=[UIBezierPath bezierPathWithRect:pathRect].CGPath;
    sideBar.frontViewController.view.layer.shadowRadius=10.0;
    sideBar.frontViewController.view.layer.shadowOpacity = 1.0f;
    sideBar.frontViewController.view.layer.rasterizationScale=[UIScreen mainScreen].scale;
    [sideBar addChildViewController:frontVC];
    [sideBar.view addSubview:frontVC.view];
    [sideBar setNewBackViewController:backVC];
    return sideBar;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.startPoint=CGPointMake(MAX_OFFSET, 0);
    
    
}
-(void)setDirection:(SideDirection)direction
{
    _direction=direction;
    if(_direction==SideDirectionRight)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NC_SIDE_RIGHT object:nil];
    }
}
-(void)timerTick
{
    self.time+=0.01;
}

-(void)moveFrontViewOnPosition:(double)xPos
{
    self.navigationController.navigationBar.frame=
    CGRectMake(xPos,
               self.navigationController.navigationBar.frame.origin.y,
               self.navigationController.navigationBar.frame.size.width,
               self.navigationController.navigationBar.frame.size.height);
    
    self.frontViewController.view.frame=
    CGRectMake(xPos,
               self.frontViewController.view.frame.origin.y,
               self.frontViewController.view.frame.size.width,
               self.frontViewController.view.frame.size.height);
}

-(void)gestureSwipe
{
    if(self.direction==SideDirectionRight)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NC_BACK_CONTROLLER_APPEARED object:nil];
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^
         {
             [self moveFrontViewOnPosition:0.0];
         } completion:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NC_FRONT_CONTROLLER_APPEARED object:nil];
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^
         {
             [self moveFrontViewOnPosition:MAX_OFFSET];
         } completion:nil];
    }
}

-(void)gesturePan
{
    CGPoint location=[self.pan locationInView:self.view];
    
    
    if(self.startPoint.x+(location.x-self.tapPoint.x)<0)
    {
        [self moveFrontViewOnPosition:self.startPoint.x+(location.x-self.tapPoint.x)];
    }
    
    if(self.pan.state==UIGestureRecognizerStateEnded)
    {
        
        if(location.x>self.tapPoint.x)
        {
            self.direction=SideDirectionRight;
        }
        else
        {
            self.direction=SideDirectionLeft;
        }
        
        if(self.time>=0.2)
        {
            if(self.startPoint.x+(location.x-self.tapPoint.x)<MAX_OFFSET/2+30)
            {
                self.direction=SideDirectionLeft;
            }
            else
            {
                self.direction=SideDirectionRight;
            }
        }
        
        [self.timer invalidate];
        [self gestureSwipe];
    }
    
}

-(void)side
{
    if(self.direction==SideDirectionLeft)
    {
        self.direction=SideDirectionRight;
    }
    else
    {
        self.direction=SideDirectionLeft;
    }
    [self gestureSwipe];
}


@end
