//
//  Copyright © 2014 kishikawakatsumi.
//  Copyright © 2015 evgenyneu.
//  Copyright © 2015 ibireme.
//  Copyright © 2022 reers.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#if canImport(Security) && canImport(Foundation)
import Security
import Foundation

/// A helper class to interact with the Keychain for storing, retrieving, and deleting key-value pairs securely.
public final class Keychain {
    /// The keychain service identifier.
    let service: String
    /// The access group for shared keychain items.
    var accessGroup: String?

    /// Indicates whether the keychain item should be synchronized to other devices through iCloud.
    public var synchronizable: Bool = false

    /// A lock to ensure thread safety during keychain operations.
    private let lock = UnfairLock()

    /// Initializes a new instance of Keychain with the specified service and access group.
    /// - Parameters:
    ///   - service: The keychain service identifier. Defaults to the app's bundle identifier.
    ///   - accessGroup: The access group for shared keychain items.
    public init(
        service: String = Bundle.main.bundleIdentifier ?? "com.reers.keychain",
        accessGroup: String? = nil,
        synchronizable: Bool = false
    ) {
        self.service = service
        self.accessGroup = accessGroup
        self.synchronizable = synchronizable
    }

    /// Stores the provided data in the keychain under the specified key.
    /// - Parameters:
    ///   - value: The data to store in the keychain.
    ///   - key: The key under which to store the data.
    ///   - access: The accessibility level of the keychain item.
    /// - Returns: A status indicating the result of the keychain operation.
    @discardableResult
    public func setData(
        _ value: Data,
        forKey key: String,
        withAccess access: Keychain.Accessibility = .whenUnlocked
    ) -> Keychain.Status {
        lock.lock()
        defer { lock.unlock() }

        // Build query dictionary to check if the item already exists
        var query: [String: Any] = [
            Keychain.Attribute.service: service,
            Keychain.Attribute.account: key,
            Keychain.Attribute.class: kSecClassGenericPassword
        ]

        if let accessGroup {
            query[Keychain.Attribute.accessGroup] = accessGroup
        }

        if synchronizable {
            query[Keychain.Attribute.synchronizable] = kCFBooleanTrue!
        }

        // Try to find existing item
        var status = SecItemCopyMatching(query as CFDictionary, nil)
        switch status {
        case errSecSuccess, errSecInteractionNotAllowed:
            // Item exists, try to update it
            var attributesToUpdate: [String: Any] = [
                Keychain.Attribute.valueData: value
            ]

            if synchronizable {
                attributesToUpdate[Keychain.Attribute.synchronizable] = kCFBooleanTrue!
            }

            #if os(iOS)
            // Update existing item
            status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            if status != errSecSuccess {
                // Update failed, return error status
                return Keychain.Status(status: status)
            }
            return .success
            #else
            // Update existing item (non-iOS platforms)
            status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            if status != errSecSuccess {
                // Update failed, return error status
                return Keychain.Status(status: status)
            }
            return .success
            #endif

        case errSecItemNotFound:
            // Item not found, add new item
            var attributes: [String: Any] = query
            attributes[Keychain.Attribute.valueData] = value
            attributes[Keychain.Attribute.accessible] = access.rawValue

            if synchronizable {
                attributes[Keychain.Attribute.synchronizable] = kCFBooleanTrue!
            }

            // Add new item
            status = SecItemAdd(attributes as CFDictionary, nil)
            if status != errSecSuccess {
                // Add failed, return error status
                return Keychain.Status(status: status)
            }
            return .success

        default:
            // Other errors, return error status
            return Keychain.Status(status: status)
        }
    }

    /// Stores the provided string in the keychain under the specified key.
    /// - Parameters:
    ///   - value: The string to store in the keychain.
    ///   - key: The key under which to store the string.
    ///   - access: The accessibility level of the keychain item.
    /// - Returns: A status indicating the result of the keychain operation.
    @discardableResult
    public func setString(
        _ value: String,
        forKey key: String,
        withAccess access: Keychain.Accessibility = .whenUnlocked
    ) -> Keychain.Status {
        guard let data = value.data(using: .utf8) else {
            return .param // Parameter error
        }
        return setData(data, forKey: key, withAccess: access)
    }

    /// Retrieves the data stored in the keychain for the specified key.
    /// - Parameter key: The key for which to retrieve the data.
    /// - Returns: A tuple containing the data if found and a status indicating the result of the keychain operation.
    public func getData(_ key: String) -> (data: Data?, status: Keychain.Status) {
        lock.lock()
        defer { lock.unlock() }

        var query: [String: Any] = [
            Keychain.Attribute.service: service,
            Keychain.Attribute.account: key,
            Keychain.Attribute.class: kSecClassGenericPassword,
            Keychain.Attribute.returnData: kCFBooleanTrue!,
            Keychain.Attribute.matchLimit: kSecMatchLimitOne
        ]

        if let accessGroup {
            query[Keychain.Attribute.accessGroup] = accessGroup
        }

        if synchronizable {
            query[Keychain.Attribute.synchronizable] = kCFBooleanTrue!
        }

        var result: AnyObject?
        let statusOS = SecItemCopyMatching(query as CFDictionary, &result)
        let status = Keychain.Status(status: statusOS)

        if status == .success {
            return (result as? Data, .success)
        } else {
            return (nil, status)
        }
    }

    /// Retrieves the string stored in the keychain for the specified key.
    /// - Parameter key: The key for which to retrieve the string.
    /// - Returns: A tuple containing the string if found and a status indicating the result of the keychain operation.
    public func getString(_ key: String) -> (string: String?, status: Keychain.Status) {
        let (data, status) = getData(key)
        if let data, let string = String(data: data, encoding: .utf8) {
            return (string, .success)
        } else {
            return (nil, status)
        }
    }

    /// Deletes the keychain item for the specified key.
    /// - Parameter key: The key for which to delete the keychain item.
    /// - Returns: A status indicating the result of the keychain operation.
    @discardableResult
    public func remove(forKey key: String) -> Keychain.Status {
        lock.lock()
        defer { lock.unlock() }

        var query: [String: Any] = [
            Keychain.Attribute.service: service,
            Keychain.Attribute.account: key,
            Keychain.Attribute.class: kSecClassGenericPassword
        ]

        if let accessGroup {
            query[Keychain.Attribute.accessGroup] = accessGroup
        }

        if synchronizable {
            query[Keychain.Attribute.synchronizable] = kCFBooleanTrue!
        }

        let statusOS = SecItemDelete(query as CFDictionary)
        let status = Keychain.Status(status: statusOS)
        if status == .success || status == .itemNotFound {
            return .success
        } else {
            return status
        }
    }

    /// Updates the keychain item with the provided data for the specified key.
    /// - Parameters:
    ///   - value: The new data to store in the keychain.
    ///   - key: The key for which to update the keychain item.
    ///   - access: The accessibility level of the keychain item.
    /// - Returns: A status indicating the result of the keychain operation.
    @discardableResult
    public func update(
        _ value: Data,
        forKey key: String,
        withAccess access: Keychain.Accessibility = .whenUnlocked
    ) -> Keychain.Status {
        lock.lock()
        defer { lock.unlock() }

        let query: [String: Any] = [
            Keychain.Attribute.service: service,
            Keychain.Attribute.account: key,
            Keychain.Attribute.class: kSecClassGenericPassword
        ]

        var attributesToUpdate: [String: Any] = [
            Keychain.Attribute.valueData: value,
            Keychain.Attribute.accessible: access.rawValue
        ]

        if let accessGroup {
            attributesToUpdate[Keychain.Attribute.accessGroup] = accessGroup
        }

        if synchronizable {
            attributesToUpdate[Keychain.Attribute.synchronizable] = kCFBooleanTrue!
        }

        let statusOS = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
        let status = Keychain.Status(status: statusOS)
        return status == .success ? .success : status
    }

    /// Retrieves all keys stored in the keychain for the current service.
    /// - Returns: A tuple containing an array of keys and a status indicating the result of the keychain operation.
    public func allKeys() -> (keys: [String], status: Keychain.Status) {
        lock.lock()
        defer { lock.unlock() }

        var query: [String: Any] = [
            Keychain.Attribute.service: service,
            Keychain.Attribute.class: kSecClassGenericPassword,
            Keychain.Attribute.returnAttributes: kCFBooleanTrue!,
            Keychain.Attribute.matchLimit: kSecMatchLimitAll
        ]

        if let accessGroup {
            query[Keychain.Attribute.accessGroup] = accessGroup
        }

        if synchronizable {
            query[Keychain.Attribute.synchronizable] = kCFBooleanTrue!
        }

        var result: AnyObject?
        let statusOS = SecItemCopyMatching(query as CFDictionary, &result)
        let status = Keychain.Status(status: statusOS)

        var keys = [String]()
        if status == .success, let items = result as? [[String: Any]] {
            for item in items {
                if let account = item[Keychain.Attribute.account] as? String {
                    keys.append(account)
                }
            }
            return (keys, .success)
        } else {
            return ([], status)
        }
    }

    /// Deletes all keychain items for the current service.
    /// - Returns: A status indicating the result of the keychain operation.
    @discardableResult
    public func removeAll() -> Keychain.Status {
        lock.lock()
        defer { lock.unlock() }

        var query: [String: Any] = [
            Keychain.Attribute.service: service,
            Keychain.Attribute.class: kSecClassGenericPassword
        ]

        if let accessGroup {
            query[Keychain.Attribute.accessGroup] = accessGroup
        }

        if synchronizable {
            query[Keychain.Attribute.synchronizable] = kCFBooleanTrue!
        }

        let statusOS = SecItemDelete(query as CFDictionary)
        let status = Keychain.Status(status: statusOS)
        if status == .success || status == .itemNotFound {
            return .success
        } else {
            return status
        }
    }
}

extension Keychain {
    /// Enum representing the accessibility levels for keychain items.
    public enum Accessibility: RawRepresentable {
        /// Item data can only be accessed while the device is unlocked.
        /// This is recommended for items that only need to be accessible while the application is in the foreground.
        /// Items with this attribute will migrate to a new device when using encrypted backups.
        case whenUnlocked

        /// Item data can only be accessed once the device has been unlocked after a restart.
        /// This is recommended for items that need to be accessible by background applications.
        /// Items with this attribute will migrate to a new device when using encrypted backups.
        case afterFirstUnlock

        /// Item data can only be accessed while the device is unlocked.
        /// This class is only available if a passcode is set on the device.
        /// This is recommended for items that only need to be accessible while the application is in the foreground.
        /// Items with this attribute will never migrate to a new device, so after a backup is restored to a new device, these items will be missing.
        /// No items can be stored in this class on devices without a passcode.
        /// Disabling the device passcode will cause all items in this class to be deleted.
        case whenPasscodeSetThisDeviceOnly

        /// Item data can only be accessed while the device is unlocked.
        /// This is recommended for items that only need to be accessible while the application is in the foreground.
        /// Items with this attribute will never migrate to a new device, so after a backup is restored to a new device, these items will be missing.
        case whenUnlockedThisDeviceOnly

        /// Item data can only be accessed once the device has been unlocked after a restart.
        /// This is recommended for items that need to be accessible by background applications.
        /// Items with this attribute will never migrate to a new device, so after a backup is restored to a new device these items will be missing.
        case afterFirstUnlockThisDeviceOnly

        public init?(rawValue: String) {
            switch rawValue {
            case String(kSecAttrAccessibleWhenUnlocked):
                self = .whenUnlocked
            case String(kSecAttrAccessibleAfterFirstUnlock):
                self = .afterFirstUnlock
            case String(kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly):
                self = .whenPasscodeSetThisDeviceOnly
            case String(kSecAttrAccessibleWhenUnlockedThisDeviceOnly):
                self = .whenUnlockedThisDeviceOnly
            case String(kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly):
                self = .afterFirstUnlockThisDeviceOnly
            default:
                return nil
            }
        }

        public var rawValue: String {
            switch self {
            case .whenUnlocked:
                return String(kSecAttrAccessibleWhenUnlocked)
            case .afterFirstUnlock:
                return String(kSecAttrAccessibleAfterFirstUnlock)
            case .whenPasscodeSetThisDeviceOnly:
                return String(kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly)
            case .whenUnlockedThisDeviceOnly:
                return String(kSecAttrAccessibleWhenUnlockedThisDeviceOnly)
            case .afterFirstUnlockThisDeviceOnly:
                return String(kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly)
            }
        }
    }
}

extension Keychain {
    /// A collection of constants representing keychain attribute keys.
    public struct Attribute {
        /// The service associated with the keychain item.
        public static var service: String { return String(kSecAttrService) }
        /// The access group for the keychain item.
        public static var accessGroup: String { return String(kSecAttrAccessGroup) }
        /// The accessibility of the keychain item.
        public static var accessible: String { return String(kSecAttrAccessible) }
        /// The account associated with the keychain item.
        public static var account: String { return String(kSecAttrAccount) }
        /// Indicates whether the keychain item is synchronized to other devices through iCloud.
        public static var synchronizable: String { return String(kSecAttrSynchronizable) }
        /// The class of the keychain item.
        public static var `class`: String { return String(kSecClass) }
        /// A value that indicates the maximum number of results returned.
        public static var matchLimit: String { return String(kSecMatchLimit) }
        /// A Boolean value that indicates whether to return the data from a keychain item.
        public static var returnData: String { return String(kSecReturnData) }
        /// The data value of the keychain item.
        public static var valueData: String { return String(kSecValueData) }
        /// A persistent reference to a keychain item.
        public static var returnReference: String { return String(kSecReturnPersistentRef) }
        /// A Boolean value that indicates whether to return a dictionary of attributes for the keychain item.
        public static var returnAttributes : String { return String(kSecReturnAttributes) }
        /// A value that specifies that all matching items should be returned.
        public static var matchLimitAll : String { return String(kSecMatchLimitAll) }
    }
}

extension Keychain {
    /// Enum representing possible status codes returned by keychain APIs.
    public enum Status: OSStatus {
        case success                            = 0
        case unimplemented                      = -4
        case diskFull                           = -34
        case io                                 = -36
        case opWr                               = -49
        case param                              = -50
        case wrPerm                             = -61
        case allocate                           = -108
        case userCanceled                       = -128
        case badReq                             = -909
        case internalComponent                  = -2070
        case notAvailable                       = -25291
        case readOnly                           = -25292
        case authFailed                         = -25293
        case noSuchKeychain                     = -25294
        case invalidKeychain                    = -25295
        case duplicateKeychain                  = -25296
        case duplicateCallback                  = -25297
        case invalidCallback                    = -25298
        case duplicateItem                      = -25299
        case itemNotFound                       = -25300
        case bufferTooSmall                     = -25301
        case dataTooLarge                       = -25302
        case noSuchAttr                         = -25303
        case invalidItemRef                     = -25304
        case invalidSearchRef                   = -25305
        case noSuchClass                        = -25306
        case noDefaultKeychain                  = -25307
        case interactionNotAllowed              = -25308
        case readOnlyAttr                       = -25309
        case wrongSecVersion                    = -25310
        case keySizeNotAllowed                  = -25311
        case noStorageModule                    = -25312
        case noCertificateModule                = -25313
        case noPolicyModule                     = -25314
        case interactionRequired                = -25315
        case dataNotAvailable                   = -25316
        case dataNotModifiable                  = -25317
        case createChainFailed                  = -25318
        case invalidPrefsDomain                 = -25319
        case inDarkWake                         = -25320
        case aclNotSimple                       = -25240
        case policyNotFound                     = -25241
        case invalidTrustSetting                = -25242
        case noAccessForItem                    = -25243
        case invalidOwnerEdit                   = -25244
        case trustNotAvailable                  = -25245
        case unsupportedFormat                  = -25256
        case unknownFormat                      = -25257
        case keyIsSensitive                     = -25258
        case multiplePrivKeys                   = -25259
        case passphraseRequired                 = -25260
        case invalidPasswordRef                 = -25261
        case invalidTrustSettings               = -25262
        case noTrustSettings                    = -25263
        case pkcs12VerifyFailure                = -25264
        case invalidCertificate                 = -26265
        case notSigner                          = -26267
        case policyDenied                       = -26270
        case invalidKey                         = -26274
        case decode                             = -26275
        case `internal`                         = -26276
        case unsupportedAlgorithm               = -26268
        case unsupportedOperation               = -26271
        case unsupportedPadding                 = -26273
        case itemInvalidKey                     = -34000
        case itemInvalidKeyType                 = -34001
        case itemInvalidValue                   = -34002
        case itemClassMissing                   = -34003
        case itemMatchUnsupported               = -34004
        case useItemListUnsupported             = -34005
        case useKeychainUnsupported             = -34006
        case useKeychainListUnsupported         = -34007
        case returnDataUnsupported              = -34008
        case returnAttributesUnsupported        = -34009
        case returnRefUnsupported               = -34010
        case returnPersitentRefUnsupported      = -34011
        case valueRefUnsupported                = -34012
        case valuePersistentRefUnsupported      = -34013
        case returnMissingPointer               = -34014
        case matchLimitUnsupported              = -34015
        case itemIllegalQuery                   = -34016
        case waitForCallback                    = -34017
        case missingEntitlement                 = -34018
        case upgradePending                     = -34019
        case mpSignatureInvalid                 = -25327
        case otrTooOld                          = -25328
        case otrIDTooNew                        = -25329
        case serviceNotAvailable                = -67585
        case insufficientClientID               = -67586
        case deviceReset                        = -67587
        case deviceFailed                       = -67588
        case appleAddAppACLSubject              = -67589
        case applePublicKeyIncomplete           = -67590
        case appleSignatureMismatch             = -67591
        case appleInvalidKeyStartDate           = -67592
        case appleInvalidKeyEndDate             = -67593
        case conversionError                    = -67594
        case appleSSLv2Rollback                 = -67595
        case quotaExceeded                      = -67596
        case fileTooBig                         = -67597
        case invalidDatabaseBlob                = -67598
        case invalidKeyBlob                     = -67599
        case incompatibleDatabaseBlob           = -67600
        case incompatibleKeyBlob                = -67601
        case hostNameMismatch                   = -67602
        case unknownCriticalExtensionFlag       = -67603
        case noBasicConstraints                 = -67604
        case noBasicConstraintsCA               = -67605
        case invalidAuthorityKeyID              = -67606
        case invalidSubjectKeyID                = -67607
        case invalidKeyUsageForPolicy           = -67608
        case invalidExtendedKeyUsage            = -67609
        case invalidIDLinkage                   = -67610
        case pathLengthConstraintExceeded       = -67611
        case invalidRoot                        = -67612
        case crlExpired                         = -67613
        case crlNotValidYet                     = -67614
        case crlNotFound                        = -67615
        case crlServerDown                      = -67616
        case crlBadURI                          = -67617
        case unknownCertExtension               = -67618
        case unknownCRLExtension                = -67619
        case crlNotTrusted                      = -67620
        case crlPolicyFailed                    = -67621
        case idpFailure                         = -67622
        case smimeEmailAddressesNotFound        = -67623
        case smimeBadExtendedKeyUsage           = -67624
        case smimeBadKeyUsage                   = -67625
        case smimeKeyUsageNotCritical           = -67626
        case smimeNoEmailAddress                = -67627
        case smimeSubjAltNameNotCritical        = -67628
        case sslBadExtendedKeyUsage             = -67629
        case ocspBadResponse                    = -67630
        case ocspBadRequest                     = -67631
        case ocspUnavailable                    = -67632
        case ocspStatusUnrecognized             = -67633
        case endOfData                          = -67634
        case incompleteCertRevocationCheck      = -67635
        case networkFailure                     = -67636
        case ocspNotTrustedToAnchor             = -67637
        case recordModified                     = -67638
        case ocspSignatureError                 = -67639
        case ocspNoSigner                       = -67640
        case ocspResponderMalformedReq          = -67641
        case ocspResponderInternalError         = -67642
        case ocspResponderTryLater              = -67643
        case ocspResponderSignatureRequired     = -67644
        case ocspResponderUnauthorized          = -67645
        case ocspResponseNonceMismatch          = -67646
        case codeSigningBadCertChainLength      = -67647
        case codeSigningNoBasicConstraints      = -67648
        case codeSigningBadPathLengthConstraint = -67649
        case codeSigningNoExtendedKeyUsage      = -67650
        case codeSigningDevelopment             = -67651
        case resourceSignBadCertChainLength     = -67652
        case resourceSignBadExtKeyUsage         = -67653
        case trustSettingDeny                   = -67654
        case invalidSubjectName                 = -67655
        case unknownQualifiedCertStatement      = -67656
        case mobileMeRequestQueued              = -67657
        case mobileMeRequestRedirected          = -67658
        case mobileMeServerError                = -67659
        case mobileMeServerNotAvailable         = -67660
        case mobileMeServerAlreadyExists        = -67661
        case mobileMeServerServiceErr           = -67662
        case mobileMeRequestAlreadyPending      = -67663
        case mobileMeNoRequestPending           = -67664
        case mobileMeCSRVerifyFailure           = -67665
        case mobileMeFailedConsistencyCheck     = -67666
        case notInitialized                     = -67667
        case invalidHandleUsage                 = -67668
        case pvcReferentNotFound                = -67669
        case functionIntegrityFail              = -67670
        case internalError                      = -67671
        case memoryError                        = -67672
        case invalidData                        = -67673
        case mdsError                           = -67674
        case invalidPointer                     = -67675
        case selfCheckFailed                    = -67676
        case functionFailed                     = -67677
        case moduleManifestVerifyFailed         = -67678
        case invalidGUID                        = -67679
        case invalidHandle                      = -67680
        case invalidDBList                      = -67681
        case invalidPassthroughID               = -67682
        case invalidNetworkAddress              = -67683
        case crlAlreadySigned                   = -67684
        case invalidNumberOfFields              = -67685
        case verificationFailure                = -67686
        case unknownTag                         = -67687
        case invalidSignature                   = -67688
        case invalidName                        = -67689
        case invalidCertificateRef              = -67690
        case invalidCertificateGroup            = -67691
        case tagNotFound                        = -67692
        case invalidQuery                       = -67693
        case invalidValue                       = -67694
        case callbackFailed                     = -67695
        case aclDeleteFailed                    = -67696
        case aclReplaceFailed                   = -67697
        case aclAddFailed                       = -67698
        case aclChangeFailed                    = -67699
        case invalidAccessCredentials           = -67700
        case invalidRecord                      = -67701
        case invalidACL                         = -67702
        case invalidSampleValue                 = -67703
        case incompatibleVersion                = -67704
        case privilegeNotGranted                = -67705
        case invalidScope                       = -67706
        case pvcAlreadyConfigured               = -67707
        case invalidPVC                         = -67708
        case emmLoadFailed                      = -67709
        case emmUnloadFailed                    = -67710
        case addinLoadFailed                    = -67711
        case invalidKeyRef                      = -67712
        case invalidKeyHierarchy                = -67713
        case addinUnloadFailed                  = -67714
        case libraryReferenceNotFound           = -67715
        case invalidAddinFunctionTable          = -67716
        case invalidServiceMask                 = -67717
        case moduleNotLoaded                    = -67718
        case invalidSubServiceID                = -67719
        case attributeNotInContext              = -67720
        case moduleManagerInitializeFailed      = -67721
        case moduleManagerNotFound              = -67722
        case eventNotificationCallbackNotFound  = -67723
        case inputLengthError                   = -67724
        case outputLengthError                  = -67725
        case privilegeNotSupported              = -67726
        case deviceError                        = -67727
        case attachHandleBusy                   = -67728
        case notLoggedIn                        = -67729
        case algorithmMismatch                  = -67730
        case keyUsageIncorrect                  = -67731
        case keyBlobTypeIncorrect               = -67732
        case keyHeaderInconsistent              = -67733
        case unsupportedKeyFormat               = -67734
        case unsupportedKeySize                 = -67735
        case invalidKeyUsageMask                = -67736
        case unsupportedKeyUsageMask            = -67737
        case invalidKeyAttributeMask            = -67738
        case unsupportedKeyAttributeMask        = -67739
        case invalidKeyLabel                    = -67740
        case unsupportedKeyLabel                = -67741
        case invalidKeyFormat                   = -67742
        case unsupportedVectorOfBuffers         = -67743
        case invalidInputVector                 = -67744
        case invalidOutputVector                = -67745
        case invalidContext                     = -67746
        case invalidAlgorithm                   = -67747
        case invalidAttributeKey                = -67748
        case missingAttributeKey                = -67749
        case invalidAttributeInitVector         = -67750
        case missingAttributeInitVector         = -67751
        case invalidAttributeSalt               = -67752
        case missingAttributeSalt               = -67753
        case invalidAttributePadding            = -67754
        case missingAttributePadding            = -67755
        case invalidAttributeRandom             = -67756
        case missingAttributeRandom             = -67757
        case invalidAttributeSeed               = -67758
        case missingAttributeSeed               = -67759
        case invalidAttributePassphrase         = -67760
        case missingAttributePassphrase         = -67761
        case invalidAttributeKeyLength          = -67762
        case missingAttributeKeyLength          = -67763
        case invalidAttributeBlockSize          = -67764
        case missingAttributeBlockSize          = -67765
        case invalidAttributeOutputSize         = -67766
        case missingAttributeOutputSize         = -67767
        case invalidAttributeRounds             = -67768
        case missingAttributeRounds             = -67769
        case invalidAlgorithmParms              = -67770
        case missingAlgorithmParms              = -67771
        case invalidAttributeLabel              = -67772
        case missingAttributeLabel              = -67773
        case invalidAttributeKeyType            = -67774
        case missingAttributeKeyType            = -67775
        case invalidAttributeMode               = -67776
        case missingAttributeMode               = -67777
        case invalidAttributeEffectiveBits      = -67778
        case missingAttributeEffectiveBits      = -67779
        case invalidAttributeStartDate          = -67780
        case missingAttributeStartDate          = -67781
        case invalidAttributeEndDate            = -67782
        case missingAttributeEndDate            = -67783
        case invalidAttributeVersion            = -67784
        case missingAttributeVersion            = -67785
        case invalidAttributePrime              = -67786
        case missingAttributePrime              = -67787
        case invalidAttributeBase               = -67788
        case missingAttributeBase               = -67789
        case invalidAttributeSubprime           = -67790
        case missingAttributeSubprime           = -67791
        case invalidAttributeIterationCount     = -67792
        case missingAttributeIterationCount     = -67793
        case invalidAttributeDLDBHandle         = -67794
        case missingAttributeDLDBHandle         = -67795
        case invalidAttributeAccessCredentials  = -67796
        case missingAttributeAccessCredentials  = -67797
        case invalidAttributePublicKeyFormat    = -67798
        case missingAttributePublicKeyFormat    = -67799
        case invalidAttributePrivateKeyFormat   = -67800
        case missingAttributePrivateKeyFormat   = -67801
        case invalidAttributeSymmetricKeyFormat = -67802
        case missingAttributeSymmetricKeyFormat = -67803
        case invalidAttributeWrappedKeyFormat   = -67804
        case missingAttributeWrappedKeyFormat   = -67805
        case stagedOperationInProgress          = -67806
        case stagedOperationNotStarted          = -67807
        case verifyFailed                       = -67808
        case querySizeUnknown                   = -67809
        case blockSizeMismatch                  = -67810
        case publicKeyInconsistent              = -67811
        case deviceVerifyFailed                 = -67812
        case invalidLoginName                   = -67813
        case alreadyLoggedIn                    = -67814
        case invalidDigestAlgorithm             = -67815
        case invalidCRLGroup                    = -67816
        case certificateCannotOperate           = -67817
        case certificateExpired                 = -67818
        case certificateNotValidYet             = -67819
        case certificateRevoked                 = -67820
        case certificateSuspended               = -67821
        case insufficientCredentials            = -67822
        case invalidAction                      = -67823
        case invalidAuthority                   = -67824
        case verifyActionFailed                 = -67825
        case invalidCertAuthority               = -67826
        case invalidCRLAuthority                = -67827
        case invalidCRLEncoding                 = -67828
        case invalidCRLType                     = -67829
        case invalidCRL                         = -67830
        case invalidFormType                    = -67831
        case invalidID                          = -67832
        case invalidIdentifier                  = -67833
        case invalidIndex                       = -67834
        case invalidPolicyIdentifiers           = -67835
        case invalidTimeString                  = -67836
        case invalidReason                      = -67837
        case invalidRequestInputs               = -67838
        case invalidResponseVector              = -67839
        case invalidStopOnPolicy                = -67840
        case invalidTuple                       = -67841
        case multipleValuesUnsupported          = -67842
        case notTrusted                         = -67843
        case noDefaultAuthority                 = -67844
        case rejectedForm                       = -67845
        case requestLost                        = -67846
        case requestRejected                    = -67847
        case unsupportedAddressType             = -67848
        case unsupportedService                 = -67849
        case invalidTupleGroup                  = -67850
        case invalidBaseACLs                    = -67851
        case invalidTupleCredendtials           = -67852
        case invalidEncoding                    = -67853
        case invalidValidityPeriod              = -67854
        case invalidRequestor                   = -67855
        case requestDescriptor                  = -67856
        case invalidBundleInfo                  = -67857
        case invalidCRLIndex                    = -67858
        case noFieldValues                      = -67859
        case unsupportedFieldFormat             = -67860
        case unsupportedIndexInfo               = -67861
        case unsupportedLocality                = -67862
        case unsupportedNumAttributes           = -67863
        case unsupportedNumIndexes              = -67864
        case unsupportedNumRecordTypes          = -67865
        case fieldSpecifiedMultiple             = -67866
        case incompatibleFieldFormat            = -67867
        case invalidParsingModule               = -67868
        case databaseLocked                     = -67869
        case datastoreIsOpen                    = -67870
        case missingValue                       = -67871
        case unsupportedQueryLimits             = -67872
        case unsupportedNumSelectionPreds       = -67873
        case unsupportedOperator                = -67874
        case invalidDBLocation                  = -67875
        case invalidAccessRequest               = -67876
        case invalidIndexInfo                   = -67877
        case invalidNewOwner                    = -67878
        case invalidModifyMode                  = -67879
        case missingRequiredExtension           = -67880
        case extendedKeyUsageNotCritical        = -67881
        case timestampMissing                   = -67882
        case timestampInvalid                   = -67883
        case timestampNotTrusted                = -67884
        case timestampServiceNotAvailable       = -67885
        case timestampBadAlg                    = -67886
        case timestampBadRequest                = -67887
        case timestampBadDataFormat             = -67888
        case timestampTimeNotAvailable          = -67889
        case timestampUnacceptedPolicy          = -67890
        case timestampUnacceptedExtension       = -67891
        case timestampAddInfoNotAvailable       = -67892
        case timestampSystemFailure             = -67893
        case signingTimeMissing                 = -67894
        case timestampRejection                 = -67895
        case timestampWaiting                   = -67896
        case timestampRevocationWarning         = -67897
        case timestampRevocationNotification    = -67898
        case unexpectedError                    = -99999
    }
}

extension Keychain.Status: RawRepresentable {
    /// Initializes a Keychain.Status from an OSStatus code.
    /// - Parameter status: The OSStatus code.
    public init(status: OSStatus) {
        if let mappedStatus = Keychain.Status(rawValue: status) {
            self = mappedStatus
        } else {
            self = .unexpectedError
        }
    }
}
#endif
