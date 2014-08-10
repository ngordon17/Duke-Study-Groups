//
//  DatabaseCore.m
//  Study Groups
//
//  Created by Nicholas Gordon on 8/9/14.
//  Copyright (c) 2014 Duke Student Government. All rights reserved.
//

#import "DatabaseCore.h"

@implementation DatabaseCore

static const NSString *DATABASE_URL_ROOT = @"http://colab-sbx-68.oit.duke.edu";
static const NSString *LOGIN_VALIDATION_URL_EXTENSION = @"validate_login.php";

static const NSString *DUKE_OIT_URL_ROOT = @"https://streamer.oit.duke.edu";
static const NSString *DUKE_OIT_ACCESS_TOKEN = @"a90cec76bce0a30d4a53aca6ca780448";
static const NSString *DUKE_OIT_GET_SUBJECT_URL_EXTENSION = @"curriculum/list_of_values/fieldname/SUBJECT?access_token=%@";
static const NSString *DUKE_OIT_GET_COURSE_LIST_URL_EXTENSION = @"curriculum/courses/subject/%@?access_token=%@";

+(NSURL *) makeURL:(NSString *) root extension:(NSString *) extension {
    NSString *address = [[NSString alloc] initWithFormat:@"%@/%@", root, extension];
    return [NSURL URLWithString: address];
}

+(NSMutableURLRequest *) createHttpPostRequest:(NSURL *) url  post: (NSString *) post{
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL: url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    return request;
}

+(void) validateLogin:(NSString *) email password:(NSString *) password
        completionHandler:(void (^)(NSURLResponse *response, NSData *data, NSError *error)) handler {

    NSURL *url = [self makeURL:DATABASE_URL_ROOT extension:LOGIN_VALIDATION_URL_EXTENSION];
    NSString *post = [[NSString alloc] initWithFormat:@"email=%@&password=%@", email, password];
    NSMutableURLRequest *request = [self createHttpPostRequest:url post:post];
    NSOperationQueue *queue = [NSOperationQueue mainQueue];

    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler: handler];
}

+(void) getSubjectList: (void (^)(NSURLResponse *response, NSData *data, NSError *error)) handler  {

    NSString *address_extension = [[NSString alloc] initWithFormat:DUKE_OIT_GET_SUBJECT_URL_EXTENSION, DUKE_OIT_ACCESS_TOKEN];
    NSURL *url = [self makeURL:DUKE_OIT_URL_ROOT extension:address_extension];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL: url];
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:handler];
}

+(void) getCourseList: (NSString *) subjectID
    completionHandler: (void (^) (NSURLResponse *response, NSData *data, NSError *error)) handler {
            
    NSString *escapedSubjectID = [subjectID stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSString *address_extension = [[NSString alloc] initWithFormat:DUKE_OIT_GET_COURSE_LIST_URL_EXTENSION,
            escapedSubjectID, DUKE_OIT_ACCESS_TOKEN];
    NSURL *url = [self makeURL:DUKE_OIT_URL_ROOT extension:address_extension];
            
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL: url];
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:handler];
}

@end
