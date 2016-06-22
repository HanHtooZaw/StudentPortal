//
//  SPNoticeboardTableViewCell.h
//  Student Portal
//
//  Created by Han Htoo Zaw on 1/26/16.
//  Copyright © 2016 HHZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPNoticeboardTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *headerTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionTextLabel;

@end
