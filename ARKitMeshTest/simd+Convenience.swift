
import simd

extension simd_float4x4 {
    var position: simd_float3 {
        return simd_float3(columns.3.x, columns.3.y, columns.3.z)
    }
}
