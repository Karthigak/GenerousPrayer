//
//  SearchCell.h
//  GeneresPrayer
//
//  Created by Sathish on 16/07/15.
//  Copyright (c) 2015 Optisol Business Solutions pvt ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *nameLbl;
@property (strong, nonatomic) IBOutlet UILabel *emailLbl;
@property (strong, nonatomic) IBOutlet UIButton *addFriend;
@property (strong, nonatomic) IBOutlet UIButton *FollowBtn;
@property (strong, nonatomic) IBOutlet UIButton *inviteBtn;
@property (strong, nonatomic) IBOutlet UIImageView *userImage;

@end
