//
//  ViewController.swift
//  RulAR
//
//  Created by Michael Cangcianno on 7/26/18.
//  Copyright © 2018 Michael Cangcianno. All rights reserved.
//

import UIKit
import ARKit

class MyARCamera: UIViewController, ARSCNViewDelegate {
    var isVertical = false
    
    @IBOutlet weak var previewButton: UIButton!
    @IBOutlet weak var PreviewBoard: UIView!
    @IBOutlet weak var previewButtonLabel: UILabel!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is ImagePreviewController
        {
            let vc = segue.destination as? ImagePreviewController
            vc?.coordinates = coordinates
            vc?.lengths = lengths
            vc?.area = areaValue
        }
    }
    
    @IBOutlet weak var PreviewImage: UIImageView!
    @IBOutlet weak var sceneView: ARSCNView!
    
    // planes
    var dictPlanes = [ARPlaneAnchor: Plane]()
    
    // distance label
    
    var coordinates: [SCNVector3] = []
    var areaValue: Float = 0
    var lengths: [Float] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        previewButton.isHidden = true
        previewButtonLabel.isHidden = true
        // setup scene
        self.setupScene()
    }
    
    // setup scene
    func setupScene()
    {
        // set delegate - ARSCNViewDelegate
        self.sceneView.delegate = self
        
        // showing statistics (fps, timing info)
        self.sceneView.autoenablesDefaultLighting = true
        
        // debug points
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        // create new scene
        let scene = SCNScene()
        self.sceneView.scene = scene
        
    }
    
    // start node
    var startNode: SCNNode?
    var secondNode: Bool = false
    var endNode: SCNVector3?
    var beginningPoint: SCNVector3?
    var measuringMode: Bool = true
    
    //MARK: - Action
    @IBOutlet weak var areaText: UILabel!
    @IBAction func resetMeasure(_ sender: UIButton) {
        startNode = nil
        endNode = nil
        beginningPoint = nil
        secondNode = false
        sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
            node.removeFromParentNode() }
        measuringMode = true
        coordinates = []
        lengths = []
        PreviewImage.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
    }
    @IBAction func FinishedMeasuring(_ sender: UIButton) {
        previewButton.isHidden = false
        previewButtonLabel.isHidden = false
        measuringMode = false
        self.lineToEnd?.removeFromParentNode()
        self.line_node?.removeFromParentNode()
        guard let start = self.startNode,
            let endingNode = self.beginningPoint else {
                return
        }
        
        self.line_node = self.getDrawnLineFrom(pos1: endingNode,
                                               toPos2: start.position)
        self.sceneView.scene.rootNode.addChildNode(self.line_node!)
        let firstPointToPrev = start.position
        let toBeMadePoint = endingNode
        
        let position = SCNVector3Make(toBeMadePoint.x - firstPointToPrev.x, toBeMadePoint.y - firstPointToPrev.y, toBeMadePoint.z - firstPointToPrev.z)
        
        let result = sqrt(position.x*position.x + position.z*position.z)
        
        let centerPoint = SCNVector3((firstPointToPrev.x+toBeMadePoint.x)/2,(firstPointToPrev.y+toBeMadePoint.y)/2,(firstPointToPrev.z+toBeMadePoint.z)/2)
        
        self.displayText(distance: result, position: centerPoint)
        self.lengths.append(result)
//        print("here!", self.lengths)
        // self.drawPreview()
    }
    @IBAction func onAddButtonClick(_ sender: UIButton) {
        let startPoint = startNode
        if measuringMode == true {
            if let position = self.doHitTestOnExistingPlanes() {
                // add node at hit-position
                let node = self.nodeWithPosition(position)
                sceneView.scene.rootNode.addChildNode(node)
                // set start node
                startNode = node

                coordinates.append((startNode?.position)!)
                
                if secondNode == true{
                    guard let currentPosition = endNode,
                        let start = startPoint else {
                            return
                    }
                    
                    if (isVertical) {
                        createPreviewVertical()
                        areaValue = calculateAreaVertical(coordinates)
                    } else {
                        createPreviewHorizontal()
                        areaValue = calculateAreaHorizontal(coordinates)
                    }
                    
                    areaText.text = "Area: \(((areaValue*10000).rounded())/10000)m2"
                    
                    // line-node
                    self.line_node = self.getDrawnLineFrom(pos1: currentPosition,
                                                           toPos2: start.position)
                    
                    sceneView.scene.rootNode.addChildNode(self.line_node!)
                    
                    let firstPointToPrev = start.position
                    let toBeMadePoint = currentPosition
                    
                    let position = SCNVector3Make(toBeMadePoint.x - firstPointToPrev.x, toBeMadePoint.y - firstPointToPrev.y, toBeMadePoint.z - firstPointToPrev.z)
                    
                    let length = sqrt(powf(position.x, 2.0) + powf(position.z, 2.0))
                    
                    let centerPoint = SCNVector3((firstPointToPrev.x + toBeMadePoint.x)/2,(firstPointToPrev.y + toBeMadePoint.y)/2,(firstPointToPrev.z + toBeMadePoint.z)/2)
                    
                    self.displayText(distance: length, position: centerPoint)
                    self.lengths.append(length)
                    
                    
                    //trying to make preview
//                     self.drawPreview()

                    
                    // line-node
                    self.line_node = self.getDrawnLineFrom(pos1: currentPosition,
                                                           toPos2: start.position)
                    
                    sceneView.scene.rootNode.addChildNode(self.line_node!)
                    
                } else {
                    beginningPoint = startNode?.position
                }
            }
            if secondNode == false {
                secondNode = true
            }
        }
    }
    
    func createPreviewHorizontal() {
        let minX = coordinates.min { a, b in a.x < b.x }?.x
        let minY = coordinates.min { a, b in a.z < b.z }?.z
        let maxX = (coordinates.max { a, b in a.x < b.x }?.x)! - minX!
        let maxY = (coordinates.max { a, b in a.z < b.z }?.z)! - minY!
        
        PreviewImage.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        let shape = CAShapeLayer()
        PreviewImage.layer.addSublayer(shape)
        shape.opacity = 0.5
        shape.lineWidth = 2
        shape.lineJoin = kCALineJoinMiter
        shape.strokeColor = UIColor(hue: 0.786, saturation: 0.79, brightness: 0.53, alpha: 1.0).cgColor
        shape.fillColor = UIColor(hue: 0.786, saturation: 0.15, brightness: 0.89, alpha: 1.0).cgColor
        
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: (Int(((coordinates[0].x - minX!) * 138 / maxX).rounded())), y: Int(((coordinates[0].z - minY!) * 128 / maxY).rounded())))
        
        for coordinate in coordinates {
            print("x: \((Int(((coordinate.x - minX!) * 138 / maxX).rounded()))), y: \((Int(((coordinate.z - minY!) * 128 / maxY).rounded())))")
            path.addLine(to: CGPoint(x: (Int(((coordinate.x - minX!) * 138 / maxX).rounded())), y: (Int(((coordinate.z - minY!) * 128 / maxY).rounded()))))
            
        }
        
        path.close()
        shape.path = path.cgPath
    }
    
    func createPreviewVertical() {
        let minX = coordinates.min { a, b in a.x < b.x }?.x
        let minY = coordinates.min { a, b in a.y < b.y }?.y
        let maxX = (coordinates.max { a, b in a.x < b.x }?.x)! - minX!
        let maxY = (coordinates.max { a, b in a.y < b.y }?.y)! - minY!
        
        PreviewImage.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        let shape = CAShapeLayer()
        PreviewImage.layer.addSublayer(shape)
        shape.opacity = 0.5
        shape.lineWidth = 2
        shape.lineJoin = kCALineJoinMiter
        shape.strokeColor = UIColor(hue: 0.786, saturation: 0.79, brightness: 0.53, alpha: 1.0).cgColor
        shape.fillColor = UIColor(hue: 0.786, saturation: 0.15, brightness: 0.89, alpha: 1.0).cgColor
        
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: Int(((coordinates[0].x - minX!) * 138 / maxX).rounded()), y: 128 - Int(((coordinates[0].y - minY!) * 128 / maxY).rounded())))
        
        for coordinate in coordinates {
            print("x: \((Int(((coordinate.x - minX!) * 138 / maxX).rounded()))), y: \((Int(((coordinate.y - minY!) * 128 / maxY).rounded())))")
            path.addLine(to: CGPoint(x: Int(((coordinate.x - minX!) * 138 / maxX).rounded()), y: 128 - Int(((coordinate.y - minY!) * 128 / maxY).rounded())))
            
        }
        
        path.close()
        shape.path = path.cgPath
    }
    
    func calculateAreaHorizontal(_ coordinates: [SCNVector3]) -> Float {
        var area: Float = 0
        var coordinateTwo: SCNVector3 = coordinates.last!
        
        for coordinate in coordinates {
            area += (coordinate.x * coordinateTwo.z)
            area -= (coordinate.z * coordinateTwo.x)
            coordinateTwo = coordinate
        }
        
        return abs(area * 100 / 2)
    }
    
    func calculateAreaVertical(_ coordinates: [SCNVector3]) -> Float {
        var area: Float = 0
        var coordinateTwo: SCNVector3 = coordinates.last!
        
        for coordinate in coordinates {
            area += (coordinate.x * coordinateTwo.y)
            area -= (coordinate.y * coordinateTwo.x)
            coordinateTwo = coordinate
        }
        
        return abs(area * 100 / 2)
    }
    
    func doHitTestOnExistingPlanes() -> SCNVector3? {
        // hit-test of view's center with existing-planes
        let results = sceneView.hitTest(view.center,
                                        types: .existingPlaneUsingExtent)
        // check if result is available
        if let result = results.first {
            // get vector from transform
            let hitPos = self.positionFromTransform(result.worldTransform)
            return hitPos
        }
        return nil
    }
    
    // get position 'vector' from 'transform'
    func positionFromTransform(_ transform: matrix_float4x4) -> SCNVector3 {
        return SCNVector3Make(transform.columns.3.x,
                              transform.columns.3.y,
                              transform.columns.3.z)
    }
    
    // add dot node with given position
    func nodeWithPosition(_ position: SCNVector3) -> SCNNode {
        // create sphere geometry with radius
        let sphere = SCNSphere(radius: 0.003)
        // set color
        sphere.firstMaterial?.diffuse.contents = UIColor(red: 255.0/255.0,
                                                         green: 255.0/255.0,
                                                         blue: 255.0/255.0,
                                                         alpha: 1)
        // set lighting model
        sphere.firstMaterial?.lightingModel = .constant
        sphere.firstMaterial?.isDoubleSided = true
        // create node with 'sphere' geometry
        let node = SCNNode(geometry: sphere)
        node.position = position
        
        return node
    }
    
    func saveLine () -> SCNNode {
        let wideLine = SCNBox(width: 0.02, height: 0.02, length: 0.1, chamferRadius: 0.01)
        
        wideLine.firstMaterial?.diffuse.contents = UIColor(red: 255/255.0,
                                                         green: 255/255.0,
                                                         blue: 255/255.0,
                                                         alpha: 1)
        
        wideLine.firstMaterial?.lightingModel = .constant
        wideLine.firstMaterial?.isDoubleSided = true
        let node = SCNNode(geometry: wideLine)
        
        return node
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // set up session
        self.setupARSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // setup AR Session
    func setupARSession()
    {
        // create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // set to detect horizontal planes
        
        if (isVertical) {
            configuration.planeDetection = .vertical
        } else {
            configuration.planeDetection = .horizontal
        }
        
        // run the configuration
        self.sceneView.session.run(configuration)
    }
    
    // MARK: - ARSCNViewDelegate
    
    // line-node
    var line_node: SCNNode?
    var desc: String?
    var centimeterVal: Float?
    var lineToEnd: SCNNode?
    
    // renderer callback method
    func renderer(_ renderer: SCNSceneRenderer,
                  updateAtTime time: TimeInterval) {
        
        if self.measuringMode == true{
            DispatchQueue.main.async {
                // get current hit position
                // and check if start-node is available
                guard let currentPosition = self.doHitTestOnExistingPlanes(),
                    let start = self.startNode,
                    let beginningNode = self.beginningPoint else {
                        return
                }
                
                self.endNode = currentPosition
                
                // line-node
                self.lineToEnd?.removeFromParentNode()
                self.line_node?.removeFromParentNode()
                self.lineToEnd = self.getDrawnLineFrom(pos1: currentPosition, toPos2: beginningNode)
                self.line_node = self.getDrawnLineFrom(pos1: currentPosition,
                                                       toPos2: start.position)
                
                self.sceneView.scene.rootNode.addChildNode(self.line_node!)
                self.sceneView.scene.rootNode.addChildNode(self.lineToEnd!)
                
            }
        }
    }
    
    private func displayText(distance: Float,position :SCNVector3) {
        
        let roundedDist = ((distance*100).rounded())/100
        
        let textGeo = SCNText(string: "\(roundedDist) m", extrusionDepth: 1.0)
        textGeo.firstMaterial?.diffuse.contents = UIColor.black
        
        let textNode = SCNNode(geometry: textGeo)
        
        textNode.position = position
        
        if (isVertical) {
            textNode.rotation = SCNVector4(0,0,0,Double.pi)
        } else {
            textNode.rotation = SCNVector4(1,0,0,-Double.pi/2)
        }
        
        textNode.scale = SCNVector3(0.002,0.002,0.002)
        
        for material in (textNode.geometry?.materials)! {
            material.lightingModel = .constant
            material.diffuse.contents = UIColor.white
            material.isDoubleSided = false
        }
        
        self.sceneView.scene.rootNode.addChildNode(textNode)
    }
    
    //creating preview
    func drawPreview() {
        let minX = coordinates.min { a, b in a.x < b.x }?.x
        let minY = coordinates.min { a, b in a.z < b.z }?.z
        let maxX = (coordinates.max { a, b in a.x < b.x }?.x)! - minX!
        let maxY = (coordinates.max { a, b in a.z < b.z }?.z)! - minY!
        
        PreviewBoard.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        let shape = CAShapeLayer()
        PreviewBoard.layer.addSublayer(shape)
        shape.opacity = 0.5
        shape.lineWidth = 2
        shape.lineJoin = kCALineJoinMiter
        shape.strokeColor = UIColor(hue: 0.786, saturation: 0.79, brightness: 0.53, alpha: 1.0).cgColor
        shape.fillColor = UIColor(hue: 0.786, saturation: 0.15, brightness: 0.89, alpha: 1.0).cgColor
        
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: (Int(((coordinates[0].x - minX!) * 138 / maxX).rounded())), y: Int(((coordinates[0].z - minY!) * 128 / maxY).rounded())))
        
        var centerCoor: CGPoint
        var centerXText: Float
        var centerYText: Float
        
        centerXText = (((coordinates[0].x - minX!) + (coordinates[1].x - minX!))) * 128
        centerYText = (((coordinates[0].z - minY!) + (coordinates[1].z - minY!))) * 138
        
        centerCoor = CGPoint(x: Int((centerXText / maxX)+50)/2, y: Int((centerYText / maxY)+5)/2)

        
        let myTextLayer = CATextLayer()
        myTextLayer.string = "\((lengths[0]*100).rounded()/100)m"
        myTextLayer.foregroundColor = UIColor.cyan.cgColor
        myTextLayer.frame = CGRect(x:0.0,y:0.0,width:100,height:10)
        myTextLayer.position = centerCoor
        print(myTextLayer.frame)
        myTextLayer.fontSize = 10.0
        print(myTextLayer.position)
        PreviewBoard.layer.addSublayer(myTextLayer)
        
        for (index, coordinate) in coordinates.enumerated() {
            print("x: \((Int(((coordinate.x - minX!) * 138 / maxX).rounded()))), y: \((Int(((coordinate.z - minY!) * 128 / maxY).rounded())))")
            path.addLine(to: CGPoint(x: (Int(((coordinate.x - minX!) * 138 / maxX).rounded())), y: (Int(((coordinate.z - minY!) * 128 / maxY).rounded()))))
            
            if coordinates.count > 2 && index > 1 {
                
                centerXText = (((coordinate.x - minX!) + (coordinates[index-1].x - minX!))) * 138
                centerYText = (((coordinate.z - minY!) + (coordinates[index-1].z - minY!))) * 128
                
                centerCoor = CGPoint(x: Int((centerXText / maxX)+50)/2, y: Int((centerYText / maxY)+5)/2)
                
                print("center", centerCoor)
                
                let myTextLayer = CATextLayer()
                myTextLayer.string = "\((lengths[index-1]*100).rounded()/100)m"
                myTextLayer.foregroundColor = UIColor.cyan.cgColor
                myTextLayer.frame = CGRect(x:0.0,y:0.0,width:100,height:10)
                myTextLayer.position = centerCoor
                myTextLayer.fontSize = 10.0
                PreviewBoard.layer.addSublayer(myTextLayer)
            }
            
            if index == coordinates.count-1 && measuringMode == false {
                centerXText = (((coordinates[0].x - minX!) + (coordinates[coordinates.count-1].x - minX!))) * 138
                centerYText = (((coordinates[0].z - minY!) + (coordinates[coordinates.count-1].z - minY!))) * 128
                    
                centerCoor = CGPoint(x: Int((centerXText / maxX)+50)/2, y: Int((centerYText / maxY)+5)/2)
                print("center",centerCoor)
                let myTextLayer = CATextLayer()
                myTextLayer.string = "\((lengths[index]*100).rounded()/100)m"
                myTextLayer.foregroundColor = UIColor.cyan.cgColor
                myTextLayer.frame = CGRect(x:0.0,y:0.0,width:100,height:10)
                myTextLayer.position = centerCoor
                myTextLayer.fontSize = 10.0
                PreviewBoard.layer.addSublayer(myTextLayer)
            }
            
            
        }
        path.close()
        shape.path = path.cgPath

    }
    
    // draw line-node between two vectors
    func getDrawnLineFrom(pos1: SCNVector3,
                          toPos2: SCNVector3) -> SCNNode {
        
        let line = lineFrom(vector: pos1, toVector: toPos2)
        
        for material in line.materials {
            material.lightingModel = .constant
            material.diffuse.contents = UIColor.white
            material.isDoubleSided = false
        }
        
        let lineInBetween1 = SCNNode(geometry: line)
        return lineInBetween1
        
    }
    
    // get line geometry between two vectors
    func lineFrom(vector vector1: SCNVector3,
                  toVector vector2: SCNVector3) -> SCNGeometry {
        
        let indices: [Int32] = [0, 1]
        let source = SCNGeometrySource(vertices: [vector1, vector2])
        let element = SCNGeometryElement(indices: indices,
                                         primitiveType: .line)
        return SCNGeometry(sources: [source], elements: [element])
    }
    
    /**
     Distance string
     */
    func getDistanceStringBeween(pos1: SCNVector3?,
                                 pos2: SCNVector3?) -> String {
        
        if pos1 == nil || pos2 == nil {
            return "0"
        }
        let d = self.distanceBetweenPoints(A: pos1!, B: pos2!)
        
        var result = ""
        
        let meter = stringValue(v: Float(d), unit: "meters")
        result.append(meter)
        result.append("\n")
        
        let f = self.foot_fromMeter(m: Float(d))
        let feet = stringValue(v: Float(f), unit: "feet")
        result.append(feet)
        result.append("\n")
        
        let inch = self.Inch_fromMeter(m: Float(d))
        let inches = stringValue(v: Float(inch), unit: "inch")
        result.append(inches)
        result.append("\n")
        
        let cm = self.CM_fromMeter(m: Float(d))
        let cms = stringValue(v: Float(cm), unit: "cm")
        result.append(cms)
        
        return result
    }
    
    /**
     Distance between 2 points
     */
    func distanceBetweenPoints(A: SCNVector3, B: SCNVector3) -> CGFloat {
        let l = sqrt(
            (A.x - B.x) * (A.x - B.x)
                +   (A.y - B.y) * (A.y - B.y)
                +   (A.z - B.z) * (A.z - B.z)
        )
        return CGFloat(l)
    }
    
    /**
     String with float value and unit
     */
    func stringValue(v: Float, unit: String) -> String {
        let s = String(format: "%.1f %@", v, unit)
        return s
    }
    
    /**
     Inch from meter
     */
    func Inch_fromMeter(m: Float) -> Float {
        let v = m * 39.3701
        return v
    }
    
    /**
     centimeter from meter
     */
    func CM_fromMeter(m: Float) -> Float {
        let v = m * 100.0
        return v
    }
    
    /**
     feet from meter
     */
    func foot_fromMeter(m: Float) -> Float {
        let v = m * 3.28084
        return v
    }
    
    /**
     Called when a new node has been mapped to the given anchor.
     */
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        print("--> did add node")
        
        DispatchQueue.main.async {
            if let planeAnchor = anchor as? ARPlaneAnchor {
                
                // create plane with the "PlaneAnchor"
                let plane = Plane(anchor: planeAnchor)
                // add to the detected
                node.addChildNode(plane)
                // add to dictionary
                self.dictPlanes[planeAnchor] = plane
            }
        }
    }
    
    /**
     Called when a node will be updated with data from the given anchor.
     */
    func renderer(_ renderer: SCNSceneRenderer, willUpdate node: SCNNode, for anchor: ARAnchor) { }
    
    /**
     Called when a node has been updated with data from the given anchor.
     */
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async {
            if let planeAnchor = anchor as? ARPlaneAnchor {
                // get plane with anchor
                let plane = self.dictPlanes[planeAnchor]
                // update
                plane?.updateWith(planeAnchor)
            }
        }
    }
    
    /**
     Called when a mapped node has been removed from the scene graph for the given anchor.
     */
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        
        if let planeAnchor = anchor as? ARPlaneAnchor {
            self.dictPlanes.removeValue(forKey: planeAnchor)
        }
    }

    
//    @IBAction func forPreviewButton(_ sender: Any) {
//        let goToPreview = self.storyboard?.instantiateViewController(withIdentifier: "previewModel") as! ImagePreviewController
//        let previewSecene = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "previewModel") as! ImagePreviewController;
//        print("toPreview",goToPreview)
//        print("toPreview2", previewSecene)
//        
//        self.navigationController?.pushViewController(previewSecene, animated: false)
//        self.dismiss(animated: true, completion: nil)
//    }
}
