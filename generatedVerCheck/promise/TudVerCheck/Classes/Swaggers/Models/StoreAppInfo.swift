//
// StoreAppInfo.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


/** iTunesStoreを検索して取得した公開中アプリの情報 */

public struct StoreAppInfo: Codable {

    /** アプリID */
    public var trackId: Int
    /** アプリ名 */
    public var trackName: String
    /** 初回リリース日 */
    public var releaseDate: String
    /** 現在バージョン公開日 */
    public var currentVersionReleaseDate: String
    /** バージョン番号 */
    public var version: String

    public init(trackId: Int, trackName: String, releaseDate: String, currentVersionReleaseDate: String, version: String) {
        self.trackId = trackId
        self.trackName = trackName
        self.releaseDate = releaseDate
        self.currentVersionReleaseDate = currentVersionReleaseDate
        self.version = version
    }

}
