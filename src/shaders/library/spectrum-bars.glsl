// name: SPECTRUM BARS
// category: audio
// ported from prism-video-synth
float hash(float n){return fract(sin(n)*43758.5453);}void main(){vec2 uv=gl_FragCoord.xy/u_res.xy;float t=u_time*u_speed;float bars=32.0*u_scale;float barId=floor(uv.x*bars);float barWidth=1.0/bars;float barCenter=(barId+0.5)*barWidth;float h=hash(barId);float height=0.3+0.5*(sin(t*3.0+barId*0.5)*0.5+0.5)*(0.5+0.5*sin(t*2.0+h*10.0));float bar=step(uv.y,height)*smoothstep(barWidth*0.1,barWidth*0.4,abs(uv.x-barCenter));vec3 col=vec3(0.02,0.02,0.05);vec3 barCol=0.5+0.5*cos(barId*0.2+t+vec3(0.0,2.0,4.0));col+=barCol*bar*u_intensity+barCol*smoothstep(height+0.02,height,uv.y)*0.5*u_intensity;outColor=vec4(audioPop(col),1.0);}
