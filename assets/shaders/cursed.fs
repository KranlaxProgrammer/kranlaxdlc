#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
    #define MY_HIGHP_OR_MEDIUMP highp
#else
    #define MY_HIGHP_OR_MEDIUMP mediump
#endif

extern MY_HIGHP_OR_MEDIUMP number dissolve;
extern MY_HIGHP_OR_MEDIUMP number time;
extern MY_HIGHP_OR_MEDIUMP vec4 texture_details;
extern MY_HIGHP_OR_MEDIUMP vec2 image_details;
extern bool shadow;
extern MY_HIGHP_OR_MEDIUMP vec4 burn_colour_1;
extern MY_HIGHP_OR_MEDIUMP vec4 burn_colour_2;
extern MY_HIGHP_OR_MEDIUMP vec2 mouse_screen_pos;
extern MY_HIGHP_OR_MEDIUMP float hovering;
extern MY_HIGHP_OR_MEDIUMP float screen_scale;

extern MY_HIGHP_OR_MEDIUMP vec2 cursed;

vec4 dissolve_mask(vec4 tex, vec2 texture_coords, vec2 uv) {
    if (dissolve < 0.001) { return vec4(shadow ? vec3(0.,0.,0.) : tex.xyz, shadow ? tex.a*0.3: tex.a); }
    float adjusted_dissolve = (dissolve*dissolve*(3.-2.*dissolve))*1.02 - 0.01;
    float t = cursed.y * 10.0 + 2003.;
    vec2 floored_uv = (floor((uv*texture_details.ba)))/max(texture_details.b, texture_details.a);
    vec2 uv_scaled_centered = (floored_uv - 0.5) * 2.3 * max(texture_details.b, texture_details.a);
    vec2 field_part1 = uv_scaled_centered + 50.*vec2(sin(-t / 143.6340), cos(-t / 99.4324));
    vec2 field_part2 = uv_scaled_centered + 50.*vec2(cos( t / 53.1532),  cos( t / 61.4532));
    vec2 field_part3 = uv_scaled_centered + 50.*vec2(sin(-t / 87.53218), sin(-t / 49.0000));
    float field = (1.+ (cos(length(field_part1) / 19.483) + sin(length(field_part2) / 33.155) * cos(field_part2.y / 15.73) + cos(length(field_part3) / 27.193) * sin(field_part3.x / 21.92) ))/2.;
    vec2 borders = vec2(0.2, 0.8);
    float res = (.5 + .5* cos( (adjusted_dissolve) / 82.612 + ( field + -.5 ) *3.14))
    - (floored_uv.x > borders.y ? (floored_uv.x - borders.y)*(5. + 5.*dissolve) : 0.)*(dissolve)
    - (floored_uv.y > borders.y ? (floored_uv.y - borders.y)*(5. + 5.*dissolve) : 0.)*(dissolve)
    - (floored_uv.x < borders.x ? (borders.x - floored_uv.x)*(5. + 5.*dissolve) : 0.)*(dissolve)
    - (floored_uv.y < borders.x ? (borders.x - floored_uv.y)*(5. + 5.*dissolve) : 0.)*(dissolve);
    if (tex.a > 0.01 && burn_colour_1.a > 0.01 && !shadow && res < adjusted_dissolve + 0.8*(0.5-abs(adjusted_dissolve-0.5)) && res > adjusted_dissolve) {
        if (!shadow && res < adjusted_dissolve + 0.5*(0.5-abs(adjusted_dissolve-0.5)) && res > adjusted_dissolve) { tex.rgba = burn_colour_1.rgba; } else if (burn_colour_2.a > 0.01) { tex.rgba = burn_colour_2.rgba; }
    }
    return vec4(shadow ? vec3(0.,0.,0.) : tex.xyz, res > adjusted_dissolve ? (shadow ? tex.a*0.3: tex.a) : .0);
}

float sdPentagram( vec2 p, float r ) {
    const vec3 k = vec3(0.809016994,0.587785252,0.726542528);
    p.x = abs(p.x);
    p -= 2.0*min(dot(vec2(-k.x,k.y),p),0.0)*vec2(-k.x,k.y);
    p -= 2.0*min(dot(vec2( k.x,k.y),p),0.0)*vec2( k.x,k.y);
    p -= vec2(clamp(p.x,r*k.z,r*k.x),r*k.y);
    return length(p)*sign(p.y);
}

vec4 effect( vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords ) {
    vec2 uv = (((texture_coords)*(image_details)) - texture_details.xy*texture_details.ba)/texture_details.ba;
    vec4 tex = Texel(texture, texture_coords);
    
    vec2 center_uv = uv * 2.0 - 1.0;
    center_uv.y *= 1.338; 
    
    float d = 100.0;
    float radius = 0.48; 
    
    for(int i = 0; i < 5; i++) {
        float a1 = float(i) * 6.2831853 / 5.0 - 1.570796;
        float a2 = float(i + 2) * 6.2831853 / 5.0 - 1.570796;
        vec2 p1 = vec2(cos(a1), sin(a1)) * radius;
        vec2 p2 = vec2(cos(a2), sin(a2)) * radius;
        vec2 pa = center_uv - p1;
        vec2 ba = p2 - p1;
        float h = clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0);
        d = min(d, length(pa - ba * h));
    }
    
    float d_circle = abs(length(center_uv) - radius);
    d = min(d, d_circle); 
    
    float pulse = 0.55 + 0.3 * sin(cursed.y * 3.0);
    
    float line_core = smoothstep(0.025, 0.015, d);
    float glow = 0.015 / (d + 0.005);
    float aura = max(0.0, 0.6 - length(center_uv)) * (0.3 + 0.3 * sin(cursed.y * 2.5));
    
    vec4 final_color = tex;
    final_color.rgb *= 0.35; 
    final_color.rgb += vec3(0.5, 0.0, 0.0) * aura * tex.a; 
    final_color.rgb += vec3(1.0, 0.05, 0.05) * glow * tex.a * pulse; 
    final_color.rgb = mix(final_color.rgb, vec3(1.0, 0.1, 0.1), line_core * tex.a * pulse);
    
    final_color.a += (cursed.x + cursed.y + time) * 0.00000001; 
    
    return dissolve_mask(final_color * colour, texture_coords, uv);
}

#ifdef VERTEX
vec4 position( mat4 transform_projection, vec4 vertex_position ) {
    if (hovering <= 0.){ return transform_projection * vertex_position; }
    float mid_dist = length(vertex_position.xy - 0.5*love_ScreenSize.xy)/length(love_ScreenSize.xy);
    vec2 mouse_offset = (vertex_position.xy - mouse_screen_pos.xy)/screen_scale;
    float scale = 0.2*(-0.03 - 0.3*max(0., 0.3-mid_dist))*hovering*(length(mouse_offset)*length(mouse_offset))/(2. -mid_dist);
    return transform_projection * vertex_position + vec4(0.,0.,0.,scale);
}
#endif