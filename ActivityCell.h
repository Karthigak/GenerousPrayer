//
//  ActivityCell.h
//  GeneresPrayer
//
//  Created by Sathish on 23/07/15.
//  Copyright (c) 2015 Optisol Business Solutions pvt ltd. All rights reserved.
//

#import "SWTableViewCell.h"

@interface ActivityCell : SWTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImage;

@property (weak, nonatomic) IBOutlet UILabel *statusLbl;
@property (weak, nonatomic) IBOutlet UIImageView *statusImage;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;

@end
