//
//  X-LabelsView.swift
//  iOS
//
//  Created by Marc on 18.05.21.
//

import SwiftUI

struct XLabelsView: View {
    @ObservedObject var temperatureAggregationsVM: TemperatureAggregationsViewModel
    @Binding var timeFrame: TimeFrame
    @Binding var totalSteps: Int

    var startDate: Date {
        switch timeFrame {
        case .day:
            return Date()
        case .week:
            return temperatureAggregationsVM.startDateWeek
        default:
            return temperatureAggregationsVM.startDateMonth
        }
    }

    var midDate: Date {
        return Calendar.current.date(byAdding: .day, value: totalSteps/2, to: startDate)!
    }

    var endDate: Date {
        return Calendar.current.date(byAdding: .day, value: totalSteps, to: startDate)!

    }

    var body: some View {
        HStack {
            if timeFrame == .day {

                Text("00:00")
                Spacer()
                Text("12:00")
                Spacer()
                Text("24:00")

            } else if timeFrame == .week {

                Text(formatDateTextWeek(date: startDate))
                Spacer()
                Text(formatDateTextWeek(date: midDate))
                Spacer()
                Text(formatDateTextWeek(date: endDate))

            } else {

                Text(formatDateTextMonth(date: startDate))
                Spacer()
                Text(formatDateTextMonth(date: midDate))
                Spacer()
                Text(formatDateTextMonth(date: endDate))
            }
        }
    }

    func formatDateTextWeek(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("eee")
        return dateFormatter.string(from: date)
    }

    func formatDateTextMonth(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("dd MMM")
        return dateFormatter.string(from: date)
    }
}

struct XLabelsView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
