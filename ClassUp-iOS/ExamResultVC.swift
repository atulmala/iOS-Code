//
//  ExamResultVC.swift
//  ClassUp-iOS
//
//  Created by Atul Gupta on 27/03/16.
//  Copyright © 2016 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit
import SwiftCharts
import SwiftyJSON
import Just

class ExamResultVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private var chart: Chart? // arc
    
    struct ExamResultModel  {
        var subject: String = ""
        var max_marks: String = ""
        var marks_obtained: String = ""
    }
    
    @IBOutlet weak var container_view: UIView!
    
    var exam_result_list: [ExamResultModel] = []
    var subject_list: [String] = []
    var perc_list:[Double] = []
    
    var student_id: String = ""
    var student_full_name = ""
    var exam_id: String = ""
    var exam_title: String = ""
    
    @IBOutlet weak var title_label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        title_label.text = "\(exam_title) Results for \(student_full_name)"
        
        let server_ip: String = MiscFunction.getServerIP()
        let url: String = "\(server_ip)/parents/get_exam_result/\(student_id)/\(exam_id)/"
        
        let j = JSON(Just.get(url).json!)
        
        let count: Int? = j.count
        if (count! > 0)  {
            if let ct = count {
                for index in 0...ct-1 {
                    var em = ExamResultModel()
                    var max_marks: String = ""
                    var marks: String = ""
                    
                    if let _ = j[index]["max_marks"].string {
                        em.max_marks = max_marks
                        max_marks = j[index]["max_marks"].string!
                    }
                    if let _ = j[index]["max_marks"].int {
                        let name = j[index]["max_marks"]
                        let max_marks = String(stringInterpolationSegment: name)
                        em.max_marks = max_marks
                    }
                    
                   
                    
                    if let marks_obtained = j[index]["marks"].string    {
                        em.marks_obtained = marks_obtained
                    }
                    if let _ = j[index]["marks"].int {
                        let m = j[index]["marks"]
                        if m != -1000   {
                            marks = String(stringInterpolationSegment: m)
                            em.marks_obtained = marks
                        }
                        else{
                            marks = "ABS"
                            em.marks_obtained = "ABS"
                        }
                    }
                    if let _ = j[index]["marks"].float {
                        let m = j[index]["marks"]
                        if m != -1000   {
                            marks = String(stringInterpolationSegment: m)
                            em.marks_obtained = marks
                        }
                        else{
                            marks = "ABS"
                            em.marks_obtained = "ABS"
                        }
                    }
                    
                    
                    if let subject = j[index]["subject"].string {
                        em.subject = subject
                        
                        if max_marks != "Grade Based"  {
                            if marks != "ABS"   {
                            subject_list.append(subject)
                            }
                        }
                    }
                    exam_result_list.append(em)
                    
                    // update arrays for line graph
                    if max_marks != "Grade Based"     {
                        if marks != "ABS"   {
                        let nf = NumberFormatter()
                        let mo = nf.number(from: em.marks_obtained)?.floatValue
                        let mm = nf.number(from: em.max_marks)?.floatValue
                        let perc = round((mo!/mm!)*100)
                        perc_list.append(Double(perc))
                        }
                    }
                }
            }
        }
        
        // Now draw the bar chart
        let zero = MyPerc(number: 0, text: "0%")
        let ten = MyPerc(number: 10, text: "10%")
        let twenty = MyPerc(number: 20, text: "20%")
        let thirty = MyPerc(number: 30, text: "30%")
        let forty = MyPerc(number: 40, text: "40%")
        let fifty = MyPerc(number: 50, text: "50%")
        let sixty = MyPerc(number: 60, text: "60%")
        let seventy = MyPerc(number: 70, text: "70%")
        let eighty = MyPerc(number: 80, text: "80%")
        let ninty = MyPerc(number: 90, text: "90%")
        let hundred = MyPerc(number: 100, text: "100%")
        
        
        var ms: [MySubject] = []
        var bars = [(String, Double)]()
        for var i in 0..<subject_list.count {
            bars.append((subject_list[i], perc_list[i]))
            ms.append(MySubject(name: subject_list[i], perc: perc_list[i]))
        }

        let chartLabelSetting = ChartLabelSettings(font: ExamplesDefaults.labelFont, rotation: 45, rotationKeep: .top)
        let labelSettings = ChartLabelSettings(font: ExamplesDefaults.labelFont)
        
        let chartConfig = BarsChartConfig(
            valsAxisConfig: ChartAxisConfig(from: 0, to: 100, by: 10), xAxisLabelSettings: chartLabelSetting, yAxisLabelSettings:chartLabelSetting        )
        
        let chartPoints: [ChartPoint] = ms.enumerated().map {index, item in
            let xLabelSettings = ChartLabelSettings(font: ExamplesDefaults.labelFont, rotation: 45, rotationKeep: .top)
            let x = ChartAxisValueString(item.name, order: index, labelSettings: xLabelSettings)
            let y = ChartAxisValueString(item.perc, order: item.pct, labelSettings: labelSettings)
            return ChartPoint(x: x, y: y)
        }
        
        let xValues = [ChartAxisValueString("", order: -1)] + chartPoints.map{$0.x} + [ChartAxisValueString("", order: 6)]
        
        func toYValue(perc: MyPerc) -> ChartAxisValue {
            return ChartAxisValueString(perc.text, order: perc.number, labelSettings: labelSettings)
        }
        
        let yValues = [toYValue(perc: zero), toYValue(perc: ten), toYValue(perc: twenty), toYValue(perc: thirty), toYValue(perc: forty), toYValue(perc: fifty), toYValue(perc: sixty), toYValue(perc: seventy), toYValue(perc: eighty), toYValue(perc: ninty), toYValue(perc: hundred)]
        
        let xModel = ChartAxisModel(axisValues: xValues, axisTitleLabel: ChartAxisLabel(text: "", settings: labelSettings))
        let yModel = ChartAxisModel(axisValues: yValues, axisTitleLabel: ChartAxisLabel(text: "", settings: labelSettings.defaultVertical()))
        let chartFrame = ExamplesDefaults.chartFrame(containerBounds: self.view.bounds)
        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: ExamplesDefaults.chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
        let (xAxis, yAxis, innerFrame) = (coordsSpace.xAxis, coordsSpace.yAxis, coordsSpace.chartInnerFrame)
        
        let minBarSpacing: CGFloat = ExamplesDefaults.minBarSpacing + 10
        
        let generator = {(chartPointModel: ChartPointLayerModel, layer: ChartPointsLayer, chart: Chart) -> UIView? in
            let bottomLeft = CGPoint(x: layer.innerFrame.origin.x, y: layer.innerFrame.origin.y + layer.innerFrame.height)
            //let bottomLeft = CGPointMake(layer.innerFrame.origin.x, layer.innerFrame.origin.y + layer.innerFrame.height)
            
            
            let barWidth = layer.minXScreenSpace - minBarSpacing
            
            let (p1, p2): (CGPoint, CGPoint) = (CGPoint(x: chartPointModel.screenLoc.x, y: bottomLeft.y), CGPoint(x: chartPointModel.screenLoc.x, y: chartPointModel.screenLoc.y))
            return ChartPointViewBar(p1: p1, p2: p2, width: barWidth, bgColor: UIColor.blue.withAlphaComponent(0.6))
        }
        
        let chartPointsLayer = ChartPointsViewsLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, chartPoints: chartPoints, viewGenerator: generator)
        
        let settings = ChartGuideLinesDottedLayerSettings(linesColor: UIColor.black, linesWidth: ExamplesDefaults.guidelinesWidth)
        let guidelinesLayer = ChartGuideLinesDottedLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, settings: settings)
        
        let dividersSettings =  ChartDividersLayerSettings(linesColor: UIColor.black, linesWidth: Env.iPad ? 1 : 0.2, start: Env.iPad ? 7 : 3, end: 0, onlyVisibleValues: true)
        let dividersLayer = ChartDividersLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, settings: dividersSettings)
        
        let chart = Chart(
            frame: chartFrame,
            layers: [
                xAxis,
                yAxis,
                guidelinesLayer,
                dividersLayer,
                chartPointsLayer
            ]
        )

        
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
        _ = BarsChart(
            frame: CGRect(x: 0, y: 0, width: 300, height: height),
            //frame: CGRectMake(0, 0, 300, height),
            chartConfig: chartConfig,
            xTitle: "",
            yTitle: "",
            bars: bars,
            color: UIColor.red,
            barWidth: 20,
            animDuration: 5
        )
        self.chart = chart
        
        self.view.addSubview(chart.view)
        self.chart = chart
        container_view.addSubview(chart.view)
    }
    
    class ChartAxisValuePercent: ChartAxisValueDouble {
        override var description: String {
            return "\(self.formatter.string(from: NSNumber(value: self.scalar))!)%"
            //return "\(self.formatter.string(from: NSNumber(self.scalar))!)%"
            
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return exam_result_list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exam_result_cell", for: indexPath as IndexPath) as! ExamResultCellTVC
        
        cell.subject.text = exam_result_list[indexPath.row].subject
        cell.max_marks.text = exam_result_list[indexPath.row].max_marks
        cell.marks_obtained.text = exam_result_list[indexPath.row].marks_obtained
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //print("inside header processing of pending test")
        let header_cell = tableView.dequeueReusableCell(withIdentifier: "exam_result_header_cell") as! ExamResultHeaderCellTVC
        header_cell.backgroundColor = UIColor.cyan
        return header_cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

private struct MyPerc   {
    let number: Int
    let text: String
    
    init(number: Int, text: String) {
        self.number = number
        self.text = text
    }
}

private struct MySubject    {
    let name: String
    let perc: String
    let pct: Int
    
    init(name: String, perc: Double)    {
        self.name = name
        self.perc = String(stringInterpolationSegment: perc*100)
        self.pct = Int(perc)
    }
}
