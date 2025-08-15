import SwiftUI

/**
 `CapsuleStrokeCA` uses Core Animation (`CAShapeLayer`) instead of SwiftUI-driven animations
 to keep the UI smooth in lists: no body re-renders per frame, low CPU/GPU cost, and
 reliable restart after window detach/attach (e.g., table/collection cell reuse/navigation).
 
 The animation:
 - Animate stroke 0→1 at alpha=1, hold 1s
 - Fade alpha from 1 to 0 in 0.3s, hold alpha at 0 for 0.5s
 - Restart alpha to 1 and stroke to 0 (stroke never reverses)
 
 Implemented with a repeating `CAAnimationGroup` for smooth, low-CPU rendering.
 */
struct CapsuleStrokeCA: UIViewRepresentable {
    var color: UIColor
    var lineWidth: CGFloat = 1
    var duration: CFTimeInterval = 1
    
    func makeUIView(context: Context) -> StrokeView {
        StrokeView(color: color, lineWidth: lineWidth, duration: duration)
    }
    func updateUIView(_ uiView: StrokeView, context: Context) {}
}

final class StrokeView: UIView {
    private let shape = CAShapeLayer()
    private let lineWidth: CGFloat
    private let color: UIColor
    private let duration: CFTimeInterval
    
    init(color: UIColor, lineWidth: CGFloat, duration: CFTimeInterval) {
        self.color = color
        self.lineWidth = lineWidth
        self.duration = duration
        
        super.init(frame: .zero)
        
        shape.fillColor = UIColor.clear.cgColor
        shape.strokeColor = color.cgColor
        shape.lineWidth = lineWidth
        shape.contentsScale = UIScreen.main.scale
        
        layer.addSublayer(shape)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let r = bounds.height / 2
        let path = UIBezierPath(roundedRect: bounds.insetBy(dx: lineWidth/2, dy: lineWidth/2),
                                cornerRadius: r)
        shape.path = path.cgPath
        shape.frame = bounds
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
    
    /// Animate stroke 0→1 at alpha=1, hold 1s. Then fade alpha from 1to 0 in 0.3s, hold  alpha at 0 for 0.5s
    /// then restart alpha to 1 and stroke to 0. Stroke never reverses;
    /// Implemented with a repeating CAAnimationGroup for smooth, low-CPU rendering.
    private func startAnimationsIfNeeded() {
        guard shape.animation(forKey: "stroke") == nil else { return }
        
        // Phase durations
        let grow: CFTimeInterval = duration      // stroke 0 → 1
        let hold: CFTimeInterval = 1.0           // hold at 1 (alpha 1)
        let fade: CFTimeInterval = 0.3           // alpha 1 → 0
        let zeroHold: CFTimeInterval = 0.5       // hold at alpha 0
        let total = grow + hold + fade + zeroHold
        
        // Stroke grows 0→1
        let strokeGrow = CABasicAnimation(keyPath: "strokeEnd")
        strokeGrow.fromValue = 0
        strokeGrow.toValue = 1
        strokeGrow.duration = grow
        
        // Stroke stays at 1 during hold + fade + zeroHold (no reverse)
        let strokeHold = CABasicAnimation(keyPath: "strokeEnd")
        strokeHold.fromValue = 1
        strokeHold.toValue = 1
        strokeHold.beginTime = grow
        strokeHold.duration = hold + fade + zeroHold
        
        // Opacity holds at 1 through grow+hold
        let opacityHold = CABasicAnimation(keyPath: "opacity")
        opacityHold.fromValue = 1
        opacityHold.toValue = 1
        opacityHold.duration = grow + hold
        
        // Opacity fades to 0 right after the hold
        let opacityFade = CABasicAnimation(keyPath: "opacity")
        opacityFade.fromValue = 1
        opacityFade.toValue = 0
        opacityFade.beginTime = grow + hold
        opacityFade.duration = fade
        
        // Opacity stays at 0 before restarting the cycle
        let opacityZeroHold = CABasicAnimation(keyPath: "opacity")
        opacityZeroHold.fromValue = 0
        opacityZeroHold.toValue = 0
        opacityZeroHold.beginTime = grow + hold + fade
        opacityZeroHold.duration = zeroHold
        
        // Group everything into a single looping animation
        let group = CAAnimationGroup()
        group.animations = [strokeGrow, strokeHold, opacityHold, opacityFade, opacityZeroHold]
        group.duration = total
        group.repeatCount = .infinity
        group.timingFunction = CAMediaTimingFunction(name: .linear)
        
        // Base layer state for the next cycle
        shape.strokeEnd = 0
        shape.opacity = 1
        
        shape.add(group, forKey: "stroke")
    }
    
    private func stopAnimations() {
        shape.removeAnimation(forKey: "stroke")
    }
}
