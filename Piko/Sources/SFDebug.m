//
//  SFDebug.m
//
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

#import "SFDebug.h"

#if (SF_DEBUG)
void
SFDebugLog(const char *func, int line, NSString *format, ...)
{
    NSString *s;
    va_list args;

    va_start(args, format);
    s = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);

    if (func != NULL) {
        s = [[NSString alloc] initWithFormat:@"%s L:%d %@", func, line, s];
    }

    s = [s stringByReplacingOccurrencesOfString:@"%" withString:@"%%"];

    static dispatch_once_t predicate;
    static CFCalendarRef calendar = NULL;

    dispatch_once(&predicate, ^{
        calendar = CFCalendarCopyCurrent();
    });

    CFAbsoluteTime time = CFAbsoluteTimeGetCurrent();
    int hour, minute, second;

    if (CFCalendarDecomposeAbsoluteTime(calendar, time, "Hms",
                                        &hour, &minute, &second)) {
        printf("%02ld:%02ld:%02ld.%03ld %s",
               (long)hour,
               (long)minute,
               (long)second,
               (long)floor((time - floor(time)) * 1000.0),
               s.UTF8String);
    } else {
        printf(s.UTF8String, NULL);
    }
}
#endif
