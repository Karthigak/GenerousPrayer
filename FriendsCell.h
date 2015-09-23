//
//  FriendsCell.h
//  GeneresPrayer
//
//  Created by Sathish on 24/07/15.
//  Copyright (c) 2015 Optisol Business Solutions pvt ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *userImage;
@property (strong, nonatomic) IBOutlet UILabel *nameLbl;
@property (strong, nonatomic) IBOutlet UILabel *emailLbl;
@property (weak, nonatomic) IBOutlet UIButton *buttonOne;
@property (weak, nonatomic) IBOutlet UIButton *buttonTwo;
@property (weak, nonatomic) IBOutlet UIButton *buttonThree;

@end
