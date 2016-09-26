//
//  DescriptionViewController.m
//  PlanAndDo
//
//  Created by Амин on 15.09.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "DescriptionViewController.h"

@interface DescriptionViewController ()
@property (nonatomic)UITextView * textView;

@end

@implementation DescriptionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"Description";
    UIBarButtonItem * doneItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneDidTap)];
    doneItem.tintColor=[UIColor whiteColor];
    UIBarButtonItem * cancelItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(cancelDidTap)];
    doneItem.tintColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem=doneItem;
    self.navigationItem.leftBarButtonItem=cancelItem;
    self.textView=[[UITextView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.textView];
    self.textView.text = self.text;
    
    self.view.backgroundColor=[UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShown:) name:UIKeyboardWillShowNotification object:nil];
}

-(void)keyboardWillShown:(NSNotification*) not
{
    
    NSDictionary * info=[not userInfo];
    NSValue* aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;
    
    [UIView animateWithDuration:1 animations:^
     {
         self.textView.frame=CGRectMake(self.textView.frame.origin.x,
                                        self.textView.frame.origin.y,
                                        self.textView.frame.size.width,
                                        [aValue CGRectValue].origin.y-70);
         self.textView.bounds=CGRectMake(self.textView.frame.origin.x,
                                        self.textView.frame.origin.y,
                                        self.textView.frame.size.width,
                                        [aValue CGRectValue].origin.y-70);
     } completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)doneDidTap
{
    if([self.parentController isKindOfClass:[AddTaskViewController class]])
    ((AddTaskViewController*)self.parentController).taskDesc = self.textView.text;
    
    if([self.parentController isKindOfClass:[EditTaskViewController class]])
        ((EditTaskViewController*)self.parentController).taskDesc = self.textView.text;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)cancelDidTap
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
