//
//  LakeOverView.swift
//  iOS
//
//  Created by Marc Kramer on 22.08.20.
//

import SwiftUI
import MapKit

struct LakeOverView: View {
    var lake: Lake
    @ObservedObject var sensorsVM: SensorListViewModel
    @State var selectedTag: Int?
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            TopMap(lake: lake, sensors: sensorsVM, region: lake.region, selectedTag: $selectedTag)
            
            ScrollViewReader { proxy in
                List(selection: $selectedTag) {
                    Text("Locations")
                        .font(.title2)
                        .bold()
                    ForEach(getSensorsInBody()) { sensor in
                        SensorScrollItemSmall(sensor: sensor, selectedTag: $selectedTag)
                            .id(sensor.id)
                    }
                }
                .listStyle(.insetGrouped)
                .onChange(of: selectedTag) { _ in
                    proxy.scrollTo(selectedTag)
                }
            }
            Spacer()
        }
        .navigationBarTitle(lake.name)
        .background(Color.systemGroupedBackground.ignoresSafeArea())
    }
    
    func getSensorsInBody() -> [Sensor] {
        var sensors = [Sensor]()
        for sensor in sensorsVM.sensorArray {
            if lake.sensors.contains(sensor.id) {
                sensors.append(sensor)
            }
        }
        return sensors
    }
}

struct LakeOverView_Previews: PreviewProvider {
    static var previews: some View {
        LakeOverView(lake: lakeOfZurich, sensorsVM: SensorListViewModel.init())
    }
}

struct TopMap: View {
    
    var lake: Lake
    
    @ObservedObject var sensors: SensorListViewModel
    @State var region: MKCoordinateRegion
    @Binding var selectedTag: Int?
    var body: some View {
        
        Map(coordinateRegion: $region,
            annotationItems: sensors.sensorArray, annotationContent: { pin in
            MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: pin.latitude!, longitude: pin.longitude!),
                          content: {
                Button {
                    selectedTag = pin.id
                } label: {
                    Image(systemName: "mappin")
                        .font(Font.title3.weight(.bold))
                        .foregroundColor(.red)
                        .padding(4)
                }
            })
        })
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/3.5)
        .onAppear(perform: {
            region = MKCoordinateRegion(
                center: lake.region.center,
                span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
            )
        })
        .onChange(of: region.span.longitudeDelta) { _ in
            if region.span.latitudeDelta > 0.5 || region.span.longitudeDelta > 0.5 {
                region = MKCoordinateRegion(
                    center: lake.region.center,
                    span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
                )
            }
        }
    }
}

struct SensorScrollItemSmall: View {
    @AppStorage("favorites") private var favorites = [Int]()
    var sensor: Sensor
    @Binding var selectedTag: Int?

    var body: some View {
        NavigationLink(destination: SensorOverView(sensorID: sensor.id, sensorName: sensor.sensorName)) {
            HStack(alignment: .top) {
                Text(sensor.sensorName)
                    .bold()
                if favorites.contains(sensor.id) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text(makeTemperatureString(double: sensor.latestTemp))
                    Text(sensor.lastTempTime!, format: .relative(presentation: .named))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }.foregroundColor(selectedTag == sensor.id ? .blue : .primary)
                .lineLimit(2)
        }
    }
}
