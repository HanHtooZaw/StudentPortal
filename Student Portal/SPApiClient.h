//
//  SPApiClient.h
//  Student Portal
//
//  Created by Han Htoo Zaw on 12/1/15.
//  Copyright © 2015 HHZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface SPApiClient : NSObject

+ (instancetype)sharedInstance;
- (void)logInWithEmail:(NSString *)email Password:(NSString *)password completion:(void(^)(PFObject *student, NSError *error))completionBlock;
- (void)getScheduleOfSection:(NSString *)studentObjectId completion:(void(^)(NSArray *scheduleArray, NSError *error))completionBlock;
- (NSArray *)filterScheduleForDay:(NSString *)day fromArray:(NSArray *)scheduleArray;
- (void)getSubjectsForStudent:(NSString *)studentObjectId completion:(void(^)(NSArray *subjects, NSError *error))completionBlock;
- (NSArray *)parseSubjectTitle:(NSArray *)responseSubjects;
- (void)fetchNotices:(void(^)(NSArray *notices, NSError *error))completionBlock;
- (void)getStudentFromObjectId:(NSString *)studentObjectId completion:(void(^)(PFObject *student, PFObject *section, NSError *error))completionBlock;

@end
