//
//  Ext_ErrorMessage.swift
//  test_amplify
//
//  Created by ms-mb014 on 2020/01/17.
//  Copyright © 2020 ms-mb014. All rights reserved.
//

import UIKit
import AWSMobileClient
import TudApi

public extension AWSMobileClientError {
    var dispError: String {
        switch self {
        case .aliasExists(let message):
            return "aliasExists: [\(message)]"
        case .codeDeliveryFailure(let message):
            return "codeDeliveryFailure: [\(message)]"
        case .codeMismatch(let message):
            return "codeMismatch: [\(message)]"
        case .expiredCode(let message):
            return "expiredCode: [\(message)]"
        case .groupExists(let message):
            return "groupExists: [\(message)]"
        case .internalError(let message):
            return "internalError: [\(message)]"
        case .invalidLambdaResponse(let message):
            return "invalidLambdaResponse: [\(message)]"
        case .invalidOAuthFlow(let message):
            return "invalidOAuthFlow: [\(message)]"
        case .invalidParameter(let message):
            return "invalidParameter: [\(message)]"
        case .invalidPassword(let message):
            return "invalidPassword: [\(message)]"
        case .invalidUserPoolConfiguration(let message):
            return "invalidUserPoolConfiguration: [\(message)]"
        case .limitExceeded(let message):
            return "limitExceeded: [\(message)]"
        case .mfaMethodNotFound(let message):
            return "mfaMethodNotFound: [\(message)]"
        case .notAuthorized(let message):
            return "notAuthorized: [\(message)]"
        case .passwordResetRequired(let message):
            return "passwordResetRequired: [\(message)]"
        case .resourceNotFound(let message):
            return "resourceNotFound: [\(message)]"
        case .scopeDoesNotExist(let message):
            return "scopeDoesNotExist: [\(message)]"
        case .softwareTokenMFANotFound(let message):
            return "softwareTokenMFANotFound: [\(message)]"
        case .tooManyFailedAttempts(let message):
            return "tooManyFailedAttempts: [\(message)]"
        case .tooManyRequests(let message):
            return "tooManyRequests: [\(message)]"
        case .unexpectedLambda(let message):
            return "unexpectedLambda: [\(message)]"
        case .userLambdaValidation(let message):
            return "userLambdaValidation: [\(message)]"
        case .userNotConfirmed(let message):
            return "userNotConfirmed: [\(message)]"
        case .userNotFound(let message):
            return "userNotFound: [\(message)]"
        case .usernameExists(let message):
            return "usernameExists: [\(message)]"
        case .unknown(let message):
            return "unknown: [\(message)]"
        case .notSignedIn(let message):
            return "notSignedIn: [\(message)]"
        case .identityIdUnavailable(let message):
            return "identityIdUnavailable: [\(message)]"
        case .guestAccessNotAllowed(let message):
            return "guestAccessNotAllowed: [\(message)]"
        case .federationProviderExists(let message):
            return "federationProviderExists: [\(message)]"
        case .cognitoIdentityPoolNotConfigured(let message):
            return "cognitoIdentityPoolNotConfigured: [\(message)]"
        case .unableToSignIn(let message):
            return "unableToSignIn: [\(message)]"
        case .invalidState(let message):
            return "invalidState: [\(message)]"
        case .userPoolNotConfigured(let message):
            return "userPoolNotConfigured: [\(message)]"
        case .userCancelledSignIn(let message):
            return "userCancelledSignIn: [\(message)]"
        case .badRequest(let message):
            return "badRequest: [\(message)]"
        case .expiredRefreshToken(let message):
            return "expiredRefreshToken: [\(message)]"
        case .errorLoadingPage(let message):
            return "errorLoadingPage: [\(message)]"
        case .securityFailed(let message):
            return "securityFailed: [\(message)]"
        case .idTokenNotIssued(let message):
            return "idTokenNotIssued: [\(message)]"
        case .idTokenAndAcceessTokenNotIssued(let message):
            return "idTokenAndAcceessTokenNotIssued: [\(message)]"
        case .invalidConfiguration(let message):
            return "invalidConfiguration: [\(message)]"
        case .deviceNotRemembered(let message):
            return "deviceNotRemembered: [\(message)]"
        }
    }
}


//======== Swagger codegen - Validattion Error Response
//▼user-api: [PATCH] /todos/{createdAt} で、21文字以上で実行した場合のレスポンス：
//{
//  "statusCode": 400,
//  "error": "Bad Request",
//  "message": [
//    {
//      "target": {
//        "note": "09876543210987654321_"
//      },
//      "value": "09876543210987654321_",
//      "property": "note",
//      "children": [],
//      "constraints": {
//        "length": "note must be shorter than or equal to 20 characters"
//      }
//    }
//  ]
//}

struct SwaErrModel: Codable {
    var message: String = ""
}
struct SwaErrModel_404: Codable {
    var status: Int = -1
    var error: String = ""
}
struct SwaValidErrModel: Decodable {
    var statusCode: Int = -1
    var error: String = ""
    var message: [SwaValidErrSubModel] = []
    
    var debugDisp: String {
        return "[\(statusCode): \(error)] [\(message.count)]件 ... [\(message.description)]"
    }
}
struct SwaValidErrSubModel: Decodable {
   var children: [SwaValidErrSubModel] = []
   var property: String = ""
   var constraints: [String: String]? = nil
    
    var debugDisp: String {
        return "[\(property): \(String(describing: constraints?.count))件] ... [\(String(describing: constraints?.keys))] の情報あり ：　[続行\((children.count > 0) ? "あり" : "なし")]"
    }
}
//===Type応募APIでのサーバ側エラー(不正なXMLによるリクエストです)
struct TypeEntryErrModel: Codable {
    var message: String = ""
    var detailMessage: String = ""
}
//======== もろもろエラーをひっぺがす
struct SwaValidErrMsg {
    var property: String = ""
    var constraintsKey: String = ""
    var constraintsVal: String = ""
    
    var debugDisp: String {
        return "[\(property)]...[\(constraintsKey): \(constraintsVal)]"
    }
}
struct MyErrorDisp {
    var code: Int = 0
    var title: String = "エラー"
    var message: String = "エラーが発生しました"
    let orgErr: Error!
    var arrValidErrMsg: [SwaValidErrMsg] = [] // 複合種キーになりかねないから、とりあえず抜粋モデルにしておく
    //var dicParam: [String: String] = [:]//NSErrorにあるやつのために用意したけど、orgErrorにもついてるだろうし、つかわないかな？
    enum CodeType: Int {
        case existsUser = 24
        case undefinedUser = 23
        case invalidSession = 13
        case afterInvalidSession = 32
    }
    
    var debugDisp: String {
        var buf: String = ""
        buf += "✨▽\(orgErr.localizedDescription) -> \n"
        buf += "✨\t[\(code): \(title)] ... [\(message)]\n"
        for valid in arrValidErrMsg {
            buf += "✨\t[\(valid.property)] ... [\(valid.constraintsKey)] [\(valid.constraintsVal)]\n"
        }
        return buf
    }
}

extension AuthManager {
    class func convAnyError(_ error: Error) -> MyErrorDisp {
        //====== 初期準備 ======
        var myErrorDisp: MyErrorDisp = MyErrorDisp(orgErr: error)
        
        guard let _error = error as? NSError  else {
            print("=== 準備失敗 ===\n", myErrorDisp.debugDisp, "\n==================")
            return myErrorDisp
        }
        
        
        
        //=== UserDefine Error は、そのまま表示させておわる
        if let error = error as? ApiError {
            switch error {
            case .userDefine(let _error):
                myErrorDisp.code = _error.code
                myErrorDisp.title = _error.domain
                var buf: String = ""
                for key in _error.userInfo.keys {
                    if let val = _error.userInfo[key] as? String {
                        buf += "[\(key): \(val)]\n"
                    }
                    if let val = _error.userInfo[key] as? Int {
                        buf += "[\(key): \(val)]\n"
                    }
                }
                myErrorDisp.message = buf
                return myErrorDisp
                
            case .retryMax(let orgError): //自動リトライした結果のエラー
//                print("自動リトライしたけどダメだったエラー")
                return convAnyError(orgError)

            case .validation(let orgError):
                return convAnyError(orgError)

            case .badParameter(let key): //パラメータ不正
                let buf = "パラメータが不正だった [\(key)]"
                myErrorDisp.message = buf
                return myErrorDisp

            case .noFetch:
                let buf = "フェッチ不要だった場合（エラーじゃない）"
                myErrorDisp.message = buf
                return myErrorDisp
                
//            case .validate(let message):
//                print("Validation Error")
//                myErrorDisp.message = message
            }
        }
        
        myErrorDisp.code = _error.code
        myErrorDisp.title = _error.domain
        myErrorDisp.message = _error.userInfo.description
        
        //=== AWS Mobile Client:
        if let orgErr = error as? AWSMobileClientError {
            myErrorDisp.title = "AWSMobileClient"
            myErrorDisp.message = orgErr.dispError
            return myErrorDisp
        }
        switch _error.domain {
            //=== NSURLErrorDomain（ネットワーク接続がないときにやってくる： Auth系など、-1009 で返ってくる場合）
            case  "NSURLErrorDomain":
                myErrorDisp.title = "NSURLErrorDomain"
                if let msg = _error.userInfo["NSLocalizedDescription"] as? String {
                    myErrorDisp.message = msg
                }
                return myErrorDisp
        
            //=== NSCocoaErrorDomain
            case  "NSCocoaErrorDomain":
                myErrorDisp.title = "NSCocoaErrorDomain"
                let cocorErrMsg = NSError.convCocoaErr(code: _error.code)
                myErrorDisp.message = cocorErrMsg
                return myErrorDisp
        
            case "TudApi.ErrorResponse":
                myErrorDisp.title = "TudApi.ErrorResponse"
                switch error as? Error {
                case .none:
                    myErrorDisp.message = "[\(_error.code)] \(_error.domain)"

                case .some((let swaErrResp)):
                    if let swaErr = swaErrResp as? ErrorResponse {
                        switch swaErr {
                        case .error(let swaCode, let swaData, let swaErr):
                            myErrorDisp.code = swaCode
                            switch swaCode {
                            case 400:
                                myErrorDisp.title = "Validation Error"
                                if let _data = swaData, _data.count > 0 {
                                    var isErrorDecode: Bool = false
                                    do {//Type応募を叩いた場合でのエラーモデル
                                        let swa = try JSONDecoder().decode(TypeEntryErrModel.self, from: _data) as TypeEntryErrModel
                                        var bufMsg: String = ""
                                        bufMsg += "[\(swa.message)]\n\(swa.detailMessage)"
                                        myErrorDisp.message = bufMsg
                                        isErrorDecode = true
                                    } catch {
                                        //Decode失敗
                                    }
                                    do {//TUD-APIを叩いた場合でのエラーモデル
                                        let swa = try JSONDecoder().decode(SwaValidErrModel.self, from: _data) as SwaValidErrModel
                                        print(swa)
                                        myErrorDisp.code = swa.statusCode
                                        var bufMsg: String = ""
                                        func chkChildErr(subModel: SwaValidErrSubModel) {
                                            if let _constraints = subModel.constraints {
                                                for (k, v) in _constraints {
                                                    let obj: SwaValidErrMsg = SwaValidErrMsg(property: subModel.property, constraintsKey: k, constraintsVal: v)
                                                    myErrorDisp.arrValidErrMsg.append(obj)
                                                    bufMsg += "\t[\(subModel.property): \(v)]\n"
                                                }
                                            }
                                            if subModel.children.count > 0 {
                                                for child in subModel.children {
                                                    chkChildErr(subModel: child)
                                                }
                                            }
                                        }
                                        //ぐるぐるっと呼び出しまくる
                                        for item in swa.message {
                                            chkChildErr(subModel: item)
                                        }
                                        myErrorDisp.message = bufMsg
                                        isErrorDecode = true
                                    } catch {
                                        //Decode失敗
                                    }
                                    if isErrorDecode {
                                        //Decodeできた
                                    } else {
                                        let jsonStr = String(bytes: _data, encoding: .utf8)!
                                        print("JSONモデルのパースに失敗(\(#line)): [\(jsonStr)]", error.localizedDescription)
                                    }
                                }
                                
                            case 500: // （ネットワーク接続がない時にやってくる：　user-apiなど）
                                myErrorDisp.title = "Network Error"
                                myErrorDisp.message = swaErr.localizedDescription

                            case 401:
                                myErrorDisp.title = "認証エラー"
                                if let _data = swaData, _data.count > 0 {
                                    do {
                                        let swa = try JSONDecoder().decode(SwaErrModel.self, from: _data) as SwaErrModel
                                        myErrorDisp.message = swa.message
                                    } catch {
                                        let jsonStr = String(bytes: _data, encoding: .utf8)!
                                        print("JSONモデルのパースに失敗(\(#line)): [\(jsonStr)]", error.localizedDescription)
                                    }
                                }
                                //=== 再認証を促すため、ログイン画面に遷移させるとかする？
                                // The incoming token has expired
                                
                            case 404:
                                if let _data = swaData, _data.count > 0 {
                                    do {
                                        let swa = try JSONDecoder().decode(SwaErrModel_404.self, from: _data) as SwaErrModel_404
                                        myErrorDisp.code = swa.status
                                        myErrorDisp.message = swa.error
                                    } catch {
                                        let jsonStr = String(bytes: _data, encoding: .utf8)!
                                        print("JSONモデルのパースに失敗(\(#line)): [\(jsonStr)]", error.localizedDescription)
                                    }
                                }

                            default:
                                myErrorDisp.title = "\(swaErr)"
                                if let _data = swaData, _data.count > 0 {
                                    do {
                                        let swa = try JSONDecoder().decode(SwaErrModel.self, from: _data) as SwaErrModel
                                        myErrorDisp.message = swa.message
                                    } catch {
                                        let jsonStr = String(bytes: _data, encoding: .utf8)!
                                        print("JSONモデルのパースに失敗(\(#line)): [\(jsonStr)]", error.localizedDescription)
                                    }
                                }
                            }
                        }
                    }
                }
        default:
            myErrorDisp.message = "[\(_error.code)] \(_error.domain)"
        }
        return myErrorDisp
    }
}







//NSCocoaErrorDomain
extension NSError {
    class func convCocoaErr(code: Int) -> String {
        let array: [(Int, String)] = [
            (NSFileNoSuchFileError, "NSFileNoSuchFileError"),
            (NSFileLockingError, "NSFileLockingError"),
            (NSFileReadUnknownError, "NSFileReadUnknownError"),
            (NSFileReadNoPermissionError, "NSFileReadNoPermissionError"),
            (NSFileReadInvalidFileNameError, "NSFileReadInvalidFileNameError"),
            (NSFileReadCorruptFileError, "NSFileReadCorruptFileError"),
            (NSFileReadNoSuchFileError, "NSFileReadNoSuchFileError"),
            (NSFileReadInapplicableStringEncodingError, "NSFileReadInapplicableStringEncodingError"),
            (NSFileReadUnsupportedSchemeError, "NSFileReadUnsupportedSchemeError"),
            (NSFileReadTooLargeError, "NSFileReadTooLargeError"),
            (NSFileReadUnknownStringEncodingError, "NSFileReadUnknownStringEncodingError"),
            (NSFileWriteUnknownError, "NSFileWriteUnknownError"),
            (NSFileWriteNoPermissionError, "NSFileWriteNoPermissionError"),
            (NSFileWriteInvalidFileNameError, "NSFileWriteInvalidFileNameError"),
            (NSFileWriteFileExistsError, "NSFileWriteFileExistsError"),
            (NSFileWriteInapplicableStringEncodingError, "NSFileWriteInapplicableStringEncodingError"),
            (NSFileWriteUnsupportedSchemeError, "NSFileWriteUnsupportedSchemeError"),
            (NSFileWriteOutOfSpaceError, "NSFileWriteOutOfSpaceError"),
            (NSFileWriteVolumeReadOnlyError, "NSFileWriteVolumeReadOnlyError"),
    //        (NSFileManagerUnmountUnknownError, "NSFileManagerUnmountUnknownError"),
    //        (NSFileManagerUnmountBusyError, "NSFileManagerUnmountBusyError"),
            (NSKeyValueValidationError, "NSKeyValueValidationError"),
            (NSFormattingError, "NSFormattingError"),
            (NSUserCancelledError, "NSUserCancelledError"),
            (NSFeatureUnsupportedError, "NSFeatureUnsupportedError"),
            (NSExecutableNotLoadableError, "NSExecutableNotLoadableError"),
            (NSExecutableArchitectureMismatchError, "NSExecutableArchitectureMismatchError"),
            (NSExecutableRuntimeMismatchError, "NSExecutableRuntimeMismatchError"),
            (NSExecutableLoadError, "NSExecutableLoadError"),
            (NSExecutableLinkError, "NSExecutableLinkError"),
            (NSFileErrorMinimum, "NSFileErrorMinimum"),
            (NSFileErrorMaximum, "NSFileErrorMaximum"),
            (NSValidationErrorMaximum, "NSValidationErrorMaximum"),
            (NSExecutableErrorMinimum, "NSExecutableErrorMinimum"),
            (NSExecutableErrorMaximum, "NSExecutableErrorMaximum"),
            (NSFormattingErrorMaximum, "NSFormattingErrorMaximum"),
            (NSPropertyListReadCorruptError, "NSPropertyListReadCorruptError"),
            (NSPropertyListReadUnknownVersionError, "NSPropertyListReadUnknownVersionError"),
            (NSPropertyListReadStreamError, "NSPropertyListReadStreamError"),
            (NSPropertyListWriteStreamError, "NSPropertyListWriteStreamError"),
            (NSPropertyListWriteInvalidError, "NSPropertyListWriteInvalidError"),
            (NSPropertyListErrorMinimum, "NSPropertyListErrorMinimum"),
            (NSPropertyListErrorMaximum, "NSPropertyListErrorMaximum"),
            (NSXPCConnectionInterrupted, "NSXPCConnectionInterrupted"),
            (NSXPCConnectionInvalid, "NSXPCConnectionInvalid"),
            (NSXPCConnectionReplyInvalid, "NSXPCConnectionReplyInvalid"),
            (NSXPCConnectionErrorMinimum, "NSXPCConnectionErrorMinimum"),
            (NSXPCConnectionErrorMaximum, "NSXPCConnectionErrorMaximum"),
            (NSUbiquitousFileUnavailableError, "NSUbiquitousFileUnavailableError"),
            (NSUbiquitousFileNotUploadedDueToQuotaError, "NSUbiquitousFileNotUploadedDueToQuotaError"),
            (NSUbiquitousFileUbiquityServerNotAvailable, "NSUbiquitousFileUbiquityServerNotAvailable"),
            (NSUbiquitousFileErrorMinimum, "NSUbiquitousFileErrorMinimum"),
            (NSUbiquitousFileErrorMaximum, "NSUbiquitousFileErrorMaximum"),
            (NSUserActivityHandoffFailedError, "NSUserActivityHandoffFailedError"),
            (NSUserActivityConnectionUnavailableError, "NSUserActivityConnectionUnavailableError"),
            (NSUserActivityRemoteApplicationTimedOutError, "NSUserActivityRemoteApplicationTimedOutError"),
            (NSUserActivityHandoffUserInfoTooLargeError, "NSUserActivityHandoffUserInfoTooLargeError"),
            (NSUserActivityErrorMinimum, "NSUserActivityErrorMinimum"),
            (NSUserActivityErrorMaximum, "NSUserActivityErrorMaximum"),
            (NSCoderReadCorruptError, "NSCoderReadCorruptError"),
            (NSCoderValueNotFoundError, "NSCoderValueNotFoundError"),
            (NSCoderErrorMinimum, "NSCoderErrorMinimum"),
            (NSCoderErrorMaximum, "NSCoderErrorMaximum"),
            (NSBundleErrorMinimum, "NSBundleErrorMinimum"),
            (NSBundleErrorMaximum, "NSBundleErrorMaximum"),
            (NSCloudSharingNetworkFailureError, "NSCloudSharingNetworkFailureError"),
            (NSCloudSharingQuotaExceededError, "NSCloudSharingQuotaExceededError"),
            (NSCloudSharingTooManyParticipantsError, "NSCloudSharingTooManyParticipantsError"),
            (NSCloudSharingConflictError, "NSCloudSharingConflictError"),
            (NSCloudSharingNoPermissionError, "NSCloudSharingNoPermissionError"),
            (NSCloudSharingOtherError, "NSCloudSharingOtherError"),
            (NSCloudSharingErrorMinimum, "NSCloudSharingErrorMinimum"),
            (NSCloudSharingErrorMaximum, "NSCloudSharingErrorMaximum"),

            (NSManagedObjectConstraintValidationError, "NSManagedObjectConstraintValidationError"),
            (NSValidationMultipleErrorsError, "NSValidationMultipleErrorsError"),
            (NSValidationMissingMandatoryPropertyError, "NSValidationMissingMandatoryPropertyError"),
            (NSValidationRelationshipLacksMinimumCountError, "NSValidationRelationshipLacksMinimumCountError"),
            (NSValidationRelationshipExceedsMaximumCountError, "NSValidationRelationshipExceedsMaximumCountError"),
            (NSValidationRelationshipDeniedDeleteError, "NSValidationRelationshipDeniedDeleteError"),
            (NSValidationNumberTooLargeError, "NSValidationNumberTooLargeError"),
            (NSValidationNumberTooSmallError, "NSValidationNumberTooSmallError"),
            (NSValidationDateTooLateError, "NSValidationDateTooLateError"),
            (NSValidationDateTooSoonError, "NSValidationDateTooSoonError"),
            (NSValidationInvalidDateError, "NSValidationInvalidDateError"),
            (NSValidationStringTooLongError, "NSValidationStringTooLongError"),
            (NSValidationStringTooShortError, "NSValidationStringTooShortError"),
            (NSValidationStringPatternMatchingError, "NSValidationStringPatternMatchingError"),
            (NSValidationInvalidURIError, "NSValidationInvalidURIError"),

            (NSPersistentStoreCoordinatorLockingError, "NSPersistentStoreCoordinatorLockingError"),

            (NSManagedObjectExternalRelationshipError, "NSManagedObjectExternalRelationshipError"),
            (NSManagedObjectMergeError, "NSManagedObjectMergeError"),
            (NSManagedObjectConstraintMergeError, "NSManagedObjectConstraintMergeError"),

            (NSPersistentStoreTypeMismatchError, "NSPersistentStoreTypeMismatchError"),
            (NSPersistentStoreIncompatibleSchemaError, "NSPersistentStoreIncompatibleSchemaError"),
            (NSPersistentStoreSaveError, "NSPersistentStoreSaveError"),
            (NSPersistentStoreIncompleteSaveError, "NSPersistentStoreIncompleteSaveError"),
            (NSPersistentStoreSaveConflictsError, "NSPersistentStoreSaveConflictsError"),

            (NSPersistentStoreOperationError, "NSPersistentStoreOperationError"),
            (NSPersistentStoreOpenError, "NSPersistentStoreOpenError"),
            (NSPersistentStoreTimeoutError, "NSPersistentStoreTimeoutError"),
            (NSPersistentStoreUnsupportedRequestTypeError, "NSPersistentStoreUnsupportedRequestTypeError"),

            (NSMigrationError, "NSMigrationError"),
            (NSMigrationConstraintViolationError, "NSMigrationConstraintViolationError"),
            (NSMigrationCancelledError, "NSMigrationCancelledError"),
            (NSMigrationMissingSourceModelError, "NSMigrationMissingSourceModelError"),
            (NSMigrationMissingMappingModelError, "NSMigrationMissingMappingModelError"),
            (NSMigrationManagerSourceStoreError, "NSMigrationManagerSourceStoreError"),
            (NSMigrationManagerDestinationStoreError, "NSMigrationManagerDestinationStoreError"),
            (NSEntityMigrationPolicyError, "NSEntityMigrationPolicyError"),
            (NSExternalRecordImportError, "NSExternalRecordImportError"),
        ]
        let obj = array.filter { (cd, name) -> Bool in
            return (cd == code)
        }
        guard let errObj = obj.first else { return "unknown" }
        return errObj.1
    }
    
}
