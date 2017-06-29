//
//  Colors.swift
//  mala-ios
//
//  Created by 王新宇 on 2017/2/10.
//  Copyright © 2017年 Mala Online. All rights reserved.
//
//  Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

#if os(iOS) || os(tvOS) || os(watchOS)
    import UIKit.UIColor
    typealias Color = UIColor
#elseif os(OSX)
    import AppKit.NSColor
    typealias Color = NSColor
#endif

extension Color {
    convenience init(rgbaValue: UInt32) {
        let red   = CGFloat((rgbaValue >> 24) & 0xff) / 255.0
        let green = CGFloat((rgbaValue >> 16) & 0xff) / 255.0
        let blue  = CGFloat((rgbaValue >>  8) & 0xff) / 255.0
        let alpha = CGFloat((rgbaValue      ) & 0xff) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}


enum ColorName: UInt32 {
    
    case ArticleTitle = 0x333333FF
    case ArticleSubTitle = 0x6C6C6CFF
    case ArticleText = 0x636363FF
    case HeaderTitle = 0x939393FF
    case CardTag = 0x33333399
    case Disabled = 0xCFCFCFFF
    case CommitButtonNormal = 0xBCD7EBFF
    case OptionTitle = 0x7E7E7EFF
    case OptionBackground = 0xFDFDFDFF
    case ChartLabel = 0x5E5E5EFF
    case LevelYellow = 0xFDDC55FF
    case TeachingAgeRed = 0xFA7A7AFF
    case ProgressGray = 0xEEEEEEFF
    case OrderGreen = 0x7BB045FF
    case OptionSelectColor = 0x8DBEDEFF
    case LoginBlue = 0x8DBEDFFF
    case SeparatorLine = 0xDADADAFF
    case SharedBoard = 0xF2F2F2F2
    case BaseBoard = 0xF6F6F6FF
    case NavigationShadow = 0xF4F4F4FF
    case LiveAvatarBack = 0xA8D0FFFF
    case SubjectTagBlue = 0xB1D8F3FF
    case DescGray = 0xB7B7B7FF
    case ReportTopicData = 0xBBDDF6FF
    case ThemeRed = 0xE26254FF
    case ThemeRedHighlight = 0xFCEFEDFF
    case ThemeBlue = 0x9BC3E1FF
    case ThemeGreen = 0x9EC379FF
    case ThemeTextBlue = 0x84B3D7FF
    case ThemeDeepBlue = 0x6DB2E5FF
    case ThemeBlueTranslucent95 = 0x88BCDEF2
    case SubjectRed = 0xE25C5CFF
    case SubjectLightRed = 0xF9B7B7FF
    case SubjectBlue = 0x2B7BB4FF
    case SubjectGreen = 0x259746FF
    case SubjectLightGreen = 0xBFE7CAFF
    case StyleTag = 0x5789ACFF
    case PageControl = 0x2AAADDFF
    case WhiteTranslucent9 = 0xFFFFFFE6
    case ReportDesc = 0x363B4EFF
    case CouponGray = 0x999999FF
    case LiveClassCapacity = 0x7ED321FF
    case LiveClassCapacityShadow = 0x3E8CC7FF
    case LiveClassCardBlue = 0x5FAEEAFF
    case LiveDetailCardTitle = 0x7DB7E2FF
    case ChartYellow = 0xF8DB6BFF
    case ChartCyan = 0x6DC9CEFF
    case ChartRed = 0xF9877CFF
    case ChartGreen = 0x69CC99FF
    case ChartBlue = 0x88BCDEFF
    case ChartGrayBlue = 0x8BA3CAFF
    case ChartOrange = 0xF7AF63FF
    case ChartPurple = 0xBA9CDAFF
    case ChartGrayRed = 0xC09C8BFF
    case ChartLegendGreen = 0x75CC97FF
    case ChartLegentLightBlue = 0x82C9F9FF
    case ChartDateText = 0xFDAF6BFF
    case ChartPercentText = 0x97A8BBFF
    case ChartRadarInner = 0xC9E4E8FF
    case InfoText = 0xD4D4D4FF
    case ShadowGray = 0xD7D7D7FF
    case OrderStatusRed = 0xE36A5CFF
    case HighlightGray = 0xF8F8F8FF
    case ChartLegendGray = 0xE6E9ECFF
    case CommitHighlightBlue = 0xE6F1FCFF
    case ReportLabelBack = 0xE8F2F8FF
    case RegularBackground = 0xEDEDEDFF
    case CertificateLabel = 0xEF8F1DFF
    case CardBackground = 0xF2F2F2FF
    case ThemeLikeColor = 0xF76E6DFF
    case CertificateBack = 0xFCDFB7FF
    
    // New
    case themeBlue = 0x73A4FCFF
    case themeLightBlue = 0xE7F1FFFF
    case themeShadowBlue = 0xBFDDFFFF
    case labelBlack = 0x373A41FF
    case labelLightGray = 0xC3C5CDFF
    case indexBlue = 0x76A7FDFF
    case indexBlueClear = 0x76A7FD33
    case indexBluePress = 0x76A7FDAA
    case groupTitleGray = 0x8F929BFF
    case lineGray = 0x979797FF
    case subjectGray = 0x656970FF
    case solutionBlue = 0x5190FFFF
    
    case pageControlGray = 0xD8D8D8FF
    case loginBlue = 0x78A8FEFF
    case loginDisableBlue = 0x78A8FE7F
    case protocolGary = 0xA0A3ABFF
    case protocolGaryHighlight = 0xA0A3AB4C
    case loginShadow = 0xCDE4FFFF
    case profileBlue = 0x7FAEFFFF
    case profileAvatarBG = 0xA5C6FFFF
    case commentBlue = 0x82B4D9FF
    
    case liveShadowBlue = 0xB6D7FCFF
    case liveThemeBlue = 0x75A6FCFF
    case liveMathPurple = 0x99D03BFF
    case liveEnglishGreen = 0xB790FFFF
    case liveCourseTypeBlue = 0x76A6FDFF
    case livePriceRed = 0xFE3059FF
    case livePriceRedHighlight = 0xFE305933
    case liveDetailThemeBlue = 0x74A5FCFF
    case liveDetailThemeRed = 0xF9151BFF
    
    case webProgressBlue = 0x4E85E7FF
    case midGray = 0xE3E3E3FF
    case orderLightRed = 0xFA8487FF
    case orderDisabledGray = 0xDCDCDCFF
    
    var color: Color {
        return Color(named: self)
    }
}


extension Color {
    convenience init(named name: ColorName) {
        self.init(rgbaValue: name.rawValue)
    }
}
