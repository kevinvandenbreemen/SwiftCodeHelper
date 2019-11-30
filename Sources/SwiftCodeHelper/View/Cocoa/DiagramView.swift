import Cacao
import Foundation
import DisplayLogic
import Logging

class DiagramView: UIView {

    private var logger: Logger

    private let model: SystemModel

    override var intrinsicContentSize: CGSize {
        CGSize.init(width: 1000, height: 1000)
    }

    init(frame: CGRect, model: SystemModel) {

        self.model = model
        self.logger = Logger.init(label: "cocoa.DiagramView")
        self.logger.logLevel = .debug

        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        self.backgroundColor = .clear
        self.frame.size = CGSize.init(width: 1000, height: 1000)

        
    }

    override func draw(_ rect: CGRect) {

        logger.debug("Drawing the model...")

        let modelArrangementHead: UnsafeMutablePointer<model_arrangement_rect_node> = model_arrangement_new_rect_node()
        var modelArrangementCurrent = modelArrangementHead
        var previousArrangementNode: UnsafeMutablePointer<model_arrangement_rect_node>? = nil

        let classConfig = ModelRectConfig()
        classConfig.glyphHeight = 60
        classConfig.glyphWidth = 30
        classConfig.minDistanceBetweenBoxesHorizontal = 10

        model.classes.forEach{ clz in 

            let typeName = UnsafeMutablePointer<CChar>(mutating: clz.name)
            guard let dimensionsRect = model_arrangement_computeRectDimensionsFor(typeName, classConfig.pointer) else {
                logger.error("Failed to compute rect for type \(typeName)")
                return
            }
            
            if logger.logLevel == .debug {
                print("Dim Rect [\(clz.name)]=\(dimensionsRect.pointee)")
            }
            
            modelArrangementCurrent.pointee.rect = dimensionsRect

            guard let next = model_arrangement_new_rect_node() else {
                logger.error("Failed to create storage node")
                return
            }
            modelArrangementCurrent.pointee.next = next
            previousArrangementNode = modelArrangementCurrent
            modelArrangementCurrent = next

        }

        if let nodeBeforeLast = previousArrangementNode {
            nodeBeforeLast.pointee.next = nil
        }

        model_arrangement_ArrangeRectangles(modelArrangementHead)

        //  Convert the queue to an array
        var currentModelArrangementNode : model_arrangement_rect_node? = modelArrangementHead.pointee
        var modelArrangementRects: [model_arrangement_rect] = []
        repeat {
            if let currentNode = currentModelArrangementNode {
                modelArrangementRects.append(currentNode.rect.pointee)

                if let nextPointer = currentNode.next {
                    currentModelArrangementNode = nextPointer.pointee
                } else {
                    currentModelArrangementNode = nil
                }
            }
        } while currentModelArrangementNode != nil

        if logger.logLevel == .debug {
            logger.debug("Got \(modelArrangementRects)")
        }
        
        var clzIndex = 0
        modelArrangementRects.forEach{ rect in 
            logger.debug("Trying to create labelled box")
            guard let lbr:model_arrangement_rect = rect.label_rect.pointee else {
                return
            }

            let classRect = CGRect.init(x: CGFloat(rect.x), y: CGFloat(rect.y), width: CGFloat(rect.width), height: CGFloat(rect.height))
            let classLabelRect = CGRect.init(x: CGFloat(lbr.x), y: CGFloat(lbr.y), width: CGFloat(lbr.width), height: CGFloat(lbr.height))
            let classBox = UIBezierPath.init(rect: classRect)
            classBox.lineWidth = 2.0
            classBox.stroke()
            
            let label = UILabel.init(frame: classLabelRect)
            label.text = model.classes[clzIndex].name
            label.font = FontHelper.font(for: .consolas, size: 40)
            addSubview(label)

            clzIndex += 1

        }

        // let littleRectangle = CGRect.init(x: rect.origin.x + 10, y: rect.origin.y + 10, width: 100, height: 100)

        

        // let path = UIBezierPath(rect: rect)
        // UIColor.green.setFill()
        // path.fill()

        // let littlePath = UIBezierPath.init(rect: littleRectangle)
        // littlePath.lineWidth = CGFloat(6.0)
        // littlePath.stroke()

        // let textRect = CGRect.init(x: rect.origin.x + 200, y: rect.origin.y+10, width: 200, height: 40)
        // let label = UILabel.init(frame: textRect)
        // label.text = "Test Label"
        // addSubview(label)

        // UIColor.red.setStroke()
        // let littleLineMaker = UIBezierPath()
        // littleLineMaker.move(to: textRect.origin)
        // littleLineMaker.addLine(to: littleRectangle.origin)
        // littleLineMaker.lineWidth = 2
        // littleLineMaker.stroke()

    }
    

}