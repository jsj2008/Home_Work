/**
 * Autogenerated by Thrift Compiler (0.9.0)
 *
 * DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
 *  @generated
 */

#import <Foundation/Foundation.h>

#import "TProtocol.h"
#import "TApplicationException.h"
#import "TProtocolUtil.h"
#import "TProcessor.h"
#import "TObjective-C.h"


enum DeviceType {
  DeviceType_WEB = 1,
  DeviceType_XK_WATCH = 101,
  DeviceType_XK_TERMINAL = 201,
  DeviceType_ANDROID = 1001,
  DeviceType_IOS = 1002
};

enum Region {
  Region_CN = 0,
  Region_US = 1
};

enum Language {
  Language_ZH_CN = 0,
  Language_EN_US = 1
};

enum AuthMode {
  AuthMode_NONE = 0,
  AuthMode_DIGEST = 1
};

@interface TerminalInfo : NSObject <NSCoding> {
  int __deviceType;
  NSString * __deviceId;
  NSString * __OsVersion;

  BOOL __deviceType_isset;
  BOOL __deviceId_isset;
  BOOL __OsVersion_isset;
}

#if TARGET_OS_IPHONE || (MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5)
@property (nonatomic, getter=deviceType, setter=setDeviceType:) int deviceType;
@property (nonatomic, retain, getter=deviceId, setter=setDeviceId:) NSString * deviceId;
@property (nonatomic, retain, getter=osVersion, setter=setOsVersion:) NSString * OsVersion;
#endif

- (id) init;
- (id) initWithDeviceType: (int) deviceType deviceId: (NSString *) deviceId OsVersion: (NSString *) OsVersion;

- (void) read: (id <TProtocol>) inProtocol;
- (void) write: (id <TProtocol>) outProtocol;

#if !__has_feature(objc_arc)
- (int) deviceType;
- (void) setDeviceType: (int) deviceType;
#endif
- (BOOL) deviceTypeIsSet;

#if !__has_feature(objc_arc)
- (NSString *) deviceId;
- (void) setDeviceId: (NSString *) deviceId;
#endif
- (BOOL) deviceIdIsSet;

#if !__has_feature(objc_arc)
- (NSString *) osVersion;
- (void) setOsVersion: (NSString *) OsVersion;
#endif
- (BOOL) OsVersionIsSet;

@end

@interface AppInfo : NSObject <NSCoding> {
  NSString * __appId;
  NSString * __appVersion;

  BOOL __appId_isset;
  BOOL __appVersion_isset;
}

#if TARGET_OS_IPHONE || (MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5)
@property (nonatomic, retain, getter=appId, setter=setAppId:) NSString * appId;
@property (nonatomic, retain, getter=appVersion, setter=setAppVersion:) NSString * appVersion;
#endif

- (id) init;
- (id) initWithAppId: (NSString *) appId appVersion: (NSString *) appVersion;

- (void) read: (id <TProtocol>) inProtocol;
- (void) write: (id <TProtocol>) outProtocol;

#if !__has_feature(objc_arc)
- (NSString *) appId;
- (void) setAppId: (NSString *) appId;
#endif
- (BOOL) appIdIsSet;

#if !__has_feature(objc_arc)
- (NSString *) appVersion;
- (void) setAppVersion: (NSString *) appVersion;
#endif
- (BOOL) appVersionIsSet;

@end

@interface I18nInfo : NSObject <NSCoding> {
  int __region;
  int __language;

  BOOL __region_isset;
  BOOL __language_isset;
}

#if TARGET_OS_IPHONE || (MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5)
@property (nonatomic, getter=region, setter=setRegion:) int region;
@property (nonatomic, getter=language, setter=setLanguage:) int language;
#endif

- (id) init;
- (id) initWithRegion: (int) region language: (int) language;

- (void) read: (id <TProtocol>) inProtocol;
- (void) write: (id <TProtocol>) outProtocol;

#if !__has_feature(objc_arc)
- (int) region;
- (void) setRegion: (int) region;
#endif
- (BOOL) regionIsSet;

#if !__has_feature(objc_arc)
- (int) language;
- (void) setLanguage: (int) language;
#endif
- (BOOL) languageIsSet;

@end

@interface DigestAuthenticationReq : NSObject <NSCoding> {
  NSString * __clientId;
  int64_t __clientCount;
  NSString * __clientRandom;
  NSString * __accessToken;

  BOOL __clientId_isset;
  BOOL __clientCount_isset;
  BOOL __clientRandom_isset;
  BOOL __accessToken_isset;
}

#if TARGET_OS_IPHONE || (MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5)
@property (nonatomic, retain, getter=clientId, setter=setClientId:) NSString * clientId;
@property (nonatomic, getter=clientCount, setter=setClientCount:) int64_t clientCount;
@property (nonatomic, retain, getter=clientRandom, setter=setClientRandom:) NSString * clientRandom;
@property (nonatomic, retain, getter=accessToken, setter=setAccessToken:) NSString * accessToken;
#endif

- (id) init;
- (id) initWithClientId: (NSString *) clientId clientCount: (int64_t) clientCount clientRandom: (NSString *) clientRandom accessToken: (NSString *) accessToken;

- (void) read: (id <TProtocol>) inProtocol;
- (void) write: (id <TProtocol>) outProtocol;

#if !__has_feature(objc_arc)
- (NSString *) clientId;
- (void) setClientId: (NSString *) clientId;
#endif
- (BOOL) clientIdIsSet;

#if !__has_feature(objc_arc)
- (int64_t) clientCount;
- (void) setClientCount: (int64_t) clientCount;
#endif
- (BOOL) clientCountIsSet;

#if !__has_feature(objc_arc)
- (NSString *) clientRandom;
- (void) setClientRandom: (NSString *) clientRandom;
#endif
- (BOOL) clientRandomIsSet;

#if !__has_feature(objc_arc)
- (NSString *) accessToken;
- (void) setAccessToken: (NSString *) accessToken;
#endif
- (BOOL) accessTokenIsSet;

@end

@interface CommArgs : NSObject <NSCoding> {
  TerminalInfo * __terminalInfo;
  AppInfo * __appInfo;
  NSString * __userId;
  I18nInfo * __i18nInfo;
  int __authMode;
  DigestAuthenticationReq * __digestAuthenticationReq;
  BOOL __checkVersion;

  BOOL __terminalInfo_isset;
  BOOL __appInfo_isset;
  BOOL __userId_isset;
  BOOL __i18nInfo_isset;
  BOOL __authMode_isset;
  BOOL __digestAuthenticationReq_isset;
  BOOL __checkVersion_isset;
}

#if TARGET_OS_IPHONE || (MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5)
@property (nonatomic, retain, getter=terminalInfo, setter=setTerminalInfo:) TerminalInfo * terminalInfo;
@property (nonatomic, retain, getter=appInfo, setter=setAppInfo:) AppInfo * appInfo;
@property (nonatomic, retain, getter=userId, setter=setUserId:) NSString * userId;
@property (nonatomic, retain, getter=i18nInfo, setter=setI18nInfo:) I18nInfo * i18nInfo;
@property (nonatomic, getter=authMode, setter=setAuthMode:) int authMode;
@property (nonatomic, retain, getter=digestAuthenticationReq, setter=setDigestAuthenticationReq:) DigestAuthenticationReq * digestAuthenticationReq;
@property (nonatomic, getter=checkVersion, setter=setCheckVersion:) BOOL checkVersion;
#endif

- (id) init;
- (id) initWithTerminalInfo: (TerminalInfo *) terminalInfo appInfo: (AppInfo *) appInfo userId: (NSString *) userId i18nInfo: (I18nInfo *) i18nInfo authMode: (int) authMode digestAuthenticationReq: (DigestAuthenticationReq *) digestAuthenticationReq checkVersion: (BOOL) checkVersion;

- (void) read: (id <TProtocol>) inProtocol;
- (void) write: (id <TProtocol>) outProtocol;

#if !__has_feature(objc_arc)
- (TerminalInfo *) terminalInfo;
- (void) setTerminalInfo: (TerminalInfo *) terminalInfo;
#endif
- (BOOL) terminalInfoIsSet;

#if !__has_feature(objc_arc)
- (AppInfo *) appInfo;
- (void) setAppInfo: (AppInfo *) appInfo;
#endif
- (BOOL) appInfoIsSet;

#if !__has_feature(objc_arc)
- (NSString *) userId;
- (void) setUserId: (NSString *) userId;
#endif
- (BOOL) userIdIsSet;

#if !__has_feature(objc_arc)
- (I18nInfo *) i18nInfo;
- (void) setI18nInfo: (I18nInfo *) i18nInfo;
#endif
- (BOOL) i18nInfoIsSet;

#if !__has_feature(objc_arc)
- (int) authMode;
- (void) setAuthMode: (int) authMode;
#endif
- (BOOL) authModeIsSet;

#if !__has_feature(objc_arc)
- (DigestAuthenticationReq *) digestAuthenticationReq;
- (void) setDigestAuthenticationReq: (DigestAuthenticationReq *) digestAuthenticationReq;
#endif
- (BOOL) digestAuthenticationReqIsSet;

#if !__has_feature(objc_arc)
- (BOOL) checkVersion;
- (void) setCheckVersion: (BOOL) checkVersion;
#endif
- (BOOL) checkVersionIsSet;

@end

@interface DigestAuthorizationRes : NSObject <NSCoding> {
  NSString * __clientId;
  NSString * __initialToken;
  int32_t __initialCount;
  NSString * __resSign;
  int32_t __authTtl;

  BOOL __clientId_isset;
  BOOL __initialToken_isset;
  BOOL __initialCount_isset;
  BOOL __resSign_isset;
  BOOL __authTtl_isset;
}

#if TARGET_OS_IPHONE || (MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5)
@property (nonatomic, retain, getter=clientId, setter=setClientId:) NSString * clientId;
@property (nonatomic, retain, getter=initialToken, setter=setInitialToken:) NSString * initialToken;
@property (nonatomic, getter=initialCount, setter=setInitialCount:) int32_t initialCount;
@property (nonatomic, retain, getter=resSign, setter=setResSign:) NSString * resSign;
@property (nonatomic, getter=authTtl, setter=setAuthTtl:) int32_t authTtl;
#endif

- (id) init;
- (id) initWithClientId: (NSString *) clientId initialToken: (NSString *) initialToken initialCount: (int32_t) initialCount resSign: (NSString *) resSign authTtl: (int32_t) authTtl;

- (void) read: (id <TProtocol>) inProtocol;
- (void) write: (id <TProtocol>) outProtocol;

#if !__has_feature(objc_arc)
- (NSString *) clientId;
- (void) setClientId: (NSString *) clientId;
#endif
- (BOOL) clientIdIsSet;

#if !__has_feature(objc_arc)
- (NSString *) initialToken;
- (void) setInitialToken: (NSString *) initialToken;
#endif
- (BOOL) initialTokenIsSet;

#if !__has_feature(objc_arc)
- (int32_t) initialCount;
- (void) setInitialCount: (int32_t) initialCount;
#endif
- (BOOL) initialCountIsSet;

#if !__has_feature(objc_arc)
- (NSString *) resSign;
- (void) setResSign: (NSString *) resSign;
#endif
- (BOOL) resSignIsSet;

#if !__has_feature(objc_arc)
- (int32_t) authTtl;
- (void) setAuthTtl: (int32_t) authTtl;
#endif
- (BOOL) authTtlIsSet;

@end

@interface ReturnMessage : NSObject <NSCoding> {
  BOOL __isSucceed;
  NSString * __message;

  BOOL __isSucceed_isset;
  BOOL __message_isset;
}

#if TARGET_OS_IPHONE || (MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5)
@property (nonatomic, getter=isSucceed, setter=setIsSucceed:) BOOL isSucceed;
@property (nonatomic, retain, getter=message, setter=setMessage:) NSString * message;
#endif

- (id) init;
- (id) initWithIsSucceed: (BOOL) isSucceed message: (NSString *) message;

- (void) read: (id <TProtocol>) inProtocol;
- (void) write: (id <TProtocol>) outProtocol;

#if !__has_feature(objc_arc)
- (BOOL) isSucceed;
- (void) setIsSucceed: (BOOL) isSucceed;
#endif
- (BOOL) isSucceedIsSet;

#if !__has_feature(objc_arc)
- (NSString *) message;
- (void) setMessage: (NSString *) message;
#endif
- (BOOL) messageIsSet;

@end

@interface BizException : NSException <NSCoding> {
  int32_t __code;
  NSString * __message;

  BOOL __code_isset;
  BOOL __message_isset;
}

#if TARGET_OS_IPHONE || (MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5)
@property (nonatomic, getter=code, setter=setCode:) int32_t code;
@property (nonatomic, retain, getter=message, setter=setMessage:) NSString * message;
#endif

- (id) init;
- (id) initWithCode: (int32_t) code message: (NSString *) message;

- (void) read: (id <TProtocol>) inProtocol;
- (void) write: (id <TProtocol>) outProtocol;

#if !__has_feature(objc_arc)
//- (int32_t) code;
- (void) setCode: (int32_t) code;
#endif
- (BOOL) codeIsSet;

#if !__has_feature(objc_arc)
- (NSString *) message;
- (void) setMessage: (NSString *) message;
#endif
- (BOOL) messageIsSet;

@end

@interface AuthException : NSException <NSCoding> {
  int32_t __code;
  NSString * __message;

  BOOL __code_isset;
  BOOL __message_isset;
}

#if TARGET_OS_IPHONE || (MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5)
@property (nonatomic, getter=code, setter=setCode:) int32_t code;
@property (nonatomic, retain, getter=message, setter=setMessage:) NSString * message;
#endif

- (id) init;
- (id) initWithCode: (int32_t) code message: (NSString *) message;

- (void) read: (id <TProtocol>) inProtocol;
- (void) write: (id <TProtocol>) outProtocol;

#if !__has_feature(objc_arc)
//- (int32_t) code;
- (void) setCode: (int32_t) code;
#endif
- (BOOL) codeIsSet;

#if !__has_feature(objc_arc)
- (NSString *) message;
- (void) setMessage: (NSString *) message;
#endif
- (BOOL) messageIsSet;

@end

@interface VersionException : NSException <NSCoding> {
  int32_t __code;
  NSString * __message;

  BOOL __code_isset;
  BOOL __message_isset;
}

#if TARGET_OS_IPHONE || (MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5)
@property (nonatomic, getter=code, setter=setCode:) int32_t code;
@property (nonatomic, retain, getter=message, setter=setMessage:) NSString * message;
#endif

- (id) init;
- (id) initWithCode: (int32_t) code message: (NSString *) message;

- (void) read: (id <TProtocol>) inProtocol;
- (void) write: (id <TProtocol>) outProtocol;

#if !__has_feature(objc_arc)
//- (int32_t) code;
- (void) setCode: (int32_t) code;
#endif
- (BOOL) codeIsSet;

#if !__has_feature(objc_arc)
- (NSString *) message;
- (void) setMessage: (NSString *) message;
#endif
- (BOOL) messageIsSet;

@end

@interface xkcmConstants : NSObject {
}
@end
