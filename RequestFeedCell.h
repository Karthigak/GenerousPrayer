//
//  RequestFeedCell.h
//  GeneresPrayer
//
//  Created by Sathish on 18/07/15.
//  Copyright (c) 2015 Optisol Business Solutions pvt ltd. All rights reserved.
//

#import "SWTableViewCell.h"

@interface RequestFeedCell : SWTableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *statusImageTwo;
@property (strong, nonatomic) IBOutlet UIImageView *statusImageOne;
@property (strong, nonatomic) IBOutlet UIImageView *userImage;
@property (strong, nonatomic) IBOutlet UILabel *nameLbl;
@property (strong, nonatomic) IBOutlet UILabel *reasonLbl;
@property (strong, nonatomic) IBOutlet UILabel *countLbl;
@property (strong, nonatomic) IBOutlet UIImageView *statusImage;
@property (strong, nonatomic) IBOutlet UIImageView *prayHand;
@property (strong, nonatomic) IBOutlet UILabel *timeLbl;

@end
