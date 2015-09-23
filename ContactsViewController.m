//
//  ContactsViewController.m
//  GeneresPrayer
//
//  Created by Sathish on 14/07/15.
//  Copyright (c) 2015 Optisol Business Solutions pvt ltd. All rights reserved.
//

#import "ContactsViewController.h"
#import "SearchCell.h"
#import "CommonMethodClass.h"
#import "Constants.h"
@interface ContactsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tableView.backgroundColor=[UIColor clearColor];
    UIColor *sepColor=[CommonMethodClass pxColorWithHexValue:@"#b1eafd"];
    self.tableView.separatorColor=sepColor;
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    
    
    UIInterfaceOrientation orientation = self.interfaceOrientation;
    if(orientation == UIInterfaceOrientationPortrait){
        if(isiPad){
            
            CGFloat width = CGRectGetWidth(self.view.bounds);
            CGFloat viewHeight = CGRectGetHeight(self.view.frame);
            [self.tableView setFrame:CGRectMake(0, 0, width, viewHeight)];
        }
        else{
            
        }
        
        
    }
    else if(orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight){
        if(isiPad){
            
            CGFloat width = CGRectGetWidth(self.view.bounds);
            CGFloat viewHeight = CGRectGetHeight(self.view.frame);
            [self.tableView setFrame:CGRectMake(0, 0, width, viewHeight)];
            
        }
        else{
            
        }
        
    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SearchCell class])];
    
    
    cell.contentView.backgroundColor=[UIColor clearColor];
    cell.backgroundColor=[UIColor clearColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;

    if (indexPath.row==0) {
        cell.addFriend.hidden=YES;
        cell.FollowBtn.hidden=YES;
        
    }
    else if(indexPath.row==2)
    {
        cell.inviteBtn.hidden=YES;
        
    }
    else if(indexPath.row==1)
    {
        cell.addFriend.hidden=YES;
        cell.FollowBtn.hidden=YES;
        [cell.inviteBtn setTitle:@"Invited" forState:UIControlStateNormal];
        [cell.inviteBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
        [[cell.inviteBtn layer] setBorderWidth:1.0f];
        cell.inviteBtn.backgroundColor=[UIColor clearColor];
    }
    else if(indexPath.row==3)
    {
        cell.addFriend.hidden=YES;
        cell.FollowBtn.hidden=YES;
        [cell.inviteBtn setTitle:@"Unfriend" forState:UIControlStateNormal];
        [cell.inviteBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
        [[cell.inviteBtn layer] setBorderWidth:1.0f];
        cell.inviteBtn.backgroundColor=[UIColor clearColor];
    }
    else if(indexPath.row==4)
    {
        cell.inviteBtn.hidden=YES;
        [cell.FollowBtn setTitle:@"Unfollow" forState:UIControlStateNormal];
        [cell.FollowBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
        [[cell.FollowBtn layer] setBorderWidth:1.0f];
        cell.FollowBtn.backgroundColor=[UIColor clearColor];
    }
    
        
        UIColor *sepColor=[CommonMethodClass pxColorWithHexValue:@"#b1eafd"];
        UILabel *lineLbl=[[UILabel alloc]init];
        [lineLbl setFrame:CGRectMake(0,134, self.tableView.frame.size.width,0.3)];
        [lineLbl setBackgroundColor:sepColor];
        [cell.contentView addSubview:lineLbl];
    
        return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 135;
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    
    [self.tableView reloadData];
    
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
