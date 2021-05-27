//
//  ChartView.swift
//  ShotnVideos
//
//  Created by Behran Kankul on 27.05.2021.
//

import UIKit
import Charts

class ChartView: UIView {
    
    private weak var axisFormatDelegate: IAxisValueFormatter?
    
    init() {
        super.init(frame: .zero)
    
        setupChart()
        
        axisFormatDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Chart Setup
    private var chart: BarChartView?
    
    private func setupChart() {
        chart = BarChartView(frame: .zero)
        
        guard let chart = chart else {
            return
        }
        
        addSubviews(views: chart)
        chart.fillSuperview()
    }
    
    func prepareChartFor(user: UserObject?) {
              
        
        guard let shots = user?.shots else {
            return
        }
        
        var dataEntries: [BarChartDataEntry] = []
        
        for shot in shots {
            let dataEntry = BarChartDataEntry(x: shot.shotPosX,
                                              y: shot.shotPosY)
            
            dataEntries.append(dataEntry)
        }
        
        let chartSet = BarChartDataSet(entries: dataEntries,
                                       label: "Positions")
        
        let chartData = BarChartData(dataSet: chartSet)
        chartData.barWidth = 2
        
        chart?.data = chartData
        chart?.backgroundColor = .secondarySystemBackground
        
        let xAxis = chart?.xAxis
        xAxis?.labelTextColor = .label
        xAxis?.valueFormatter = axisFormatDelegate
    }
}

// MARK: axisFormatDelegate
extension ChartView: IAxisValueFormatter {
  
  func stringForValue(_ value: Double, axis: AxisBase?) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm.ss"
    
    return dateFormatter.string(from: Date(timeIntervalSince1970: value))
  }
}
