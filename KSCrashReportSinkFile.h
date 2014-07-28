//
//  KSCrashReportSinkFile.h
//  TestCrash
//
//  Created by zhangjunbo on 14-7-28.
//  Copyright (c) 2014年 ZhangJunbo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KSCrashReportFilter.h"

@interface KSCrashReportSinkFile : NSObject <KSCrashReportFilter>

+ (KSCrashReportSinkFile*) sinkWithFileDir:(NSString *)fileDir;


- (id) initWithFileDir:(NSString *)fileDir;

- (id <KSCrashReportFilter>) defaultCrashReportFilterSet;

@end
