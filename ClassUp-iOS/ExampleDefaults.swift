//
//  ExampleDefaults.swift
//  GraphLearning
//
//  Created by Atul Gupta on 10/04/16.
//  Copyright © 2016 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import Foundation

//
//  ExamplesDefaults.swift
//  SwiftCharts
//
//  Created by ischuetz on 04/05/15.
//  Copyright (c) 2015 ivanschuetz. All rights reserved.
//

import UIKit
import SwiftCharts

struct ExamplesDefaults {
    
    static var chartSettings: ChartSettings {
        if Env.iPad {
            return self.iPadChartSettings
        } else {
            return self.iPhoneChartSettings
        }
    }
    
    private static var iPadChartSettings: ChartSettings {
//        let chartSettings = ChartSettings()
//        chartSettings.leading = 20
//        chartSettings.top = 20
//        chartSettings.trailing = 20
//        chartSettings.bottom = 20
//        chartSettings.labelsToAxisSpacingX = 10
//        chartSettings.labelsToAxisSpacingY = 10
//        chartSettings.axisTitleLabelsToLabelsSpacing = 5
//        chartSettings.axisStrokeWidth = 1
//        chartSettings.spacingBetweenAxesX = 15
//        chartSettings.spacingBetweenAxesY = 15
        return chartSettings
    }
    
    private static var iPhoneChartSettings: ChartSettings {
        let chartSettings = ChartSettings()
        chartSettings.leading = 10
        chartSettings.top = 10
        chartSettings.trailing = 10
        chartSettings.bottom = -20
        chartSettings.labelsToAxisSpacingX = 5
        chartSettings.labelsToAxisSpacingY = 5
        chartSettings.axisTitleLabelsToLabelsSpacing = 4
        chartSettings.axisStrokeWidth = 0.2
        chartSettings.spacingBetweenAxesX = 4
        chartSettings.spacingBetweenAxesY = 4
        return chartSettings
    }
    
    static func chartFrame(containerBounds: CGRect) -> CGRect {
        // let us determine the device type and then assign height to the chart view
        var height: CGFloat = 200
        
        let deviceType = UIDevice.current.model
        
        if deviceType.lowercased().range(of: "iphone 4") != nil {
            height = 180
        }
        else if deviceType.lowercased().range(of: "iphone 5") != nil {
            height = 250
        }
        else if deviceType.lowercased().range(of: "iphone 6") != nil {
            height = 350
        }
        return CGRect(x: 0, y: 0, width: 300, height: height)
        //return CGRectMake(0, 0, 300, height)
    }
    
    static var labelSettings: ChartLabelSettings {
        return ChartLabelSettings(font: ExamplesDefaults.labelFont)
    }
    
    static var labelFont: UIFont {
        return ExamplesDefaults.fontWithSize(size: Env.iPad ? 14 : 11)
    }
    
    static var labelFontSmall: UIFont {
        return ExamplesDefaults.fontWithSize(size: Env.iPad ? 12 : 10)
    }
    
    static func fontWithSize(size: CGFloat) -> UIFont {
        return UIFont(name: "Helvetica", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static var guidelinesWidth: CGFloat {
        return Env.iPad ? 0.5 : 0.1
    }
    
    static var minBarSpacing: CGFloat {
        return Env.iPad ? 10 : 5
    }
}
