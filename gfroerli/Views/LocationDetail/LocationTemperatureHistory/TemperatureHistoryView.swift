//
//  TemperatureHistoryView.swift
//  gfroerli
//
//  Created by Marc on 09.09.22.
//

import Charts
import GfroerliAPI
import SwiftUI

struct TemperatureHistoryView: View {
    
    typealias config = AppConfiguration

    var locationID: Int

    @StateObject var hourlyVM: HourlyTemperaturesViewModel
    @State var currentSelection: AppConfiguration.ChartSpan = .day
    @State var zoomed = false
    
    init(locationID: Int) {
        self.locationID = locationID
        self._hourlyVM = StateObject(wrappedValue: HourlyTemperaturesViewModel(locationID: locationID, date: Date.now))
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("History")
                    .font(.title)
                    .bold()
                
                Spacer()
                
                Picker("Choose time span", selection: $currentSelection) {
                    Text("Day").tag(AppConfiguration.ChartSpan.day)
                    Text("Week").tag(AppConfiguration.ChartSpan.week)
                    Text("Month").tag(AppConfiguration.ChartSpan.month)
                }
                
                Button {
                    zoomed = !zoomed
                } label: {
                    if zoomed {
                        Image(systemName: "minus.magnifyingglass")
                    }
                    else {
                        Image(systemName: "plus.magnifyingglass")
                    }
                }
                .buttonBorderShape(.capsule)
                .buttonStyle(.bordered)
            }
            switch currentSelection {
            case .day:
                HourlyHistoryGraphView(hourlyVM: hourlyVM, zoomed: $zoomed)
            case .week:
                Text("week")
            case .month:
                Text("Month")
            }
        }
        .padding()
        .defaultBoxStyle()
    }
}

struct TemperatureHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        TemperatureHistoryView(locationID: 1)
    }
}
