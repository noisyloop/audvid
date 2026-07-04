// name: SIGNAL DECAY
// category: glitch
// ported from prism-video-synth
float hash(vec2 p){return fract(sin(dot(p,vec2(127.1,311.7)))*43758.5453);}
float pat(vec2 p,float t){return (0.5+0.5*sin(p.x*8.0+t*1.4))*(0.5+0.5*sin(p.y*6.0-t))+0.5*smoothstep(0.25,0.0,abs(length(p-vec2(0.5))-0.27+0.1*sin(t*0.8)));}
void main(){vec2 uv=gl_FragCoord.xy/u_res.xy;float t=u_time*u_speed;vec2 p=uv*u_scale;float row=floor(uv.y*70.0);float drop=step(0.93,hash(vec2(row,floor(t*6.0))));p.x+=drop*(hash(vec2(row,floor(t*6.0)+0.5))-0.5)*0.25;float v=0.0;float w=1.0;for(int k=0;k<5;k++){v+=pat(p-vec2(float(k)*0.035*(1.0+0.5*sin(t*0.7)),0.0),t)*w;w*=0.55;}v/=2.1;v=mix(v,hash(uv*vec2(210.0,140.0)+floor(t*24.0)),0.13);vec3 col=vec3(v*0.55,v*0.95,v*0.7);col*=1.0-drop*0.55;col*=0.88+0.12*sin(uv.y*u_res.y*1.7);col+=vec3(0.0,0.06,0.03);outColor=vec4(col*u_intensity,1.0);}
