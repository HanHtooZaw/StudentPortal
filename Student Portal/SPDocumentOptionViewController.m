//
//  SPDocumentOptionViewController.m
//  Student Portal
//
//  Created by Han Htoo Zaw on 12/31/15.
//  Copyright © 2015 HHZ. All rights reserved.
//

#import "SPDocumentOptionViewController.h"
#import "SPApiClient.h"
#import "SPDocumentViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>


static NSString *const documentPushIdentifier = @"documentViewPushIdentifier";

@interface SPDocumentOptionViewController ()

@property (strong, nonatomic) NSArray *subjectsToFill;
@property (strong, nonatomic) NSArray *subjectObjects;
@property (strong, nonatomic) NSString *studentObjectId;
@property (weak, nonatomic) PFObject *subject;
@property (strong, nonatomic) NSString *savedDocumentPath;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation SPDocumentOptionViewController

@dynamic refreshControl;

- (void)viewDidLoad {
    
    [SVProgressHUD dismiss];
    self.title = @"Subjects";
    self.studentObjectId = [[NSUserDefaults standardUserDefaults] stringForKey:@"studentObjectID"];
    [SVProgressHUD show];
    [self loadTableWithSubjects:^(NSError *error) {
       
        if (error) {
            
            [SVProgressHUD dismiss];
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Can't fetch subjects" message:@"There was an error loading the subjects. Please try again later." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
            
        } else {
            
            [SVProgressHUD dismiss];
            [self.tableView reloadData];
            
        }
    }];
    
    [super viewDidLoad];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshSubjects) forControlEvents:UIControlEventValueChanged];
}

- (void)refreshSubjects {
    
    [self loadTableWithSubjects:^(NSError *error) {
       
        if (error) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Refresh failed" message:@"There was an error refreshing the subjects. Please try again later." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
            
        } else {
            
            [self.refreshControl endRefreshing];
            [self.tableView reloadData];
        }
        
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"documentIdentifier" forIndexPath:indexPath];
    cell.textLabel.text = self.subjectsToFill[indexPath.row];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.subjectsToFill.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.subject = self.subjectObjects[indexPath.row];
    PFFile *document = [self.subject objectForKey:@"slide"];
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    NSString *documentPath = [documentDirectory stringByAppendingPathComponent:document.name];
    [SVProgressHUD show];
    [document getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
       
        if (error) {
            
            [SVProgressHUD dismiss];
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"There was an error loading the document. Please try again later." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
            
        } else if (!data) {
            
            [SVProgressHUD dismiss];
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No document available" message:@"There is no document available for this subject." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
            
        } else {
            
            [data writeToFile:documentPath atomically:YES];
            self.savedDocumentPath = documentPath;
            SPDocumentViewController *documentViewController = [[SPDocumentViewController alloc] init];
            documentViewController.dataSource = self;
            documentViewController.delegate = self;
            documentViewController.documentTitle = [self.subject objectForKey:@"subjectTitle"];
            [SVProgressHUD dismiss];
            [self.navigationController pushViewController:documentViewController animated:YES];
        }
    }];
}

- (void)loadTableWithSubjects:(void(^)(NSError *error))completionBlock {
    
    [[SPApiClient sharedInstance] getSubjectsForStudent:self.studentObjectId completion:^(NSArray *subjects, NSError *error) {
       
        if (error) {
            
            completionBlock(error);
            
        } else {
            
            self.subjectObjects = subjects;
            self.subjectsToFill = [[SPApiClient sharedInstance] parseSubjectTitle:subjects];
            completionBlock(nil);
        }
    }];
}

- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
    
    
    return [NSURL fileURLWithPath:self.savedDocumentPath];
}

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
    
    return 1;
}


@end
