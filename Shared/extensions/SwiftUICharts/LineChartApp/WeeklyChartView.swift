//
//  DailyChartView.swift
//  iOS
//
//  Created by Marc Kramer on 01.12.20.
//

import Foundation
import SwiftUI

struct WeeklyChartView: View {

    @Binding var showMax: Bool
    @Binding var showMin: Bool
    @Binding var showAvg: Bool
    @Binding var showCircles: Bool

    var avgColor: Color?
    var daySpan: DaySpan
    let data: [DailyAggregation]
    var lineWidth: CGFloat = 2
    var pointSize: CGFloat = 4
    var frame: CGRect

    var maxVal: Double {let highestPoint = data.max { $0.maxTemp! < $1.maxTemp! }
        return highestPoint?.maxTemp ?? 1}

    var minVal: Double {let lowestPoint = data.min { $0.minTemp! < $1.minTemp! }
        return lowestPoint?.minTemp ?? 1}

    var xLabels: [String] {
        return getXLabels(data: data)
    }

    var body: some View {
        VStack {
        ZStack(alignment: .center) {

            Legend(
                frame: frame,
                xLabels: getXLabels(data: data),
                max: CGFloat(maxVal.rounded(.up)),
                min: CGFloat(minVal.rounded(.down))
            )

            WeeklyLineChartShape(
                pointSize: pointSize,
                data: data,
                type: .minimum,
                span: daySpan,
                max: maxVal,
                min: minVal,
                showCircles: showCircles
            )
            .stroke(
                showMin ? Color.blue : Color.clear,
                style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round)
            )
            .frame(width: frame.width-40, height: frame.height).offset(x: +20)

            WeeklyLineChartShape(
                pointSize: pointSize,
                data: data,
                type: .maximum,
                span: daySpan,
                max: maxVal,
                min: minVal,
                showCircles: showCircles
            )
            .stroke(
                showMax ? Color.red : Color.clear,
                style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round)
            )
            .frame(width: frame.width-40, height: frame.height).offset(x: +20)

            WeeklyLineChartShape(
                pointSize: pointSize,
                data: data,
                type: .average,
                span: daySpan,
                max: maxVal,
                min: minVal,
                showCircles: showCircles
            )
            .stroke(
                showAvg ? ((avgColor != nil) ? Color.white : Color.green) : Color.clear,
                style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round)
            )
            .frame(width: frame.width-40, height: frame.height).offset(x: +20)

        }
        Spacer()
        HStack {
            Text("0.00").foregroundColor(.clear)
                .font(.caption)

        }
        }
    }

    func getXLabels(data: [DailyAggregation]) -> [String] {
        var labels = [String]()
        labels.append(createLegendDateString(date: Date()))
        return labels
    }

    func makeDMString(string: String) -> String {
        var str = string
        str.removeLast(3)
        let str2 = str.suffix(2)
        return string.suffix(2)+"."+str2+"."
    }

    func createLegendDateString(date: Date) -> String {

        let stringFormatter = DateFormatter()
        stringFormatter.dateFormat = "dd.MM."
        return stringFormatter.string(from: date)
    }
}

struct DailyChartView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
