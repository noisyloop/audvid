// name: TRIP HEX
// category: psychedelic
// ported from prism-video-synth
mat2 rot(float a){float c=cos(a),s=sin(a);return mat2(c,-s,s,c);}void main(){vec2 uv=(gl_FragCoord.xy-u_res.xy*0.5)/u_res.y;float t=u_time*u_speed;vec2 p=uv*2.0*u_scale;for(int i=0;i<3;i++){float r=length(p);float a=atan(p.y,p.x);float sec=0.5236;a=mod(a,2.0*sec);a=abs(a-sec);p=vec2(cos(a),sin(a))*r-vec2(0.45,0.0);p*=1.35;p=rot(t*0.12+float(i)*0.4)*p;}float pat=sin(p.x*8.0+t)+sin(p.y*8.0-t*0.8)+sin(length(p)*12.0-t*2.0);vec3 col=(0.5+0.5*cos(6.28318*(pat*0.12+t*0.08+vec3(0.0,0.33,0.67))))*(0.55+0.45*sin(pat*2.0));col+=vec3(1.0,0.7,0.9)*pow(0.5+0.5*sin(pat*3.0+t),8.0)*0.6;outColor=vec4(col*u_intensity,1.0);}
