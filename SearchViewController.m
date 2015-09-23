//
//  SearchViewController.m
//  GeneresPrayer
//
//  Created by Sathish on 14/07/15.
//  Copyright (c) 2015 Optisol Business Solutions pvt ltd. All rights reserved.
//
#import "Constants.h"
#import "SearchViewController.h"
#import "SearchCell.h"
#import <QuartzCore/QuartzCore.h>
#import "CommonMethodClass.h"
@interface SearchViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    
    UIImageView *searchIcon;
    UITextField *textField;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SearchViewController
-(void)setSearchIconToFavicon
{
    searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searchbaricon.png"]];
    searchBar.backgroundImage = [UIImage new];
    textField = [searchBar valueForKey: @"_searchField"];
    if(textField){
//        textField.frame = CGRectMake(textField.frame.origin.x,textField.frame.origin.y, textField.frame.size.width, 70);
        [textField setLeftViewMode:UITextFieldViewModeNever];
        [textField setRightViewMode:UITextFieldViewModeNever];
        
        UIInterfaceOrientation orientation = self.interfaceOrientation;
        if(orientation == UIInterfaceOrientationPortrait){
            if (isiPad) {
                // searchIcon.frame = CGRectMake(950, 4, 19, 19);
                searchIcon.frame = CGRectMake(680, 4, 19, 19);
                
            }else{
                if(IS_IPHONE_5){
                    searchIcon.frame = CGRectMake(245, 4, 19, 19);
                }else if (IS_IPHONE_6){
                    searchIcon.frame = CGRectMake(300, 4, 19, 19);
                }else if (IS_IPHONE_6_PLUS){
                    searchIcon.frame = CGRectMake(340, 4, 19, 19);
                }
            }

        }
        else if(orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight){
            if (isiPad) {
                // searchIcon.frame = CGRectMake(950, 4, 19, 19);
                searchIcon.frame = CGRectMake(950, 4, 19, 19);
                
            }else{
                if(IS_IPHONE_5){
                    searchIcon.frame = CGRectMake(245, 4, 19, 19);
                }else if (IS_IPHONE_6){
                    searchIcon.frame = CGRectMake(300, 4, 19, 19);
                }else if (IS_IPHONE_6_PLUS){
                    searchIcon.frame = CGRectMake(340, 4, 19, 19);
                }
            }

        }
        
        textField.clearButtonMode=UITextFieldViewModeNever;
        [textField addSubview:searchIcon];
        [textField setFont:[UIFont fontWithName:@"Myriad Pro" size:15.0]];

    }
    
  
}
-(void)viewWillAppear:(BOOL)animated{
    
    
    UIInterfaceOrientation orientation = self.interfaceOrientation;
    if(orientation == UIInterfaceOrientationPortrait){
        if(isiPad){
            [self setSearchIconToFavicon];

            CGFloat width = CGRectGetWidth(self.view.bounds);
            CGFloat viewHeight = CGRectGetHeight(self.view.frame);
            [self.tableView setFrame:CGRectMake(0, 0, width, viewHeight)];
        }
        else{
            [self setSearchIconToFavicon];

        }
        
        
    }
    else if(orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight){
        if(isiPad){
            [self setSearchIconToFavicon];

            CGFloat width = CGRectGetWidth(self.view.bounds);
            CGFloat viewHeight = CGRectGetHeight(self.view.frame);
            [self.tableView setFrame:CGRectMake(0, 0, width, viewHeight)];
            
        }
        else{
            [self setSearchIconToFavicon];

        }
        
    }
    
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    
        if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation ]== UIDeviceOrientationLandscapeRight)
        {
            NSLog(@"Lanscapse");
            searchIcon.frame = CGRectMake(950, 4, 19, 19);
            [textField addSubview:searchIcon];
        }
        if([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait || [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown )
        {
            NSLog(@"UIDeviceOrientationPortrait");
            searchIcon.frame = CGRectMake(680, 4, 19, 19);
            [textField addSubview:searchIcon];

        }
    [self.tableView reloadData];
      
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [UITextField appearanceWhenContainedIn:[UISearchBar class], nil].leftView = nil;

    searchBar.placeholder=@"Search by Email or Name";
    searchBar.delegate=self;
    

    self.tableView.tableHeaderView.backgroundColor=[UIColor clearColor];
    self.tableView.backgroundColor=[UIColor clearColor];
    //this line add the searchBar
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SearchCell class])];
       cell.contentView.backgroundColor=[UIColor clearColor];
    cell.backgroundColor=[UIColor clearColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    [UITextField appearanceWhenContainedIn:[UISearchBar class], nil].leftView = nil;

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
    
    
    UIColor *sepColor=[CommonMethodClass pxColorWithHexValue:@"#b1eafd"];
    UILabel *lineLbl=[[UILabel alloc]init];
    [lineLbl setFrame:CGRectMake(0,134, self.tableView.frame.size.width,0.5)];
    [lineLbl setBackgroundColor:sepColor];
    [cell.contentView addSubview:lineLbl];
 
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 135;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
