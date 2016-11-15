//
//  SubjectMarksHistoryVC.swift
//  ClassUp-iOS
//
//  Created by Atul Gupta on 27/03/16.
//  Copyright © 2016 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit
import SwiftCharts
import SwiftyJSON
import Just


class SubjectMarksHistoryVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private var chart: Chart?
    
    
    @IBOutlet weak var container_view: UIView!
    
    var marks_history: [SubjectMarksHistoryModel] = []
    var date_list: [String] = []
    var perc_list: [Double] = []
    
    var student_id: String = ""
    var student_full_name: String = ""
    var subject_name: String = ""
    
    @IBOutlet weak var title_label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title_label.text = "\(subject_name) Marks History for \(student_full_name)"
        // Do any additional setup after loading the view.
        let server_ip: String = MiscFunction.getServerIP()
        let url = ("\(server_ip)/parents/retrieve_stu_sub_marks_history/\(subject_name)/?student=\(student_id)").replacingOccurrences(of: " ", with: "%20")
        let j = JSON(Just.get(url).json!)
        
        let count: Int? = j.count
        if (count! > 0)  {
            if let ct = count {
                for index in 0...ct-1 {
                    var mh = SubjectMarksHistoryModel()
                    var max_marks: String = ""
                    var marks: String = ""
                    
                    if let _ = j[index]["max_marks"].string {
                        max_marks = j[index]["max_marks"].string!
                        mh.max_marks = max_marks
                    }
                    if let _ = j[index]["max_marks"].int {
                        let name = j[index]["max_marks"]
                        let max_marks = String(stringInterpolationSegment: name)
                        mh.max_marks = max_marks
                    }
                    
                    if let marks_obtained = j[index]["marks"].string    {
                        mh.marks_obtained = marks_obtained
                    }
                    
                    if let _ = j[index]["marks"].int {
                        let m = j[index]["marks"]
                        if m != -1000   {
                        marks = String(stringInterpolationSegment: m)
                        mh.marks_obtained = marks
                        }
                        else    {
                            marks = "ABS"
                            mh.marks_obtained = "ABS"
                        }
                    }
                    if let _ = j[index]["marks"].float {
                        let m = j[index]["marks"]
                        if m != -1000   {
                            marks = String(stringInterpolationSegment: m)
                            mh.marks_obtained = marks
                        }
                        else    {
                            marks = "ABS"
                            mh.marks_obtained = "ABS"
                        }

                    }

                    if let the_date = j[index]["date"].string {
                        // convert date to dd/mm/yy format
                        // the date we have received is in yyyy-mm-dd format. Let's convert it to dd/mm/yy format
                        let yyyymmdd = the_date
                        let yy = yyyymmdd[2...3]
                        let mm = yyyymmdd[5...6]
                        let dd = yyyymmdd[8...9]
                        let ddmmyy = dd + "/" + mm +  "/"   + yy
                        mh.date = ddmmyy
                        
                        if max_marks != "Grade Based"   {
                            if marks != "ABS"   {
                            date_list.append(yyyymmdd)
                            }
                        }
                    }
                    marks_history.append(mh)
                    
                    // update arrays for line graph
                    if max_marks != "Grade Based"   {
                        if marks != "ABS"   {
                        let nf = NumberFormatter()
                        let mo = nf.number(from: mh.marks_obtained)?.floatValue
                        let mm = nf.number(from: mh.max_marks)?.floatValue
                        let perc = round((mo!/mm!)*100)
                        perc_list.append(Double(perc))
                        }
                    }
                }
            }
        }
        
        let labelSettings = ChartLabelSettings(font: ExamplesDefaults.labelFont)
        
        var readFormatter = DateFormatter()
        //readFormatter.dateFormat = "dd.MM.yyyy"
        readFormatter.dateFormat = "yyyy-MM-dd"
        
        var displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "dd/MM"
        
        let date = {(str: String) -> Date in
            return readFormatter.date(from: str)!
        }
        
        let calendar = NSCalendar.current
        
//        let dateWithComponents = {(day: Int, month: Int, year: Int) -> NSDate in
//            let components = NSDateComponents()
//            components.day = day
//            components.month = month
//            components.year = year
//            return calendar.dateComponents(components)!
//        }
        
        func filler(date: NSDate) -> ChartAxisValueDate {
            let filler = ChartAxisValueDate(date: date as Date, formatter: displayFormatter)
            filler.hidden = true
            return filler
        }
        
        var chartPoints = [
            createChartPoint(dateStr: date_list[0], percent: perc_list[0], readFormatter: readFormatter, displayFormatter: displayFormatter)
        ]
        
        for var i in 1..<date_list.count {
            chartPoints.append(createChartPoint(dateStr: date_list[i], percent: perc_list[i], readFormatter: readFormatter, displayFormatter: displayFormatter))
        }
        
        let yValues = stride(from: 30, to: 100, by: 10).map {ChartAxisValuePercent($0, labelSettings: labelSettings)}
        //let yValues = 30.stride(through: 100, by: 10).map {ChartAxisValuePercent($0, labelSettings: labelSettings)}
        yValues.first?.hidden = true
        
        var xValues = [
            self.createDateAxisValue(dateStr: date_list[0], readFormatter: readFormatter, displayFormatter: displayFormatter)
        ]
        for i in 1..<date_list.count    {
            xValues.append(self.createDateAxisValue(dateStr: date_list[i], readFormatter: readFormatter, displayFormatter: displayFormatter))
        }
        let xModel = ChartAxisModel(axisValues: xValues, axisTitleLabel: ChartAxisLabel(text: "", settings: labelSettings))
        let yModel = ChartAxisModel(axisValues: yValues, axisTitleLabel: ChartAxisLabel(text: "Percentage", settings: labelSettings.defaultVertical()))
        let chartFrame = ExamplesDefaults.chartFrame(containerBounds: self.view.bounds)
        let chartSettings = ExamplesDefaults.chartSettings
        chartSettings.trailing = 40
        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
        let (xAxis, yAxis, innerFrame) = (coordsSpace.xAxis, coordsSpace.yAxis, coordsSpace.chartInnerFrame)
        
        let lineModel = ChartLineModel(chartPoints: chartPoints, lineColor: UIColor.red, animDuration: 1, animDelay: 0)
        let chartPointsLineLayer = ChartPointsLineLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, lineModels: [lineModel])
        
        let settings = ChartGuideLinesDottedLayerSettings(linesColor: UIColor.black, linesWidth: ExamplesDefaults.guidelinesWidth)
        let guidelinesLayer = ChartGuideLinesDottedLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, settings: settings)
        
        
        let chart = Chart(
            frame: chartFrame,
            layers: [
                coordsSpace.xAxis,
                coordsSpace.yAxis,
                guidelinesLayer,
                chartPointsLineLayer]
        )
        
        //self.view.addSubview(chart.view)
        self.chart = chart
        container_view.addSubview(chart.view)
    }
    
    func createChartPoint(dateStr: String, percent: Double, readFormatter: DateFormatter, displayFormatter: DateFormatter) -> ChartPoint {
        return ChartPoint(x: self.createDateAxisValue(dateStr: dateStr, readFormatter: readFormatter, displayFormatter: displayFormatter), y: ChartAxisValuePercent(percent))
    }
    
    func createDateAxisValue(dateStr: String, readFormatter: DateFormatter, displayFormatter: DateFormatter) -> ChartAxisValue {
        let date = readFormatter.date(from: dateStr)!
        let labelSettings = ChartLabelSettings(font: ExamplesDefaults.labelFont, rotation: 45, rotationKeep: .top)
        return ChartAxisValueDate(date: date, formatter: displayFormatter, labelSettings: labelSettings)
    }
    
    class ChartAxisValuePercent: ChartAxisValueDouble {
        override var description: String {
            return "\(self.formatter.string(from: NSNumber(value: self.scalar))!)%"
            //return "\(self.formatter.stringFromNumber(NSNumber(self.scalar))!)%"
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
        return marks_history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "marks_history_cell", for: indexPath as IndexPath) as! MarksHistoryCellTVC
        
        cell.date.text = marks_history[indexPath.row].date
        cell.max_marks.text = marks_history[indexPath.row].max_marks
        cell.marks_obtained.text = marks_history[indexPath.row].marks_obtained
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return UITableViewAutomaticDimension
        return 30
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    //
    //    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    //        return UITableViewAutomaticDimension
    //    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //print("inside header processing of pending test")
        let header_cell = tableView.dequeueReusableCell(withIdentifier: "marks_history_header_cell") as! MarksHistoryHeaderCellTVC
        header_cell.backgroundColor = UIColor.cyan
        return header_cell
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
