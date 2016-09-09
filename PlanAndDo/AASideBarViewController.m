//
//  ViewController.m
//  AMGitHubApplication
//
//  Created by Амин on 24.07.16.
//  Copyright © 2016 Амин. All rights reserved.
//

#import "AASideBarViewController.h"

@interface AASideBarViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic)UIPanGestureRecognizer * pan;

@property (nonatomic)CGPoint tapPoint;
@property (nonatomic)CGPoint startPoint;
@property (nonatomic)NSTimer * timer;
@property (nonatomic)double time;

@property (nonatomic)SideDirection direction;
@end

@implementation AASideBarViewController

#define MENU_WIDTH 270.0
#define MIN_OFFSET -280.0
#define MAX_OFFSET 0.0

#pragma mark - Gesture delegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    self.tapPoint=[gestureRecognizer locationInView:self.view];
    self.startPoint= CGPointMake(self.frontViewController.view.frame.origin.x - MENU_WIDTH, self.frontViewController.view.frame.origin.y);
    
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

-(void)setNewFrontViewController:(UIViewController *)frontViewController
{
    CGPoint lastCoords;
    if(self.frontViewController)
    {
        lastCoords=self.frontViewController.view.frame.origin;
        [self.frontViewController.view removeFromSuperview];
        [self.frontViewController removeFromParentViewController];
    }
    
    CGRect pathRect=self.backViewController.view.bounds;
    pathRect.size=self.backViewController.view.frame.size;
    self.backViewController.view.layer.shadowColor=[UIColor blackColor].CGColor;
    self.backViewController.view.layer.shadowPath=[UIBezierPath bezierPathWithRect:pathRect].CGPath;
    self.backViewController.view.layer.shadowRadius=10.0;
    self.backViewController.view.layer.shadowOpacity = 1.0f;
    self.backViewController.view.layer.rasterizationScale=[UIScreen mainScreen].scale;
    
    
    self.frontViewController=frontViewController;
    self.frontViewController.view.frame=
    CGRectMake(lastCoords.x,
               self.frontViewController.view.frame.origin.y,
               self.frontViewController.view.frame.size.width,
               self.frontViewController.view.frame.size.height);
    
    
    
    [self addChildViewController:self.frontViewController];
    [self.view insertSubview:self.frontViewController.view belowSubview:self.backViewController.view];
    
    self.pan=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gesturePan)];
    self.pan.delegate=self;
    
    [self.frontViewController.view addGestureRecognizer:self.pan];
}

+(AASideBarViewController *)sideBarWithFrontVC:(UIViewController *)frontVC andBackVC:(UIViewController *)backVC
{
    AASideBarViewController * sideBar=[[AASideBarViewController alloc] init];
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
    
    

    
    sideBar.backViewController=backVC;
    
    sideBar.backViewController.view.frame =
    CGRectMake(MIN_OFFSET,
               sideBar.backViewController.view.frame.origin.y,
               MENU_WIDTH,
               sideBar.backViewController.view.frame.size.height);
    
    [sideBar addChildViewController:backVC];
    [sideBar.view addSubview:backVC.view];
    
    [sideBar setNewFrontViewController:frontVC];
    return sideBar;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    self.startPoint=CGPointMake(0, 0);
    
    
}
-(void)setDirection:(SideDirection)direction
{
    _direction=direction;
    if(_direction==SideDirectionRight)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SideRight" object:nil];
    }
}
-(void)timerTick
{
    self.time+=0.01;
}

-(void)moveFrontViewOnPosition:(double)xPos
{
    self.navigationController.navigationBar.frame=
               CGRectMake(xPos + MENU_WIDTH,
               self.navigationController.navigationBar.frame.origin.y,
               self.navigationController.navigationBar.frame.size.width,
               self.navigationController.navigationBar.frame.size.height);
    
    self.backViewController.view.frame=
               CGRectMake(xPos,
               self.backViewController.view.frame.origin.y,
               self.backViewController.view.frame.size.width,
               self.backViewController.view.frame.size.height);
}

-(void)gestureSwipe
{
    if(self.direction==SideDirectionRight)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BackViewControllerWillApeared" object:nil];
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^
         {
             [self moveFrontViewOnPosition:MAX_OFFSET];
         } completion:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FrontViewControllerWillApeared" object:nil];
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^
         {
             [self moveFrontViewOnPosition:MIN_OFFSET];
         } completion:nil];
    }
}

-(void)gesturePan
{
    CGPoint location=[self.pan locationInView:self.view];
    
    
    if(self.startPoint.x+(location.x-self.tapPoint.x)>=MIN_OFFSET)
    {
        CGFloat delta = (location.x - self.tapPoint.x);
        if(location.x > self.tapPoint.x){
            [self moveFrontViewOnPosition:self.startPoint.x+delta];
        }
        else if(location.x < self.tapPoint.x){
            [self moveFrontViewOnPosition:self.startPoint.x+delta + MENU_WIDTH];
        }
    }
    
    if(self.pan.state==UIGestureRecognizerStateEnded)
    {
            
        if(location.x + MENU_WIDTH >self.tapPoint.x)
        {
            self.direction=SideDirectionRight;
        }
        else
        {
            self.direction=SideDirectionLeft;
        }
        
        if(self.time>=0.2)
        {
            if(self.startPoint.x+(location.x-self.tapPoint.x)<(MAX_OFFSET - MIN_OFFSET)*-1)
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
