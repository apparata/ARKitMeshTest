
import SceneKit
import ARKit

extension SCNGeometry {
    
    public static func makeFromMeshAnchor(_ meshAnchor: ARMeshAnchor, materials: [SCNMaterial]) -> SCNGeometry {
        let vertices = meshAnchor.geometry.vertices
        let normals = meshAnchor.geometry.normals
        let faces = meshAnchor.geometry.faces
        
        let vertexSource = SCNGeometrySource(buffer: vertices.buffer,
                                             vertexFormat: vertices.format,
                                             semantic: .vertex,
                                             vertexCount: vertices.count,
                                             dataOffset: vertices.offset,
                                             dataStride: vertices.stride)

        let normalSource = SCNGeometrySource(buffer: normals.buffer,
                                             vertexFormat: normals.format,
                                             semantic: .normal,
                                             vertexCount: normals.count,
                                             dataOffset: normals.offset,
                                             dataStride: normals.stride)

        let uvSource = SCNGeometrySource(buffer: vertices.buffer,
                                         vertexFormat: MTLVertexFormat.float2,
                                         semantic: .texcoord,
                                         vertexCount: vertices.count,
                                         dataOffset: vertices.offset,
                                         dataStride: vertices.stride)
        
        let triangleData = Data(bytesNoCopy: faces.buffer.contents(),
                                count: faces.buffer.length,
                                deallocator: .none)
        
        let geometryElement = SCNGeometryElement(data: triangleData,
                                                 primitiveType: .triangles,
                                                 primitiveCount: faces.count,
                                                 bytesPerIndex: faces.bytesPerIndex)
        
        let sources = [vertexSource, normalSource, uvSource]
        let geometry = SCNGeometry(sources: sources, elements: [geometryElement])
        
        geometry.materials = materials
        
        return geometry;
    }
}
