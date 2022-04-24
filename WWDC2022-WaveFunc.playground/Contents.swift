import SwiftUI
import PlaygroundSupport
import AppKit

struct GraphShape: Shape {
    let fn: (Double) -> Double
    let steps: Int
    let range: ClosedRange<Double>
    
    var points: [CGPoint] {
        var points: [CGPoint] = []
        let stepsDistance = (range.upperBound - range.lowerBound) / Double(steps - 1)
        
        for x in stride(from: range.lowerBound, through: range.upperBound, by: stepsDistance) {
            let y = fn(x)
            let point = CGPoint(x: x, y: y)
            
            points.append(point)
        }
        
        return points
    }
    
    private func normalizedPoints(in rect: CGRect) -> [CGPoint] {
        let testRect = rect
        let points = self.points
        return points.enumerated().map { (offset, p) in
            let screenX = CGFloat(offset) * rect.width/CGFloat(points.count - 1)
            let screenY = rect.midY - p.y
            
            return CGPoint(x: screenX, y: screenY)
        }
    }
    
    func path(in rect: CGRect) -> Path {
        Path { p in
            let points = normalizedPoints(in: rect)
            p.addLines(points)
        }
    }
}

struct GraphView: View {
    var amplitude: Double = 50
    var frequency: Double = 4
    
    private func cosFunc(_ x: Double) -> Double {
        amplitude * cos(frequency * x)
    }
    
    var body: some View {
        GraphShape(
            fn: { cosFunc($0) },
            steps: 150,
            range: 0...(2 * .pi)
        )
        .stroke(Color.blue,
                style: StrokeStyle(
                    lineWidth: 3,
                    lineCap: .round,
                    lineJoin: .round,
                    miterLimit: 10,
                    dash: [],
                    dashPhase: 0
                )
        )
    }
}

struct ParamSlider: View {
    var label: String
    var value: Binding<Double>
    var range: ClosedRange<Double>
    
    var body: some View {
        HStack {
            Text(label)
            Slider(value: value, in: range)
        }
    }
}

struct ContentView: View {
    @State var amplitude: Double = 50.0
    @State var frequency: Double = 4.0
    
    var body: some View {
        VStack {
            GraphView(amplitude: amplitude, frequency: frequency)
                .frame(width: 300, height: 150)
                .background(Color(red: 0.5, green: 0.5, blue: 0.5, opacity: 0.3))
            
            VStack {
                ParamSlider(label: "A", value: $amplitude, range: 0...70)
                ParamSlider(label: "k", value: $frequency, range: 1...10)
            }
        }
        .frame(width: 400, height: 500, alignment: .center)
    }
}


PlaygroundPage.current.setLiveView(ContentView())
