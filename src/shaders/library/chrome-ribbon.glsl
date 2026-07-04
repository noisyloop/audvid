// name: CHROME RIBBON
// category: retro
// ported from prism-video-synth
void main(){vec2 uv=(gl_FragCoord.xy-u_res.xy*0.5)/u_res.y;float t=u_time*u_speed;vec2 p=uv*u_scale;vec3 col=mix(vec3(0.05,0.0,0.12),vec3(0.16,0.02,0.2),uv.y+0.5);for(int i=0;i<3;i++){float fi=float(i);float yc=sin(p.x*1.6+t*(0.8+fi*0.2)+fi*2.1)*0.22+(fi-1.0)*0.34;float w=0.09;float d=p.y-yc;float band=smoothstep(w,w-0.015,abs(d));float sh=d/w*0.5+0.5;vec3 chrome=mix(vec3(0.15,0.1,0.3),vec3(1.0),pow(abs(sin(sh*3.14159+p.x*2.0-t)),3.0));chrome=mix(chrome,vec3(1.0,0.4,0.7),smoothstep(0.35,0.5,sh)*smoothstep(0.65,0.5,sh)*0.7);float stripe=step(0.5,fract(p.x*9.0+t*1.5+fi*0.3));chrome*=0.75+0.25*stripe;col=mix(col,chrome,band);col+=vec3(0.8,0.5,1.0)*exp(-abs(d)*18.0)*0.18;}outColor=vec4(col*u_intensity,1.0);}
