//
//  Copyright © 2015 Dennis Weissmann
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

#if canImport(UIKit) && !os(watchOS)
import UIKit

#if canImport(Darwin)
import Darwin
#endif

public extension UIDevice {
    // https://github.com/devicekit/DeviceKit
    enum Name {
        #if os(iOS)
        /// Device is an [iPod touch (5th generation)](https://support.apple.com/kb/SP657)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP657/sp657_ipod-touch_size.jpg)
        case iPodTouch5
        /// Device is an [iPod touch (6th generation)](https://support.apple.com/kb/SP720)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP720/SP720-ipod-touch-specs-color-sg-2015.jpg)
        case iPodTouch6
        /// Device is an [iPod touch (7th generation)](https://support.apple.com/kb/SP796)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP796/ipod-touch-7th-gen_2x.png)
        case iPodTouch7
        /// Device is an [iPhone 4](https://support.apple.com/kb/SP587)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP643/sp643_iphone4s_color_black.jpg)
        case iPhone4
        /// Device is an [iPhone 4s](https://support.apple.com/kb/SP643)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP643/sp643_iphone4s_color_black.jpg)
        case iPhone4s
        /// Device is an [iPhone 5](https://support.apple.com/kb/SP655)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP655/sp655_iphone5_color.jpg)
        case iPhone5
        /// Device is an [iPhone 5c](https://support.apple.com/kb/SP684)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP684/SP684-color_yellow.jpg)
        case iPhone5c
        /// Device is an [iPhone 5s](https://support.apple.com/kb/SP685)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP685/SP685-color_black.jpg)
        case iPhone5s
        /// Device is an [iPhone 6](https://support.apple.com/kb/SP705)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP705/SP705-iphone_6-mul.png)
        case iPhone6
        /// Device is an [iPhone 6 Plus](https://support.apple.com/kb/SP706)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP706/SP706-iphone_6_plus-mul.png)
        case iPhone6Plus
        /// Device is an [iPhone 6s](https://support.apple.com/kb/SP726)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP726/SP726-iphone6s-gray-select-2015.png)
        case iPhone6s
        /// Device is an [iPhone 6s Plus](https://support.apple.com/kb/SP727)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP727/SP727-iphone6s-plus-gray-select-2015.png)
        case iPhone6sPlus
        /// Device is an [iPhone 7](https://support.apple.com/kb/SP743)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP743/iphone7-black.png)
        case iPhone7
        /// Device is an [iPhone 7 Plus](https://support.apple.com/kb/SP744)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP744/iphone7-plus-black.png)
        case iPhone7Plus
        /// Device is an [iPhone SE](https://support.apple.com/kb/SP738)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP738/SP738.png)
        case iPhoneSE
        /// Device is an [iPhone 8](https://support.apple.com/kb/SP767)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP767/iphone8.png)
        case iPhone8
        /// Device is an [iPhone 8 Plus](https://support.apple.com/kb/SP768)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP768/iphone8plus.png)
        case iPhone8Plus
        /// Device is an [iPhone X](https://support.apple.com/kb/SP770)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP770/iphonex.png)
        case iPhoneX
        /// Device is an [iPhone Xs](https://support.apple.com/kb/SP779)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP779/SP779-iphone-xs.jpg)
        case iPhoneXS
        /// Device is an [iPhone Xs Max](https://support.apple.com/kb/SP780)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP780/SP780-iPhone-Xs-Max.jpg)
        case iPhoneXSMax
        /// Device is an [iPhone Xʀ](https://support.apple.com/kb/SP781)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP781/SP781-iPhone-xr.jpg)
        case iPhoneXR
        /// Device is an [iPhone 11](https://support.apple.com/kb/SP804)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP804/sp804-iphone11_2x.png)
        case iPhone11
        /// Device is an [iPhone 11 Pro](https://support.apple.com/kb/SP805)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP805/sp805-iphone11pro_2x.png)
        case iPhone11Pro
        /// Device is an [iPhone 11 Pro Max](https://support.apple.com/kb/SP806)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP806/sp806-iphone11pro-max_2x.png)
        case iPhone11ProMax
        /// Device is an [iPhone SE (2nd generation)](https://support.apple.com/kb/SP820)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP820/iphone-se-2nd-gen_2x.png)
        case iPhoneSE2
        /// Device is an [iPhone 12](https://support.apple.com/kb/SP830)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP830/sp830-iphone12-ios14_2x.png)
        case iPhone12
        /// Device is an [iPhone 12 mini](https://support.apple.com/kb/SP829)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP829/sp829-iphone12mini-ios14_2x.png)
        case iPhone12Mini
        /// Device is an [iPhone 12 Pro](https://support.apple.com/kb/SP831)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP831/iphone12pro-ios14_2x.png)
        case iPhone12Pro
        /// Device is an [iPhone 12 Pro Max](https://support.apple.com/kb/SP832)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP832/iphone12promax-ios14_2x.png)
        case iPhone12ProMax
        /// Device is an [iPhone 13](https://support.apple.com/kb/SP851)
        ///
        /// ![Image](https://km.support.apple.com/resources/sites/APPLE/content/live/IMAGES/1000/IM1092/en_US/iphone-13-240.png)
        case iPhone13
        /// Device is an [iPhone 13 mini](https://support.apple.com/kb/SP847)
        ///
        /// ![Image](https://km.support.apple.com/resources/sites/APPLE/content/live/IMAGES/1000/IM1091/en_US/iphone-13mini-240.png)
        case iPhone13Mini
        /// Device is an [iPhone 13 Pro](https://support.apple.com/kb/SP852)
        ///
        /// ![Image](https://km.support.apple.com/resources/sites/APPLE/content/live/IMAGES/1000/IM1093/en_US/iphone-13pro-240.png)
        case iPhone13Pro
        /// Device is an [iPhone 13 Pro Max](https://support.apple.com/kb/SP848)
        ///
        /// ![Image](https://km.support.apple.com/resources/sites/APPLE/content/live/IMAGES/1000/IM1095/en_US/iphone-13promax-240.png)
        case iPhone13ProMax
        /// Device is an [iPhone SE (3rd generation)](https://support.apple.com/kb/SP867)
        ///
        /// ![Image](https://km.support.apple.com/resources/sites/APPLE/content/live/IMAGES/1000/IM1136/en_US/iphone-se-3rd-gen-colors-240.png)
        case iPhoneSE3
        /// Device is an [iPhone 14](https://support.apple.com/kb/SP873)
        ///
        /// ![Image](https://km.support.apple.com/resources/sites/APPLE/content/live/IMAGES/1000/IM1092/en_US/TODO)
        case iPhone14
        /// Device is an [iPhone 14 Plus](https://support.apple.com/kb/SP874)
        ///
        /// ![Image](https://km.support.apple.com/resources/sites/APPLE/content/live/IMAGES/1000/IM1091/en_US/TODO)
        case iPhone14Plus
        /// Device is an [iPhone 14 Pro](https://support.apple.com/kb/SP875)
        ///
        /// ![Image](https://km.support.apple.com/resources/sites/APPLE/content/live/IMAGES/1000/IM1093/en_US/TODO)
        case iPhone14Pro
        /// Device is an [iPhone 14 Pro Max](https://support.apple.com/kb/SP876)
        ///
        /// ![Image](https://km.support.apple.com/resources/sites/APPLE/content/live/IMAGES/1000/IM1095/en_US/TODO)
        case iPhone14ProMax
        /// Device is an [iPhone 15]()
        ///
        /// ![Image]()
        case iPhone15
        /// Device is an [iPhone 15 Plus]()
        ///
        /// ![Image]()
        case iPhone15Plus
        /// Device is an [iPhone 15 Pro]()
        ///
        /// ![Image]()
        case iPhone15Pro
        /// Device is an [iPhone 15 Pro Max]()
        ///
        /// ![Image]()
        case iPhone15ProMax
        /// Device is an [iPad 2](https://support.apple.com/kb/SP622)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP622/SP622_01-ipad2-mul.png)
        case iPad2
        /// Device is an [iPad (3rd generation)](https://support.apple.com/kb/SP647)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP662/sp662_ipad-4th-gen_color.jpg)
        case iPad3
        /// Device is an [iPad (4th generation)](https://support.apple.com/kb/SP662)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP662/sp662_ipad-4th-gen_color.jpg)
        case iPad4
        /// Device is an [iPad Air](https://support.apple.com/kb/SP692)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP692/SP692-specs_color-mul.png)
        case iPadAir
        /// Device is an [iPad Air 2](https://support.apple.com/kb/SP708)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP708/SP708-space_gray.jpeg)
        case iPadAir2
        /// Device is an [iPad (5th generation)](https://support.apple.com/kb/SP751)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP751/ipad_5th_generation.png)
        case iPad5
        /// Device is an [iPad (6th generation)](https://support.apple.com/kb/SP774)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP774/sp774-ipad-6-gen_2x.png)
        case iPad6
        /// Device is an [iPad Air (3rd generation)](https://support.apple.com/kb/SP787)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP787/ipad-air-2019.jpg)
        case iPadAir3
        /// Device is an [iPad (7th generation)](https://support.apple.com/kb/SP807)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP807/sp807-ipad-7th-gen_2x.png)
        case iPad7
        /// Device is an [iPad (8th generation)](https://support.apple.com/kb/SP822)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP822/sp822-ipad-8gen_2x.png)
        case iPad8
        /// Device is an [iPad (9th generation)](https://support.apple.com/kb/SP849)
        ///
        /// ![Image](https://km.support.apple.com/resources/sites/APPLE/content/live/IMAGES/1000/IM1096/en_US/ipad-9gen-240.png)
        case iPad9
        /// Device is an [iPad (10th generation)](https://support.apple.com/kb/SP884)
        ///
        /// ![Image](https://km.support.apple.com/resources/sites/APPLE/content/live/IMAGES/1000/IM1096/en_US/TODO.png)
        case iPad10
        /// Device is an [iPad Air (4th generation)](https://support.apple.com/kb/SP828)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP828/sp828ipad-air-ipados14-960_2x.png)
        case iPadAir4
        /// Device is an [iPad Air (5th generation)](https://support.apple.com/kb/TODO)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/TODO)
        case iPadAir5
        /// Device is an [iPad Mini](https://support.apple.com/kb/SP661)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP661/sp661_ipad_mini_color.jpg)
        case iPadMini
        /// Device is an [iPad Mini 2](https://support.apple.com/kb/SP693)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP693/SP693-specs_color-mul.png)
        case iPadMini2
        /// Device is an [iPad Mini 3](https://support.apple.com/kb/SP709)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP709/SP709-space_gray.jpeg)
        case iPadMini3
        /// Device is an [iPad Mini 4](https://support.apple.com/kb/SP725)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP725/SP725ipad-mini-4.png)
        case iPadMini4
        /// Device is an [iPad Mini (5th generation)](https://support.apple.com/kb/SP788)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP788/ipad-mini-2019.jpg)
        case iPadMini5
        /// Device is an [iPad Mini (6th generation)](https://support.apple.com/kb/SP850)
        ///
        /// ![Image](https://km.support.apple.com/resources/sites/APPLE/content/live/IMAGES/1000/IM1097/en_US/ipad-mini-6gen-240.png)
        case iPadMini6
        /// Device is an [iPad Pro 9.7-inch](https://support.apple.com/kb/SP739)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP739/SP739.png)
        case iPadPro9Inch
        /// Device is an [iPad Pro 12-inch](https://support.apple.com/kb/SP723)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP723/SP723-iPad_Pro_2x.png)
        case iPadPro12Inch
        /// Device is an [iPad Pro 12-inch (2nd generation)](https://support.apple.com/kb/SP761)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP761/ipad-pro-12in-hero-201706.png)
        case iPadPro12Inch2
        /// Device is an [iPad Pro 10.5-inch](https://support.apple.com/kb/SP762)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP761/ipad-pro-10in-hero-201706.png)
        case iPadPro10Inch
        /// Device is an [iPad Pro 11-inch](https://support.apple.com/kb/SP784)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP784/ipad-pro-11-2018_2x.png)
        case iPadPro11Inch
        /// Device is an [iPad Pro 12.9-inch (3rd generation)](https://support.apple.com/kb/SP785)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP785/ipad-pro-12-2018_2x.png)
        case iPadPro12Inch3
        /// Device is an [iPad Pro 11-inch (2nd generation)](https://support.apple.com/kb/SP814)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP814/ipad-pro-11-2020.jpeg)
        case iPadPro11Inch2
        /// Device is an [iPad Pro 12.9-inch (4th generation)](https://support.apple.com/kb/SP815)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP815/ipad-pro-12-2020.jpeg)
        case iPadPro12Inch4
        /// Device is an [iPad Pro 11-inch (3rd generation)](https://support.apple.com/kb/SP843)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP843/ipad-pro-11_2x.png)
        case iPadPro11Inch3
        /// Device is an [iPad Pro 12.9-inch (5th generation)](https://support.apple.com/kb/SP844)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP844/ipad-pro-12-9_2x.png)
        case iPadPro12Inch5
        /// Device is an [iPad Pro 11-inch (4th generation)](https://support.apple.com/kb/SP882)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP843/TODO.png)
        case iPadPro11Inch4
        /// Device is an [iPad Pro 12.9-inch (6th generation)](https://support.apple.com/kb/SP883)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP844/TODO.png)
        case iPadPro12Inch6
        /// Device is an [iPad Pro 11-inch (M4)](https://support.apple.com/en-us/119892)
        ///
        /// ![Image](https://cdsassets.apple.com/content/services/pub/image?productid=301031&size=240x240)
        case iPadPro11M4
        /// Device is an [iPad Pro 13-inch (M4)](https://support.apple.com/en-us/119891)
        ///
        /// ![Image](https://cdsassets.apple.com/content/services/pub/image?productid=301033&size=240x240)
        case iPadPro13M4
        /// Device is a [HomePod](https://support.apple.com/kb/SP773)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP773/homepod_space_gray_large_2x.jpg)
        case homePod
        #elseif os(tvOS)
        /// Device is an [Apple TV HD](https://support.apple.com/kb/SP724) (Previously Apple TV (4th generation))
        ///
        /// ![Image](http://images.apple.com/v/tv/c/images/overview/buy_tv_large_2x.jpg)
        case appleTVHD
        /// Device is an [Apple TV 4K](https://support.apple.com/kb/SP769)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP769/appletv4k.png)
        case appleTV4K
        /// Device is an [Apple TV 4K (2nd generation)](https://support.apple.com/kb/SP845)
        ///
        /// ![Image](https://km.support.apple.com/resources/sites/APPLE/content/live/IMAGES/1000/IM1023/en_US/apple-tv-4k-2gen-240.png)
        case appleTV4K2
        /// Device is an [Apple TV 4K (3rd generation)](https://support.apple.com/kb/TODO)
        ///
        /// ![Image](https://km.support.apple.com/resources/sites/APPLE/content/live/IMAGES/1000/IM1023/en_US/TODO.png)
        case appleTV4K3
        #elseif os(watchOS)
        /// Device is an [Apple Watch (1st generation)](https://support.apple.com/kb/SP735)
        ///
        /// ![Image](https://km.support.apple.com/resources/sites/APPLE/content/live/IMAGES/0/IM784/en_US/apple_watch_sport-240.png)
        case appleWatchSeries0_38mm
        /// Device is an [Apple Watch (1st generation)](https://support.apple.com/kb/SP735)
        ///
        /// ![Image](https://km.support.apple.com/resources/sites/APPLE/content/live/IMAGES/0/IM784/en_US/apple_watch_sport-240.png)
        case appleWatchSeries0_42mm
        /// Device is an [Apple Watch Series 1](https://support.apple.com/kb/SP745)
        ///
        /// ![Image](https://km.support.apple.com/resources/sites/APPLE/content/live/IMAGES/0/IM848/en_US/applewatch-series2-aluminum-temp-240.png)
        case appleWatchSeries1_38mm
        /// Device is an [Apple Watch Series 1](https://support.apple.com/kb/SP745)
        ///
        /// ![Image](https://km.support.apple.com/resources/sites/APPLE/content/live/IMAGES/0/IM848/en_US/applewatch-series2-aluminum-temp-240.png)
        case appleWatchSeries1_42mm
        /// Device is an [Apple Watch Series 2](https://support.apple.com/kb/SP746)
        ///
        /// ![Image](https://km.support.apple.com/resources/sites/APPLE/content/live/IMAGES/0/IM852/en_US/applewatch-series2-hermes-240.png)
        case appleWatchSeries2_38mm
        /// Device is an [Apple Watch Series 2](https://support.apple.com/kb/SP746)
        ///
        /// ![Image](https://km.support.apple.com/resources/sites/APPLE/content/live/IMAGES/0/IM852/en_US/applewatch-series2-hermes-240.png)
        case appleWatchSeries2_42mm
        /// Device is an [Apple Watch Series 3](https://support.apple.com/kb/SP766)
        ///
        /// ![Image](https://km.support.apple.com/resources/sites/APPLE/content/live/IMAGES/0/IM893/en_US/apple-watch-s3-nikeplus-240.png)
        case appleWatchSeries3_38mm
        /// Device is an [Apple Watch Series 3](https://support.apple.com/kb/SP766)
        ///
        /// ![Image](https://km.support.apple.com/resources/sites/APPLE/content/live/IMAGES/0/IM893/en_US/apple-watch-s3-nikeplus-240.png)
        case appleWatchSeries3_42mm
        /// Device is an [Apple Watch Series 4](https://support.apple.com/kb/SP778)
        ///
        /// ![Image](https://km.support.apple.com/resources/sites/APPLE/content/live/IMAGES/0/IM911/en_US/aw-series4-nike-240.png)
        case appleWatchSeries4_40mm
        /// Device is an [Apple Watch Series 4](https://support.apple.com/kb/SP778)
        ///
        /// ![Image](https://km.support.apple.com/resources/sites/APPLE/content/live/IMAGES/0/IM911/en_US/aw-series4-nike-240.png)
        case appleWatchSeries4_44mm
        /// Device is an [Apple Watch Series 5](https://support.apple.com/kb/SP808)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP808/sp808-apple-watch-series-5_2x.png)
        case appleWatchSeries5_40mm
        /// Device is an [Apple Watch Series 5](https://support.apple.com/kb/SP808)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP808/sp808-apple-watch-series-5_2x.png)
        case appleWatchSeries5_44mm
        /// Device is an [Apple Watch Series 6](https://support.apple.com/kb/SP826)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP826/sp826-apple-watch-series6-580_2x.png)
        case appleWatchSeries6_40mm
        /// Device is an [Apple Watch Series 6](https://support.apple.com/kb/SP826)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP826/sp826-apple-watch-series6-580_2x.png)
        case appleWatchSeries6_44mm
        /// Device is an [Apple Watch SE](https://support.apple.com/kb/SP827)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP827/sp827-apple-watch-se-580_2x.png)
        case appleWatchSE_40mm
        /// Device is an [Apple Watch SE](https://support.apple.com/kb/SP827)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP827/sp827-apple-watch-se-580_2x.png)
        case appleWatchSE_44mm
        /// Device is an [Apple Watch Series 7](https://support.apple.com/kb/SP860)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP860/series7-480_2x.png)
        case appleWatchSeries7_41mm
        /// Device is an [Apple Watch Series 7](https://support.apple.com/kb/SP860)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP860/series7-480_2x.png)
        case appleWatchSeries7_45mm
        /// Device is an [Apple Watch Series 8](https://support.apple.com/kb/SP878)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP860/TODO)
        case appleWatchSeries8_41mm
        /// Device is an [Apple Watch Series 8](https://support.apple.com/kb/SP878)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP860/TODO)
        case appleWatchSeries8_45mm
        /// Device is an [Apple Watch SE (2nd generation)](https://support.apple.com/kb/SP877)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP827/TODO)
        case appleWatchSE2_40mm
        /// Device is an [Apple Watch SE (2nd generation)](https://support.apple.com/kb/SP877)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP827/TODO)
        case appleWatchSE2_44mm
        /// Device is an [Apple Watch Ultra](https://support.apple.com/kb/SP879)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP827/TODO)
        case appleWatchUltra
        #elseif os(visionOS)
        case appleVisionPro
        #endif
        
        /// Device is [Simulator](https://developer.apple.com/library/ios/documentation/IDEs/Conceptual/iOS_Simulator_Guide/Introduction/Introduction.html)
        ///
        /// ![Image](https://developer.apple.com/assets/elements/icons/256x256/xcode-6.png)
        indirect case simulator(Name)
        
        /// Device is not yet known (implemented)
        /// You can still use this enum as before but the description equals the identifier (you can get multiple identifiers for the same product class
        /// (e.g. "iPhone6,1" or "iPhone 6,2" do both mean "iPhone 5s"))
        case unknown(String)
    }
}

public extension Reer where Base: UIDevice {
    
    /// ReerKit: Get current device's os version.
    static var osVersion: String {
        return UIDevice.current.systemVersion
    }
    
    /// ReerKit: Get current device's os version number.
    static var osVersionNumber: Float {
        return (UIDevice.current.systemVersion as NSString).floatValue
    }
    
    /// ReerKit: Get current device's current language.
    static var currentLanguage: String {
        if #available(macOS 13, iOS 16, tvOS 16, watchOS 9, *) {
            return Locale.preferredLanguages.first ?? Locale.current.language.languageCode?.identifier ?? "en"
        } else {
            return Locale.preferredLanguages.first ?? Locale.current.languageCode ?? "en"
        }
    }
    
    /// ReerKit: Whether the device is iPhone or iPod touch.
    static var isPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
    /// ReerKit: Whether the device is iPad/iPad mini.
    static var isPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    /// ReerKit: Whether the device is Mac.
    static var isMac: Bool {
        if #available(iOS 14.0, tvOS 14.0, *) {
            return UIDevice.current.userInterfaceIdiom == .mac
        } else {
            return false
        }
    }
    
    /// ReerKit: Whether the device is Apple TV.
    static var isTV: Bool {
        return UIDevice.current.userInterfaceIdiom == .tv
    }
    
    /// ReerKit: Whether the device is Vision Pro.
    static var isVision: Bool {
        if #available(iOS 17.0, tvOS 17.0, *) {
            return UIDevice.current.userInterfaceIdiom == .vision
        } else {
            return false
        }
    }
    
    /// ReerKit: Whether the device is a simulator.
    static var isSimulator: Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }
    
    /// ReerKit: Whether the device is jailbroken.
    static var isJailbroken: Bool {
        if self.isSimulator {
            return false
        }
        
        let paths = [
            "/Applications/Cydia.app",
            "/private/var/lib/apt/",
            "/private/var/lib/cydia",
            "/private/var/stash"
        ]
        for path in paths {
            if FileManager.default.fileExists(atPath: path) {
                return true
            }
        }
        
        let bash = fopen("/bin/bash", "r")
        if bash != nil {
            fclose(bash)
            return true
        }
        
        let path = "/private/" + String.re.random(ofLength: 21)
        do {
            try "test".write(toFile: path, atomically: true, encoding: .utf8)
            try? FileManager.default.removeItem(atPath: path)
            return true
        } catch _ {
            
        }
        
        return false
    }
    
    /// ReerKit: Wherher the device can make phone calls.
    static var canMakePhoneCalls: Bool {
        return UIApplication.shared.canOpenURL(URL(string: "tel://")!)
    }

    #if canImport(Darwin)
    /// ReerKit: WIFI IP address of this device (can be nil). e.g. @"192.168.1.111"
    static var ipAddressWIFI: String? {
        return ipAddress(withIfaName: "en0")
    }
    
    /// ReerKit: Cell IP address of this device (can be nil). e.g. @"10.2.2.222"
    static var ipAddressCell: String? {
        return ipAddress(withIfaName: "pdp_ip0")
    }
    #endif
    
    #if os(iOS)
    static var isRectangularScreen: Bool {
        switch modelName {
        case .iPodTouch5, .iPodTouch6, .iPodTouch7, .iPhone4, .iPhone4s, .iPhone5, .iPhone5c, .iPhone5s, .iPhone6, .iPhone6Plus, .iPhone6s, .iPhone6sPlus, .iPhone7, .iPhone7Plus, .iPhoneSE, .iPhone8, .iPhone8Plus, .iPhoneSE2, .iPhoneSE3:
            return true
        default:
            return false
        }
    }
    
    static var isNotchScreen: Bool {
        switch modelName {
        case .iPhoneX, .iPhoneXS, .iPhoneXSMax,
             .iPhoneXR, .iPhone11, .iPhone11Pro, .iPhone11ProMax,
             .iPhone12, .iPhone12Mini, .iPhone12Pro, .iPhone12ProMax,
             .iPhone13, .iPhone13Mini, .iPhone13Pro, .iPhone13ProMax,
             .iPhone14, .iPhone14Plus:
            return true
        default:
            return false
        }
    }
    
    static var isDynamicIslandScreen: Bool {
        switch modelName {
        case .iPhone14Pro, .iPhone14ProMax, .iPhone15, .iPhone15Plus, .iPhone15Pro, .iPhone15ProMax:
            return true
        default:
            return false
        }
    }
    #endif
    
    /// ReerKit: The device's hardware machine id.  e.g. "iPhone6,1" "iPad4,6"
    ///
    /// [reference](http://theiphonewiki.com/wiki/Models)
    static var machineModelIdentifier: String {
        return sysctl(by: "hw.machine")
    }
    
    /// ReerKit: The device's machine model internal name.  e.g. "D83AP" "D16AP"
    static var machineModelName: String {
        return sysctl(by: "hw.model")
    }
    
    /// ReerKit: Get product model name of the device. e.g `.iPhone13ProMax`
    /// or get string version `UIDevice.current.re.modelName.description` -> "iPhone13 Pro Max"
    static var modelName: UIDevice.Name {
        return getName(ofMachineModel: machineModelIdentifier)
    }
    
    private static func getName(ofMachineModel modelIdentifier: String) -> UIDevice.Name {
        #if os(iOS)
        switch modelIdentifier {
        case "iPod5,1": return .iPodTouch5
        case "iPod7,1": return .iPodTouch6
        case "iPod9,1": return .iPodTouch7
        case "iPhone3,1", "iPhone3,2", "iPhone3,3": return .iPhone4
        case "iPhone4,1": return .iPhone4s
        case "iPhone5,1", "iPhone5,2": return .iPhone5
        case "iPhone5,3", "iPhone5,4": return .iPhone5c
        case "iPhone6,1", "iPhone6,2": return .iPhone5s
        case "iPhone7,2": return .iPhone6
        case "iPhone7,1": return .iPhone6Plus
        case "iPhone8,1": return .iPhone6s
        case "iPhone8,2": return .iPhone6sPlus
        case "iPhone9,1", "iPhone9,3": return .iPhone7
        case "iPhone9,2", "iPhone9,4": return .iPhone7Plus
        case "iPhone8,4": return .iPhoneSE
        case "iPhone10,1", "iPhone10,4": return .iPhone8
        case "iPhone10,2", "iPhone10,5": return .iPhone8Plus
        case "iPhone10,3", "iPhone10,6": return .iPhoneX
        case "iPhone11,2": return .iPhoneXS
        case "iPhone11,4", "iPhone11,6": return .iPhoneXSMax
        case "iPhone11,8": return .iPhoneXR
        case "iPhone12,1": return .iPhone11
        case "iPhone12,3": return .iPhone11Pro
        case "iPhone12,5": return .iPhone11ProMax
        case "iPhone12,8": return .iPhoneSE2
        case "iPhone13,2": return .iPhone12
        case "iPhone13,1": return .iPhone12Mini
        case "iPhone13,3": return .iPhone12Pro
        case "iPhone13,4": return .iPhone12ProMax
        case "iPhone14,5": return .iPhone13
        case "iPhone14,4": return .iPhone13Mini
        case "iPhone14,2": return .iPhone13Pro
        case "iPhone14,3": return .iPhone13ProMax
        case "iPhone14,6": return .iPhoneSE3
        case "iPhone14,7": return .iPhone14
        case "iPhone14,8": return .iPhone14Plus
        case "iPhone15,2": return .iPhone14Pro
        case "iPhone15,3": return .iPhone14ProMax
        case "iPhone15,4": return .iPhone15
        case "iPhone15,5": return .iPhone15Plus
        case "iPhone16,1": return .iPhone15Pro
        case "iPhone16,2": return .iPhone15ProMax
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4": return .iPad2
        case "iPad3,1", "iPad3,2", "iPad3,3": return .iPad3
        case "iPad3,4", "iPad3,5", "iPad3,6": return .iPad4
        case "iPad4,1", "iPad4,2", "iPad4,3": return .iPadAir
        case "iPad5,3", "iPad5,4": return .iPadAir2
        case "iPad6,11", "iPad6,12": return .iPad5
        case "iPad7,5", "iPad7,6": return .iPad6
        case "iPad11,3", "iPad11,4": return .iPadAir3
        case "iPad7,11", "iPad7,12": return .iPad7
        case "iPad11,6", "iPad11,7": return .iPad8
        case "iPad12,1", "iPad12,2": return .iPad9
        case "iPad13,18", "iPad13,19": return .iPad10
        case "iPad13,1", "iPad13,2": return .iPadAir4
        case "iPad13,16", "iPad13,17": return .iPadAir5
        case "iPad2,5", "iPad2,6", "iPad2,7": return .iPadMini
        case "iPad4,4", "iPad4,5", "iPad4,6": return .iPadMini2
        case "iPad4,7", "iPad4,8", "iPad4,9": return .iPadMini3
        case "iPad5,1", "iPad5,2": return .iPadMini4
        case "iPad11,1", "iPad11,2": return .iPadMini5
        case "iPad14,1", "iPad14,2": return .iPadMini6
        case "iPad6,3", "iPad6,4": return .iPadPro9Inch
        case "iPad6,7", "iPad6,8": return .iPadPro12Inch
        case "iPad7,1", "iPad7,2": return .iPadPro12Inch2
        case "iPad7,3", "iPad7,4": return .iPadPro10Inch
        case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4": return .iPadPro11Inch
        case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8": return .iPadPro12Inch3
        case "iPad8,9", "iPad8,10": return .iPadPro11Inch2
        case "iPad8,11", "iPad8,12": return .iPadPro12Inch4
        case "iPad13,4", "iPad13,5", "iPad13,6", "iPad13,7": return .iPadPro11Inch3
        case "iPad13,8", "iPad13,9", "iPad13,10", "iPad13,11": return .iPadPro12Inch5
        case "iPad14,3", "iPad14,4": return .iPadPro11Inch4
        case "iPad14,5", "iPad14,6": return .iPadPro12Inch6
        case "iPad16,3", "iPad16,4": return .iPadPro11M4
        case "iPad16,5", "iPad16,6": return .iPadPro13M4
        case "AudioAccessory1,1": return .homePod
        case "i386", "x86_64", "arm64": return .simulator(getName(ofMachineModel: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))
        default: return .unknown(machineModelIdentifier)
        }
        #elseif os(tvOS)
        switch modelIdentifier {
        case "AppleTV5,3": return .appleTVHD
        case "AppleTV6,2": return .appleTV4K
        case "AppleTV11,1": return .appleTV4K2
        case "AppleTV14,1": return .appleTV4K3
        case "i386", "x86_64", "arm64": return .simulator(getName(ofMachineModel: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))
        default: return .unknown(machineModelIdentifier)
        }
        #elseif os(watchOS)
        switch modelIdentifier {
        case "Watch1,1": return .appleWatchSeries0_38mm
        case "Watch1,2": return .appleWatchSeries0_42mm
        case "Watch2,6": return .appleWatchSeries1_38mm
        case "Watch2,7": return .appleWatchSeries1_42mm
        case "Watch2,3": return .appleWatchSeries2_38mm
        case "Watch2,4": return .appleWatchSeries2_42mm
        case "Watch3,1", "Watch3,3": return .appleWatchSeries3_38mm
        case "Watch3,2", "Watch3,4": return .appleWatchSeries3_42mm
        case "Watch4,1", "Watch4,3": return .appleWatchSeries4_40mm
        case "Watch4,2", "Watch4,4": return .appleWatchSeries4_44mm
        case "Watch5,1", "Watch5,3": return .appleWatchSeries5_40mm
        case "Watch5,2", "Watch5,4": return .appleWatchSeries5_44mm
        case "Watch6,1", "Watch6,3": return .appleWatchSeries6_40mm
        case "Watch6,2", "Watch6,4": return .appleWatchSeries6_44mm
        case "Watch5,9", "Watch5,11": return .appleWatchSE_40mm
        case "Watch5,10", "Watch5,12": return .appleWatchSE_44mm
        case "Watch6,6", "Watch6,8": return .appleWatchSeries7_41mm
        case "Watch6,7", "Watch6,9": return .appleWatchSeries7_45mm
        case "Watch6,14", "Watch6,16": return .appleWatchSeries8_41mm
        case "Watch6,15", "Watch6,17": return .appleWatchSeries8_45mm
        case "Watch6,10", "Watch6,12": return .appleWatchSE2_40mm
        case "Watch6,11", "Watch6,13": return .appleWatchSE2_44mm
        case "Watch6,18": return .appleWatchUltra
        case "i386", "x86_64", "arm64": return .simulator(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "watchOS"))
        default: return .unknown(identifier)
        }
        #elseif os(visionOS)
        switch modelIdentifier {
        case "i386", "x86_64", "arm64": return .simulator(.appleVisionPro)
        default: return .appleVisionPro
        }
        #endif
    }
    
    /// ReerKit: Mount id
    static var mntID: String {
        var buf = statfs()
        if statfs("/", &buf) == 0 {
            let prefix = "com.apple.os.update-"
            let cChars = Mirror(reflecting: buf.f_mntfromname).children.compactMap { $0.value as? CChar }
            let mntfromname = cChars.reduce("") { $0 + String(format: "%c", UInt8(bitPattern: $1)) }
            if mntfromname.contains(prefix) {
                let index = mntfromname.index(mntfromname.startIndex, offsetBy: prefix.count)
                let id = String(mntfromname[index...])
                return id
            }
        }
        return ""
    }
    
    /// ReerKit: Total disk space in byte. (-1 when error occurs)
    static var diskSpace: Int64 {
        do {
            let attrs = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())
            var space = attrs[.systemSize] as! Int64
            if space < 0 {
                space = -1
            }
            return space
        } catch _ {
            return -1
        }
    }
    
    /// ReerKit: Free disk space in byte. (-1 when error occurs)
    static var diskSpaceFree: Int64 {
        do {
            let attrs = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())
            var space = attrs[.systemFreeSize] as! Int64
            if space < 0 {
                space = -1
            }
            return space
        } catch _ {
            return -1
        }
    }
    
    /// ReerKit: Used disk space in byte. (-1 when error occurs)
    static var diskSpaceUsed: Int64 {
        let total = diskSpace
        let free = diskSpaceFree
        if total < 0 || free < 0 {
            return -1
        }
        var used = total - free
        if used < 0 {
            used = -1
        }
        return used
    }
    
    /// ReerKit: Total physical memory in byte. (-1 when error occurs)
    static var memoryTotal: Int64 {
        let mem = ProcessInfo.processInfo.physicalMemory
        guard mem > 0 else {
            return -1
        }
        return Int64(mem)
    }
    
    #if canImport(Darwin)
    /// ReerKit: Used app memory and total memory
    ///
    /// [Reference](https://github.com/zixun/SystemEye/blob/master/SystemEye/Classes/Memory.swift)
    static var appMemoryUsage: (used: Int64, total: Int64) {
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout.size(ofValue: info) / MemoryLayout<integer_t>.size)
        let kerr = withUnsafeMutablePointer(to: &info) {
            return $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                return task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
            }
        }
        guard kerr == KERN_SUCCESS else {
            return (0, self.memoryTotal)
        }
        
        return (Int64(info.resident_size), self.memoryTotal)
    }

    /// ReerKit: System memory usage
    static var systemMemoryUsage: (
        free: Int64,
        active: Int64,
        inactive: Int64,
        wired: Int64,
        compressed: Int64,
        purgable: Int64,
        total: Int64
    ) {
        var statistics: vm_statistics64 {
            var size = HOST_VM_INFO64_COUNT
            var hostInfo = vm_statistics64()
            let result = withUnsafeMutablePointer(to: &hostInfo) {
                $0.withMemoryRebound(to: integer_t.self, capacity: Int(size)) {
                    host_statistics64(mach_host_self(), HOST_VM_INFO64, $0, &size)
                }
            }
            #if DEBUG
            if result != KERN_SUCCESS {
                print("ERROR - \(#file):\(#function) - kern_result_t = "
                      + "\(result)")
            }
            #endif
            return hostInfo
        }
        
        let free = Double(statistics.free_count) * PAGE_SIZE
        let active = Double(statistics.active_count) * PAGE_SIZE
        let inactive = Double(statistics.inactive_count) * PAGE_SIZE
        let wired = Double(statistics.wire_count) * PAGE_SIZE
        let compressed = Double(statistics.compressor_page_count) * PAGE_SIZE
        let purgable = Double(statistics.purgeable_count) * PAGE_SIZE
        return (
            Int64(free),
            Int64(active),
            Int64(inactive),
            Int64(wired),
            Int64(compressed),
            Int64(purgable),
            memoryTotal
        )
    }
    
    /// ReerKit: App CPU usage
    static var appCPUUsage: Double {
        let threads = UIDevice.re.threadBasicInfos()
        var result : Double = 0.0
        threads.forEach { (thread: thread_basic_info) in
            if UIDevice.re.flag(thread) {
                result += Double.init(thread.cpu_usage) / Double.init(TH_USAGE_SCALE);
            }
        }
        return result * 100
    }
    
    /// ReerKit: System CPU usage
    static var systemCPUUsage: (
        system: Double,
        user: Double,
        idle: Double,
        nice: Double
    ) {
        let load = UIDevice.re.hostCPULoadInfo
        
        let userDiff = Double(load.cpu_ticks.0 - UIDevice.loadPrevious.cpu_ticks.0)
        let sysDiff  = Double(load.cpu_ticks.1 - UIDevice.loadPrevious.cpu_ticks.1)
        let idleDiff = Double(load.cpu_ticks.2 - UIDevice.loadPrevious.cpu_ticks.2)
        let niceDiff = Double(load.cpu_ticks.3 - UIDevice.loadPrevious.cpu_ticks.3)
        
        let totalTicks = sysDiff + userDiff + niceDiff + idleDiff
        
        let sys  = sysDiff  / totalTicks * 100.0
        let user = userDiff / totalTicks * 100.0
        let idle = idleDiff / totalTicks * 100.0
        let nice = niceDiff / totalTicks * 100.0
        
        UIDevice.loadPrevious = load
        return (sys, user, idle, nice)
    }
    
    private static var hostCPULoadInfo: host_cpu_load_info {
        get {
            var size     = HOST_CPU_LOAD_INFO_COUNT
            var hostInfo = host_cpu_load_info()
            let result = withUnsafeMutablePointer(to: &hostInfo) {
                $0.withMemoryRebound(to: integer_t.self, capacity: Int(size)) {
                    host_statistics(mach_host_self(), HOST_CPU_LOAD_INFO, $0, &size)
                }
            }
            
            #if DEBUG
            if result != KERN_SUCCESS {
                fatalError("ERROR - \(#file):\(#function) - kern_result_t = "
                    + "\(result)")
            }
            #endif
            
            return hostInfo
        }
    }
    #endif
}

extension Reer where Base: UIDevice {
    #if canImport(Darwin)
    // https://stackoverflow.com/questions/30748480/swift-get-devices-ip-address/30748582
    private static func ipAddress(withIfaName ifaName: String) -> String? {
        if ifaName.count == 0 { return nil }
        var address: String?
        
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else {
            return nil
        }
        guard let firstAddr = ifaddr else {
            return nil
        }
        
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                
                let name = String(cString: interface.ifa_name)
                if name == ifaName {
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(
                        interface.ifa_addr,
                        socklen_t(interface.ifa_addr.pointee.sa_len),
                        &hostname,
                        socklen_t(hostname.count),
                        nil,
                        socklen_t(0),
                        NI_NUMERICHOST
                    )
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        
        return address
    }
    
    private static func flag(_ thread: thread_basic_info) -> Bool {
        let foo = thread.flags & TH_FLAGS_IDLE
        let number = NSNumber.init(value: foo)
        return !Bool.init(truncating: number)
    }
    
    private static func threadBasicInfos() -> [thread_basic_info]  {
        var result: [thread_basic_info] = []
        
        var thinfo : thread_info_t = thread_info_t.allocate(capacity: Int(THREAD_INFO_MAX))
        let thread_info_count = UnsafeMutablePointer<mach_msg_type_number_t>.allocate(capacity: 128)
        let count: Int = MemoryLayout<thread_basic_info_data_t>.size / MemoryLayout<integer_t>.size
        for act_t in threadActPointers() {
            thread_info_count.pointee = UInt32(THREAD_INFO_MAX);
            let kr = thread_info(act_t ,thread_flavor_t(THREAD_BASIC_INFO),thinfo, thread_info_count);
            if (kr != KERN_SUCCESS) {
                return [thread_basic_info]();
            }
            
            let th_basic_info = withUnsafePointer(to: &thinfo, {
                return $0.withMemoryRebound(to: thread_basic_info_t.self, capacity: count, {
                    return $0.pointee
                })
            }).pointee
            
            result.append(th_basic_info)
        }
        return result
    }
    
    private static func threadActPointers() -> [thread_act_t] {
        var threads_act: [thread_act_t] = []
        
        var threads_array: thread_act_array_t? = nil
        var count = mach_msg_type_number_t()
        
        let result = task_threads(mach_task_self_, &(threads_array), &count)
        
        guard result == KERN_SUCCESS else {
            return threads_act
        }
        
        guard let array = threads_array  else {
            return threads_act
        }
        
        for i in 0..<count {
            threads_act.append(array[Int(i)])
        }
        
        let krsize = count * UInt32.init(MemoryLayout<thread_t>.size)
        _ = vm_deallocate(mach_task_self_, vm_address_t(array.pointee), vm_size_t(krsize));
        return threads_act
    }
    #endif
}

extension UIDevice {
    fileprivate static var loadPrevious = host_cpu_load_info()
}

extension UIDevice.Name: CustomStringConvertible {
    
    /// A textual representation of the device.
    public var description: String {
        #if os(iOS)
        switch self {
        case .iPodTouch5: return "iPod touch (5th generation)"
        case .iPodTouch6: return "iPod touch (6th generation)"
        case .iPodTouch7: return "iPod touch (7th generation)"
        case .iPhone4: return "iPhone 4"
        case .iPhone4s: return "iPhone 4s"
        case .iPhone5: return "iPhone 5"
        case .iPhone5c: return "iPhone 5c"
        case .iPhone5s: return "iPhone 5s"
        case .iPhone6: return "iPhone 6"
        case .iPhone6Plus: return "iPhone 6 Plus"
        case .iPhone6s: return "iPhone 6s"
        case .iPhone6sPlus: return "iPhone 6s Plus"
        case .iPhone7: return "iPhone 7"
        case .iPhone7Plus: return "iPhone 7 Plus"
        case .iPhoneSE: return "iPhone SE"
        case .iPhone8: return "iPhone 8"
        case .iPhone8Plus: return "iPhone 8 Plus"
        case .iPhoneX: return "iPhone X"
        case .iPhoneXS: return "iPhone Xs"
        case .iPhoneXSMax: return "iPhone Xs Max"
        case .iPhoneXR: return "iPhone Xʀ"
        case .iPhone11: return "iPhone 11"
        case .iPhone11Pro: return "iPhone 11 Pro"
        case .iPhone11ProMax: return "iPhone 11 Pro Max"
        case .iPhoneSE2: return "iPhone SE (2nd generation)"
        case .iPhone12: return "iPhone 12"
        case .iPhone12Mini: return "iPhone 12 mini"
        case .iPhone12Pro: return "iPhone 12 Pro"
        case .iPhone12ProMax: return "iPhone 12 Pro Max"
        case .iPhone13: return "iPhone 13"
        case .iPhone13Mini: return "iPhone 13 mini"
        case .iPhone13Pro: return "iPhone 13 Pro"
        case .iPhone13ProMax: return "iPhone 13 Pro Max"
        case .iPhoneSE3: return "iPhone SE (3rd generation)"
        case .iPhone14: return "iPhone 14"
        case .iPhone14Plus: return "iPhone 14 Plus"
        case .iPhone14Pro: return "iPhone 14 Pro"
        case .iPhone14ProMax: return "iPhone 14 Pro Max"
        case .iPhone15: return "iPhone 15"
        case .iPhone15Plus: return "iPhone 15 Plus"
        case .iPhone15Pro: return "iPhone 15 Pro"
        case .iPhone15ProMax: return "iPhone 15 Pro Max"
        case .iPad2: return "iPad 2"
        case .iPad3: return "iPad (3rd generation)"
        case .iPad4: return "iPad (4th generation)"
        case .iPadAir: return "iPad Air"
        case .iPadAir2: return "iPad Air 2"
        case .iPad5: return "iPad (5th generation)"
        case .iPad6: return "iPad (6th generation)"
        case .iPadAir3: return "iPad Air (3rd generation)"
        case .iPad7: return "iPad (7th generation)"
        case .iPad8: return "iPad (8th generation)"
        case .iPad9: return "iPad (9th generation)"
        case .iPad10: return "iPad (10th generation)"
        case .iPadAir4: return "iPad Air (4th generation)"
        case .iPadAir5: return "iPad Air (5th generation)"
        case .iPadMini: return "iPad Mini"
        case .iPadMini2: return "iPad Mini 2"
        case .iPadMini3: return "iPad Mini 3"
        case .iPadMini4: return "iPad Mini 4"
        case .iPadMini5: return "iPad Mini (5th generation)"
        case .iPadMini6: return "iPad Mini (6th generation)"
        case .iPadPro9Inch: return "iPad Pro (9.7-inch)"
        case .iPadPro12Inch: return "iPad Pro (12.9-inch)"
        case .iPadPro12Inch2: return "iPad Pro (12.9-inch) (2nd generation)"
        case .iPadPro10Inch: return "iPad Pro (10.5-inch)"
        case .iPadPro11Inch: return "iPad Pro (11-inch)"
        case .iPadPro12Inch3: return "iPad Pro (12.9-inch) (3rd generation)"
        case .iPadPro11Inch2: return "iPad Pro (11-inch) (2nd generation)"
        case .iPadPro12Inch4: return "iPad Pro (12.9-inch) (4th generation)"
        case .iPadPro11Inch3: return "iPad Pro (11-inch) (3rd generation)"
        case .iPadPro12Inch5: return "iPad Pro (12.9-inch) (5th generation)"
        case .iPadPro11Inch4: return "iPad Pro (11-inch) (4th generation)"
        case .iPadPro12Inch6: return "iPad Pro (12.9-inch) (6th generation)"
        case .iPadPro11M4: return "iPad Pro (11-inch) (M4)"
        case .iPadPro13M4: return "iPad Pro (13-inch) (M4)"
        case .homePod: return "HomePod"
        case .simulator(let model): return "Simulator (\(model.description))"
        case .unknown(let identifier): return identifier
        }
        #elseif os(watchOS)
        switch self {
        case .appleWatchSeries0_38mm: return "Apple Watch (1st generation) 38mm"
        case .appleWatchSeries0_42mm: return "Apple Watch (1st generation) 42mm"
        case .appleWatchSeries1_38mm: return "Apple Watch Series 1 38mm"
        case .appleWatchSeries1_42mm: return "Apple Watch Series 1 42mm"
        case .appleWatchSeries2_38mm: return "Apple Watch Series 2 38mm"
        case .appleWatchSeries2_42mm: return "Apple Watch Series 2 42mm"
        case .appleWatchSeries3_38mm: return "Apple Watch Series 3 38mm"
        case .appleWatchSeries3_42mm: return "Apple Watch Series 3 42mm"
        case .appleWatchSeries4_40mm: return "Apple Watch Series 4 40mm"
        case .appleWatchSeries4_44mm: return "Apple Watch Series 4 44mm"
        case .appleWatchSeries5_40mm: return "Apple Watch Series 5 40mm"
        case .appleWatchSeries5_44mm: return "Apple Watch Series 5 44mm"
        case .appleWatchSeries6_40mm: return "Apple Watch Series 6 40mm"
        case .appleWatchSeries6_44mm: return "Apple Watch Series 6 44mm"
        case .appleWatchSE_40mm: return "Apple Watch SE 40mm"
        case .appleWatchSE_44mm: return "Apple Watch SE 44mm"
        case .appleWatchSeries7_41mm: return "Apple Watch Series 7 41mm"
        case .appleWatchSeries7_45mm: return "Apple Watch Series 7 45mm"
        case .appleWatchSeries8_41mm: return "Apple Watch Series 8 41mm"
        case .appleWatchSeries8_45mm: return "Apple Watch Series 8 45mm"
        case .appleWatchSE2_40mm: return "Apple Watch SE (2nd generation) 40mm"
        case .appleWatchSE2_44mm: return "Apple Watch SE (2nd generation) 44mm"
        case .appleWatchUltra: return "Apple Watch Ultra"
        case .simulator(let model): return "Simulator (\(model.description))"
        case .unknown(let identifier): return identifier
        }
        #elseif os(tvOS)
        switch self {
        case .appleTVHD: return "Apple TV HD"
        case .appleTV4K: return "Apple TV 4K"
        case .appleTV4K2: return "Apple TV 4K (2nd generation)"
        case .appleTV4K3: return "Apple TV 4K (3rd generation)"
        case .simulator(let model): return "Simulator (\(model.description))"
        case .unknown(let identifier): return identifier
        }
        #elseif os(visionOS)
        switch self {
        case .appleVisionPro: return "Apple Vision Pro"
        case .simulator(let model): return "Simulator (\(model.description))"
        case .unknown(let identifier): return identifier
        }
        #endif
    }
}

private let HOST_VM_INFO64_COUNT: mach_msg_type_number_t =
    UInt32(MemoryLayout<vm_statistics64_data_t>.size / MemoryLayout<integer_t>.size)

private let PAGE_SIZE: Double = Double(vm_kernel_page_size)

private let HOST_CPU_LOAD_INFO_COUNT: mach_msg_type_number_t =
    UInt32(MemoryLayout<host_cpu_load_info_data_t>.size / MemoryLayout<integer_t>.size)


#endif
