//
//  SFDebug.h
//
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

@import Foundation;

#ifndef SF_DEBUG
    #if (DEBUG)
        #define SF_DEBUG 1
    #else
        #define SF_DEBUG 0
    #endif
#endif

#if (SF_DEBUG)
extern void
SFDebugLog(const char *func, int line, NSString *format, ...);
#endif

/*

*/
#if (SF_DEBUG)
#define SFLog(...)          SFDebugLog(__FUNCTION__, __LINE__, __VA_ARGS__)
#else
#define SFLog(...)
#endif

/*

*/
#if (SF_DEBUG)
#define SFLogRaw(...)       SFDebugLog(NULL, 0, __VA_ARGS__)
#else
#define SFLogRaw(...)
#endif

/*

*/
#if (DEBUG)
#define SFAssert(x)         assert(x)
#else
#define SFAssert(x)
#endif

/*

*/
#if (SF_DEBUG)
#define SFCheck(x)          assert(x)
#else
#define SFCheck(x)          ((void)(x))
#endif

/*

*/
#define SFBreakQuietIf(x)   if (x) break

/*

*/
#if (SF_DEBUG)
#define SFBreakIf(x)        if ((x)) {                                      \
                                SFLog(@"(%s)\n", #x);                       \
                                break;                                      \
                            }
#else
#define SFBreakIf(x)        if (x) break
#endif

/*

*/
#if (SF_DEBUG)
#define SFLogIf(x)         if (x) { SFLog(@"(%s)\n", #x); }
#else
#define SFLogIf(x)         if (x) { }
#endif

/*

*/
#if (SF_DEBUG)
#define SFReturnIf(x)       if (x) {                                        \
                                SFLog(@"(%s)\n", #x);                       \
                                return;                                     \
                            }
#else
#define SFReturnIf(x)       if (x) return
#endif

/*

*/
#if (SF_DEBUG)
#define SFReturnValueIf(x, v)   if (x) {                                    \
                                    SFLog(@"(%s)\n", #x);                   \
                                    return (v);                             \
                                }
#else
#define SFReturnValueIf(x, v)   if (x) return (v)
#endif

/*

*/
#if (SF_DEBUG)
#define SFGotoIf(x, label)      if (x) {                                    \
                                    SFLog(@"(%s)\n", #x);                   \
                                    goto label;                             \
                                }
#else
#define SFGotoIf(x, label)      if (x) goto label
#endif
