//
//  OthersProfileViewController.h
//  GeneresPrayer
//
//  Created by Sathish on 24/07/15.
//  Copyright (c) 2015 Optisol Business Solutions pvt ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OthersProfileViewController : UIViewController{
    __weak IBOutlet UILabel *name;
    __weak IBOutlet UILabel *address;
    __weak IBOutlet UILabel *email;
    __weak IBOutlet UILabel *phonenumber;
    __weak IBOutlet UILabel *headerUsername;
    __weak IBOutlet UILabel *friendLabel;
    __weak IBOutlet UILabel *followingLabel;
    __weak IBOutlet UILabel *blockLabel;

    IBOutlet UIImageView *profileImage;
}
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) NSString *userProfileId;
@property (strong, nonatomic) IBOutlet UIButton *friendButton;
@property (strong, nonatomic) IBOutlet UIButton *followingButton;
@property (strong, nonatomic) IBOutlet UIButton *blockButton;

@end
