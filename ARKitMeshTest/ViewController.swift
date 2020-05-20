
import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    private var knownAnchors = Dictionary<UUID, SCNNode>()
    
    private let meshMaterial = SCNMaterial()
            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.showsStatistics = true
        
        let scene = SCNScene(named: "art.scnassets/scene.scn")!
        sceneView.scene = scene
        
        meshMaterial.shaderModifiers = [
            .geometry: geometryShaderModifierMTL
        ]
                
        //meshMaterial.fillMode = .lines
        let image = UIImage(named: "art.scnassets/uvtexturechecker.png")!
        meshMaterial.diffuse.contents = image
        meshMaterial.diffuse.wrapS = .repeat
        meshMaterial.diffuse.wrapT = .repeat
        meshMaterial.emission.contents = UIColor.black
        meshMaterial.lightingModel = .constant
        meshMaterial.blendMode = .alpha
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.sceneReconstruction = .mesh

        sceneView.session.run(configuration)
        
        sceneView.session.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
}

// MARK: - ARSessionDelegate

extension ViewController: ARSessionDelegate {

    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        for anchor in anchors {
            var sceneNode: SCNNode?
            
            if let meshAnchor = anchor as? ARMeshAnchor {
                let geometry = SCNGeometry.makeFromMeshAnchor(meshAnchor, materials: [meshMaterial])
                sceneNode = SCNNode(geometry: geometry)
            }
            
            if let node = sceneNode {
                node.simdTransform = anchor.transform
                knownAnchors[anchor.identifier] = node
                sceneView.scene.rootNode.addChildNode(node)
            }
        }
    }

    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        for anchor in anchors {
            if let node = knownAnchors[anchor.identifier] {
                if let meshAnchor = anchor as? ARMeshAnchor {
                    node.geometry = SCNGeometry.makeFromMeshAnchor(meshAnchor, materials: [meshMaterial])
                }
                node.simdTransform = anchor.transform
            }
        }
    }

    func session(_ session: ARSession, didRemove anchors: [ARAnchor]) {
        for anchor in anchors {
            if let meshAnchor = anchor as? ARMeshAnchor,
                let node = knownAnchors[meshAnchor.identifier] {
                node.removeFromParentNode()
                knownAnchors.removeValue(forKey: meshAnchor.identifier)
            }
        }
    }
}
