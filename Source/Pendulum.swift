import UIKit

// algorithm copied from: https://github.com/micaeloliveira/physics-sandbox/blob/feature/new-styling/assets/javascripts/pendulum.js

let MAX_TRAIL = Int(400)

class Pendulum
{
    var context:CGContext! = nil
    var redMarble:UIImage! = nil
    var blueMarble:UIImage! = nil
    var rect = CGRect()
    var anchor = CGPoint()
    var len1 = Float()
    var len2 = Float()
    var mass1 = Float()
    var mass2 = Float()
    var speed1 = Float()
    var speed2 = Float()
    var accel1 = Float()
    var accel2 = Float()
    var angle1 = Float()
    var angle2 = Float()
    var pos1 = CGPoint()
    var pos2 = CGPoint()
    let gravity = Float(9.8)
    var trail = Array(repeating:CGPoint(), count:MAX_TRAIL)
    var tIndex:Int = 0
    var tFull:Bool = false
    var c1 = CGPoint()
    var c2 = CGPoint()

    init(_ nrect:CGRect) {
        rect = nrect
        initialize()
    }
    
    func initialize() {
//        let xs = scrnLandscape ? scrnSz[scrnIndex].y : scrnSz[scrnIndex].x
//        let ys = scrnLandscape ? scrnSz[scrnIndex].x : scrnSz[scrnIndex].y
        
        anchor.x = rect.width/2
        anchor.y = 350
        
        redMarble = UIImage(named: "marbleRed.png")!
        blueMarble = UIImage(named: "marbleBlue.png")!
        reset()
    }
    
    func reset() {
        accel1 = 0
        accel2 = 0
        speed1 = 0
        speed2 = 0
        angle1 = 0
        angle2 = 2.3 * Float.pi / 2
        mass1 = 10
        mass2 = 10
        len1 = 150
        len2 = 150
        
        tIndex = 0
        tFull = false
    }
    
    let lenMin:Float = 20
    let lenMax:Float = 200
    let massMin:Float = 5
    let massMax:Float = 100
    let speedMin:Float = 0
    let speedMax:Float = 1
    
    func setMass1(_ ratio:Float) { mass1 = mix(massMin,massMax,ratio) }
    func setMass2(_ ratio:Float) { mass2 = mix(massMin,massMax,ratio) }
    func setLength1(_ ratio:Float) { len1 = mix(lenMin,lenMax,ratio) }
    func setLength2(_ ratio:Float) { len2 = mix(lenMin,lenMax,ratio) }
    func setSpeed1(_ ratio:Float) { speed1 = mix(speedMin,speedMax,ratio) }
    func setSpeed2(_ ratio:Float) { speed2 = mix(speedMin,speedMax,ratio) }
    
    func getMass1Ratio() -> Float { return unMix(massMin,massMax,mass1) }
    func getMass2Ratio() -> Float { return unMix(massMin,massMax,mass2) }
    func getLength1Ratio() -> Float { return unMix(lenMin,lenMax,len1) }
    func getLength2Ratio() -> Float { return unMix(lenMin,lenMax,len2) }
    func getSpeed1Ratio() -> Float { return unMix(speedMin,speedMax,speed1) }
    func getSpeed2Ratio() -> Float { return unMix(speedMin,speedMax,speed2) }

    func mix(_ min:Float, _ max:Float, _ ratio:Float) -> Float { return min + (max - min) * ratio }
    func unMix(_ min:Float, _ max:Float, _ value:Float) -> Float { return (value - min) / (max - min) }

    func update() {
        let mu:Float = 1 + mass1 / mass2
        let time:Float = 0.05
        let dAngle = angle1 - angle2
        let s1Sqr = speed1 * speed1
        let s2Sqr = speed2 * speed2
        
        accel1 = ( gravity
                    * ( sinf(angle2) * cosf(dAngle) - mu * sinf(angle1) )
                    - ( len2 * s2Sqr + len1 * s1Sqr * cosf(dAngle) )
                    * sinf(dAngle)
                 )
                 / (len1 * (mu - cosf(dAngle) * cosf(dAngle)))
 
        accel2 = ( mu * gravity
                    * ( sinf(angle1) * cosf(dAngle) - sinf(angle2) )
                    + ( mu * len1 * s1Sqr + len2 * s2Sqr * cosf(dAngle) )
                    * sinf(dAngle)
                 )
                 / (len2 * (mu - cosf(dAngle) * cosf(dAngle)))
        
        speed1 += accel1 * time
        speed2 += accel2 * time
        angle1 += speed1 * time
        angle2 += speed2 * time
        
        c1 = CGPoint(x: anchor.x + CGFloat(len1 * sinf(angle1))                      , y: anchor.y + CGFloat(len1 * cosf(angle1)))
        c2 = CGPoint(x: anchor.x + CGFloat(len1 * sinf(angle1) + len2 * sinf(angle2)), y: anchor.y + CGFloat(len1 * cosf(angle1) + len2 * cosf(angle2)))
        
        addTrail(c2)
    }
    
    func addTrail(_ pt:CGPoint) {
        trail[tIndex] = pt
        tIndex += 1
        if tIndex == MAX_TRAIL { tIndex = 0;  tFull = true }
    }
    
    func drawTrail() {
        var count:Int = tFull ? MAX_TRAIL : tIndex
        var color:CGFloat = 0
        let deltaColor = CGFloat(1) / CGFloat(count)
        
        var index = tIndex - count - 1
        if index < 0 { index += MAX_TRAIL }
        
        while true {
            count -= 1
            if count < 0 { break }
            
            index += 1
            if index >= MAX_TRAIL { index = 0 }

            context.setFillColor(UIColor(red:color, green:0, blue:0, alpha: 1).cgColor)
            color += deltaColor
            
            drawFilledRectangle(trail[index], 5)
        }
    }
    
    func drawLine(_ p1:CGPoint, _ p2:CGPoint) {
        context.beginPath()
        context.move(to:p1)
        context.addLine(to:p2)
        context.strokePath()
    }

    func drawFilledRectangle(_ center:CGPoint, _ sz:CGFloat) {
        context.beginPath()
        context.addRect(CGRect(x:CGFloat(center.x - sz/2), y:CGFloat(center.y - sz/2), width:sz, height:sz))
        context.fillPath()
    }

    func draw(_ ncontext:CGContext) {
        context = ncontext

        drawTrail()
        
        context.setLineWidth(5)
        context.setStrokeColor(UIColor.green.cgColor)
        drawLine(anchor,c1)
        drawLine(c1,c2)
        
        let sz1 = CGFloat(20 + mass1 / 4)
        let sz2 = CGFloat(20 + mass2 / 4)
        
        blueMarble.draw(in:CGRect(x:CGFloat(c1.x - sz1/2), y:CGFloat(c1.y - sz1/2), width:sz1, height:sz1))
         redMarble.draw(in:CGRect(x:CGFloat(c2.x - sz2/2), y:CGFloat(c2.y - sz2/2), width:sz2, height:sz2))
         redMarble.draw(in:CGRect(x:CGFloat(anchor.x - 8), y:CGFloat(anchor.y - 8), width:16, height:16))
    }
}

