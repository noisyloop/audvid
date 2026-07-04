// name: APOLLONIAN GASKET
// category: fractal
// ported from prism-video-synth
void main(){vec2 uv=(gl_FragCoord.xy-u_res.xy*0.5)/u_res.y;float t=u_time*u_speed*0.3;float ca=cos(t*0.4),sa=sin(t*0.4);vec3 p=vec3(mat2(ca,-sa,sa,ca)*uv*1.2*u_scale,0.15+0.1*sin(t));float sc=1.0;float trap=1e9;for(int i=0;i<8;i++){p=mod(p-1.0,2.0)-1.0;float r2=max(dot(p,p),1e-4);float k=1.25/r2;p*=k;sc*=k;trap=min(trap,r2);}float d=length(p.xy)/sc;float v=clamp(0.0025/(d+0.0008),0.0,2.2);vec3 col=(0.5+0.5*cos(6.28318*(trap*0.7+t*0.15+vec3(0.0,0.33,0.67))))*v*0.55;col+=vec3(0.8,0.6,1.0)*pow(max(1.0-trap,0.0),5.0)*0.35;outColor=vec4(audioPop(col*u_intensity),1.0);}
