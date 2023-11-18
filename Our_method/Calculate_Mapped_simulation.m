function [sumH_mapped,dHi,A_3D,H] = Calculate_Mapped_simulation(P,Object,temp_tk)
global  n_sensor  camera_p

R_l = [1, 0, 0; 0, sind(camera_p.alpha_l), -cosd(camera_p.alpha_l); 0, cosd(camera_p.alpha_l), sind(camera_p.alpha_l)];
R_r = [1, 0, 0; 0, sind(camera_p.alpha_r), cosd(camera_p.alpha_r); 0, -cosd(camera_p.alpha_r), sind(camera_p.alpha_r)];


%%加载的Object是224*6；
A_3D = zeros(length(Object(:,1)),n_sensor);%%构建一个224*n的向量,最后的结果，
FoV= zeros(length(Object(:,1)),n_sensor);
PsO_C_O= zeros(length(Object(:,1)),n_sensor);


for n = 1:n_sensor
    % 世界坐标系到相机坐标系
    [x_st, y_st, z_st] = World2Camera(Object(:,1), Object(:,2), Object(:,3),P,n);
    
    % 双目相机坐标系到左相机坐标系
    x_cl = x_st;
    y_cl = sind(camera_p.alpha_l)*((camera_p.PD/2)+y_st)-cosd(camera_p.alpha_l)*z_st;
    z_cl = cosd(camera_p.alpha_l)*((camera_p.PD/2)+y_st)+sind(camera_p.alpha_l)*z_st;
    % 双目相机坐标系到右相机坐标系
    x_cr = x_st;
    y_cr = -sind(camera_p.alpha_r)*((camera_p.PD/2)-y_st)+cosd(camera_p.alpha_r)*z_st;
    z_cr = cosd(camera_p.alpha_r)*((camera_p.PD/2)-y_st)+sind(camera_p.alpha_r)*z_st;
    
    
    % 初始情况建图
    A_2D_l = ones(length(Object(:,1)),1);
    angle_x_z_l = x_cl./z_cl;
    angle_y_z_l = y_cl./z_cl;
    
    A_2D_r = ones(length(Object(:,1)),1);
    angle_x_z_r = x_cr./z_cr;
    angle_y_z_r = y_cr./z_cr;
    
    % 判断目标点中心是否满足FOV
    %左相机
    A_2D_l(find(z_cl<camera_p.d_Nl)) = 0;
    A_2D_l(find(z_cl>camera_p.d_Fl)) = 0;
    A_2D_l(find(angle_x_z_l>tand(camera_p.angle_vl/2))) = 0;
    A_2D_l(find(angle_x_z_l<-tand(camera_p.angle_vl/2))) = 0;
    A_2D_l(find(angle_y_z_l>tand(camera_p.angle_ul/2))) = 0;
    A_2D_l(find(angle_y_z_l<-tand(camera_p.angle_ul/2))) = 0;
    % 右相机区域
    A_2D_r(find(z_cr<camera_p.d_Nr)) = 0;
    A_2D_r(find(z_cr>camera_p.d_Fr)) = 0;
    A_2D_r(find(angle_x_z_r>tand(camera_p.angle_vr/2))) = 0;
    A_2D_r(find(angle_x_z_r<-tand(camera_p.angle_vr/2))) = 0;
    A_2D_r(find(angle_y_z_r>tand(camera_p.angle_ur/2))) = 0;
    A_2D_r(find(angle_y_z_r<-tand(camera_p.angle_ur/2))) = 0;
    
    %%只有左右相机都满足FOV才算达标
    temps_A_2D=A_2D_l+A_2D_r;
    temps_A_2D(find(temps_A_2D<2))=0;
    temps_A_2D(find(temps_A_2D==2))=1;
    
    FoV(:,n)=temps_A_2D;
    
    %%第二项容许朝向判断
    R = [cosd(P(3,n)),-sind(P(3,n)),0;sind(P(3,n)),cosd(P(3,n)),0;0,0,1]*[1,0,0;0,cosd(P(1,n)),-sind(P(1,n));0,sind(P(1,n)),cosd(P(1,n))]*[cosd(P(2,n)),0,sind(P(2,n));0,1,0;-sind(P(2,n)),0,cosd(P(2,n))]*[1,0,0;0,0,-1;0,1,0];
    %%左相机
    P_cl_o=R^(-1)*R_l^(-1)*[0; 0; 1];
    %%右相机
    P_cr_o=R^(-1)*R_r^(-1)*[0; 0; 1];
    
    Position_camera_l(n,:)=(R^(-1))*((R_l^(-1))*[0; 0; 0]+[0; -camera_p.PD/2; 0])+[P(4,n);P(5,n);P(6,n)];
    Position_camera_r(n,:)=(R^(-1))*((R_r^(-1))*[0; 0; 0]+[0; camera_p.PD/2; 0])+[P(4,n);P(5,n);P(6,n)];
    
    orientation_camera_l(n,:)=P_cl_o';
    orientation_camera_r(n,:)=P_cr_o';
    norm_a_l(n)=norm(orientation_camera_l(n,:));
    norm_a_r(n)=norm(orientation_camera_r(n,:));
    
    for k=1: length(Object(:,1))
        %%取点的向量
        orientation_object(k,:,n)=[Object(k,4),Object(k,5),Object(k,6)];
        norm_b(k,n)=norm(orientation_object(k,:,n));
        theta_l(k,n)=acos(dot(orientation_camera_l(n,:),orientation_object(k,:,n))/(norm_a_l(n)*norm_b(k,n)));
        theta_deg_l(k,n)=rad2deg(theta_l(k,n));
        
        theta_r(k,n)=acos(dot(orientation_camera_r(n,:),orientation_object(k,:,n))/(norm_a_r(n)*norm_b(k,n)));
        theta_deg_r(k,n)=rad2deg(theta_r(k,n));
        
        %%夹角需要大于90度，夹角越接近180度越是正面面对
        %%左右相机判断
        if  (theta_deg_l(k,n)>90) &&(theta_deg_r(k,n)>90)
            PsO_C_O(k,n)=1;
        else
            PsO_C_O(k,n)=0;
        end
    end
    
    temp_pso=PsO_C_O(:,n);
    %%第三项遮挡判断
    %%由于遮挡计算较为复杂，为了减少计算量，先判断完前两项是否达标。
    %%第一项的结果是放在了temps_A_2D.是一个列向量（K，1）。  第二项放在了PsO_C_O内也是（k,1）。
    %%合并前两项的结果
    temp_fov_and_pso=temp_pso+temps_A_2D;
    temp_fov_and_pso(find(temp_fov_and_pso<2))=0;
    temp_fov_and_pso(find(temp_fov_and_pso==2))=1;
    %求索引和长度
    si=find(temp_fov_and_pso==1);%%索引
    
    %长度
    Num_si=length(si);
    
    %%遮挡判断预支
    derta_dk=3;
    d_k2tok_l=zeros(Num_si,Num_si);
    d_k2tok_r=zeros(Num_si,Num_si);
    %%该判断程序也是在世界坐标系下完成。需要判断左相机和右相机
    %步骤：1.首先计算满足条件的三角形片到相机位置的矩形框
    %2.判断整个其他三角形片有多少在矩形框的内部，通常被遮挡的三角形片也处在市场内。
    %3.计算在矩形框内部的三角形片与该直线的交点，
    %4.判断该交点是否在三角形片内 ，在三角形内则被遮挡，否则未被遮挡
    for k_si=1:Num_si
        for k_s2=1: Num_si
            d_k2tok_l(k_si,k_s2)=norm(cross([Position_camera_l(n,1), Position_camera_l(n,2), Position_camera_l(n,3)]-[Object(k_si,1),Object(k_si,2),Object(k_si,3)],[Object(k_s2,1),Object(k_s2,2),Object(k_s2,3)]-[Object(k_si,1),Object(k_si,2),Object(k_si,3)]))/norm([Position_camera_l(n,1), Position_camera_l(n,2), Position_camera_l(n,3)]-[Object(k_si,1),Object(k_si,2),Object(k_si,3)]);
            d_k2tok_r(k_si,k_s2)=norm(cross([Position_camera_r(n,1), Position_camera_r(n,2), Position_camera_r(n,3)]-[Object(k_si,1),Object(k_si,2),Object(k_si,3)],[Object(k_s2,1),Object(k_s2,2),Object(k_s2,3)]-[Object(k_si,1),Object(k_si,2),Object(k_si,3)]))/norm([Position_camera_r(n,1), Position_camera_r(n,2), Position_camera_r(n,3)]-[Object(k_si,1),Object(k_si,2),Object(k_si,3)]);
            
            %%判断d_k2tok是否小于阈值
            if d_k2tok_l(k_si,k_s2)<derta_dk
                occlusion_l(k_si)=node_judge2(k_si,k_s2,Position_camera_l(n,:),Object,temp_tk);
            else
                occlusion_l(k_si)=0;
            end
            
            %%判断d_k2tok是否小于阈值
            if d_k2tok_r(k_si,k_s2)<derta_dk
                occlusion_r(k_si)=node_judge2(k_si,k_s2,Position_camera_r(n,:),Object,temp_tk);
            else
                occlusion_r(k_si)=0;
            end
             
            
       %%只要大于1，即被遮挡。
       %%temps_occlusion是一个向量，只有Num_si长度。
            
        temps_occlusion(k_si) = occlusion_l(k_si)+occlusion_r(k_si);
%        temp_zhedang;
        if  temps_occlusion(k_si)>0
            
            temp_fov_and_pso(si(k_si))=0; %%遮挡，把该项位置改0.
            %%可以将遮挡的那列给保存下来

            
        end
           
              
        end
       
    end
    
%%将结果保存在A_3D
A_3D(:,n)=temp_fov_and_pso;
 
    
end

%%需要将sum(A_3D)=

H=sum(A_3D');
H(H>1)=1;

dHi=find(H==1);
sumH_mapped=length(dHi);



end