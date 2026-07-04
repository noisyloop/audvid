// name: KALEIDOSCOPE
// category: psychedelic
// ported from prism-video-synth
vec2 kaleid(vec2 uv,float n){float angle=3.14159/n;float a=atan(uv.y,uv.x);a=mod(a,angle*2.0);a=abs(a-angle);return length(uv)*vec2(cos(a),sin(a));}void main(){vec2 uv=gl_FragCoord.xy/u_res.xy;vec2 p=uv-0.5;p.x*=u_res.x/u_res.y;float t=u_time*u_speed;p=kaleid(p*u_scale,6.0);p=kaleid(p+0.1*sin(t),4.0);vec3 col=vec3(0.0);for(float i=0.0;i<5.0;i++){float fi=i+1.0;vec2 q=p*fi+t*0.5;col.r+=0.2/abs(sin(q.x*10.0+sin(q.y*5.0+t)));col.g+=0.2/abs(sin(q.x*10.0+sin(q.y*5.0+t+1.0)));col.b+=0.2/abs(sin(q.x*10.0+sin(q.y*5.0+t+2.0)));}outColor=vec4(clamp(pow(col,vec3(1.5))*u_intensity,0.0,1.0),1.0);}
