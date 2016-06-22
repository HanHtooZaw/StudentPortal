//
//  ViewController.m
//  Student Portal
//
//  Created by Han Htoo Zaw on 12/1/15.
//  Copyright © 2015 HHZ. All rights reserved.
//

#import "ViewController.h"
#import "SPApiClient.h"
#import "SPScheduleTableViewController.h"

@interface ViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *headingLabel;

@property (strong, nonatomic) UIGestureRecognizer *gesture;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpKeyboard];
    self.loginButton.layer.cornerRadius = 6.0f;
}

- (void)setUpKeyboard {
    
    if (!self.gesture) {
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
        [self.view addGestureRecognizer:tapGesture];
        self.gesture = tapGesture;
    }
}

- (void)hideKeyboard {
    
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    [self loginTapped:self];
    return YES;
}

- (IBAction)loginTapped:(id)sender {
    
    NSString *studentEmail = self.emailTextField.text;
    NSString *studentPassword = self.passwordTextField.text;
    
    if (studentEmail.length == 0 || studentPassword.length == 0) {
        
        [self checkTextField];
        
    } else {
       
        [[SPApiClient sharedInstance] logInWithEmail:studentEmail Password:studentPassword completion:^(PFObject *student, NSError *error) {
            
            if (error) {
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"No student with this info found. Please check your email and password again." preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:action];
                [self presentViewController:alert animated:YES completion:nil];
                
            } else if (!student) {
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Incorrect Login Info" message:@"No student with this info found. Please check your email and password again." preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:action];
                [self presentViewController:alert animated:YES completion:nil];
                
            } else {
                
                [self hideKeyboard];
                UIViewController *tabBarVC = [UIViewController alloc];
                tabBarVC = [self.storyboard instantiateViewControllerWithIdentifier:@"home"];
                tabBarVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                
                NSString *studentId = [student objectForKey:@"studentId"];
                [[NSUserDefaults standardUserDefaults] setObject:student.objectId forKey:@"studentObjectID"];
                [[NSUserDefaults standardUserDefaults] setObject:studentId forKey:@"studentId"];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLoggedIn"];
                
                
                [self presentViewController:tabBarVC animated:YES completion:nil];
            }
        }];
    }
}

- (void)checkTextField {
    
    if (self.emailTextField.text.length > 0 && self.passwordTextField.text.length == 0) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Password required" message:@"Please enter your password." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        
    } else if (self.emailTextField.text.length == 0 && self.passwordTextField.text.length > 0) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Email required" message:@"Please enter your email." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        
    } else {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Email and Password required" message:@"Please enter your email and password." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

@end
