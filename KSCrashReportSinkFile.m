//
//  KSCrashReportSinkFile.m
//  TestCrash
//
//  Created by zhangjunbo on 14-7-28.
//  Copyright (c) 2014年 ZhangJunbo. All rights reserved.
//

#import "KSCrashReportSinkFile.h"
#import "ARCSafe_MemMgmt.h"
#import "KSCrashCallCompletion.h"
#import "KSCrashReportFilterAppleFmt.h"

@interface KSCrashReportSinkFile ()

@property (nonatomic, readwrite, retain) NSString* fileDir;

@end

@implementation KSCrashReportSinkFile

@synthesize fileDir = _fileDir;

+ (KSCrashReportSinkFile*) sinkWithFileDir:(NSString *)fileDir
{
    return as_autorelease([[self alloc] initWithFileDir:fileDir]);
}

- (id) initWithFileDir:(NSString *)fileDir
{
    if((self = [super init])){
        self.fileDir = fileDir;
    }
    return self;
}

- (BOOL) ensureDirectoryExists:(NSString*) path
{
    NSError* error = nil;
    NSFileManager* fm = [NSFileManager defaultManager];
    
    if(![fm fileExistsAtPath:path])
    {
        if(![fm createDirectoryAtPath:path
          withIntermediateDirectories:YES
                           attributes:nil
                                error:&error])
        {
            NSLog(@"Could not create directory %@: %@.", path, error);
            return NO;
        }
    }
    
    return YES;
}

- (void) dealloc
{
    as_release(_fileDir);
    as_superdealloc();
}

- (void) filterReports:(NSArray*) reports
          onCompletion:(KSCrashReportFilterCompletion) onCompletion
{
    [self ensureDirectoryExists:self.fileDir];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd-HH-mm-ss"];
    NSString *fileName = [NSString stringWithFormat:@"%@-%@-%ld.txt", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"],
                          [dateFormatter stringFromDate:[NSDate date]], (long)[[NSDate date] timeIntervalSince1970]];
    NSString *file = [self.fileDir stringByAppendingPathComponent:fileName];
    [[NSFileManager defaultManager] createFileAtPath:file
                                            contents:nil
                                          attributes:nil];
    
    NSFileHandle *crashReportHandle = [NSFileHandle fileHandleForWritingAtPath:file];
    for (NSString *str in reports) {
        [crashReportHandle seekToEndOfFile];
        [crashReportHandle writeData:[str dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    kscrash_i_callCompletion(onCompletion, reports, YES, nil);
}

- (id <KSCrashReportFilter>) defaultCrashReportFilterSet
{
    return [KSCrashReportFilterPipeline filterWithFilters:
            [KSCrashReportFilterAppleFmt filterWithReportStyle:KSAppleReportStyleSymbolicatedSideBySide],
            self,
            nil];
}


@end
