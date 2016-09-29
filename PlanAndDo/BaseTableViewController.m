//
//  BaseTableViewController.m
//  PlanAndDo
//
//  Created by Амин on 14.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "BaseTableViewController.h"
#import "UIImage+ACScaleImage.h"
@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView=[[UITableView alloc] initWithFrame:self.view.bounds];
    self.refresh=[[UIRefreshControl alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2-15, 0, 40, 40)];
    self.tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView addSubview:self.refresh];
    [self.view addSubview:self.tableView];
    
    self.emptyTableHeader=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, [UIScreen mainScreen].bounds.size.height-100)];
    self.emptyTableHeader.backgroundColor=[UIColor whiteColor];
    UIImageView * imageView=[[UIImageView alloc] init];
    imageView.image=[UIImage imageWithImage:[UIImage imageNamed:@"You free"] scaledToSize:CGSizeMake(180.0, 180.0)];
    imageView.translatesAutoresizingMaskIntoConstraints=NO;
    [self.emptyTableHeader addSubview:imageView];
    
    [self.emptyTableHeader addConstraint:[NSLayoutConstraint
                                          constraintWithItem:imageView
                                          attribute:NSLayoutAttributeCenterX
                                          relatedBy:NSLayoutRelationEqual
                                          toItem:self.emptyTableHeader
                                          attribute:NSLayoutAttributeCenterX
                                          multiplier:1.0f
                                          constant:0.f]];
    
    [self.emptyTableHeader addConstraint:[NSLayoutConstraint
                                          constraintWithItem:imageView
                                          attribute:NSLayoutAttributeCenterY
                                          relatedBy:NSLayoutRelationEqual
                                          toItem:self.emptyTableHeader
                                          attribute:NSLayoutAttributeCenterY
                                          multiplier:1.0f
                                          constant:0.f]];
    
    [self setConstraints];
}

-(UIView *)emptyTableHeader
{
    if(_emptyTableHeader.constraints.count==2)
    {
//        UIImageView * view=self.emptyTableHeader.subviews.firstObject;
//        [UIView animateWithDuration:1 animations:^
//        {
//            view.frame=CGRectMake(0, 0, view.bounds.size.width/2, view.bounds.size.height/2);
//        }];
    }
    else
    {
        
    }
    return _emptyTableHeader;
}
-(void)setConstraints
{
    self.trailing =[NSLayoutConstraint
                    constraintWithItem:self.tableView
                    attribute:NSLayoutAttributeTrailing
                    relatedBy:NSLayoutRelationEqual
                    toItem:self.view
                    attribute:NSLayoutAttributeTrailing
                    multiplier:1.0f
                    constant:0.f];
    
    self.leading = [NSLayoutConstraint
                    constraintWithItem:self.tableView
                    attribute:NSLayoutAttributeLeading
                    relatedBy:NSLayoutRelationEqual
                    toItem:self.view
                    attribute:NSLayoutAttributeLeading
                    multiplier:1.0f
                    constant:0.f];
    
    self.bottom =[NSLayoutConstraint
                  constraintWithItem:self.tableView
                  attribute:NSLayoutAttributeBottom
                  relatedBy:NSLayoutRelationEqual
                  toItem:self.view
                  attribute:NSLayoutAttributeBottom
                  multiplier:1.0f
                  constant:0.f];
    
    self.top =[NSLayoutConstraint
               constraintWithItem:self.tableView
               attribute:NSLayoutAttributeTop
               relatedBy:NSLayoutRelationEqual
               toItem:self.view
               attribute:NSLayoutAttributeTop
               multiplier:1.0f
               constant:0.f];
    
    self.tableView.translatesAutoresizingMaskIntoConstraints=NO;
    [self.view addConstraint:self.trailing];
    [self.view addConstraint:self.leading];
    [self.view addConstraint:self.bottom];
    [self.view addConstraint:self.top];
}

@end
