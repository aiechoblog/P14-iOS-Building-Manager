import Foundation

func persianNumber(_ value: Int) -> String {
    return String(value).toPersianDigits()
}

func formatMoney(_ value: Int) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.groupingSeparator = ","

    let number = NSNumber(value: value)
    let formatted = formatter.string(from: number) ?? String(value)
    return formatted.toPersianDigits() + " تومان"
}

func normalizedNumericText(_ text: String) -> String {
    let englishText = text.toEnglishDigits()
    let withoutComma = englishText.replacingOccurrences(of: ",", with: "")
    let withoutSpace = withoutComma.replacingOccurrences(of: " ", with: "")
    return withoutSpace.replacingOccurrences(of: "−", with: "-")
}

func parseAmount(_ text: String) -> Int {
    return Int(normalizedNumericText(text)) ?? 0
}

func isNumericText(_ text: String) -> Bool {
    let normalized = normalizedNumericText(text)
    if normalized.isEmpty {
        return false
    }
    return Int(normalized) != nil
}

extension String {
    func toPersianDigits() -> String {
        var result = self
        result = result.replacingOccurrences(of: "0", with: "۰")
        result = result.replacingOccurrences(of: "1", with: "۱")
        result = result.replacingOccurrences(of: "2", with: "۲")
        result = result.replacingOccurrences(of: "3", with: "۳")
        result = result.replacingOccurrences(of: "4", with: "۴")
        result = result.replacingOccurrences(of: "5", with: "۵")
        result = result.replacingOccurrences(of: "6", with: "۶")
        result = result.replacingOccurrences(of: "7", with: "۷")
        result = result.replacingOccurrences(of: "8", with: "۸")
        result = result.replacingOccurrences(of: "9", with: "۹")
        return result
    }

    func toEnglishDigits() -> String {
        var result = self
        result = result.replacingOccurrences(of: "۰", with: "0")
        result = result.replacingOccurrences(of: "۱", with: "1")
        result = result.replacingOccurrences(of: "۲", with: "2")
        result = result.replacingOccurrences(of: "۳", with: "3")
        result = result.replacingOccurrences(of: "۴", with: "4")
        result = result.replacingOccurrences(of: "۵", with: "5")
        result = result.replacingOccurrences(of: "۶", with: "6")
        result = result.replacingOccurrences(of: "۷", with: "7")
        result = result.replacingOccurrences(of: "۸", with: "8")
        result = result.replacingOccurrences(of: "۹", with: "9")
        return result
    }
}