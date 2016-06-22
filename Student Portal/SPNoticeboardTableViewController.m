//
//  SPNoticeboardTableViewController.m
//  Student Portal
//
//  Created by Han Htoo Zaw on 1/25/16.
//  Copyright © 2016 HHZ. All rights reserved.
//

#import "SPNoticeboardTableViewController.h"
#import "SPNoticeboardTableViewCell.h"
#import "SPApiClient.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "SPNoticeDetailViewController.h"

static NSString *const reuseIdentifier = @"noticeReuseIdentifier";
static NSString *const pushIdentifier = @"noticeDetailPushIdentifier";

@interface SPNoticeboardTableViewController ()

@property (strong, nonatomic) NSArray *notices;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSString *noticeTitle;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *dateTime;
@property (strong, nonatomic) NSString *noticeDescription;
@property (strong, nonatomic) PFFile *imageFile;

@end

@implementation SPNoticeboardTableViewController

@dynamic refreshControl;

- (void)viewDidLoad {
    
    
    [SVProgressHUD dismiss];
    [super viewDidLoad];
    self.title = @"Noticeboard";
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 60;
    [SVProgressHUD show];
    [self loadNotices:^(NSError *error) {
       
        if (error) {
            
            
        } else {
            
            [SVProgressHUD dismiss];
            [self.tableView reloadData];
            
        }
    }];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshNotices) forControlEvents:UIControlEventValueChanged];
}

- (void)refreshNotices {
    
    [self loadNotices:^(NSError *error) {
       
        if (error) {
            
            
        } else {
            
            [self.refreshControl endRefreshing];
            [self.tableView reloadData];
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PFObject *notice = self.notices[indexPath.row];
    SPNoticeboardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.headerTextLabel.text = [notice objectForKey:@"title"];
    cell.descriptionTextLabel.text = [notice objectForKey:@"description"];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.notices.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PFObject *notice = self.notices[indexPath.row];
    NSString *unconstructedDateString = [NSString stringWithFormat:@"%@", [notice objectForKey:@"date"]];
    NSArray *arrayOfUnconstructedDateString = [unconstructedDateString componentsSeparatedByString:@" "];
    NSString *constructedDateString = arrayOfUnconstructedDateString[0];
    
    NSString *startTimeHour = [[notice objectForKey:@"startTime"] componentsSeparatedByString:@":"][0];
    NSString *startTimeMinute = [[notice objectForKey:@"startTime"] componentsSeparatedByString:@":"][1];
    
    NSString *startTime;
    if (startTimeHour.intValue > 12) {
        
        startTime = [NSString stringWithFormat:@"%d:%@ PM", startTimeHour.intValue - 12, startTimeMinute];
        
    } else {
        
        startTime = [NSString stringWithFormat:@"%d:%@ AM", startTimeHour.intValue, startTimeMinute];
    }
    
    NSString *endTimeHour = [[notice objectForKey:@"endTime"] componentsSeparatedByString:@":"][0];
    NSString *endTimeMinute = [[notice objectForKey:@"endTime"] componentsSeparatedByString:@":"][1];
    NSString *endTime;
    if (endTime.intValue > 12) {
        
        endTime = [NSString stringWithFormat:@"%d:%@ PM", endTimeHour.intValue - 12, endTimeMinute];
        
    } else {
        
        endTime = [NSString stringWithFormat:@"%d:%@ PM", endTimeHour.intValue, endTimeMinute];
    }
    self.noticeTitle = [notice objectForKey:@"title"];
    self.location = [notice objectForKey:@"location"];
    self.dateTime = [NSString stringWithFormat:@"%@, %@-%@", constructedDateString, startTime, endTime];
    self.noticeDescription = [notice objectForKey:@"description"];
    self.imageFile = [notice objectForKey:@"image"];
    
    
    [self performSegueWithIdentifier:pushIdentifier sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:pushIdentifier]) {
        
        SPNoticeDetailViewController *detailVC = (SPNoticeDetailViewController *)segue.destinationViewController;
        detailVC.titleString = self.noticeTitle;
        detailVC.dateTimeString = self.dateTime;
        detailVC.locationString = self.location;
        detailVC.detailImageFile = self.imageFile;
        detailVC.descriptionString = self.noticeDescription;
    }
}


- (void)loadNotices:(void(^)(NSError *error))completionBlock {
    
    [[SPApiClient sharedInstance] fetchNotices:^(NSArray *notices, NSError *error) {
        
        if (error) {
            
            completionBlock(error);
            
        } else {
            
            self.notices = notices;
            completionBlock(nil);
        }
    }];
}

@end
