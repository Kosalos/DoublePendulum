import UIKit

//// used during development of screenRotated() layout routine to simulate other iPad sizes
//let scrnSz:[CGPoint] = [ CGPoint(x:768,y:1024), CGPoint(x:834,y:1112), CGPoint(x:1024,y:1366) ] // portrait 9.7, 10.5, 12.9" iPads
//let scrnIndex = 2
//let scrnLandscape:Bool = false

class QuartzView: UIView
{
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    override func draw(_ rect: CGRect) {
        UIColor.black.setFill()
        UIBezierPath(rect:rect).fill()
        
//        // development of layout for different size iPads
//        let xs = scrnLandscape ? scrnSz[scrnIndex].y : scrnSz[scrnIndex].x
//        let ys = scrnLandscape ? scrnSz[scrnIndex].x : scrnSz[scrnIndex].y
//        UIColor.gray.setFill()
//        UIBezierPath(rect:CGRect(x:0, y:0, width:xs, height:ys)).fill()

        pendulum.draw(UIGraphicsGetCurrentContext()!)
    }
}
