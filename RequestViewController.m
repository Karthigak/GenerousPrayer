//
//  RequestViewController.m
//  GeneresPrayer
//
//  Created by Sathish on 14/07/15.
//  Copyright (c) 2015 Optisol Business Solutions pvt ltd. All rights reserved.
//

#import "RequestViewController.h"
#import "RequestCell.h"
#import "CommonMethodClass.h"
#import "Constants.h"
@interface RequestViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tableView.backgroundColor=[UIColor clearColor];
    UIColor *sepColor=[CommonMethodClass pxColorWithHexValue:@"#b1eafd"];
    self.tableView.separatorColor=sepColor;

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   RequestCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RequestCell class])];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
       
    cell.contentView.backgroundColor=[UIColor clearColor];
    cell.backgroundColor=[UIColor clearColor];
    
    

        
        UIColor *sepColor=[CommonMethodClass pxColorWithHexValue:@"#b1eafd"];
        UILabel *lineLbl=[[UILabel alloc]init];
        [lineLbl setFrame:CGRectMake(0,130, self.tableView.frame.size.width,0.5)];
        [lineLbl setBackgroundColor:sepColor];
        [cell.contentView addSubview:lineLbl];
        

    return cell;
    
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
