//
//  NLUploadFile.h
//  NLFoundationLib2
//
//  Created by libz on 14-6-20.
//  Copyright (c) 2014年 libz. All rights reserved.
//

#import <Foundation/Foundation.h>

// **假定要上传的文件数据** //
@interface NLUploadFile : NSObject

@property (nonatomic, assign) u_int64_t fileId;     // 文件ID （可选）
@property (nonatomic, strong) NSData *fileData;     // 要上传的文件数据 （必须）
@property (nonatomic, copy) NSString *name;         // 与上传的文件数据相关联的名称 （必须）
@property (nonatomic, copy) NSString *fileName;     // 与上传的文件数据相关联的文件名 （必须）
@property (nonatomic, assign) NSInteger fileType;   // 文件类型, 0：未知， 1：音频，2：图片，3：文件  （可选）
@property (nonatomic, copy) NSString *mimeType;     // MIME类型，例如jpeg图像文件的MIME类型是image/jpeg；png图像文件的MIME类型是image/png （必须）

@end
