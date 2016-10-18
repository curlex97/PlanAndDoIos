//
//  KSSplitViewController.m
//  PlanAndDo
//
//  Created by Амин on 14.10.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "KSSplitViewController.h"
@interface KSSplitViewController()
@end

@implementation KSSplitViewController

-(instancetype)initWithMenuVC:(BaseKSMenuViewController *) menuVC
                 andDetailsVC:(UINavigationController *)detailsVC
{
    if(self=[super init])
    {
        self.menu=menuVC;
        self.details=detailsVC;
        self.viewControllers=@[self.menu,self.details];
        self.delegate=self;
        [self setPreferredDisplayMode:UISplitViewControllerDisplayModeAllVisible];
    }
    return self;
}

-(void)setDetails:(UINavigationController *)details
{
    _details=details;
    self.viewControllers=@[self.menu,self.details];
}

- (void)viewDidLayoutSubviews
{
    const CGFloat menuWidth = 270.0;
    
    UIViewController * menuViewController = [self.viewControllers objectAtIndex:0];
    UIViewController * detailViewController = [self.viewControllers objectAtIndex:1];
    
    if (detailViewController.view.frame.origin.x > 0.0)
    {
        CGRect masterViewFrame = menuViewController.view.frame;
        CGFloat deltaX = masterViewFrame.size.width - menuWidth;
        masterViewFrame.size.width -= deltaX;
        menuViewController.view.frame = masterViewFrame;
        
        CGRect detailViewFrame = detailViewController.view.frame;
        detailViewFrame.origin.x -= deltaX;
        detailViewFrame.size.width += deltaX;
        detailViewController.view.frame = detailViewFrame;
        
        [menuViewController.view setNeedsLayout];
        [detailViewController.view setNeedsLayout];
    }
}

@end
