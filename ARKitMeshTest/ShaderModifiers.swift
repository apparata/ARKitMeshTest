
import Foundation

// Warning: This triplanar calculation is not entirely correct. 🙂

let geometryShaderModifierMTL = """
#pragma body
float4 worldPosition = scn_node.modelTransform * _geometry.position;
float3 worldNormal;
worldNormal = _geometry.normal.xxx * scn_node.modelTransform[0].xyz;
worldNormal += _geometry.normal.yyy * scn_node.modelTransform[1].xyz;
worldNormal += _geometry.normal.zzz * scn_node.modelTransform[2].xyz;
worldNormal = normalize(worldNormal.xyz);

float2 uv;
if (abs(worldNormal.x) > 0.5) {
    uv = float2((worldPosition.x), (worldPosition.z));
} else if (abs(worldNormal.z) > 0.5) {
    uv = float2((worldPosition.y), (worldPosition.z));
} else {
    uv = float2((worldPosition.x), (worldPosition.y));
}

_geometry.texcoords[0] = uv;
"""
