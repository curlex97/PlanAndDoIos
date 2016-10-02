
#import "TaskListViewController.h"
#import "MGSwipeButton.h"
#import "MGSwipeTableCell.h"
#import "KSShortTask.h"
#import "SubTaskTableViewCell.h"
#import "ApplicationManager.h"
@interface TaskListViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIGestureRecognizerDelegate>
@property (nonatomic)NSUInteger bottomOffset;
@property (nonatomic)NSUInteger keyboardOffset;
@property (nonatomic)UITextField * textField;
@property (nonatomic)UIView * toolBarView;
@property (nonatomic)UITapGestureRecognizer * tap;
@property (nonatomic)NSLayoutConstraint * bottomContraint;
@end

@implementation TaskListViewController

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
     [self.textField resignFirstResponder];
    return ![touch.view isDescendantOfView:self.tableView];
}

//-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Delete"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
//    {
//        [self.subTasks removeObjectAtIndex:indexPath.row];
//        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
//    }];
//    deleteAction.backgroundColor = [UIColor redColor];
//    return @[deleteAction];
//}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.subTasks insertObject:[[KSShortTask alloc] initWithID:0 andName:textField.text andStatus:NO andSyncStatus:0] atIndex:0];
    [self.tableView reloadData];
    textField.text=@"";

    return YES;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.subTasks.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"reuseble cell";
    SubTaskTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell)
    {
        cell=[[SubTaskTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    KSShortTask* subTask = self.subTasks[indexPath.row];
    
    cell.textLabel.textColor=[UIColor colorWithRed:98.0/255.0 green:98.0/255.0 blue:98.0/255.0 alpha:1.0];
    cell.textLabel.text=self.subTasks[indexPath.row].name;
    cell.accessoryType = subTask.status ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    cell.tintColor=[UIColor colorWithRed:40.0/255.0 green:69.0/255.0 blue:83.0/255.0 alpha:1.0];
    cell.rightButtons = @[[MGSwipeButton buttonWithTitle:TL_DELETE backgroundColor:[UIColor redColor] callback:^BOOL(MGSwipeTableCell *sender) {
        [self.subTasks removeObject:subTask];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [tableView reloadData];
        });
        
        return YES;
    }]];
    
    cell.rightSwipeSettings.transition = MGSwipeDirectionRightToLeft;
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if([tableView cellForRowAtIndexPath:indexPath].accessoryType==UITableViewCellAccessoryNone)
    {
        [tableView cellForRowAtIndexPath:indexPath].accessoryType=UITableViewCellAccessoryCheckmark;
        KSShortTask* subTask = self.subTasks[indexPath.row];
        subTask.status = YES;
    }
    else
    {
        [tableView cellForRowAtIndexPath:indexPath].accessoryType=UITableViewCellAccessoryNone;
        KSShortTask* subTask = self.subTasks[indexPath.row];
        subTask.status = NO;
    }
}

-(void)refreshDidTap
{
    [self.subTasks removeAllObjects];
    
    self.subTasks=[NSMutableArray arrayWithArray:[[ApplicationManager subTasksApplicationManager] allSubTasksForTask:self.task]];
    [self.tableView reloadData];
    [self.refresh endRefreshing];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //self.subTasks = [NSMutableArray arrayWithArray:[[ApplicationManager subTasksApplicationManager] allSubTasksForTask:self.task]];
    if(!self.subTasks)  self.subTasks = [NSMutableArray array];
    
    [self.refresh addTarget:self action:@selector(refreshDidTap) forControlEvents:UIControlEventValueChanged];
    
    self.view.backgroundColor=[UIColor whiteColor];
    self.bottom.constant=-45;
    [self.view layoutIfNeeded];
    self.title=NM_TASK_LIST;
    
    self.tap=[[UITapGestureRecognizer alloc] init];
    self.tap.delegate=self;
    [self.tableView addGestureRecognizer:self.tap];
    
    self.textField=[[UITextField alloc] initWithFrame:CGRectMake(16, 8, self.navigationController.toolbar.frame.size.width-32, 30)];
    self.textField.borderStyle=UITextBorderStyleRoundedRect;
    self.textField.backgroundColor=[UIColor colorWithRed:227.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1.0];
    self.textField.placeholder=TL_ENTER_YOUR_TEXT;
    self.textField.delegate=self;
    self.bottomOffset=[UIScreen mainScreen].bounds.size.height-110;
    
    self.toolBarView=[[UIView alloc] initWithFrame:CGRectMake(0, self.bottomOffset, self.view.bounds.size.width, 44)];

    self.toolBarView.backgroundColor=[UIColor whiteColor];
    [self.toolBarView addSubview:self.textField];
    [self.view addSubview:self.toolBarView];
    
    if([self.parentController isKindOfClass:[AddTaskViewController class]])
    {
        [self.refresh removeFromSuperview];
    }
    
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    
    self.tableView.bounds=CGRectMake(self.tableView.bounds.origin.x, self.tableView.bounds.origin.y, self.tableView.bounds.size.width, self.tableView.bounds.size.height-44);
    self.textField.translatesAutoresizingMaskIntoConstraints=NO;
    [self.toolBarView addConstraint:[NSLayoutConstraint
                                   constraintWithItem:self.textField
                                   attribute:NSLayoutAttributeBottom
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.toolBarView
                                   attribute:NSLayoutAttributeBottom
                                   multiplier:CO_MULTIPLER
                                   constant:-8.0]];
    
    [self.toolBarView addConstraint:[NSLayoutConstraint
                                   constraintWithItem:self.textField
                                   attribute:NSLayoutAttributeTop
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.toolBarView
                                   attribute:NSLayoutAttributeTop
                                   multiplier:CO_MULTIPLER
                                   constant:8.0]];
    
    [self.toolBarView addConstraint:[NSLayoutConstraint
                                   constraintWithItem:self.textField
                                   attribute:NSLayoutAttributeTrailing
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.toolBarView
                                   attribute:NSLayoutAttributeTrailing
                                   multiplier:CO_MULTIPLER
                                   constant:-16.0]];
    
    [self.toolBarView addConstraint:[NSLayoutConstraint
                                   constraintWithItem:self.textField
                                   attribute:NSLayoutAttributeLeading
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.toolBarView
                                   attribute:NSLayoutAttributeLeading
                                   multiplier:CO_MULTIPLER
                                   constant:16.0]];
    
    self.toolBarView.translatesAutoresizingMaskIntoConstraints=NO;
    self.bottomContraint=[NSLayoutConstraint
                          constraintWithItem:self.toolBarView
                          attribute:NSLayoutAttributeBottom
                          relatedBy:NSLayoutRelationEqual
                          toItem:self.view
                          attribute:NSLayoutAttributeBottom
                          multiplier:CO_MULTIPLER
                          constant:0.0];
    [self.view addConstraint:self.bottomContraint];
    
    [self.view addConstraint:[NSLayoutConstraint
                                     constraintWithItem:self.toolBarView
                                     attribute:NSLayoutAttributeTrailing
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:self.view
                                     attribute:NSLayoutAttributeTrailing
                                     multiplier:CO_MULTIPLER
                                     constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint
                                     constraintWithItem:self.toolBarView
                                     attribute:NSLayoutAttributeLeading
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:self.view
                                     attribute:NSLayoutAttributeLeading
                                     multiplier:CO_MULTIPLER
                                     constant:0.0]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
     [self.tableView reloadData];
    
}

-(void)keyboardWillShown:(NSNotification*) not
{
    self.tap.enabled=YES;
    NSDictionary * info=[not userInfo];
    NSValue* aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;
    
    self.bottomContraint.constant=-keyboardSize.height;
    self.bottom.constant=-keyboardSize.height-45.0;
    
    [UIView animateWithDuration:1 animations:^
     {
         [self.view layoutIfNeeded];
     } completion:nil];
}

-(void)keyboardWillHide:(NSNotification*) not
{
    self.tap.enabled=NO;

    self.bottomContraint.constant=0;
    self.bottom.constant=-45;
    [UIView animateWithDuration:1 animations:^
     {
         [self.view layoutIfNeeded];
     } completion:nil];
}

-(void)dealloc
{
    self.navigationController.toolbarHidden=YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    if([self.parentController isKindOfClass:[AddTaskViewController class]]){
        ((AddTaskViewController*)self.parentController).subTasks = [NSMutableArray arrayWithArray:self.subTasks];
    }
    
    if([self.parentController isKindOfClass:[EditTaskViewController class]]){
        ((EditTaskViewController*)self.parentController).subTasks = [NSMutableArray arrayWithArray:self.subTasks];
    }
}


@end
