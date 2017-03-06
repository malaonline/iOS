//
//  Fonts.swift
//  mala-ios
//
//  Created by 王新宇 on 2017/3/6.
//  Copyright © 2017年 Mala Online. All rights reserved.
//
//  Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

#if os(iOS) || os(tvOS) || os(watchOS)
    import UIKit.UIFont
    typealias Font = UIFont
#elseif os(OSX)
    import AppKit.NSFont
    typealias Font = NSFont
#endif

protocol FontConvertible {
    func font(_ size: CGFloat) -> Font!
}

extension FontConvertible where Self: RawRepresentable, Self.RawValue == String {
    func font(_ size: CGFloat) -> Font! {
        return Font(font: self, size: size)
    }
}

extension Font {
    convenience init!<FontType: FontConvertible>
        (font: FontType, size: CGFloat)
        where FontType: RawRepresentable, FontType.RawValue == String {
        self.init(name: font.rawValue, size: size)
    }
}

struct FontFamily {
    enum HeitiSC: String, FontConvertible {
        case Light = "STHeitiSC-Light"
        case Medium = "STHeitiSC-Medium"
    }
    enum Helvetica: String, FontConvertible {
        case Regular = "Helvetica"
        case Bold = "Helvetica-Bold"
        case Light = "Helvetica-Light"
    }
    enum HelveticaNeue: String, FontConvertible {
        case Regular = "HelveticaNeue"
        case Bold = "HelveticaNeue-Bold"
        case Light = "HelveticaNeue-Light"
        case Medium = "HelveticaNeue-Medium"
        case Thin = "HelveticaNeue-Thin"
    }
    enum PingFangSC: String, FontConvertible {
        case Light = "PingFangSC-Light"
        case Medium = "PingFangSC-Medium"
        case Regular = "PingFangSC-Regular"
        case Semibold = "PingFangSC-Semibold"
        case Thin = "PingFangSC-Thin"
        case Ultralight = "PingFangSC-Ultralight"
    }
}
