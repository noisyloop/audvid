// name: DATA CORRUPT
// category: glitch
// ported from prism-video-synth
float hash(float n){return fract(sin(n)*43758.5453);}
float hash2(vec2 p){return fract(sin(dot(p,vec2(127.1,311.7)))*43758.5453);}
void main(){
  vec2 uv=gl_FragCoord.xy/u_res.xy;
  float t=u_time*u_speed;
  float slice=floor(uv.y*30.0*u_scale);
  float glitchT=floor(t*8.0);
  float glitchAmt=step(0.85,hash(slice+glitchT*100.0));
  float offsetX=(hash(slice+glitchT)-0.5)*0.3*glitchAmt;
  float scaleX=1.0+glitchAmt*0.1*(hash(slice+glitchT*50.0)-0.5);
  vec2 uv2=vec2((uv.x+offsetX)*scaleX,uv.y);
  float r=hash2(vec2(floor(uv2.x*80.0),slice)+glitchT);
  float g=hash2(vec2(floor(uv2.x*80.0+1.0),slice)+glitchT);
  float b=hash2(vec2(floor(uv2.x*80.0+2.0),slice)+glitchT);
  vec3 col=vec3(r,g,b);
  col=mix(col,0.5+0.5*cos(uv.y*10.0+t+vec3(0,2,4)),1.0-glitchAmt);
  float scanline=0.9+0.1*sin(uv.y*u_res.y*2.0);
  col*=scanline*u_intensity;
  outColor=vec4(audioPop(col),1.0);}
