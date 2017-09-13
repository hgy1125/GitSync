import Cocoa
@testable import Utils
@testable import Element

extension GraphScrollerHandler{
    
    /**
     * This method is fired on each "scrollWheel change event" and "MoverGroup setProgressValue call-back"
     */
    func frameTick(){
        //Swift.print("frameTick \(moverGroup!.result.x)")
        //find cur 0 to 1 progress
        /*let totWidth = contentSize.width
         let maskWidth = maskSize.width
         let availableSpace = totWidth - maskWidth*/
        let x = moverGroup.result.x
        /*let progress = abs(x) / availableSpace
         Swift.print("progress: " + "\(progress)")*/
        /*print(ceil(334/100))
         print(ceil(300/100))*/
        
        /*
         let min:Int = ceil(abs(x)/100).int
         let right:CGFloat = abs(x)+(100*GraphX.config.vCount)
         let max:Int = floor(right/100).int
         
         let range:[CGFloat] = GraphAreaX.vValues!.slice2(min, max)
         
         let maxValue:CGFloat = range.max()!/*The max value in the current visible range*/
         _ = maxValue
         */
        
        //Swift.print("maxValue: " + "\(maxValue)")
        
        /*
         let size:CGSize = maskSize
         let points = GraphUtils.points(size, CGPoint(0,0), CGSize(100,100), range, maxValue,0,0)
         _ = points
         */
        
        let absX = abs(x)
        if absX >= prevX + 100 {/*only redraw at every 100px threshold*/
            //Swift.print("if x:\(x)")
            tick(x)
            prevX = absX
        }else if absX < prevX{
            //Swift.print("else if x: \(x)")
            tick(x)
            prevX = absX - 100
        }
    }
    /**
     * This method is only called on every 100th px threshold
     */
    private func tick(_ x:CGFloat){
        //Swift.print("Tick: \(x)")
        let minY = Utils.calcMinY(x: x, width: width, points:points)
        //Swift.print("⚠️️ minY: " + "\(minY))")
        if let prevMinY = self.prevMinY, prevMinY != minY {/*Skips anim if the graph doesn't need to scale*/
            initAnim()/*Initiates the animation*/
        }
        self.prevMinY = minY//set the prev anim
    }
}

/**
 * Animation related
 */
extension GraphScrollerHandler {
    //var points:[CGPoint] {get{return graphArea.points}set{graphArea.points = newValue}}
    /**
     * Initiates the animation sequence
     * NOTE: this method can be called in quick sucession as it stops any ongoing animation before it is started
     */
    func initAnim(){
        Swift.print("initAnim")
        /*if(animator != nil){
         animator?.stop()
         animator = nil
         }*/
        //prevPoints = points/*basically use newPoints if they exist or default points if not*/
        let x = moverGroup.result.x
        let minY = Utils.calcMinY(x:x, width:width, points:points)
        let ratio = Utils.calcRatio(x: x, minY: minY, height: height)
        Swift.print("ratio: " + "\(ratio)")
        //newPoints = calcScaledPoints(ratio)/*calc where the new points should go*/
        /*Setup interuptable animator*/
        //animator = Animator(Animation.sharedInstance,2.0,0,1,interpolateValue,Elastic.easeOut)
        
        if animator == nil {//upgrade to latest anim lib ⚠️️
            let initValues:NumberSpringer.InitValues = (value:1,targetValue:ratio,velocity:0,stopVelocity:0)
            animator = NumberSpringer(interpolateValue, initValues,NumberSpringer.initConfig)/*Anim*/
        }
        animator?.targetValue = ratio
        if animator!.stopped {animator!.start()}
        
        /*
         if(animator == nil){
         Swift.print("Start anim")
         prevPoints = points//basically use newPoints if they exist or default points if not
         let x = moverGroup!.result.x
         let minY = calcMinY(x)
         newPoints = calcScaledPoints(x,minY)
         animator = Animator(Animation.sharedInstance,2.0,0,1,interpolateValue,Elastic.easeOut)
         animator?.start()
         animator?.event = self.onAnimEvent
         }else{
         Swift.print("add animation que")
         animationCue = Animator(Animation.sharedInstance,2.0,0,1,interpolateValue,Elastic.easeOut)
         }
         */
    }
    /*
     func onAnimEvent(_ event:Event)  {
     if event.type == AnimEvent.completed {
     Swift.print("Animation completed")
     animator = nil
     if let animationCue = self.animationCue{
     Swift.print("start queued anim")
     animator = animationCue
     let x = moverGroup!.result.x
     let minY = calcMinY(x)
     prevPoints = points//we asign the start points to interpolate from
     newPoints = calcScaledPoints(x,minY)
     animator?.start()
     animator?.event = self.onAnimEvent
     self.animationCue = nil//remove item from anim cue
     }
     }
     }
     */
    /**
     * Interpolates between 0 and 1 while the duration of the animation
     * NOTE: ReCalc the hValue indicators (each graph range has a different max hValue etc)
     */
    private func interpolateValue(_ val:CGFloat){
        //Swift.print("val: " + "\(val)")
        /*newPoints!.forEach{
         //Swift.print("$0: " + "\($0)")
         graphPoint2!.point = $0
         }*/
        var positions:[CGPoint] = []
        positions = Utils.calcScaledPoints(points: points, ratio: val, height: height)
        /*GraphPoints*/
        /*
         for i in 0..<newPoints!.count{
         let pos:CGPoint = prevPoints![i].interpolate(newPoints![i], val)/*interpolates from one point to another*/
         positions.append(pos)
         }
         */
        //points = positions
        //let path:IPath = PolyLineGraphicUtils.path(positions)/*Compiles a path that conceptually is a polyLine*/
        //graphLine!.line!.cgPath = CGPathUtils.compile(CGMutablePath(), path)/*Converts the path to a cgPath*/
        graphArea.graphLine.line!.cgPath = CGPathParser.polyLine(positions)
        
        //⚠️️ no need to disable anim ⚠️️
        
        //        disableAnim{
        graphArea.graphLine.line!.draw() /*draws the path*///TODO: ⚠️️ it draws the entire path I think, we really only need the portion that is visible
        fatalError("out of order uncomment the bellow")
//        for (i,obj) in graphArea.graphDots.enumerated() {
//            obj.layer?.position = positions[i]//positions the graphDots
//        }
        //        }
    }
    /**
     * TODO: ⚠️️ Comment this method
     */
    func setProgressValue(_ value:CGFloat, _ dir:Dir){/*gets called from MoverGroup*/
        if dir == .hor {
            //Swift.print("🍏 GraphScrollable.setProgressValue .hor: \(value)")
            frameTick()
            (self as Elastic5).setProgress(value, dir)//was ElasticScrollable5
        }
    } 
}
/**
 * utilities related
 */
private class Utils{
    /**
     * New
     */
    static func calcRatio( x:CGFloat, minY:CGFloat, height:CGFloat) -> CGFloat{
        //let dist:CGFloat = 400.cgFloat.distance(to: minY)
        let diff:CGFloat = height + (-1 * minY)/*Since graphs start from the bottom we need to flip the y coordinates*/
        let ratio:CGFloat = height / diff/*Now that we have the flipped y coordinate we can get the ratio to scale all other points with */
        return ratio
    }
    /**
     * New
     */
    static func calcScaledPoints(points:[CGPoint], ratio:CGFloat, height:CGFloat) -> [CGPoint]{
        let scaledPoints = points.map{CGPointModifier.scale($0/*<--point to scale*/, CGPoint($0.x,height)/*<--pivot*/, CGPoint(1,ratio)/*<--Scalar ratio*/)}
        return scaledPoints
    }
    /**
     * New
     */
    static func calcMinY(x:CGFloat, width:CGFloat, points:[CGPoint]) -> CGFloat{
        let x1:CGFloat = -1 * x/*Here we flip the x to be positive*/
        let x2:CGFloat = (-1 * x) + width
        /**/
        let minX:CGFloat = x1/*The begining of the current visible graph*/
        let maxX:CGFloat = x2/*The end of the visible range*/
        let minY:CGFloat = self.minY(minX:minX,maxX:maxX,points:points)/*Returns the smallest Y value in the visible range*/
        return minY
    }
    /**
     * Returns minY for the visible graph
     * NOTE: The visible graph is the portion of the graph that is visible at any given progression.
     * PARAM: minX: The begining of the current visible graph
     * PARAM: maxX: The end of the visible range
     */
    static func minY(minX:CGFloat,maxX:CGFloat,points:[CGPoint]) -> CGFloat {
        let yValuesWithinMinXAndMaxX:[CGFloat] = points.filter{$0.x >= minX && $0.x <= maxX}.map{$0.y}/*We gather the points within the current minX and maxX*/
        return (yValuesWithinMinXAndMaxX).min()!
    }
}
