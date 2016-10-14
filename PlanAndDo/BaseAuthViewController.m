//
//  BaseMenuViewController.m
//  PlanAndDo
//
//  Created by Амин on 14.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "BaseAuthViewController.h"
#import "KSApplicationColor.h"

@interface BaseAuthViewController ()
@property (nonatomic, strong) UIImageView* imageView;
@end

@implementation BaseAuthViewController

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
//    CALayer * gradient=self.view.layer.sublayers[0];
//    CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
//    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
//    CGRect rect = CGRectMake(gradient.frame.origin.x, gradient.frame.origin.y, self.view.frame.size.height + navigationBarHeight + statusBarHeight, self.view.frame.size.width);
//    [UIView animateWithDuration:duration animations:^{
//        
//        gradient.frame = rect;
//    }];
//    NSLog(@"rect = %@", NSStringFromCGRect(rect));
//    NSLog(@"view = %@", NSStringFromCGRect(self.view.bounds));
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    NSLog(@"%@", NSStringFromCGRect(self.imageView.frame));
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CAGradientLayer * gradient=[KSApplicationColor sharedColor].rootGradient;
    gradient.frame=self.view.bounds;
    UIGraphicsBeginImageContext([gradient frame].size);
    
    [gradient renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    self.imageView=[[UIImageView alloc] initWithImage:outputImage];
    self.imageView.contentMode = UIViewContentModeScaleToFill;
    self.imageView.frame=self.view.bounds;
    [self.view insertSubview:self.imageView atIndex:0];
    
    self.imageView.translatesAutoresizingMaskIntoConstraints=NO;
    [self.view addConstraint:[NSLayoutConstraint
                                                  constraintWithItem:self.imageView
                                                  attribute:NSLayoutAttributeBottom
                                                  relatedBy:NSLayoutRelationEqual
                                                  toItem:self.view
                                                  attribute:NSLayoutAttributeBottom
                                                  multiplier:1.0f
                                                  constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint
                                                  constraintWithItem:self.imageView
                                                  attribute:NSLayoutAttributeTop
                                                  relatedBy:NSLayoutRelationEqual
                                                  toItem:self.view
                                                  attribute:NSLayoutAttributeTop
                                                  multiplier:1.0f
                                                  constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint
                                                  constraintWithItem:self.imageView
                                                  attribute:NSLayoutAttributeTrailing
                                                  relatedBy:NSLayoutRelationEqual
                                                  toItem:self.view
                                                  attribute:NSLayoutAttributeTrailing
                                                  multiplier:1.0f
                                                  constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint
                                                  constraintWithItem:self.imageView
                                                  attribute:NSLayoutAttributeLeading
                                                  relatedBy:NSLayoutRelationEqual
                                                  toItem:self.view
                                                  attribute:NSLayoutAttributeLeading
                                                  multiplier:1.0f
                                                  constant:0.0]];
    
//    CAGradientLayer * gradient=[KSApplicationColor sharedColor].rootGradient;
//    gradient.frame=self.view.bounds;
//    self.view.backgroundColor=[UIColor whiteColor];
//    [self.view.layer insertSublayer:gradient atIndex:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
