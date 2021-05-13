import CoreGraphics

extension CGAffineTransform {

    internal static func flipped(height: CGFloat) -> CGAffineTransform {
        let mirror = CGAffineTransform(scaleX: 1, y: -1)
        let translate = CGAffineTransform(translationX: 0, y: height)
        return mirror.concatenating(translate)
    }

}
