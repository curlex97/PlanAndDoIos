//
//  EditCategoryViewController.m
//  PlanAndDo
//
//  Created by Амин on 16.10.16.
//  Copyright © 2016 TodoTeamGroup. All rights reserved.
//

#import "EditCategoryViewController.h"

@interface EditCategoryViewController ()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, UITextFieldDelegate>
@property (nonatomic)UIView * addCategoryAccessoryView;
@property (nonatomic)UITextField * addCategoryTextField;
@property (nonatomic)NSLayoutConstraint * accessoryBottom;
@property (nonatomic)UITapGestureRecognizer * tap;
@property (nonatomic)UIPanGestureRecognizer * pan;
@property (nonatomic)BOOL isChangeCategory;
@property (nonatomic)NSIndexPath * managedIndexPath;
@end

@implementation EditCategoryViewController

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.categories.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if([self.addCategoryTextField isFirstResponder])
    {
        [self.addCategoryTextField resignFirstResponder];
        self.addCategoryTextField.text=@"";
    }
    return YES;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditCategoryTableViewCell * cell=[[EditCategoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text=self.categories[indexPath.row].name;
    cell.textLabel.textColor=[UIColor whiteColor];
    cell.backgroundColor=[UIColor colorWithRed:32.0/255.0 green:45.0/255.0 blue:52.0/255.0 alpha:1.0];
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertController * alertController=[UIAlertController alertControllerWithTitle:@"Delete Category" message:@"If you delete a category, delete all the tasks and lists that are in it" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction=[UIAlertAction actionWithTitle:TL_CANCEL style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction * deleteAction=[UIAlertAction actionWithTitle:TL_DELETE style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action)
                                  {
                                      dispatch_async(dispatch_get_main_queue(), ^
                                                     {                                                         
                                                         [[NSNotificationCenter defaultCenter] postNotificationName:@"CategoryIsDeleted" object:self.categories[indexPath.row]];
                                                         
                                                         for(BaseTask* task in [[ApplicationManager sharedApplication].tasksApplicationManager allTasksForCategory:self.categories[indexPath.row]])
                                                         {
                                                             [[ApplicationManager sharedApplication].tasksApplicationManager deleteTask:task completion:nil];
                                                         }
                                                         
                                                         [[ApplicationManager sharedApplication].categoryApplicationManager deleteCateroty:self.categories[indexPath.row] completion:^(bool completed)
                                                          {
                                                              if(completed)
                                                              {
                                                                  self.categories=[NSMutableArray arrayWithArray:[ApplicationManager sharedApplication].categoryApplicationManager.allCategories];
                                                                  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^
                                                                                 {
                                                                                     [self.tableView reloadData];
                                                                                 });
                                                              }
                                                          }];
                                                        
                                                         
                                                         [self.categories removeObjectAtIndex:indexPath.row];
                                                         //self.categories=[NSMutableArray arrayWithArray:[ApplicationManager categoryApplicationManager].allCategories];
                                                         [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                                                         
                                                         
                                                         if(self.categories.count==0)
                                                         {
                                                             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^
                                                                            {
                                                                                [self.tableView reloadData];
                                                                            });
                                                         }
                                                     });
                                      
                                  }];
    [alertController addAction:cancelAction];
    [alertController addAction:deleteAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)refreshDidSwipe
{
    [self.categories removeAllObjects];
    
    self.categories=[NSMutableArray arrayWithArray:[ApplicationManager sharedApplication].categoryApplicationManager.allCategories];
    [super refreshDidSwipe];
}

-(void)addButtonDidTap
{
    self.isChangeCategory=NO;
    [self.addCategoryTextField becomeFirstResponder];
}

-(void)cancelButtonDidTap
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)longPressDidUsed:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint p = [gestureRecognizer locationInView:self.tableView];
    
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];
    if (indexPath != nil && gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        self.isChangeCategory=YES;
        self.addCategoryTextField.text=[self.categories[indexPath.row] name];
        self.managedIndexPath=indexPath;
        [self.addCategoryTextField becomeFirstResponder];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if(!self.isChangeCategory)
    {
        if(textField.text.length)
        {
            [[ApplicationManager sharedApplication].categoryApplicationManager addCateroty:[[KSCategory alloc] initWithID:self.categories.lastObject.ID+1 andName:textField.text andSyncStatus:[NSDate date].timeIntervalSince1970] completion:nil];
            self.categories=[NSMutableArray arrayWithArray:[[ApplicationManager sharedApplication].categoryApplicationManager allCategories]];
            textField.text=@"";
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:self.categories.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    else
    {
        self.categories[self.managedIndexPath.row].name=textField.text;
        [[ApplicationManager sharedApplication].categoryApplicationManager updateCateroty:self.categories[self.managedIndexPath.row] completion:nil];
        self.categories=[NSMutableArray arrayWithArray:[[ApplicationManager sharedApplication].categoryApplicationManager allCategories]];
        
        [self.tableView reloadData];
        textField.text=@"";
    }
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    
    UIView * editView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50.0)];
    
    UIButton * addButton=[[UIButton alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
    [addButton setImage:[UIImage imageNamed:NM_CATEGORY_ADD] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addButtonDidTap) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * cancelButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 50)];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    cancelButton.titleLabel.textColor=[UIColor whiteColor];
    [cancelButton addTarget:self action:@selector(cancelButtonDidTap) forControlEvents:UIControlEventTouchUpInside];
    
    cancelButton.translatesAutoresizingMaskIntoConstraints=NO;
    [editView addConstraint:[NSLayoutConstraint
                             constraintWithItem:cancelButton
                             attribute:NSLayoutAttributeRight
                             relatedBy:NSLayoutRelationEqual
                             toItem:editView
                             attribute:NSLayoutAttributeRight
                             multiplier:1.0f
                             constant:-15.0]];
    
    [editView addConstraint:[NSLayoutConstraint
                             constraintWithItem:cancelButton
                             attribute:NSLayoutAttributeTop
                             relatedBy:NSLayoutRelationEqual
                             toItem:editView
                             attribute:NSLayoutAttributeTop
                             multiplier:1.0f
                             constant:10.0]];
    
    [editView addSubview:addButton];
    [editView addSubview:cancelButton];
    self.tableView.tableHeaderView=editView;
    
    self.tap=[[UITapGestureRecognizer alloc] init];
    self.tap.delegate=self;
    self.tap.enabled=NO;
    
    self.pan=[[UIPanGestureRecognizer alloc] init];
    self.pan.delegate=self;
    self.pan.enabled=NO;
    
    [self.view addGestureRecognizer:self.pan];
    [self.view addGestureRecognizer:self.tap];
    
    UILongPressGestureRecognizer * longPress=[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressDidUsed:)];
    longPress.minimumPressDuration=1.0;
    longPress.delegate=self;
    
    [self.tableView addGestureRecognizer:longPress];
    
    [self.tableView setSeparatorColor:[UIColor colorWithRed:163.0/255.0 green:167.0/255.0 blue:169.0/255.0 alpha:0.35]];
    self.tableView.backgroundColor=[UIColor colorWithRed:32.0/255.0 green:45.0/255.0 blue:52.0/255.0 alpha:1.0];
    self.view.backgroundColor=[UIColor colorWithRed:32.0/255.0 green:45.0/255.0 blue:52.0/255.0 alpha:1.0];
    self.refresh.tintColor=[UIColor whiteColor];
    self.tableView.editing=YES;
    
    self.addCategoryAccessoryView=[[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.view.bounds.size.width, 44)];
    self.addCategoryAccessoryView.backgroundColor=[UIColor colorWithRed:32.0/255.0 green:45.0/255.0 blue:52.0/255.0 alpha:1.0];
    self.addCategoryTextField=[[UITextField alloc] initWithFrame:CGRectMake(16, 8, self.navigationController.toolbar.frame.size.width-32, 30)];
    self.addCategoryTextField.borderStyle=UITextBorderStyleRoundedRect;
    self.addCategoryTextField.backgroundColor=[UIColor colorWithRed:227.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1.0];
    self.addCategoryTextField.delegate=self;
    [self.addCategoryAccessoryView addSubview:self.addCategoryTextField];
    
    [self.view addSubview:self.addCategoryAccessoryView];
    
    self.addCategoryTextField.translatesAutoresizingMaskIntoConstraints=NO;
    [self.addCategoryAccessoryView addConstraint:[NSLayoutConstraint
                                                  constraintWithItem:self.addCategoryTextField
                                                  attribute:NSLayoutAttributeBottom
                                                  relatedBy:NSLayoutRelationEqual
                                                  toItem:self.addCategoryAccessoryView
                                                  attribute:NSLayoutAttributeBottom
                                                  multiplier:1.0f
                                                  constant:-8.0]];
    
    [self.addCategoryAccessoryView addConstraint:[NSLayoutConstraint
                                                  constraintWithItem:self.addCategoryTextField
                                                  attribute:NSLayoutAttributeTop
                                                  relatedBy:NSLayoutRelationEqual
                                                  toItem:self.addCategoryAccessoryView
                                                  attribute:NSLayoutAttributeTop
                                                  multiplier:1.0f
                                                  constant:8.0]];
    
    [self.addCategoryAccessoryView addConstraint:[NSLayoutConstraint
                                                  constraintWithItem:self.addCategoryTextField
                                                  attribute:NSLayoutAttributeTrailing
                                                  relatedBy:NSLayoutRelationEqual
                                                  toItem:self.addCategoryAccessoryView
                                                  attribute:NSLayoutAttributeTrailing
                                                  multiplier:1.0f
                                                  constant:-16.0]];
    
    [self.addCategoryAccessoryView addConstraint:[NSLayoutConstraint
                                                  constraintWithItem:self.addCategoryTextField
                                                  attribute:NSLayoutAttributeLeading
                                                  relatedBy:NSLayoutRelationEqual
                                                  toItem:self.addCategoryAccessoryView
                                                  attribute:NSLayoutAttributeLeading
                                                  multiplier:1.0f
                                                  constant:16.0]];
    
    self.addCategoryAccessoryView.translatesAutoresizingMaskIntoConstraints=NO;
    
    self.accessoryBottom=[NSLayoutConstraint
                          constraintWithItem:self.addCategoryAccessoryView
                          attribute:NSLayoutAttributeBottom
                          relatedBy:NSLayoutRelationEqual
                          toItem:self.view
                          attribute:NSLayoutAttributeBottom
                          multiplier:1.0f
                          constant:44.0];
    [self.view addConstraint:self.accessoryBottom];
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:self.addCategoryAccessoryView
                              attribute:NSLayoutAttributeTrailing
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeTrailing
                              multiplier:1.0f
                              constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:self.addCategoryAccessoryView
                              attribute:NSLayoutAttributeLeading
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeLeading
                              multiplier:1.0f
                              constant:0.0]];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShown:) name:UIKeyboardDidShowNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)keyboardWillHide:(NSNotification*) not
{
    self.tap.enabled=NO;
    self.pan.enabled=NO;
    self.bottom.constant=0.0;
    self.accessoryBottom.constant=45.0;
    [UIView animateWithDuration:1 animations:^
     {
         [self.view layoutIfNeeded];
     } completion:nil];
}

-(void)keyboardWillShown:(NSNotification*) not
{
    self.tap.enabled=YES;
    self.pan.enabled=YES;

    NSDictionary * info=[not userInfo];
    NSValue* aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGPoint absolutPoint=[self.view convertPoint:self.addCategoryAccessoryView.frame.origin toView:nil];
    CGFloat delta=[aValue CGRectValue].origin.y-absolutPoint.y;
    self.accessoryBottom.constant=delta;
    self.bottom.constant=delta;
        [UIView animateWithDuration:0.5 animations:^
         {
             [self.view layoutIfNeeded];
         } completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
