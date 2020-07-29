import Foundation

public enum FileExistResult {
    case fileExist //指定ファイル（フォルダ）が存在する
    case fileNotExist(error: Error)
}
extension FileManager {
    class func fileExist(_ zipFullPath: String, isFile: Bool = true) -> FileExistResult {
        let fm = FileManager.default
        var isDirObjC: ObjCBool = false
        if fm.fileExists(atPath: zipFullPath, isDirectory: &isDirObjC) {
            if isFile {
                if isDirObjC.boolValue {
                    return FileExistResult.fileNotExist(error: NSError(domain: "対象パスが存在するがディレクトリだった", code: #line, userInfo: nil))
                } else {
                    return FileExistResult.fileExist //指定がFileでFileだった
                }
            } else {
                if isDirObjC.boolValue {
                    return FileExistResult.fileExist //指定がDirでDirだった
                } else {
                    return FileExistResult.fileNotExist(error: NSError(domain: "対象パスが存在するがファイルだった", code: #line, userInfo: nil))
                }
            }
        } else {
            return FileExistResult.fileNotExist(error: NSError(domain: "対象パスが存在しなかった", code: #line, userInfo: nil))
        }
    }
}

extension FileManager {
    //指定したフォルダを作成する（中身も空にしたものを準備する）
    class func cleanTempDir(tempFDir: String) {
        var arrError: [Error] = []
        let fm = FileManager.default
        //指定先が存在していたら削除しておく（ただしtargetを2階層以上指定しているとチェックできない）
        if fm.fileExists(atPath: tempFDir) {
            if !fm.isDeletableFile(atPath: tempFDir) {
                if !tempFDir.isEmpty {
                    arrError.append(NSError(domain: "指定フォルダを削除できそうにない", code: #line, userInfo: ["target" : tempFDir]))
                }
            } else {
                if !tempFDir.isEmpty {
                    do {
                        try fm.removeItem(at: URL(fileURLWithPath: tempFDir, isDirectory: true))
                    } catch let error as NSError {
                        arrError.append(NSError(domain: "指定フォルダを削除できなかった", code: #line, userInfo: ["target" : tempFDir]))
                    }
                }
            }
        } else {
            //arrError.append(NSError(domain: "フォルダがなかった", code: #line, userInfo: ["target" : tempFDir]))
            try! fm.createDirectory(atPath: tempFDir, withIntermediateDirectories: true, attributes: nil)
        }
        for error in arrError {
            print(#line, error.localizedDescription)
        }
    }
    class func removeDir(tempFDir: String) {
        var arrError: [Error] = []
        let fm = FileManager.default
        //指定先が存在していたら削除しておく（ただしtargetを2階層以上指定しているとチェックできない）
        if fm.fileExists(atPath: tempFDir) {
            if !fm.isDeletableFile(atPath: tempFDir) {
                if !tempFDir.isEmpty {
                    arrError.append(NSError(domain: "指定フォルダを削除できそうにない", code: #line, userInfo: ["target" : tempFDir]))
                }
            } else {
                if !tempFDir.isEmpty {
                    do {
                        try fm.removeItem(at: URL(fileURLWithPath: tempFDir, isDirectory: true))
                    } catch let error as NSError {
                        arrError.append(NSError(domain: "指定フォルダを削除できなかった", code: #line, userInfo: ["target" : tempFDir]))
                    }
                }
            }
        }
        for error in arrError {
            print(#line, error.localizedDescription)
        }
    }
}
