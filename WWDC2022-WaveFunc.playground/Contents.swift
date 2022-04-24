import SwiftUI
import PlaygroundSupport

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
            let screenY = rect.midY + p.y
            
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
    
    private func sinFunc(_ x: Double) -> Double {
        amplitude * sin(frequency * x)
    }
    
    var body: some View {
        GraphShape(
            fn: { sinFunc($0) },
            steps: 100,
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

struct ContentView: View {
    var body: some View {
        VStack {
            GraphView()
                .frame(width: 300, height: 150)
                .background(Color(red: 0.5, green: 0.5, blue: 0.5, opacity: 0.3))
        }
        .frame(width: 400, height: 500, alignment: .center)
    }
}


PlaygroundPage.current.setLiveView(ContentView())
