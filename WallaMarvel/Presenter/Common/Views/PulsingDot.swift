import SwiftUI

/**
 `PulsingDot` uses Core Animation (`CALayer`) instead of SwiftUI-driven animations
 to keep the UI smooth in lists: no body re-renders per frame, low CPU/GPU cost, and
 reliable restart after window detach/attach (e.g., cell reuse/navigation).
 
 Animation: opacity 1→0 and scale 0.5→1 over `duration`, repeating.
 */
struct PulsingDot: UIViewRepresentable {
    let color: UIColor
    let baseDiameter: CGFloat
    let scale: CGFloat
    let duration: CFTimeInterval
    
    func makeUIView(context: Context) -> PulsingDotCore {
        PulsingDotCore(color: color,
                       baseDiameter: baseDiameter,
                       scale: scale,
                       duration: duration)
    }
    
    func updateUIView(_ uiView: PulsingDotCore, context: Context) {
        // Nothing to do: the animation runs in the CoreAnimation
    }
}

final class PulsingDotCore: UIView {
    private let dot = CALayer()
    private let baseDiameter: CGFloat
    private let scale: CGFloat
    private let duration: CFTimeInterval
    private let color: UIColor
    
    init(color: UIColor,
         baseDiameter: CGFloat,
         scale: CGFloat,
         duration: CFTimeInterval) {
        self.color = color
        self.baseDiameter = baseDiameter
        self.scale = scale
        self.duration = duration
        super.init(frame: .zero)
        
        layer.addSublayer(dot)
        dot.backgroundColor = color.cgColor
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dot.bounds = CGRect(x: 0, y: 0, width: baseDiameter, height: baseDiameter)
        dot.cornerRadius = baseDiameter / 2
        dot.position = CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    /// Restart CA animations when this SwiftUI-hosted view is reattached to a window.
    /// When a cell/view leaves the window, Core Animation removes its animations.
    /// `didMoveToWindow()` lets us stop on detach and (re)start on attach so the pulse resumes.
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        if window != nil && !UIAccessibility.isReduceMotionEnabled {
            startAnimationsIfNeeded()
        } else {
            stopAnimations()
        }
    }
    
    private func startAnimationsIfNeeded() {
        guard dot.animation(forKey: "opacityBlink") == nil else { return }
        
        // Opacity blink
        let opacity = CABasicAnimation(keyPath: "opacity")
        opacity.fromValue = 1
        opacity.toValue = 0
        opacity.duration = duration
        opacity.autoreverses = false
        opacity.repeatCount = .infinity
        
        // Pulse scale
        let pulse = CABasicAnimation(keyPath: "transform.scale")
        pulse.fromValue = 0.5
        pulse.toValue = 1
        pulse.duration = duration
        pulse.autoreverses = false
        pulse.repeatCount = .infinity
        
        dot.add(opacity, forKey: "opacityBlink")
        dot.add(pulse, forKey: "scalePulse")
    }
    
    private func stopAnimations() {
        dot.removeAllAnimations()
    }
}

private struct PulsingDotCorePreview: UIViewRepresentable {
    func makeUIView(context: Context) -> PulsingDotCore {
        PulsingDotCore(color: .systemGreen,
                       baseDiameter: 10,
                       scale: 1,
                       duration: 0.8)
    }
    func updateUIView(_ uiView: PulsingDotCore, context: Context) {}
}

struct PulsingDotCore_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PulsingDotCorePreview()
                .frame(width: 20, height: 20)
                .previewLayout(.sizeThatFits)
                .padding()
                .previewDisplayName("Light")
            
            PulsingDotCorePreview()
                .frame(width: 20, height: 20)
                .padding()
                .background(Color.black)
                .environment(\.colorScheme, .dark)
                .previewDisplayName("Dark")
        }
    }
}
