//
//  AllSensorView.swift
//  iOS
//
//  Created by Marc Kramer on 11.09.20.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var sensorsVm: SensorListViewModel
    @State private var searchText = ""
    @State private var selectedTag: Int?
    @State private var selectedFilter: FilterOptions = .nameDesc
    
    @State var filteredArray =  [Sensor]()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredArray) { sensor in
                    SensorScrollItemSmall(sensor: sensor, selectedTag: $selectedTag)
                }
            }
            .searchable(text: $searchText, prompt: "Location or Temperature") {
                ForEach(filteredArray) { result in
                    Text(result.sensorName).searchCompletion(result.sensorName)
                }
            }
            .navigationBarTitle("Search")
            /*.navigationBarItems(trailing:
                                    Menu(content: {
                ForEach(FilterOptions.allFilters, id: \.self) {filter in
                    Button {
                        selectedFilter = filter
                    } label: {
                        Text(filter.rawValue)
                    }
                }
            }, label: {
                if selectedFilter == .nameDesc {
                    Label("Filter", systemImage: "arrow.up.arrow.down.circle")
                } else {
                    Label("Filter", systemImage: "arrow.up.arrow.down.circle.fill")
                }
            })
            )*/
            .onAppear(perform: {
                filterChanged()
            })
            .onChange(of: selectedFilter) { _ in
                filterChanged()
            }
            .onChange(of: searchText) { _ in
                filterChanged()
            }
        }
    }
    
    func filterChanged() {
        var array = [Sensor]()
        
        if searchText == ""{
            array = sensorsVm.sensorArray
        } else {
            array = sensorsVm.sensorArray.filter {
                $0.sensorName.localizedCaseInsensitiveContains(searchText) ||
                String($0.latestTemp!).contains(searchText)
            }
        }
        
        switch selectedFilter {
        case .tempAsc:
            filteredArray = array.sorted(by: {$0.latestTemp! < $1.latestTemp!})
        case .tempDesc:
            filteredArray = array.sorted(by: {$0.latestTemp! > $1.latestTemp!})
        case .timeAsc:
            filteredArray = array.sorted(by: {$0.lastTempTime! > $1.lastTempTime!})
        case .nameDesc:
            filteredArray = array.sorted(by: {$0.sensorName < $1.sensorName})
        }
    }
}

struct AllSensorView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(sensorsVm: SensorListViewModel())
    }
}

enum FilterOptions: String, Equatable, CaseIterable {
    case tempAsc = "Lowest Temperature"
    case tempDesc = "Highest Temperature"
    case timeAsc = "Newest Measurement"
    case nameDesc = ""
    
    static let allFilters = [nameDesc, tempDesc, tempAsc, timeAsc]
}
