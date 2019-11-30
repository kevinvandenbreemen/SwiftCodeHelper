import DisplayLogic

class ModelRectConfig {

    internal private(set) var pointer: UnsafeMutablePointer<model_rect_config>

    var glyphWidth: Int32 {
        didSet {
            pointer.pointee.glyphWidth = glyphWidth
        }
    }

    var glyphHeight: Int32 {
        didSet {
            pointer.pointee.glythHeight = glyphHeight
        }
    }

    var minDistanceBetweenBoxesHorizontal: Int32 {
        didSet {
            pointer.pointee.minHorizDistanceBetweenRects = minDistanceBetweenBoxesHorizontal
        }
    }
    
    init() {
        self.pointer = model_arrangement_model_rect_config_create()!
        self.glyphWidth = 30
        self.glyphHeight = 40
        self.minDistanceBetweenBoxesHorizontal = 10
    }

    deinit {
        model_arrangement_model_rect_config_destroy(pointer)
    }
    

}