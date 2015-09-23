//
//  ListRequestCell.h
//  GeneresPrayer
//
//  Created by Sathish on 27/07/15.
//  Copyright (c) 2015 Optisol Business Solutions pvt ltd. All rights reserved.
//

#import "SWTableViewCell.h"

@interface ListRequestCell : SWTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UIImageView *statusImage;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;

@end
