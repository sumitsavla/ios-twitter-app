//
//  TwitterClient.h
//  mytwitter
//
//  Created by Savla, Sumit on 6/20/14.
//  Copyright (c) 2014 Sumit Savla. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

- (void) login;
+ (TwitterClient *) instance;

- (AFHTTPRequestOperation *) homeTimelineWithSuccess: (void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure ;
- (AFHTTPRequestOperation *) userInfoWithSuccess: (void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure ;
- (AFHTTPRequestOperation *) postStatus:(NSString *)status success: (void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure ;
@end
