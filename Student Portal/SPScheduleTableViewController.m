//
//  SPScheduleTableViewController.m
//  Student Portal
//
//  Created by Han Htoo Zaw on 12/4/15.
//  Copyright © 2015 HHZ. All rights reserved.
//

#import "SPScheduleTableViewController.h"
#import "SPScheduleTableViewCell.h"
#import "SPApiClient.h"
#import <SVProgressHUD/SVProgressHUD.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface SPScheduleTableViewController () 

@property (strong, nonatomic) NSString *studentObjectId;

@property (strong, nonatomic) NSArray *scheduleForMonday;
@property (strong, nonatomic) NSArray *scheduleForTuesday;
@property (strong, nonatomic) NSArray *scheduleForWednesday;
@property (strong, nonatomic) NSArray *scheduleForThursday;
@property (strong, nonatomic) NSArray *scheduleForFriday;
@property (strong, nonatomic) NSArray *scheduleForSaturday;
@property (strong, nonatomic) NSArray *scheduleForSunday;
@property (strong, nonatomic) __block NSMutableArray *subjectsForMonday;

@property (strong, nonatomic) PFObject *subject;
@property (strong, nonatomic) UIRefreshControl *refreshControl;


@end

@implementation SPScheduleTableViewController

@dynamic refreshControl;

- (void)viewDidLoad {
    
    self.title = @"Weekly Schedule";
    [self configureTabBarAppearance];
    self.studentObjectId = [[NSUserDefaults standardUserDefaults] stringForKey:@"studentObjectID"];
    [SVProgressHUD show];
    [self loadScheduleSheet:^(NSError *error) {
       
        if (error) {
            
            [SVProgressHUD dismiss];
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Can't load the schedule" message:@"There was an error loading the schedule. Please try again later." preferredStyle:UIAlertControllerStyleAlert];
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
    [self.refreshControl addTarget:self action:@selector(refreshSchedule) forControlEvents:UIControlEventValueChanged];
}

- (void)refreshSchedule {
    
    [self loadScheduleSheet:^(NSError *error) {
       
        if (error) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Can't refresh schedule" message:@"There was an error refreshing the schedule. Please try again later." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
            
        } else {
            
            [self.refreshControl endRefreshing];
            [self.tableView reloadData];
        }
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    switch (section) {
        case 0:
            return self.scheduleForMonday.count;
            break;
        case 1:
            return self.scheduleForTuesday.count;
            break;
        case 2:
            return self.scheduleForWednesday.count;
            break;
        case 3:
            return self.scheduleForThursday.count;
            break;
        case 4:
            return self.scheduleForFriday.count;
            break;
        case 5:
            return self.scheduleForSaturday.count;
            break;
        case 6:
            return self.scheduleForSunday.count;
            break;
        default:
            break;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SPScheduleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"scheduleIdentifier" forIndexPath:indexPath];
    switch (indexPath.section) {
        case 0:
            cell.subjectLabel.text = [self.scheduleForMonday[indexPath.row] objectForKey:@"subjectTitle"];
            cell.timeLabel.text = [NSString stringWithFormat:@"%@-%@",[self convertTimeFormat:[self.scheduleForMonday[indexPath.row] objectForKey:@"startTime"]],[self convertTimeFormat:[self.scheduleForMonday[indexPath.row] objectForKey:@"endTime"]]];
            return cell;
            break;
        case 1:
            cell.subjectLabel.text = [self.scheduleForTuesday[indexPath.row] objectForKey:@"subjectTitle"];
            cell.timeLabel.text = [NSString stringWithFormat:@"%@-%@",[self convertTimeFormat:[self.scheduleForTuesday[indexPath.row] objectForKey:@"startTime"]],[self convertTimeFormat:[self.scheduleForTuesday[indexPath.row] objectForKey:@"endTime"]]];
            return cell;
            break;
        case 2:
            cell.subjectLabel.text = [self.scheduleForWednesday[indexPath.row] objectForKey:@"subjectTitle"];
            cell.timeLabel.text = [NSString stringWithFormat:@"%@-%@",[self convertTimeFormat:[self.scheduleForWednesday[indexPath.row] objectForKey:@"startTime"]],[self convertTimeFormat:[self.scheduleForWednesday[indexPath.row] objectForKey:@"endTime"]]];
            return cell;
            break;
        case 3:
            cell.subjectLabel.text = [self.scheduleForThursday[indexPath.row] objectForKey:@"subjectTitle"];
            cell.timeLabel.text = [NSString stringWithFormat:@"%@-%@",[self convertTimeFormat:[self.scheduleForThursday[indexPath.row] objectForKey:@"startTime"]],[self convertTimeFormat:[self.scheduleForThursday[indexPath.row] objectForKey:@"endTime"]]];
            return cell;
            break;
        case 4:
            cell.subjectLabel.text = [self.scheduleForFriday[indexPath.row] objectForKey:@"subjectTitle"];
            cell.timeLabel.text = [NSString stringWithFormat:@"%@-%@",[self convertTimeFormat:[self.scheduleForFriday[indexPath.row] objectForKey:@"startTime"]],[self convertTimeFormat:[self.scheduleForFriday[indexPath.row] objectForKey:@"endTime"]]];
            return cell;
            break;
        case 5:
            cell.subjectLabel.text = [self.scheduleForSaturday[indexPath.row] objectForKey:@"subjectTitle"];
            cell.timeLabel.text = [NSString stringWithFormat:@"%@-%@",[self convertTimeFormat:[self.scheduleForSaturday[indexPath.row] objectForKey:@"startTime"]],[self convertTimeFormat:[self.scheduleForSaturday[indexPath.row] objectForKey:@"endTime"]]];
            return cell;
            break;
        case 6:
            cell.subjectLabel.text = [self.scheduleForSunday[indexPath.row] objectForKey:@"subjectTitle"];
            cell.timeLabel.text = [NSString stringWithFormat:@"%@-%@",[self convertTimeFormat:[self.scheduleForSunday[indexPath.row] objectForKey:@"startTime"]],[self convertTimeFormat:[self.scheduleForSunday[indexPath.row] objectForKey:@"endTime"]]];
            return cell;
            break;
        default:
            break;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 22.0f;
}

- (void)loadScheduleSheet:(void(^)(NSError *error))completionBlock {
    
    
    [[SPApiClient sharedInstance] getScheduleOfSection:self.studentObjectId  completion:^(NSArray *scheduleArray, NSError *error) {
       
        if (error) {
            
            completionBlock(error);
            
        } else {
            
            self.scheduleForMonday = [[SPApiClient sharedInstance] filterScheduleForDay:@"Monday" fromArray:scheduleArray];
            self.scheduleForTuesday = [[SPApiClient sharedInstance] filterScheduleForDay:@"Tuesday" fromArray:scheduleArray];
            self.scheduleForWednesday = [[SPApiClient sharedInstance] filterScheduleForDay:@"Wednesday" fromArray:scheduleArray];
            self.scheduleForThursday = [[SPApiClient sharedInstance] filterScheduleForDay:@"Thursday" fromArray:scheduleArray];
            self.scheduleForFriday = [[SPApiClient sharedInstance] filterScheduleForDay:@"Friday" fromArray:scheduleArray];
            self.scheduleForSaturday = [[SPApiClient sharedInstance] filterScheduleForDay:@"Saturday" fromArray:scheduleArray];
            self.scheduleForSunday = [[SPApiClient sharedInstance] filterScheduleForDay:@"Sunday" fromArray:scheduleArray];
            
            completionBlock(nil);
        }
    }];
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return @"Monday";
            break;
        case 1:
            return @"Tuesday";
            break;
        case 2:
            return @"Wednesday";
            break;
        case 3:
            return @"Thursday";
            break;
        case 4:
            return @"Friday";
            break;
        case 5:
            return @"Saturday";
            break;
        case 6:
            return @"Sunday";
            break;
            
        default:
            break;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    
    view.tintColor = UIColorFromRGB(0x3C5C6F);
    
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
    headerView.textLabel.textColor = [UIColor whiteColor];
}

- (NSString *)convertTimeFormat:(NSString *)time {
    
    NSString *tempHourString = [time componentsSeparatedByString:@":"][0];
    NSString *tempMinuteString = [time componentsSeparatedByString:@":"][1];
    if ([tempHourString intValue] > 12) {
        
        NSString *constructedTimeString = [NSString stringWithFormat:@"%d:%@ PM",[tempHourString intValue]- 12, tempMinuteString];
        return constructedTimeString;
    }
    
    return [NSString stringWithFormat:@"%@ AM",time];
}

- (void)configureTabBarAppearance {
    
    UITabBarController *tabBarController = [self tabBarController];
    UITabBar *tabBar = tabBarController.tabBar;
    
    UITabBarItem *scheduleTabItem = [tabBar.items objectAtIndex:0];
    UITabBarItem *subjectTabItem = [tabBar.items objectAtIndex:1];
    UITabBarItem *noticeTabItem = [tabBar.items objectAtIndex:2];
    UITabBarItem *profileTabItem = [tabBar.items objectAtIndex:3];
    
    scheduleTabItem.image = [[UIImage imageNamed:@"ScheduleNotSelected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    scheduleTabItem.selectedImage = [[UIImage imageNamed:@"ScheduleSelected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    subjectTabItem.image = [[UIImage imageNamed:@"SubjectNotSelected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    subjectTabItem.selectedImage = [[UIImage imageNamed:@"SubjectSelected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    noticeTabItem.image = [[UIImage imageNamed:@"NoticeboardNotSelected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    noticeTabItem.selectedImage = [[UIImage imageNamed:@"NoticeboardSelected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    profileTabItem.image = [[UIImage imageNamed:@"ProfileNotSelected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    profileTabItem.selectedImage = [[UIImage imageNamed:@"ProfileSelected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [scheduleTabItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGB(0x3C5C6F), NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    [subjectTabItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGB(0x3C5C6F), NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    [noticeTabItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGB(0x3C5C6F), NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    [profileTabItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGB(0x3C5C6F), NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
}


@end
