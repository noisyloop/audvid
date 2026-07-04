// name: WAVEFORM
// category: audio
// ported from prism-video-synth
void main(){vec2 uv=gl_FragCoord.xy/u_res.xy;vec2 p=uv-0.5;p.x*=u_res.x/u_res.y;float t=u_time*u_speed;vec3 col=vec3(0.02,0.02,0.05);for(float i=0.0;i<20.0;i++){float fi=i/20.0;float freq=(2.0+i*0.5)*u_scale;float amp=0.15*(1.0-fi*0.5);float phase=t*(0.5+fi*0.3)+i*0.5;float wave=sin(p.x*freq*6.28318+phase)*amp+sin(p.x*freq*2.0*6.28318+phase*1.5)*amp*0.5;float y=p.y-wave+(fi-0.5)*0.8;float line=smoothstep(0.02,0.0,abs(y));vec3 lc=0.5+0.5*cos(6.28318*fi+vec3(0.0,2.0,4.0)+t*0.5);col+=lc*line*0.5*u_intensity+lc*0.01/(abs(y)+0.01)*0.1*u_intensity;}outColor=vec4(audioPop(col),1.0);}
