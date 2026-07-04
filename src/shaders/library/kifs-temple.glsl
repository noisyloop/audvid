// name: KIFS TEMPLE
// category: fractal
// ported from prism-video-synth
mat2 rot(float a){float c=cos(a),s=sin(a);return mat2(c,-s,s,c);}float sdB(vec2 p,vec2 b){vec2 d=abs(p)-b;return length(max(d,0.0))+min(max(d.x,d.y),0.0);}void main(){vec2 uv=(gl_FragCoord.xy-u_res.xy*0.5)/u_res.y;float t=u_time*u_speed;vec2 p=uv*1.5*u_scale;float sec=1.0472;float a=atan(p.y,p.x);a=mod(a,2.0*sec);a=abs(a-sec);p=vec2(cos(a),sin(a))*length(p);float d=1e9;float g=0.0;mat2 m=rot(0.6+t*0.08);for(int i=0;i<7;i++){p=abs(p)-vec2(0.45+0.06*sin(t*0.5),0.32);p=m*p;float bd=sdB(p,vec2(0.4,0.012));d=min(d,abs(bd));g+=exp(-40.0*abs(bd));}vec3 col=(0.5+0.5*cos(6.28318*(g*0.08+t*0.05+vec3(0.0,0.33,0.67))))*(smoothstep(0.012,0.0,d)+g*0.12);outColor=vec4(col*u_intensity,1.0);}
