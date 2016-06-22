//
//  SPApiClient.m
//  Student Portal
//
//  Created by Han Htoo Zaw on 12/1/15.
//  Copyright © 2015 HHZ. All rights reserved.
//

#import "SPApiClient.h"

@implementation SPApiClient

+ (instancetype)sharedInstance {
    
    static SPApiClient *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SPApiClient alloc] init];
    });
    return instance;
}


- (void)logInWithEmail:(NSString *)email Password:(NSString *)password completion:(void(^)(PFObject *student, NSError *error))completionBlock {
    
    PFQuery *loginQuery = [PFQuery queryWithClassName:@"Student"];
    [loginQuery whereKey:@"studentEmail" equalTo:email];
    [loginQuery whereKey:@"studentPassword" equalTo:password];
    
    [loginQuery getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
       
        if (error) {
            
            completionBlock(nil, error);
            
        } else if (!object) {
            
            completionBlock(nil, nil);
            
        } else {
            
            completionBlock(object, nil);
        } 
    }];
}

- (void)getStudentFromObjectId:(NSString *)studentObjectId completion:(void(^)(PFObject *student, PFObject *section, NSError *error))completionBlock {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Student"];
    
    [query getObjectInBackgroundWithId:studentObjectId block:^(PFObject * _Nullable object, NSError * _Nullable error) {
        
        if (error) {
            
            completionBlock(nil, nil, error);
            
        } else {
            
            completionBlock(object, [object objectForKey:@"studentSection"], nil);
        }
    }];
}

- (void)getScheduleOfSection:(NSString *)studentObjectId completion:(void(^)(NSArray *scheduleArray, NSError *error))completionBlock {
    
    [self getStudentFromObjectId:studentObjectId completion:^(PFObject *student, PFObject *section, NSError *error) {
       
        if (error) {
            
            completionBlock(nil, error);
            
        } else {
            
            PFQuery *query = [PFQuery queryWithClassName:@"ClassSchedules"];
            [query whereKey:@"Section" equalTo:section];
            
            [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
               
                if (error) {
                    
                    completionBlock(nil, error);
                    
                } else {
                    
                    completionBlock(objects, nil);
                }
            }];
        }
    }];
}

- (NSArray *)filterScheduleForDay:(NSString *)day fromArray:(NSArray *)scheduleArray {
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (PFObject *schedule in scheduleArray) {
        
        if ([[schedule objectForKey:@"Day"] isEqualToString:day]) {
            
            [tempArray addObject:schedule];
        }
    }
    
    return [tempArray copy];
}

//api calls for populating the document table view with corresponding subjects' document
- (void)getCourseOfStudent:(NSString *)studentObjectId completion:(void(^)(PFObject *course, NSError *error))completionBlock {
    
    [self getStudentFromObjectId:studentObjectId completion:^(PFObject *student, PFObject *section, NSError *error) {
        
        if (error) {
            
            completionBlock(nil, error);
            
        } else {
            
            [section fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
               
                if (error) {
                    
                    completionBlock(nil, error);
                    
                } else {
                    
                    completionBlock([object objectForKey:@"parentCourse"], nil);
                }
            }];
        }
    }];
}

- (void)getSubjectsForStudent:(NSString *)studentObjectId completion:(void(^)(NSArray *subjects, NSError *error))completionBlock {
    
    [self getCourseOfStudent:studentObjectId completion:^(PFObject *course, NSError *error) {
       
        if (error) {
            
            completionBlock(nil, error);
            
        } else {
            
            PFQuery *query = [PFQuery queryWithClassName:@"Subject"];
            [query whereKey:@"parentCourse" equalTo:course];
            [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
               
                if (error) {
                    
                    completionBlock(nil, error);
                    
                } else {
                    
                    completionBlock(objects, nil);
                }
                
            }];
        }
    }];
}

- (NSArray *)parseSubjectTitle:(NSArray *)responseSubjects {
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (PFObject *subject in responseSubjects) {
        
        [tempArray addObject:[subject objectForKey:@"subjectTitle"]];
        
    }
    return [tempArray copy];
}

- (void)fetchNotices:(void(^)(NSArray *notices, NSError *error))completionBlock {
    
    PFQuery *noticeQuery = [PFQuery queryWithClassName:@"Noticeboard"];
    [noticeQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
       
        if (error) {
            
            completionBlock(nil, error);
            
        } else {
            
            completionBlock(objects, nil);
        }
    }];
}

@end