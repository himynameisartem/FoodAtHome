//
//  LanguageManager.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 20.05.2025.
//

import Foundation

private var bundleKey: UInt8 = 0

class LanguageManager {
    static let shared = LanguageManager()
    private init() {}

    var currentLanguage: String {
        get {
            UserDefaults.standard.string(forKey: "AppLanguage") ?? Locale.current.languageCode ?? "en"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "AppLanguage")
            Bundle.setLanguage(newValue)
        }
    }

    func applyLanguage() {
        Bundle.setLanguage(currentLanguage)
    }
}

extension Bundle {
    private static var didSwizzle = false

    class func setLanguage(_ language: String) {
        if !didSwizzle {
            object_setClass(Bundle.main, LanguageBundle.self)
            didSwizzle = true
        }

        let path = Bundle.main.path(forResource: language, ofType: "lproj")!
        let langBundle = Bundle(path: path)
        objc_setAssociatedObject(Bundle.main, &bundleKey, langBundle, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}

private class LanguageBundle: Bundle, @unchecked Sendable {
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        guard let bundle = objc_getAssociatedObject(self, &bundleKey) as? Bundle else {
            return super.localizedString(forKey: key, value: value, table: tableName)
        }
        return bundle.localizedString(forKey: key, value: value, table: tableName)
    }
}
