#import "RTNUniqueIdentifier.h"

@implementation RTNUniqueIdentifier

RCT_EXPORT_MODULE()
- (NSString *)getPersistentIdentifier {
    NSDictionary *keychainQuery = @{
        (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
        (__bridge id)kSecAttrService: @"MyAppDeviceId",
        (__bridge id)kSecReturnData: @YES
    };
    
    CFTypeRef keychainResult = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, &keychainResult);
    
    if (status == errSecSuccess) {
        // Device ID found in Keychain, return it
        NSData *keychainData = (__bridge_transfer NSData *)keychainResult;
        NSString *deviceId = [[NSString alloc] initWithData:keychainData encoding:NSUTF8StringEncoding];
        return deviceId;
    } else {
        // Device ID not found, generate a new one and store it in Keychain
        NSString *deviceId = [UIDevice currentDevice].identifierForVendor.UUIDString;
        
        if (!deviceId) {
            return nil;
        }
        
        NSData *deviceIdData = [deviceId dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *addQuery = @{
            (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
            (__bridge id)kSecAttrService: @"MyAppDeviceId",
            (__bridge id)kSecValueData: deviceIdData
        };
        
        OSStatus addStatus = SecItemAdd((__bridge CFDictionaryRef)addQuery, NULL);
        if (addStatus == errSecSuccess) {
            return deviceId;
        } else {
            return nil;
        }
    }
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeUniqueIdentifierSpecJSI>(params);
}

@end
