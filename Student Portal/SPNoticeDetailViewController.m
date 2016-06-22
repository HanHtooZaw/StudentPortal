//
//  SPNoticeDetailViewController.m
//  Student Portal
//
//  Created by Han Htoo Zaw on 2/7/16.
//  Copyright © 2016 HHZ. All rights reserved.
//

#import "SPNoticeDetailViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface SPNoticeDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *noticeImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

@implementation SPNoticeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD show];
    [self hideNoticeText];
    
    [self.detailImageFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
       
        if (error) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Can't load image" message:@"There was an error loading the image. Please try again later." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
            [self setNotice];
            [SVProgressHUD dismiss];
            [self showNoticeText];
            
        } else {
            
            UIImage *image = [UIImage imageWithData:data];
            self.noticeImage.image = image;
            [self setNotice];
            [SVProgressHUD dismiss];
            [self showNoticeText];
        }
        
    }];
    
}

- (void)showNoticeText {
    
    self.titleLabel.hidden = NO;
    self.locationLabel.hidden = NO;
    self.dateTimeLabel.hidden = NO;
    self.descriptionLabel.hidden = NO;
    self.noticeImage.hidden = NO;
}

- (void)hideNoticeText {
    
    self.titleLabel.hidden = YES;
    self.locationLabel.hidden = YES;
    self.dateTimeLabel.hidden = YES;
    self.descriptionLabel.hidden = YES;
    self.noticeImage.hidden = YES;
    
}

- (void)setNotice {
    
    self.titleLabel.text = self.titleString;
    self.locationLabel.text = self.locationString;
    self.dateTimeLabel.text = self.dateTimeString;
    self.descriptionLabel.text = self.descriptionString;
}

@end
