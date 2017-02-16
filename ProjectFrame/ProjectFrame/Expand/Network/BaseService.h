//
//  BaseService.h
//  ProjectFrame
//
//  Created by JS1-ZJT on 17/2/9.
//  Copyright © 2017年 JS1-ZJT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NLUploadFile.h"

@interface BaseService : NSObject

/**
 *  向服务器端发请求，由参数“method”控制当前使用的是Get还是Post方式，取应答数据（JSON格式）
 *
 *  @param baseURL            平台的基地址
 *  @param method             请求的方式，“GET”或者“POST”
 *  @param path               追加到基地址后的接口相对地址
 *  @param authorizationToken 授权的token
 *  @param params             请求参数
 *  @param success            当发送请求成功，服务器有应答时，该函数会被回调，该回调函数有三个参数，分别是：客户端发送的请求、服务器端的响应、从服务器端响应数据转换得到的JSON object
 *  @param failure            当请求应答失败，或解析从服务器端返回的JSON数据出现错误时，该函数会被回调，该回调函数有三个参数，分别是：客户端发送的请求对象、服务器端的响应对象、错误描述对象
 */
+ (void)fetchJSONFromBaseURL:(NSURL *)baseURL
                      method:(NSString *)method
                        path:(NSString *)path
          authorizationToken:(NSString *)authorizationToken
                  parameters:(id)params
                     success:(void (^)(NSURLRequest *request, NSURLResponse *response, id JSON))success
                     failure:(void (^)(NSURLRequest *request, NSURLResponse *response, NSError *error))failure;

/**
 *  向服务器端发POST请求，附带要上传的文件(支持多个文件)，取应答数据（JSON格式）
 *
 *  @param baseURL            平台的基地址
 *  @param path               追加到基地址后的接口相对地址
 *  @param authorizationToken 授权的token
 *  @param params             请求参数
 *  @param files              要上传的文件信息
 *  @param success            当发送请求成功，服务器有应答时，该函数会被回调，该回调函数有三个参数，分别是：客户端发送的请求、服务器端的响应、从服务器端响应数据转换得到的JSON object
 *  @param failure            当请求应答失败，或解析从服务器端返回的JSON数据出现错误时，该函数会被回调，该回调函数有三个参数，分别是：客户端发送的请求对象、服务器端的响应对象、错误描述对象
 */
+ (void)fetchJSONFromBaseURL:(NSURL *)baseURL
                        path:(NSString *)path
          authorizationToken:(NSString *)authorizationToken
                  parameters:(id)params
                 uploadFiles:(NSArray *)files
                     success:(void (^)(NSURLRequest *request, NSURLResponse *response, id JSON))success
                     failure:(void (^)(NSURLRequest *request, NSURLResponse *response, NSError *error))failure;

@end
