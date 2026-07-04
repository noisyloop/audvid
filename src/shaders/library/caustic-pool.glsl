// name: CAUSTIC POOL
// category: light
// ported from prism-video-synth
void main(){vec2 uv=(gl_FragCoord.xy-u_res.xy*0.5)/u_res.y;float t=u_time*u_speed*0.5;vec2 p=uv*4.0*u_scale+4.0;vec2 i0=p;float c=1.0;float inten=0.005;for(int n=0;n<5;n++){float fn=float(n);float tt=t*(1.0-3.5/(fn+1.0));i0=p+vec2(cos(tt-i0.x)+sin(tt+i0.y),sin(tt-i0.y)+cos(tt+i0.x));c+=1.0/length(vec2(p.x/(sin(i0.x+tt)/inten+1e-6),p.y/(cos(i0.y+tt)/inten+1e-6)));}c/=5.0;c=1.17-pow(abs(c),1.4);float v=pow(abs(c),8.0);vec3 col=vec3(0.0,0.25,0.4)+vec3(v*0.9,v*1.05,v*1.15);col+=vec3(0.0,0.1,0.15)*sin(uv.y*3.0+t);outColor=vec4(audioPop(clamp(col,0.0,1.6)*u_intensity),1.0);}
