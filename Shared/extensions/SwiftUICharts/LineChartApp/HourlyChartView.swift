//
//  ChartView.swift
//  iOS
//
//  Created by Marc Kramer on 30.11.20.
//

import SwiftUI
import Foundation

struct HourlyChartView: View {
    @Binding var showMax: Bool
    @Binding var showMin: Bool
    @Binding var showAvg: Bool
    @Binding var showCircles: Bool
    
    let data: [HourlyAggregation?]
    var lineWidth: CGFloat = 2
    var pointSize: CGFloat = 4
    var frame: CGRect
    var avgColor: Color?
    
    var maxVal: Double {
        let arr = data.filter({$0 != nil})
        let highestPoint = arr.max {
            $0!.maxTemp! < $1!.maxTemp!
        }
        return highestPoint??.maxTemp ?? 1
        
    }
    
    var minVal: Double {
        let arr = data.filter({$0 != nil})
        let lowestPoint = arr.min {
            $0!.minTemp! < $1!.minTemp!
        }
        return lowestPoint??.minTemp ?? 1
        
    }
    
    var xLabels: [String] {
        return getXLabels(data: data)
    }
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                Legend(
                    frame: frame,
                    xLabels: getXLabels(data: data),
                    max: CGFloat(maxVal.rounded(.up)),
                    min: CGFloat(minVal.rounded(.down))
                )
                
                HourlyLineChartShape(
                    pointSize: pointSize,
                    data: data,
                    type: .minimum,
                    max: maxVal,
                    min: minVal,
                    showCircles: showCircles)
                    .stroke(
                        showMin ? Color.blue : Color.clear,
                        style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round)
                    )
                    .frame(width: frame.width-40, height: frame.height)
                    .offset(x: +20)
                
                HourlyLineChartShape(
                    pointSize: pointSize,
                    data: data,
                    type: .maximum,
                    max: maxVal,
                    min: minVal,
                    showCircles: showCircles)
                    .stroke(
                        showMax ? Color.red : Color.clear,
                        style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round)
                    )
                    .frame(width: frame.width-40, height: frame.height)
                    .offset(x: +20)
                
                HourlyLineChartShape(
                    pointSize: pointSize,
                    data: data,
                    type: .average,
                    max: maxVal,
                    min: minVal,
                    showCircles: showCircles)
                    .stroke(
                        showAvg ? ((avgColor != nil) ? Color.white : Color.green) : Color.clear,
                        style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round)
                    )
                    .frame(width: frame.width-40, height: frame.height)
                    .offset(x: +20)
                
            }
            Spacer()
            HStack {
                Text("0.00")
                    .foregroundColor(.clear)
                    .font(.caption)
                Text(xLabels[0])
                    .foregroundColor(Color.secondary)
                    .font(.caption)
                Spacer()
                Text(xLabels[1])
                    .foregroundColor(Color.secondary)
                    .font(.caption)
                Spacer()
                Text(xLabels[2])
                    .foregroundColor(Color.secondary)
                    .font(.caption)
            }
        }
    }
    
    func getXLabels(data: [HourlyAggregation?]) -> [String] {
        var labels = [String]()
        labels.append("00:00")
        labels.append("12:00")
        labels.append("24:00")
        return labels
    }
}
