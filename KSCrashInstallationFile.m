//
//  KSCrashInstallationFile.m
//  TestCrash
//
//  Created by zhangjunbo on 14-7-28.
//  Copyright (c) 2014年 ZhangJunbo. All rights reserved.
//

#import "KSCrashInstallationFile.h"
#import "KSCrashInstallation+Private.h"
#import "ARCSafe_MemMgmt.h"
#import "KSSingleton.h"
#import "KSCrashReportSinkFile.h"

@implementation KSCrashInstallationFile

IMPLEMENT_EXCLUSIVE_SHARED_INSTANCE(KSCrashInstallationFile)

@synthesize fileDir = _fileDir;

- (id) init
{
    if((self = [super initWithRequiredProperties:nil]))
    {
    }
    return self;
}

- (void) dealloc
{
    as_release(_url);
    as_release(_userName);
    as_release(_userEmail);
    as_superdealloc();
}

- (id<KSCrashReportFilter>) sink
{
    KSCrashReportSinkFile* sink = [KSCrashReportSinkFile sinkWithFileDir:self.fileDir];
    return [KSCrashReportFilterPipeline filterWithFilters:[sink defaultCrashReportFilterSet], nil];
}



@end
