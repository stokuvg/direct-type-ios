import UIKit

//MARK: === Public ===
class CellSeparateLine: UIView {
    override func draw(_ rect: CGRect) {
        UIColor.lightGray.setFill()
        let rectangle = UIBezierPath(rect: rect)
        rectangle.fill()
    }
}
extension Dictionary {
    public mutating func update(_ other: Dictionary) {
        for (key, value) in other {
            self.updateValue(value, forKey:key)
        }
    }
    public mutating func addDicArrVal(key: Key, val: [String]) {
        for _val in val {
            self.addDicArrVal(key: key, val: _val)
        }
    }
    public mutating func addDicArrVal(key: Key, val: String) {
        if var vals = self[key] as? [String] {
            vals.append(val)
            self.updateValue(vals as! Value, forKey: key)
        } else {
            self.updateValue([val] as! Value, forKey: key)
        }
    }
}
    
//指定した最小値〜最大値の範囲に数値を補正する
// tmpM = min(12, tmpM); tmpM = max(1, tmpM)
extension Int {
    func normalize(min: Int, max: Int) -> Int {
        var temp: Int = self
        temp = (temp > min) ? temp : min
        temp = (temp < max) ? temp : max
        return temp
    }
}
// 整数のカンマ区切り表示
extension Int {
    var dispComma: String {
        let numFormatter = NumberFormatter()
        numFormatter.locale = Locale(identifier: "ja_JP")
        numFormatter.numberStyle = .decimal
        guard let s = numFormatter.string(from: self as NSNumber) else { fatalError() }
        return s
    }
    func zeroUme(_ len: Int) -> String {
        var buf = String(repeating: "0", count: len)
        buf += String(self)
        return String(buf.suffix(len))
    }
}
extension String {
    func zeroUme(_ len: Int) -> String {
        var buf = String(repeating: "0", count: len)
        buf += String(self)
        return String(buf.suffix(len))
    }
}
class WakuVW: UIView {
    override func draw(_ rect: CGRect) {
        UIColor.gray.setStroke()
//        let rectangle = UIBezierPath(rect: rect)
        let rectangle = UIBezierPath(roundedRect: rect, cornerRadius: 8.0)
        rectangle.lineWidth = 1
        rectangle.stroke()
    }
}

//開始文字は1始まりを想定し、切り出す文字長を指定する
extension String {
    static func substr(_ text: String, _ _s: Int, _ _l: Int) -> String {
        let s = (_s - 1)
        let l = (_l - 1)
        let e = (s + l)
        guard _s > 0, _l > 0 else { return text }
        guard text.count >= e else { return text }
        let from = text.index(text.startIndex, offsetBy: s)
        let to = text.index(from, offsetBy: l)
        let result = text[from...to]
        return String(result)
    }
}

extension Data {
    var jsonStr: String {
        do {
            let jsonStr = String(bytes: self, encoding: .utf8)!
            return jsonStr
        }
    }
}

extension String {
    // ひらがな -> カタカナ
    func hiraToKata() -> String {
        return self.transform(transform: .hiraganaToKatakana, reverse: false)
    }
    func kataToHira() -> String {
        return self.transform(transform: .hiraganaToKatakana, reverse: true)
    }
    private func transform(transform: StringTransform, reverse: Bool) -> String {
        if let string = self.applyingTransform(transform, reverse: reverse) {
            return string
        } else {
            return ""
        }
    }
}



