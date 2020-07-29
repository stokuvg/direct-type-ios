import UIKit

//Documentsフォルダ以下に【logTest_2020072908.txt】のように出力されるので、適宜表示させて確認できます
//シミュレータの場合、「$ tail -f /Users/ms-mb000/Library/Developer/CoreSimulator/Devices/~/data/Containers/Data/Application/~/Documents/logTest_2020072908.txt」みたいにやると、幸せになれます
//ファイル名はアプリ起動時の時刻までで区切って生成されます

class LogManager: NSObject {
    private var cntDispatch: Int = 0
    private var cntSemaphore: Int = 0
    
    enum Mode {
        case ALWAYS
        case progress   //プログレスの対応確認のため
        case apiFetch   //apiフェッチの確認のため
        //===これ以降に必要に応じて追加して利用してください
        case apiDetail

        var isOut: Bool {
            if Constants.DbgOutputLog == false { return false }
            switch self {
            case .ALWAYS:       return true
            case .progress:     return true
            case .apiFetch:     return true
            //===これ以降に必要に応じて追加して利用してください
            case .apiDetail:    return true
            }
        }
    }

    var LogFullPath: String = ""
    static let arrSkip: [String] = []//ここで指定した文字配列に同一なgrpだった場合は出力抑止する
    class func appendLog(_ mode: Mode, _ title: String, _ text: String) {
        appendLog(mode, "", title, text)
    }
    class func appendApiLog(_ apiName: String, _ param: Any?, function: String, line: Int) {
        let _param = String(describing: type(of: param))
        appendLogEx(.apiFetch, "api", apiName, _param, function, line)
    }
    class func appendLog(_ mode: Mode, _ grp: String, _ title: String, _ text: String) {
        appendLogEx(mode, grp, title, text, "", 0)
    }
    class func appendLogEx(_ mode: Mode, _ grp: String, _ title: String, _ text: String, _ cls: String, _ line: Int) {
        var bufLv: String = ""//Progress In/Outの対応チェックで階層チェックとかするときに使うため（現在は非対応）
        var grpTitle: String = grp.isEmpty ? title : grp
        guard mode.isOut else { return }
        var isSkip: Bool = false
        if arrSkip.contains(grp) { isSkip = true }
        if isSkip { return } //上記パターンにマッチしたらログ出力抑止する
        var buf = "\(grp)\t\(title)\t\(text)"
        if !cls.isEmpty { buf = "\(buf)\t 🌈[\(cls): \(line)]"}
        self.sharedManager.appendLog(buf)
        print("\(bufLv)♦️\(buf)")
    }
    class func appendLogProgressIn(_ api: String) { appendLogProgress("Progress In", api) }
    class func appendLogProgressOut(_ api: String) { appendLogProgress("Progress Out", api) }
    class func appendLogProgressErr(_ api: String) { appendLogProgress("Progress Out(Err)", api) }
    class func appendLogProgress(_ title: String, _ text: String) {
        LogManager.appendLog(.progress, title, text)
    }
    static var sharedManager: LogManager = {
        return LogManager()
    }()
    override init() {
        super.init()
        self.commonInit()
    }
    private func commonInit() {
        let bufDocPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        let bufFName = "logTest_\(Date().FName).txt"
        self.LogFullPath = "\(bufDocPath)/\(bufFName)"
        print(self.LogFullPath)
    }
    private func appendLog(_ text: String) {
        let log = "\(Date().dispLogTime())\t\(text)\n"
        let output = OutputStream(toFileAtPath: self.LogFullPath, append: true)
        output?.open()
        let tmps = [UInt8](log.utf8)
        let bytes = UnsafePointer<UInt8>(tmps)
        let size = log.lengthOfBytes(using: String.Encoding.utf8)
        output?.write(bytes, maxLength: size)
        output?.close()
        //print("◆◆\(Date().dispLogTime())\t\(text)◆◆")
    }

}
