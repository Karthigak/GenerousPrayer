//
//  RequestFeedMineCell.h
//  GeneresPrayer
//
//  Created by Sathish on 29/07/15.
//  Copyright (c) 2015 Optisol Business Solutions pvt ltd. All rights reserved.
//

#import "SWTableViewCell.h"

@interface RequestFeedMineCell : SWTableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *statusImageOne;
@property (strong, nonatomic) IBOutlet UIImageView *statusImageTwo;
@property (weak, nonatomic) IBOutlet UILabel *reasonLbl;
@property (weak, nonatomic) IBOutlet UILabel *countLbl;
@property (weak, nonatomic) IBOutlet UIImageView *prayHand;
@property (weak, nonatomic) IBOutlet UIImageView *statusImage;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;

@end
