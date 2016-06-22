//
//  SPProfileViewController.m
//  Student Portal
//
//  Created by Han Htoo Zaw on 1/26/16.
//  Copyright © 2016 HHZ. All rights reserved.
//

#import "SPProfileViewController.h"
#import "SPApiClient.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <QuartzCore/QuartzCore.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface SPProfileViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UIImageView *idImage;
@property (weak, nonatomic) IBOutlet UIImageView *emailImage;
@property (weak, nonatomic) IBOutlet UIImageView *phoneImage;
@property (weak, nonatomic) IBOutlet UIImageView *addressImage;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

@end

@implementation SPProfileViewController

- (void)viewDidLoad {
    
    [SVProgressHUD show];
    [super viewDidLoad];
    
    self.title = @"Profile";
    self.logoutButton.layer.borderWidth = 1.0f;
    self.logoutButton.layer.borderColor = [UIColorFromRGB(0x3C5C6F) CGColor];
    [self hideContent];
    [self loadInfo:^(NSError *studentError, NSError *sectionError) {
       
        if (studentError) {
            
            [SVProgressHUD dismiss];
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Can't get student info" message:@"There was an error getting the student's info. Please try again later." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
            
        } else if (sectionError) {
            
            [SVProgressHUD dismiss];
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Can't get student's section" message:@"There was an error getting the student's section. Please try again later." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
            
        } else {
            
            [SVProgressHUD dismiss];
            [self showContent];
        }
    }];
}

- (IBAction)logouttapped:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Are you sure you want to log out?" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *logOutAction = [UIAlertAction actionWithTitle:@"Log Out" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        UIViewController *tabBarVC = [UIViewController alloc];
        tabBarVC = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
        tabBarVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLoggedIn"];
        
        [self presentViewController:tabBarVC animated:YES completion:nil];

    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:logOutAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)loadInfo:(void(^)(NSError *studentError, NSError *sectionError))completionBlock {
    
    NSString *studentObjectId = [[NSUserDefaults standardUserDefaults] stringForKey:@"studentObjectID"];
    
    [[SPApiClient sharedInstance] getStudentFromObjectId:studentObjectId completion:^(PFObject *student, PFObject *section, NSError *error) {
        
        if (error) {
            
            completionBlock(error, nil);
            
        } else {
            
            [section fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
                
                if (error) {
                    
                    completionBlock(nil, error);
                    
                } else {
                    
                    self.nameLabel.text = [student objectForKey:@"studentName"];
                    self.sectionLabel.text = [object objectForKey:@"sectionName"];
                    self.idLabel.text = [student objectForKey:@"studentId"];
                    self.emailLabel.text = [student objectForKey:@"studentEmail"];
                    self.phoneLabel.text = [student objectForKey:@"studentPhone"];
                    self.addressLabel.text = [student objectForKey:@"studentAddress"];
                    completionBlock(nil, nil);
                }
            }];
        }
    }];
}

- (void)hideContent {
    
    self.nameLabel.hidden = YES;
    self.sectionLabel.hidden = YES;
    self.idLabel.hidden = YES;
    self.emailLabel.hidden = YES;
    self.phoneLabel.hidden = YES;
    self.addressLabel.hidden = YES;
    self.profileImage.hidden = YES;
    self.idImage.hidden = YES;
    self.emailImage.hidden = YES;
    self.phoneImage.hidden = YES;
    self.addressImage.hidden = YES;
}

- (void)showContent {
    
    self.nameLabel.hidden = NO;
    self.sectionLabel.hidden = NO;
    self.idLabel.hidden = NO;
    self.emailLabel.hidden = NO;
    self.phoneLabel.hidden = NO;
    self.addressLabel.hidden = NO;
    self.profileImage.hidden = NO;
    self.idImage.hidden = NO;
    self.emailImage.hidden = NO;
    self.phoneImage.hidden = NO;
    self.addressImage.hidden = NO;

}

@end
