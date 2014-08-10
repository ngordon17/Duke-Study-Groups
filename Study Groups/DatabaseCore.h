//
//  DatabaseCore.h
//  Study Groups
//
//  Created by Nicholas Gordon on 8/9/14.
//  Copyright (c) 2014 Duke Student Government. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DatabaseCore : NSObject


+(void) validateLogin:(NSString *) email password:(NSString *) password
    completionHandler:(void (^)(NSURLResponse *response, NSData *data, NSError *error)) handler;


+(void) getSubjectList: (void (^)(NSURLResponse *response, NSData *data, NSError *error)) handler;

+(void) getCourseList: (NSString *) subjectID
    completionHandler: (void (^) (NSURLResponse *response, NSData *data, NSError *error)) handler;

@end
