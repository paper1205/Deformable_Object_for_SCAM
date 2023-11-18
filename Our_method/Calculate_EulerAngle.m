function [new_P] = Calculate_EulerAngle(V,roll,R_roll)

%%首先需要将V进行单位化
v=V/norm(V);
v_roll= R_roll*v';

    %%先计算出偏航角，
    proj_v = [v_roll(1), v_roll(2), 0];
    theta = atan2d(v_roll(2),v_roll(1));
    if theta<0
        theta=theta+360;
    end
    
    phi = atan2d(norm(proj_v), v_roll(3));
    
    pitch=360-(roll-phi);
    if  pitch>360
       pitch=pitch-360;
    end

    yaw=theta;
    
    new_P=[pitch,yaw,roll];