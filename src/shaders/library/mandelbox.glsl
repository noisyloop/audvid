// name: MANDELBOX
// category: fractal
// ported from prism-video-synth
void main(){vec2 uv=(gl_FragCoord.xy-u_res.xy*0.5)/u_res.y;float t=u_time*u_speed;float ca=cos(t*0.05),sa=sin(t*0.05);vec2 c=mat2(ca,-sa,sa,ca)*uv*3.0*u_scale;vec2 z=c;float sf=2.0+0.35*sin(t*0.3);float trap=1e9;for(int i=0;i<14;i++){z=clamp(z,-1.0,1.0)*2.0-z;float r2=dot(z,z);if(r2<0.25)z*=4.0;else if(r2<1.0)z/=r2;z=z*sf+c;trap=min(trap,length(z));if(dot(z,z)>1e4)break;}vec3 col=(0.5+0.5*cos(6.28318*(trap*0.35+t*0.06+vec3(0.0,0.3,0.6))))*smoothstep(4.0,0.2,trap);col+=vec3(1.0,0.8,0.9)*exp(-trap*2.5)*0.7;outColor=vec4(col*u_intensity,1.0);}
