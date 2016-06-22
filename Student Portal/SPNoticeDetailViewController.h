//
//  SPNoticeDetailViewController.h
//  Student Portal
//
//  Created by Han Htoo Zaw on 2/7/16.
//  Copyright © 2016 HHZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SPNoticeDetailViewController : UIViewController

@property (strong, nonatomic) NSString *titleString;
@property (strong, nonatomic) NSString *locationString;
@property (strong, nonatomic) NSString *dateTimeString;
@property (strong, nonatomic) NSString *descriptionString;
@property (strong, nonatomic) PFFile *detailImageFile;


@end
