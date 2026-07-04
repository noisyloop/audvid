// name: LISSAJOUS KNOT
// category: geometric
// ported from prism-video-synth
void main(){vec2 uv=(gl_FragCoord.xy-u_res.xy*0.5)/u_res.y;float t=u_time*u_speed;vec2 p=uv*1.3*u_scale;vec3 col=vec3(0.01,0.01,0.035);float cy=cos(t*0.3),sy=sin(t*0.3);for(int i=0;i<70;i++){float s=float(i)/70.0*6.28318;vec3 k=vec3(sin(3.0*s+t*0.5),sin(4.0*s+t*0.4+1.0),sin(5.0*s+t*0.6+2.0))*0.7;k.xz=mat2(cy,-sy,sy,cy)*k.xz;vec2 q=k.xy/(k.z*0.25+1.4);float d=length(p-q);float depth=k.z*0.5+0.5;col+=(0.5+0.5*cos(6.28318*(float(i)/70.0+t*0.08+vec3(0.0,0.33,0.67))))*exp(-d*60.0)*(0.5+0.6*depth);col+=vec3(1.0)*exp(-d*200.0)*depth*0.4;}outColor=vec4(col*u_intensity,1.0);}
