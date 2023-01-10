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

    @StateObject var hourlyVM: TemperaturesViewModel
    @StateObject var weeklyVM: TemperaturesViewModel
    @StateObject var monthlyVM: TemperaturesViewModel
    @State var currentSelection: ChartSpan = .day
    @State var zoomed = true
    
    init(locationID: Int) {
        self.locationID = locationID
        self
            ._hourlyVM =
            StateObject(wrappedValue: TemperaturesViewModel(locationID: locationID, interval: .day, date: Date.now))
        self
            ._weeklyVM =
            StateObject(wrappedValue: TemperaturesViewModel(locationID: locationID, interval: .week, date: Date.now))
        self
            ._monthlyVM =
            StateObject(wrappedValue: TemperaturesViewModel(locationID: locationID, interval: .month, date: Date.now))
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("History")
                    .font(.title2)
                    .bold()
                
                Spacer()
                
                Picker("Choose time span", selection: $currentSelection) {
                    Text("Day").tag(ChartSpan.day)
                    Text("Week").tag(ChartSpan.week)
                    Text("Month").tag(ChartSpan.month)
                }
                
                Button {
                    zoomed = !zoomed
                } label: {
                    if zoomed {
                        Image(systemName: "minus.magnifyingglass")
                            .fontWeight(.semibold)
                    }
                    else {
                        Image(systemName: "plus.magnifyingglass")
                            .fontWeight(.semibold)
                    }
                }
                .buttonBorderShape(.capsule)
                .buttonStyle(.bordered)
            }
            
            switch currentSelection {
            case .day:
                HistoryGraphView(vm: hourlyVM, zoomed: $zoomed)
            case .week:
                HistoryGraphView(vm: weeklyVM, zoomed: $zoomed)
            case .month:
                HistoryGraphView(vm: monthlyVM, zoomed: $zoomed)
            }
        }
        .padding(.horizontal, AppConfiguration.General.horizontalBoxPadding)
        .padding(.vertical, AppConfiguration.General.verticalBoxPadding)
        .defaultBoxStyle()
    }
}

struct TemperatureHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        TemperatureHistoryView(locationID: 1)
    }
}
