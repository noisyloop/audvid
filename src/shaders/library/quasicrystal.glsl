// name: QUASICRYSTAL
// category: tiling
// ported from prism-video-synth
void main(){vec2 uv=(gl_FragCoord.xy-u_res.xy*0.5)/u_res.y;float t=u_time*u_speed;float ca=cos(t*0.04),sa=sin(t*0.04);vec2 p=mat2(ca,-sa,sa,ca)*uv*9.0*u_scale;float v=0.0;for(int k=0;k<5;k++){float fk=float(k);vec2 dir=vec2(cos(fk*1.25664),sin(fk*1.25664));v+=cos(dot(p,dir)+t*(0.5+fk*0.1));}float iso=abs(fract(v*0.7)-0.5);float lines=smoothstep(0.12,0.02,iso);vec3 col=(0.5+0.5*cos(6.28318*(v*0.09+t*0.06+vec3(0.0,0.33,0.67))))*(0.25+0.45*(v*0.2+0.5));col+=(0.5+0.5*cos(6.28318*(v*0.05+0.5+t*0.1+vec3(0.0,0.33,0.67))))*lines*0.8;col+=vec3(1.0,0.9,0.8)*smoothstep(4.2,5.0,v)*0.8;outColor=vec4(col*u_intensity,1.0);}
