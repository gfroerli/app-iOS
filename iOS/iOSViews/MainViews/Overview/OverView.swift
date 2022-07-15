//
//  OverView.swift
//  iOS
//
//  Created by Marc Kramer on 22.08.20.
//

import SwiftUI
import MapKit
struct OverView: View {
    @ObservedObject var sensorsVM: SensorListViewModel
    @State var showInfo = false
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Info:").font(.title3).bold()
                        Text("More locations will follow very soon, stay tuned!", comment: "Test comment")}
                    Spacer()
                }
                .padding()
                .boxStyle()
                
                VStack(spacing: 0) {
                    switch sensorsVM.loadingState {
                    case .loaded:
                        if sensorsVM.sensorArray.count != 0 {
                            TopTabView(sensors: sensorsVM.sensorArray)
                        }
                    case .loading:
                        LoadingView()
                        
                    case .failed:
                        Text("Error")
                    }
                }
                .frame(idealHeight: UIScreen.main.bounds.height * 0.3)
                
                HStack {
                    Text("Waterbodies")
                        .font(.title)
                        .bold()
                    .padding(.leading)
                    Spacer()
                }
                
                ForEach(lakes) { lake in
                    NavigationLink(destination: LakeOverView(lake: lake, sensorsVM: sensorsVM)) {
                        WaterBodyScrollItem(sensorsVM: sensorsVM, waterBody: lake)
                    }.buttonStyle(.plain)
                }
                Spacer()
            }
            .background(Color.systemGroupedBackground.ignoresSafeArea())
            .navigationBarTitle("Overview", displayMode: .large)
            .navigationBarItems(trailing:
                                    Button(action: {
                showInfo = true
            }, label: {
                Image(systemName: "gear")
            }))
            .sheet(isPresented: $showInfo, content: {
                SettingsView()
            })
        }
    }
}

struct TopTabView: View {
    @State var sensors: [Sensor]
    var newestSensor: Sensor
    var randomSensor = testSensor1
    var latestSensor = testSensor1
    
    init(sensors: [Sensor]) {
        _sensors = State(initialValue: sensors)
        
        newestSensor = sensors.sorted(by: {$0.id > $1.id}).first!
        latestSensor = sensors.sorted(by: {$0.lastTempTime! > $1.lastTempTime!}).first!
        randomSensor = sensors.randomElement() ?? sensors.first!
        
        UIPageControl.appearance().currentPageIndicatorTintColor = .secondaryLabel
        UIPageControl.appearance().pageIndicatorTintColor = .tertiaryLabel
    }
    
    var body: some View {
        TabView {
            NavigationLink(destination:
                            SensorOverView(sensorID: newestSensor.id, sensorName: newestSensor.sensorName)
                ) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Recently Added")
                        .font(.title)
                        .bold()
                        .padding(.leading)
                    SensorScrollItem(sensor: newestSensor)
                }
            }
            if sensors.count > 0 {
                NavigationLink(destination:
                                SensorOverView(sensorID: latestSensor.id, sensorName: latestSensor.sensorName)
                ) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Newest Measurement")
                            .font(.title)
                            .bold()
                            .padding(.leading)
                        SensorScrollItem(sensor: latestSensor)
                    }
                }
                if sensors.count > 0 {
                    NavigationLink(destination:
                                    SensorOverView(sensorID: randomSensor.id, sensorName: randomSensor.sensorName)
                    ) {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Random")
                                .font(.title)
                                .bold()
                                .padding(.leading)
                            SensorScrollItem(sensor: randomSensor)
                        }
                    }
                }
            }
        }
        .buttonStyle(.plain)
        .tabViewStyle(.page(indexDisplayMode: .never))
        
    }
}

struct OverView_Previews: PreviewProvider {
    static var previews: some View {
        WaterBodyScrollItem(sensorsVM: SensorListViewModel.init(), waterBody: lakeOfZurich).makePreViewModifier()
    }
}

struct WaterBodyScrollItem: View {
    @ObservedObject var sensorsVM: SensorListViewModel
    var waterBody: Lake
    
    var body: some View {
        
        VStack(alignment: .leading) {
            HStack {
                Text(waterBody.name)
                    .font(.headline)
                    .bold()
                if calculateAvgTemperature() != 0.0 {
                    Spacer()
                    Text(makeTemperatureString(double: calculateAvgTemperature(), precision: 1))
                        .font(.headline)
                }
                
            }
            HStack(spacing: 0){
                Text("\(waterBody.sensors.count ) ")
                if waterBody.sensors.count != 1 {
                    Text("Locations")
                } else {
                    Text("Location")
                }
            }
                .font(.footnote)
        }.padding()
        .boxStyle()
    }
    
    func calculateAvgTemperature() -> Double {
        var total = 0.0
        var count = 0.0
        
        for sensor in sensorsVM.sensorArray {
            if waterBody.sensors.contains(sensor.id) {
                if let temp = sensor.latestTemp {
                    total += temp
                    count += 1
                }
            }
        }
        return total/count
    }
}
