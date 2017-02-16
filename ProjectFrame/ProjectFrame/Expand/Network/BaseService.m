//
//  BaseService.m
//  ProjectFrame
//
//  Created by JS1-ZJT on 17/2/9.
//  Copyright © 2017年 JS1-ZJT. All rights reserved.
//

#import "BaseService.h"
#import "AFNetworking.h"

static AFHTTPSessionManager *sharedHTTPSessionManagerWithAuthForPostMethod() {
    static AFHTTPSessionManager *managerWithAuthForPostMethod;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        managerWithAuthForPostMethod = [AFHTTPSessionManager manager];
        managerWithAuthForPostMethod.requestSerializer = [AFJSONRequestSerializer serializer];
    });
    return managerWithAuthForPostMethod;
}

@implementation BaseService

+ (void)fetchJSONFromBaseURL:(NSURL *)baseURL method:(NSString *)method path:(NSString *)path authorizationToken:(NSString *)authorizationToken parameters:(id)params success:(void (^)(NSURLRequest *request, NSURLResponse *response, id JSON))success failure:(void (^)(NSURLRequest *request, NSURLResponse *response, NSError *error))failure {
    if ([[method uppercaseString] isEqualToString:@"GET"])
    {
        
        AFHTTPSessionManager *manager = sharedHTTPSessionManagerWithAuthForPostMethod();
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/html", @"text/javascript", @"text/plain", nil];
        [manager.requestSerializer setValue:authorizationToken forHTTPHeaderField:@"Authorization"];
        
        [manager GET:[[baseURL absoluteString] stringByAppendingPathComponent:path] parameters:params progress:^(NSProgress * downloadProgress){} success:^(NSURLSessionDataTask * dataTask, id responseObject){
        
            NSLog(@"=====================================================");
            NSLog(@"Request Successful, Response ==== %@", responseObject);
            if (success) {
                success(dataTask.currentRequest, dataTask.response, responseObject);
            }
        } failure:^(NSURLSessionDataTask * dataTask, NSError *error){
        
            NSLog(@"=====================================================");
            NSLog(@"%@: %@", [self class], error);
            if (failure) {
                failure(dataTask.currentRequest, dataTask.response, error);
            }
        }];
        
    }else if ([[method uppercaseString] isEqualToString:@"POST"])
    {
        
        AFHTTPSessionManager *manager = sharedHTTPSessionManagerWithAuthForPostMethod();
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/html", @"text/javascript", @"text/plain", nil];
        [manager.requestSerializer setValue:authorizationToken forHTTPHeaderField:@"Authorization"];
        [manager POST:[[baseURL absoluteString] stringByAppendingPathComponent:path] parameters:params progress:^(NSProgress * downloadProgress){} success:^(NSURLSessionDataTask * dataTask, id responseObject){
        
            NSLog(@"=====================================================");
            NSLog(@"Request Successful, Response ==== %@", responseObject);
            if (success) {
                success(dataTask.currentRequest, dataTask.response, responseObject);
            }
        } failure:^(NSURLSessionDataTask * dataTask, NSError *error){
            NSLog(@"=====================================================");
            NSLog(@"%@: %@", [self class], error);
            if (failure) {
                failure(dataTask.currentRequest, dataTask.response, error);
            }
        }];
        
    }
}

+ (void)fetchJSONFromBaseURL:(NSURL *)baseURL path:(NSString *)path authorizationToken:(NSString *)authorizationToken parameters:(id)params uploadFiles:(NSArray *)files success:(void (^)(NSURLRequest *, NSURLResponse *, id))success failure:(void (^)(NSURLRequest *, NSURLResponse *, NSError *))failure {
    if (!files)
    {
        [self fetchJSONFromBaseURL:baseURL method:@"POST" path:path authorizationToken:authorizationToken parameters:params success:success failure:failure];
    }else
    {
        AFHTTPSessionManager *manager = sharedHTTPSessionManagerWithAuthForPostMethod();
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/html", @"text/javascript", @"text/plain", nil];
        [manager.requestSerializer setValue:authorizationToken forHTTPHeaderField:@"Authorization"];
        
        [manager POST:[[baseURL absoluteString] stringByAppendingPathComponent:path] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            if (params)
            {
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:(NSJSONWritingOptions)0 error:NULL];
                [formData appendPartWithFormData:jsonData name:@"request"];
            }
            
            for (NLUploadFile *file in files) {
                if (file.fileData) {
                    [formData appendPartWithFileData:file.fileData name:file.name fileName:file.fileName mimeType:file.mimeType];
                }
            }
            
        } progress:^(NSProgress * uploadProgress){} success:^(NSURLSessionDataTask * dataTask, id responseObject){
            
            NSLog(@"=====================================================");
            NSLog(@"Request Successful, Response ==== %@", responseObject);
            if (success)
            {
                success(dataTask.currentRequest, dataTask.response, responseObject);
            }
            
        } failure:^(NSURLSessionDataTask * dataTask, NSError *error){
            
            NSLog(@"=====================================================");
            NSLog(@"%@: %@", [self class], error);
            if (failure)
            {
                failure(dataTask.currentRequest, dataTask.response, error);
            }
        }];
    }
}

@end
