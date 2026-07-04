// name: CYMATIC PLATE
// category: audio
// ported from prism-video-synth
void main(){vec2 uv=(gl_FragCoord.xy-u_res.xy*0.5)/u_res.y;float t=u_time*u_speed;vec2 p=uv*3.14159*u_scale;float m1=2.0+floor(mod(t*0.3,4.0));float n1=3.0+floor(mod(t*0.19,4.0));float blendK=smoothstep(0.3,0.7,fract(t*0.3));float m2=m1+1.0;float v1=cos(m1*p.x)*cos(n1*p.y)-cos(n1*p.x)*cos(m1*p.y);float v2=cos(m2*p.x)*cos(n1*p.y)-cos(n1*p.x)*cos(m2*p.y);float v=mix(v1,v2,blendK)+0.15*sin(t*2.0)*sin(p.x*2.0)*sin(p.y*2.0);float sand=smoothstep(0.16,0.0,abs(v));vec3 col=vec3(0.03,0.02,0.06);col+=vec3(0.95,0.85,0.6)*sand*(0.7+0.3*sin(length(p)*4.0-t));col+=(0.5+0.5*cos(6.28318*(v*0.2+t*0.05+vec3(0.0,0.33,0.67))))*(1.0-sand)*0.18;col*=smoothstep(3.4,2.4,max(abs(p.x),abs(p.y)));outColor=vec4(col*u_intensity,1.0);}
