//
//  Legend.swift
//  iOS
//
//  Created by Marc Kramer on 01.12.20.
//

import SwiftUI

struct Legend: View {

    var frame: CGRect
    var stepHeight: CGFloat {
        frame.size.height/(max-min)
    }
    var xLabels: [String]
    var max: CGFloat
    var min: CGFloat

    var body: some View {

            ZStack(alignment: .topLeading) {
                        ForEach((0...4), id: \.self) { height in
                            HStack(alignment: .center) {
                                Text("\(self.getYLegendSafeText(height: height), specifier: "%.2f")°")
                                    .offset(x: 0, y: self.getYposition(height: height))
                                    .foregroundColor(Color.secondary)
                                    .font(.caption)
                                self.line(atHeight: self.getYLegendSafe(height: height), width: self.frame.width)
                                    .stroke((Color.secondary), style: StrokeStyle(lineWidth: 1, lineCap: .round))
                                    .rotationEffect(.degrees(180), anchor: .center)
                                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                                    .clipped()
                            }

                        }

            }

    }
func getYLegendSafe(height: Int) -> CGFloat {
    if let legend = getYLegend() {
        return CGFloat(legend[height])
    }
    return 0
}

    func getYLegendSafeText(height: Int) -> CGFloat {
        if let legend = getYLegendText() {
            return CGFloat(legend[height])
        }
        return 0
    }
func getYposition(height: Int) -> CGFloat {
    if let legend = getYLegend() {
        return (self.frame.height-((CGFloat(legend[height]) - min)*self.stepHeight))-(self.frame.height/2)
    }
    return 0

}

func line(atHeight: CGFloat, width: CGFloat) -> Path {
    var hLine = Path()
    hLine.move(to: CGPoint(x: 5, y: (atHeight-min)*stepHeight))
    hLine.addLine(to: CGPoint(x: width, y: (atHeight-min)*stepHeight))
    return hLine
}

func getYLegend() -> [Double]? {
    let max = Double(self.max)
    let min = Double(self.min)
    let step = Double(max - min)/4
    return [min+step * 0.001, min+step * 1, min+step * 2, min+step * 3, min+step * 3.999]

}
    func getYLegendText() -> [Double]? {
        let max = Double(self.max)
        let min = Double(self.min)
        let step = Double(max - min)/4
        return [min+step * 0, min+step * 1, min+step * 2, min+step * 3, min+step * 4]

    }
}
struct Legend_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
