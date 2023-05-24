function Theory = theta_js(X,Y)
A = [0,1];
B = [400 - X , 300 - Y ];
Theory =  acos(dot(A,B)/(norm(A)*norm(B))) * (180/pi);
if B(1) > 0
    Theory = 360 - Theory;
elseif (B(1) == 0)&&(B(2)<0)
    Theory = 180;
elseif (B(1) == 0)&&(B(2)>=0)
    Theory = 0;
end
end
