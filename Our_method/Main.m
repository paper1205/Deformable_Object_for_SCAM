
clear
close all
tic

global x_map y_map z_map  n_sensor  camera_p 

%%三维地图
x_map=200;
y_map=200;
z_map=100;

%%加载对象
%%对象特征点，名为Set_Feature，维度224*6*12；
load('Set_Feature_new_object.mat');
%%对象特征角点，名为Set_Feature_Corner，维度（224）*（12）*12；
load('Set_Feature_new_object_Corner.mat');


%%对象轮廓，方便画face，名为Segment_vertice_deform，维度32*2*12；
load('Segment_vertice_all_deforms.mat');
%%电机的位置，名为motor_position_NSEW，维度12*4；
load('motor_position_NSEW_deforms.mat');

%%对象若干参数
center_z=91;%%中心点
center_object=[0,0,center_z];
Length=10;%%每个纸带宽10cm
%四个活动杆的可活动长度在28-50cm，宽度为10cm
motor_move_max=50;
motor_move_min=28;
Deform_Times=11;%形变次数
Num_Patterns=Deform_Times+1;
Time=Deform_Times+1;
%电机（蓝色小盒），设置8*6*4.
motor_l=8;motor_w=6;motor_h=4;
fa_norm_plot=4;
%%Face颜色
Face_mesh_color=[255, 255, 255]/255;
Motor_color =[133,193,233]/255;  % 浅蓝色
Motor_range_color =[93, 109, 126]/255;  % 灰褐色
Mesh_color=[189, 195, 199]/255;


basic_margin=5;
basic_margin_z=4;
floor_Face_mesh=7;
z_mesh_paixu=(35:floor_Face_mesh+1:91)+basic_margin_z;
z_mesh_paixu(floor_Face_mesh+1)=[];
fa_vector_plot_norm=4;

%%将对象暂存为Object_i，为后续算法做准备
for k_ti=1:1:Num_Patterns
    %%将整个集合分配给每个时刻的对象
    str_Object=['Object_',int2str(k_ti),'=Set_Feature(:,:,k_ti);'];
    eval(str_Object);
    %%同时分配每个时刻的角点
    str_Object_corner=['Object_corner_',int2str(k_ti),'=Set_Feature_Corner(:,:,k_ti);'];
    eval(str_Object_corner);

    
end

%%在开始时刻，目前对象为Object_1，对象角点为Object_corner_1；
target_object=Object_1;
target_object_corner=Object_corner_1;
% target_object_vertex=Pyramid_vertex(:,:,1);
singleobject_num=length(Set_Feature(:,1,1));


%%双目相机网络参数
n_sensor=4;
%单个相机的参数

%%相机的外参  %位置及角度
P=zeros(6,n_sensor); %%x,y,theta

%%双目相机的外参
P(1, 1:n_sensor) = 350;  % alpha   pitch
P(2, 1:n_sensor) = [120 30  240 330];  % beta  yaw
P(3, 1:n_sensor) = 90;  % gama roll
P(4, 1:n_sensor) = [90, 90, -90, -90]; % x
P(5, 1:n_sensor) = [90, -90, 90, -90]; % y
P(6, 1:n_sensor) = 40; % z
%% 双目相机内参 (cm)
% 左相机
camera_p.f_cl = 0.48;  % 相机焦距
camera_p.d_Nl = 30;  % 视锥体近平面
camera_p.d_Fl = 120;  % 视锥体远平面
camera_p.angle_ul = 32;  % 相机水平方向视场角
camera_p.angle_vl = 30;  % 相机竖直方向视场角
% 右相机
camera_p.f_cr = 0.48;  % 相机焦距
camera_p.d_Nr = 30;  % 视锥体近平面
camera_p.d_Fr = 120;  % 视锥体远平面
camera_p.angle_ur = 32;  % 相机水平方向视场角
camera_p.angle_vr = 30;  % 相机竖直方向视场角

% 双目相机特参
camera_p.alpha_l = 90;
camera_p.alpha_r = 90;
camera_p.PD = 12;  %%基线  %%zed相机实测12cm

P_l=zeros(6,n_sensor); %%左相机
P_r=zeros(6,n_sensor); %%右相机

%在判断三个条件时需要先进行坐标系的转化。
temp_tk=1;%%初始状态时，对象的时序处在1时刻。
[initial_sumH,initial_Hi,initial_Cs,initial_H_map_str]=Calculate_Mapped_simulation(P,target_object,temp_tk);
%得到的每一项分别是在第一时刻的结果

%%初始建图的个数
Num_initial_known_map=initial_sumH;
str_known_map=initial_H_map_str; %%地图的位置
initial_known_map=zeros(Num_initial_known_map,6);
%%此外还需要记录地图角点的位置方便画图。
initial_known_map_corner=zeros(Num_initial_known_map,12);

for k_p=1:Num_initial_known_map
    
    initial_known_map(k_p,:)=target_object(initial_Hi(k_p),:);
    initial_known_map_corner(k_p,:)=target_object_corner(initial_Hi(k_p),:);
    
end

figure(1)
scatter3(center_object(1),center_object(2),center_object(3),'r*'); %画圆点
hold on
Plot_base_New_experiment;
Plot_object_deform_parts_experiment;
for  k_n=1:n_sensor
    Draw_Stereo_Camera(P,k_n)
end
axis([-200 200 -200 200 0 150]);
axis equal
view(-34,27)
xlabel('X');
ylabel('Y');
zlabel('Z');

figure(2)
scatter3(center_object(1),center_object(2),center_object(3),'r*'); %画圆点
hold on
Plot_base_New_experiment;
Plot_object_map_experiment(initial_known_map,initial_known_map_corner,Num_initial_known_map);
for  k_n=1:n_sensor
    Draw_Stereo_Camera(P,k_n)
end
axis([-200 200 -200 200 0 150]);
axis equal
view(-34,27)
xlabel('X');
ylabel('Y');
zlabel('Z');


%%将目前的信息全部赋给temp;
temp_P=P;
temp_known_map=initial_known_map;
temp_known_map_corner=initial_known_map_corner;
temp_Num_known_map=Num_initial_known_map;

process_add_map_str=initial_H_map_str;
add_known_map=initial_known_map;
add_known_map_corner=initial_known_map_corner;

%%迭代中参数设置
Gain_p=0.3;  %%位移的系数 x，y，z
Gain_o=0.8;  %%角度的系数
%%最大位移和最大角度偏移
MAX_position_arrow=sqrt(8^2+8^2);
MAX_orientation_arrow=(30/180)*pi;


%%由于双目相机是平行配置
%%计算出每个双目相机FOV的质心距离，方便后续计算
D_center_fov=camera_p.d_Nl+0.75*(camera_p.d_Fl-camera_p.d_Nl); %%该值应该由焦距f计算得到
%%参考二维方法的方法2，从计算出覆盖范围的中心来计算质心。
expected_distance=D_center_fov;

%%期望迭代次数
Iteration_T=80;

process_map_str=zeros(Iteration_T,singleobject_num);

for Iter=1:Iteration_T
    
    disp(Iter)
    
    if double(get(gcf,'CurrentCharacter'))==27%返回用户在绘图窗口中最后输入的一个字符，
        %即刚在键盘上按下的字符键将存储到Currentcharacter中一般于Keyppressfcn合用
        break;
    end
    
    %%计算当前情况下的FOV质心
    temp_distance_cfov_mapp=[];
    
    %%计算当前双目相机的FOV质心
    %%由于双目相机的左右两个相机角度固定，所以视场的中心是可以计算出来。
    
    
    for k_i=1:n_sensor
      temp_R=[cosd(temp_P(3,k_i)),-sind(temp_P(3,k_i)),0;sind(temp_P(3,k_i)),cosd(temp_P(3,k_i)),0;0,0,1]*[1,0,0;0,cosd(temp_P(1,k_i)),-sind(temp_P(1,k_i));0,sind(temp_P(1,k_i)),cosd(temp_P(1,k_i))]*[cosd(temp_P(2,k_i)),0,sind(temp_P(2,k_i));0,1,0;-sind(temp_P(2,k_i)),0,cosd(temp_P(2,k_i))]*[1,0,0;0,0,-1;0,1,0];
      temp_Fov_center(1:3,k_i)= temp_P(4:6,k_i)+(temp_R^(-1))*[0; 0; D_center_fov];
      %由于在本文中是平行式相机配置，则相机的朝向均为一致的
      temp_P_c_o= temp_R^(-1)*[0; 0; 1];
      temp_orientation_camera(k_i,:)=temp_P_c_o';
      
%        temp_2Dangle_camera(k_i)=cart2pol(temp_P(4,k_i),temp_P(5,k_i)); 
      temp_2Dangle_camera(k_i)=temp_P(2,k_i)+temp_P(3,k_i);
      temp_2Dangle_camera(temp_2Dangle_camera>360)=temp_2Dangle_camera(temp_2Dangle_camera>360)-360;
      temp_2D_orientation_camera(k_i,:)=[cos(temp_2Dangle_camera(k_i)),sin(temp_2Dangle_camera(k_i))];
     
      if  Iter>1    %% 若不是第一次优化，则选择已有的全部地图来计算，
            for k_pa=1:length(Weighted_known_map)
              %%计算每个采样点到相机3D视场质心的距离,
                temp_distance_cfov_mapp(k_pa,k_i)=sqrt( (Weighted_known_map(k_pa,1)-  temp_Fov_center(1,k_i)).^2+(Weighted_known_map(k_pa,2)-  temp_Fov_center(2,k_i)).^2+(Weighted_known_map(k_pa,3)-  temp_Fov_center(3,k_i)).^2);
           %可将距离进行一个强度值转化
           strength_temp_distance(k_pa,k_i)=1/temp_distance_cfov_mapp(k_pa,k_i);
          %% 计算采样点和相机的朝向的角度约束


           temp_orientation_object(k_pa,:,k_i)=[Weighted_known_map(k_pa,4),Weighted_known_map(k_pa,5),Weighted_known_map(k_pa,6)];           
           cos_temp_pso_theta(k_pa,k_i)=dot(temp_orientation_camera(k_i,:),temp_orientation_object(k_pa,:,k_i))/(norm(temp_orientation_camera(k_i,:))*norm(temp_orientation_object(k_pa,:,k_i)));
           temp_pso_theta(k_pa,k_i)=rad2deg(acos(cos_temp_pso_theta(k_pa,k_i)));
         %%若角度小于
           if temp_pso_theta(k_pa,k_i)< 90
               temp_Pso_constraint(k_pa,k_i)=0;
           else
               temp_Pso_constraint(k_pa,k_i)=abs(cos_temp_pso_theta(k_pa,k_i));
%                 temp_Pso_constraint(k_pa,k_i)=1;
           end
           
           
         %%若考虑XY平面的2D区域，则有
     temp_2D_orientation_object(k_pa,:,k_i)=[Weighted_known_map(k_pa,4),Weighted_known_map(k_pa,5)]; 
     temp_2Dangle_orientation_object(k_pa,k_i) =rad2deg(cart2pol(Weighted_known_map(k_pa,4),Weighted_known_map(k_pa,5)))+180;
    
      cos_2D_pso_theta(k_pa,k_i)=dot(temp_2D_orientation_camera(k_i,:),temp_2D_orientation_object(k_pa,:,k_i))/(norm(temp_2D_orientation_camera(k_i,:))*norm(temp_2D_orientation_object(k_pa,:,k_i)));
      temp_2D_pso_theta(k_pa,k_i)=rad2deg(acos(cos_2D_pso_theta(k_pa,k_i)));
      
           %%若角度小于
           if  temp_2D_pso_theta(k_pa,k_i)< 90
               temp_2D_Pso_constraint(k_pa,k_i)=0;
           else
               temp_2D_Pso_constraint(k_pa,k_i)=abs(cos_2D_pso_theta(k_pa,k_i));
           end
           
       %%若取xy得2D角度
%     strength_temp_cfov_mapp(k_pa,k_i)=strength_temp_distance(k_pa,k_i)*temp_2D_Pso_constraint(k_pa,k_i);
      
    %%若取3D角度约束
         %%融合角度和距离的强度值
           strength_temp_cfov_mapp(k_pa,k_i)=strength_temp_distance(k_pa,k_i)*temp_Pso_constraint(k_pa,k_i);
             
            end
            
        else
            
            for k_p=1:temp_Num_known_map
                temp_distance_cfov_mapp(k_p,k_i)=sqrt( (temp_known_map(k_p,1)-  temp_Fov_center(1,k_i)).^2+(temp_known_map(k_p,2)-  temp_Fov_center(2,k_i)).^2+(temp_known_map(k_p,3)-  temp_Fov_center(3,k_i)).^2);
             %%同理  
                strength_temp_distance(k_p,k_i)=1/temp_distance_cfov_mapp(k_p,k_i);
            temp_orientation_object(k_p,:,k_i)=[temp_known_map(k_p,4),temp_known_map(k_p,5),temp_known_map(k_p,6)];           
           cos_temp_pso_theta(k_p,k_i)=dot(temp_orientation_camera(k_i,:),temp_orientation_object(k_p,:,k_i))/(norm(temp_orientation_camera(k_i,:))*norm(temp_orientation_object(k_p,:,k_i)));
           temp_pso_theta(k_p,k_i)=rad2deg(acos(cos_temp_pso_theta(k_p,k_i)));
         %%若角度小于
           if temp_pso_theta(k_p,k_i)< 90
               temp_Pso_constraint(k_p,k_i)=0;
           else
               temp_Pso_constraint(k_p,k_i)=abs(cos_temp_pso_theta(k_p,k_i));
%                 temp_Pso_constraint(k_p,k_i)=1;
           end

      %%若考虑XY平面的2D区域，则有
         %%若考虑XY平面的2D区域，则有
     temp_2D_orientation_object(k_p,:,k_i)=[temp_known_map(k_p,4),temp_known_map(k_p,5)]; 
     temp_2Dangle_orientation_object(k_p,k_i) =rad2deg(cart2pol(temp_known_map(k_p,4),temp_known_map(k_p,5)))+180;
    
      cos_2D_pso_theta(k_p,k_i)=dot(temp_2D_orientation_camera(k_i,:),temp_2D_orientation_object(k_p,:,k_i))/(norm(temp_2D_orientation_camera(k_i,:))*norm(temp_2D_orientation_object(k_p,:,k_i)));
      temp_2D_pso_theta(k_p,k_i)=rad2deg(acos(cos_2D_pso_theta(k_p,k_i)));
      
           %%若角度小于
           if  temp_2D_pso_theta(k_p,k_i)< 90
               temp_2D_Pso_constraint(k_p,k_i)=0;
           else
               temp_2D_Pso_constraint(k_p,k_i)=abs(cos_2D_pso_theta(k_p,k_i));
           end
    
           
           %%若取xy得2D角度
%     strength_temp_cfov_mapp(k_p,k_i)=strength_temp_distance(k_p,k_i)*temp_2D_Pso_constraint(k_p,k_i);
      
    %%若取3D角度约束
    strength_temp_cfov_mapp(k_p,k_i)=strength_temp_distance(k_p,k_i)*temp_Pso_constraint(k_p,k_i);
  
            end
            
        end
        
    end
    
    
    %给目前地图进行分区
    dindex=[];
    partition_sensor=[];
    
    if  Iter>1
        for k_pa=1:length(Weighted_known_map)
            dindex=find(strength_temp_cfov_mapp(k_pa,:)==max(strength_temp_cfov_mapp(k_pa,:)));
            
            
            partition_sensor(k_pa)=dindex(1);
            
        end
        
        
    else
        for k_p=1:temp_Num_known_map
            dindex=find(strength_temp_cfov_mapp(k_p,:)==max(strength_temp_cfov_mapp(k_p,:)));
            partition_sensor(k_p)=dindex(1);
        end
    end
    
    
    %%优化过程
    %优化过程是先基于现有已知地图构建分区，再根据分区来计算出每个质心，利用质心信息来优化相机的配置
    
    for k_i=1:n_sensor
        temp_partition_sensor_index=find(partition_sensor==k_i);
        temp_nump_partitionsensor(k_i)=length(temp_partition_sensor_index);
        
        %%额外考虑部分传感器未被分到任务点的情况
        sum_point_position=zeros(1,3); %%所有点的x,y,z的集合
        sum_point_direction=zeros(1,3);%%所有点的角度的集合
        if temp_nump_partitionsensor(k_i)==0  %%若某传感器暂时未被分到任务点，
            temp_center_partition_sensor(k_i,:)=temp_Fov_center(:,k_i);%则任务质心设为FOV质心。
            temp_center_partition_Tosensor(k_i,:)=[temp_P(4,k_i),temp_P(5,k_i),temp_P(6,k_i)];
            
        else
            
            if Iter>1
                for k_ip=1:temp_nump_partitionsensor(k_i)
                    sum_point_position=sum_point_position+[Weighted_known_map(temp_partition_sensor_index(k_ip),1),Weighted_known_map(temp_partition_sensor_index(k_ip),2),Weighted_known_map(temp_partition_sensor_index(k_ip),3)];
                    sum_point_direction=sum_point_direction+[Weighted_known_map(temp_partition_sensor_index(k_ip),4),Weighted_known_map(temp_partition_sensor_index(k_ip),5),Weighted_known_map(temp_partition_sensor_index(k_ip),6)];
                end
            else
                for k_ip=1:temp_nump_partitionsensor(k_i)
                    sum_point_position=sum_point_position+[temp_known_map(temp_partition_sensor_index(k_ip),1),temp_known_map(temp_partition_sensor_index(k_ip),2),temp_known_map(temp_partition_sensor_index(k_ip),3)];
                    sum_point_direction=sum_point_direction+[temp_known_map(temp_partition_sensor_index(k_ip),4),temp_known_map(temp_partition_sensor_index(k_ip),5),temp_known_map(temp_partition_sensor_index(k_ip),6)];
                end
            end
            %%计算均值
            temp_center_partition_sensor(k_i,:)=sum_point_position/temp_nump_partitionsensor(k_i);
            temp_center_direction_sensor(k_i,:)=sum_point_direction/temp_nump_partitionsensor(k_i);
            %计算方向
            %%该方向为分区内三角形片朝向的特征方向
            direction_temp_center_partition(k_i,:)=[temp_center_partition_sensor(k_i,1),temp_center_partition_sensor(k_i,2),temp_center_partition_sensor(k_i,3)]/sqrt((temp_center_partition_sensor(k_i,1)^2)+(temp_center_partition_sensor(k_i,2)^2)+(temp_center_partition_sensor(k_i,3)^2));
            
            
            %          temp_center_partition_Tosensor(k_i,:)=expected_distance*direction_temp_center_partition(k_i,:)+[temp_center_partition_sensor(k_i,1),temp_center_partition_sensor(k_i,2),temp_center_partition_sensor(k_i,3)];
            %%位置移动的方向
            
            
            
        end
        
    end
    
    
    
    %%求点的优化矢量 ，通常情况下，相机的滚转角被固定。
    %%在3D场景中，是以对象中心（0，0，h）为参考中心，其中h为对象的所有三角形片的平均高度
    temp_h=sum(target_object(:,3))/length(target_object(:,3));
    
    %可以先求出优化的向量
    optimization_position_arrow=temp_center_partition_sensor-temp_Fov_center';
    %     distance_ctoc(k)
    
    for k_i=1:n_sensor
        %位置优化矢量
        %%不固定z轴则如下
        %         sensor_position_arrow(k_i,:)=Gain_p*[optimization_position_arrow(k_i,1),optimization_position_arrow(k_i,2),optimization_position_arrow(k_i,3)];
        
        %%如固定z轴，则先将z轴高度修改掉，然后后面将更大幅度优化俯仰角
        sensor_position_arrow(k_i,:)=Gain_p*[optimization_position_arrow(k_i,1),optimization_position_arrow(k_i,2),0];
        
        %          sensor_position_arrow(k_i,:)=Gain_p*[temp_center_partition_Tosensor(k_i,1)-temp_P(4,k_i),temp_center_partition_Tosensor(k_i,2)-temp_P(5,k_i),temp_center_partition_Tosensor(k_i,3)-temp_P(6,k_i)];
        
        %%最大位移上限 MAX_position_arrow
        %计算位置移动模值
        module_sensor_position_arrow(k_i)=sqrt((sensor_position_arrow(k_i,1)).^2+(sensor_position_arrow(k_i,2)).^2+(sensor_position_arrow(k_i,3)).^2);
        %对比最大位移上限 MAX_position_arrow，若超过位置上限，则以最大步伐运动
        if module_sensor_position_arrow(k_i) >MAX_position_arrow
            sensor_position_arrow(k_i,:)=(MAX_position_arrow/module_sensor_position_arrow(k_i))*sensor_position_arrow(k_i,:);
        end
        
        %%角度优化矢量
        
        %%滚转角若固定
        roll=temp_P(3,k_i);
        R_roll_z= [cosd(roll), sind(roll),0; -sind(roll), cosd(roll),0;0,0,1]; %%绕z轴的滚转
        
        %%在3D场景中，是以对象中心（0，0，h）为参考中心，其中h为对象的所有三角形片的平均高度
        %%当双目相机未分到区时，将双目相机 指向 （0，0，h），角度将需要计算。
        
        %%情况1， 若某传感器暂时未被分到任务点
        if temp_nump_partitionsensor(k_i)==0
            vector_oriention_sensor_face_origin(k_i,:)=[0,0,temp_h]-[temp_P(4,k_i),temp_P(5,k_i),temp_P(6,k_i)];
            
            [new_Euler(k_i,:)]=Calculate_EulerAngle(vector_oriention_sensor_face_origin(k_i,:),roll,R_roll_z);
            
            optimization_direction_arrow(k_i,:)=[new_Euler(k_i,1)-temp_P(1,k_i),new_Euler(k_i,2)-temp_P(2,k_i),new_Euler(k_i,3)-temp_P(3,k_i)];
            
            if abs(new_Euler(k_i,1)-temp_P(1,k_i))>180   %%判断是否属于突变情况
                if  (new_Euler(k_i,1)-temp_P(1,k_i))>220    %%判断是否属于情况1
                    optimization_direction_arrow(k_i,1)=360-(new_Euler(k_i,1)-temp_P(1,k_i));
                    optimization_direction_arrow(k_i,1)=-optimization_direction_arrow(k_i,1);
                else
                    %%不属于情况1,即属于情况2。
                    optimization_direction_arrow(k_i,1)=360-(temp_P(1,k_i)-new_Euler(k_i,1));
                end
            end
            
            if abs(new_Euler(k_i,2)-temp_P(2,k_i))>180    %%判断是否属于突变情况
                if  (new_Euler(k_i,2)-temp_P(2,k_i))>220    %%判断是否属于情况1
                    optimization_direction_arrow(k_i,2)=360-(new_Euler(k_i,2)-temp_P(2,k_i));
                else
                    %%不属于情况1,即属于情况2。
                    optimization_direction_arrow(k_i,2)=360-(temp_P(2,k_i)-new_Euler(k_i,2));
                end
            end
            
            sensor_direction_arrow(k_i,:)=Gain_o*optimization_direction_arrow(k_i,:);
            
        else
            %%当任务分区点数不为零时，其预期的方向是 先往前移动一步，再计算一个角度，再乘以系数。
            AssumedMoved_P(k_i,:)=[temp_P(4,k_i)+sensor_position_arrow(k_i,1), temp_P(5,k_i)+sensor_position_arrow(k_i,2),temp_P(6,k_i)+sensor_position_arrow(k_i,3)];
            vector_AMP_cp(k_i,:)=temp_center_partition_sensor(k_i,:)-AssumedMoved_P(k_i,:);
            
            %%计算角度
            [new_Euler(k_i,:)]=Calculate_EulerAngle(vector_AMP_cp(k_i,:),roll,R_roll_z);
            optimization_direction_arrow(k_i,:)=[new_Euler(k_i,1)-temp_P(1,k_i),new_Euler(k_i,2)-temp_P(2,k_i),new_Euler(k_i,3)-temp_P(3,k_i)];
            
            %%此时角度有可能在突变的情况，需要更新替换。
            %%情况1，需要增加300多度，例如temp_P(1,k_i)=0°，目标度数350°
            %%情况2，需要减少300多度，例如temp_P(1,k_i)=350°，目标度数2°
            %%俯仰角
            if abs(new_Euler(k_i,1)-temp_P(1,k_i))>180   %%判断是否属于突变情况
                if  (new_Euler(k_i,1)-temp_P(1,k_i))>220    %%判断是否属于情况1
                    optimization_direction_arrow(k_i,1)=360-(new_Euler(k_i,1)-temp_P(1,k_i));
                    optimization_direction_arrow(k_i,1)=-optimization_direction_arrow(k_i,1);
                else
                    %%不属于情况1,即属于情况2。
                    optimization_direction_arrow(k_i,1)=360-(temp_P(1,k_i)-new_Euler(k_i,1));
                end
            end
            
            if abs(new_Euler(k_i,2)-temp_P(2,k_i))>180   %%判断是否属于突变情况
                if  (new_Euler(k_i,2)-temp_P(2,k_i))>220    %%判断是否属于情况1
                    optimization_direction_arrow(k_i,2)=360-(new_Euler(k_i,2)-temp_P(2,k_i));
                    optimization_direction_arrow(k_i,2)=-optimization_direction_arrow(k_i,2);
                else
                    %%不属于情况1,即属于情况2。
                    optimization_direction_arrow(k_i,2)=360-(temp_P(2,k_i)-new_Euler(k_i,2));
                end
            end
            
            sensor_direction_arrow(k_i,:)=Gain_o*optimization_direction_arrow(k_i,:);
            
        end
        
        %%%更新部署
        temp_P(:,k_i)=temp_P(:,k_i)+[sensor_direction_arrow(k_i,1);sensor_direction_arrow(k_i,2);sensor_direction_arrow(k_i,3);sensor_position_arrow(k_i,1);sensor_position_arrow(k_i,2);sensor_position_arrow(k_i,3);];
        
        if temp_P(1,k_i)>360
            temp_P(1,k_i)=temp_P(1,k_i)-360;
        end
        
        if temp_P(1,k_i)<0
            temp_P(1,k_i)=temp_P(1,k_i)+360;
        end
        
      
    end
    
    
    %记录更新过程
    process_P(:,:,Iter)=temp_P;
    
    
    
    %%目标对象随时间变化
    %若每个时刻轮廓变化一次，计算出对应的时序
    temp_tk=mod(Iter,2*(Time-1));
        if temp_tk >Time-1
        object_sequence(Iter)=Time-(temp_tk-Time+1);
    else
        object_sequence(Iter)=temp_tk+1;
        end
    
    str_temp_object=['target_object=Object_',int2str(object_sequence(Iter)),';'];
    eval(str_temp_object);
    %%同时分配对应时刻的角点
    str_temp_object_corner=['target_object_corner=Object_corner_',int2str(object_sequence(Iter)),';'];
    eval(str_temp_object_corner);
    
    %%计算相机部署更新后的对新轮廓的覆盖情况，此时
    [op_H,op_Hi,op_Cs,op_H_map_str]=Calculate_Mapped_simulation(temp_P,target_object,object_sequence(Iter));
    
    %%记录建图的点数情况
    process_H(Iter)=op_H;  %%此为实时覆盖到的点。
    
        %%若把地图情况列举
    last_add_map_str=[];
    last_add_map_str= process_add_map_str;
    
    process_add_map_str=[];
    process_add_map_str=[last_add_map_str;op_H_map_str];
    
    %%保存每个时刻的每个target_object的覆盖情况
    process_map_str(Iter,:)=op_H_map_str;
   %%再加上初始建图序列
   process_object_sequence=[];
   process_object_sequence=[1,object_sequence];


   process_mapping_str_each=zeros(Time,singleobject_num);
    %%%
    for k_t=1:Time
    
    %%找到对应的时序的位置
    process_vi_ob_sequence=find(process_object_sequence==k_t);
    %%
    process_timenum=length(process_vi_ob_sequence);
    
    for k_pt_num=1:process_timenum
        process_mapping_str_each(k_t,:)=process_mapping_str_each(k_t,:)+process_add_map_str(process_vi_ob_sequence(k_pt_num),:);
    end
    
    for k_tp=1:singleobject_num
        if process_mapping_str_each(k_t,k_tp)>1
           process_mapping_str_each(k_t,k_tp)=1;
        end
    end
    
    process_sumH_map_each(k_t,Iter)=sum(process_mapping_str_each(k_t,:));
    end
    %%每个时刻的求和。
    process_all_sumH_map(Iter)=sum(process_sumH_map_each(:,Iter));
    
    %%%
    %%
    last_known_map=[];
    last_known_map=add_known_map;
    last_known_map_corner=add_known_map_corner;
    
    %%将每个时刻的覆盖情况都叠在一个总地图里
    temp_Num_known_map=op_H;
    Index_current_known_map=op_Hi;
    temp_known_map=[];
    temp_known_map=zeros(temp_Num_known_map,6);
    %%此外还需要记录地图角点的位置方便画图。
    temp_known_map_corner=[];
    temp_known_map_corner=zeros(temp_Num_known_map,12);
    
    %更新地图
    for k_p=1:temp_Num_known_map
        temp_known_map(k_p,:)=target_object(op_Hi(k_p),:);
        temp_known_map_corner(k_p,:)=target_object_corner(op_Hi(k_p),:);
    end
    
    
    %%将每个时刻的地图都保存下来。
    add_known_map=[];
    add_known_map=[last_known_map;temp_known_map];
%     add_known_map=unique(add_known_map,'rows');
    
    %%同样角点也可以同理保存
    add_known_map_corner=[];
    add_known_map_corner=[last_known_map_corner;temp_known_map_corner];
%     add_known_map_corner=unique(add_known_map_corner,'rows');
  

    process_addH(Iter)=length(add_known_map(:,1));

    
    %%新增一个加权的已知地图
    Weighted_known_map=[];
    Weighted_known_map_corner=[];
    %%选取最后N个时刻。
    Num_Weighted_instant=2;
   %%加权向量的设计w
   if Iter > (Num_Weighted_instant-1)
   nump_Weighted_known_map(Iter)=sum(process_H(Iter-(Num_Weighted_instant-1):Iter)); %%求出了最后N个时刻的个数
   Weighted_known_map=add_known_map(process_addH(Iter)-nump_Weighted_known_map(Iter)+1:process_addH(Iter),:);
   Weighted_known_map_corner=add_known_map_corner(process_addH(Iter)-nump_Weighted_known_map(Iter)+1:process_addH(Iter),:);
   
   else 
      %%不足时刻时即为历史地图。
      Weighted_known_map=add_known_map;
       Weighted_known_map_corner=add_known_map_corner;
   end

end

%%记录最终情况
final_P=temp_P;
end_iter=Iteration_T;


temp_tk=object_sequence(end_iter);
   
    
figure(3)
scatter3(center_object(1),center_object(2),center_object(3),'r*'); %画圆点
hold on
Plot_base_New_experiment;
Plot_object_deform_parts_experiment;
for  k_n=1:n_sensor
    Draw_Stereo_Camera(final_P,k_n)
end
axis([-200 200 -200 200 0 150]);
axis equal
view(-34,27)
xlabel('X');
ylabel('Y');
zlabel('Z');



sumH=Num_initial_known_map+sum(process_H);  %%所有覆盖的点数

CC_rate=process_H/singleobject_num*100;

figure(4)
plot(1:Iteration_T,CC_rate,'b--*');
xlabel('Each Deformation Instant');
ylabel('The Current Coverage Rate')


% %%画四条初始状态的颜色轨迹 对应Legend函数。
%%先求出初始条件下的朝向
for k_i=1:n_sensor
Chushi_R=[cosd(P(3,k_i)),-sind(P(3,k_i)),0;sind(P(3,k_i)),cosd(P(3,k_i)),0;0,0,1]*[1,0,0;0,cosd(P(1,k_i)),-sind(P(1,k_i));0,sind(P(1,k_i)),cosd(P(1,k_i))]*[cosd(P(2,k_i)),0,sind(P(2,k_i));0,1,0;-sind(P(2,k_i)),0,cosd(P(2,k_i))]*[1,0,0;0,0,-1;0,1,0];
Chushi_P_c_o(:,k_i)=( Chushi_R^(-1))*[0; 0; 20]+[P(4,k_i);P(5,k_i);P(6,k_i)];
end

figure(5)  %%轨迹图
quiver3(P(4,1),P(5,1),P(6,1),Chushi_P_c_o(1,1)-P(4,1),Chushi_P_c_o(2,1)-P(5,1),Chushi_P_c_o(3,1)-P(6,1),'Linewidth',1,'Color',[0,1,1],'MaxHeadSize',0.5);
hold on
for k_i=1:n_sensor
    ss_process_P=process_P(:,k_i,:);
    i=k_i;
    %%给每个传感器的绘图用不同的颜色
    if i==1
        cp_color = [0,1,1];  %深红色
    else if i==2
            cp_color = [0,1,0]; %绿色
        else if i==3
                cp_color = [40,55,71]/255;%褐色
            else if i==4
                    cp_color = [1,0,1]; %品红色
                end
            end
        end
    end
    
    %%画初始位置
    %     scatter3(P(4,k_i),P(5,k_i),P(6,k_i),[],cp_color);
    R = [cosd(P(3,k_i)),-sind(P(3,k_i)),0;sind(P(3,k_i)),cosd(P(3,k_i)),0;0,0,1]*[1,0,0;0,cosd(P(1,k_i)),-sind(P(1,k_i));0,sind(P(1,k_i)),cosd(P(1,k_i))]*[cosd(P(2,k_i)),0,sind(P(2,k_i));0,1,0;-sind(P(2,k_i)),0,cosd(P(2,k_i))]*[1,0,0;0,0,-1;0,1,0];
    p_c_r = (R^(-1))*[0; 0; 20]+[P(4,k_i);P(5,k_i);P(6,k_i)];  % 顶点坐标
    quiver3(P(4,k_i),P(5,k_i),P(6,k_i),p_c_r(1)-P(4,k_i),p_c_r(2)-P(5,k_i),p_c_r(3)-P(6,k_i),'Linewidth',1,'Color',cp_color,'MaxHeadSize',0.5);
    
    %%画过程位置
    for iter=1:Iteration_T
        
        process_R=[cosd(ss_process_P(3,1,iter)),-sind(ss_process_P(3,1,iter)),0;sind(ss_process_P(3,1,iter)),cosd(ss_process_P(3,1,iter)),0;0,0,1]*[1,0,0;0,cosd(ss_process_P(1,1,iter)),-sind(ss_process_P(1,1,iter));0,sind(ss_process_P(1,1,iter)),cosd(ss_process_P(1,1,iter))]*[cosd(ss_process_P(2,1,iter)),0,sind(ss_process_P(2,1,iter));0,1,0;-sind(ss_process_P(2,1,iter)),0,cosd(ss_process_P(2,1,iter))]*[1,0,0;0,0,-1;0,1,0];
        process_p_c_r = (process_R^(-1))*[0; 0; 20]+[ss_process_P(4,1,iter);ss_process_P(5,1,iter);ss_process_P(6,1,iter)];  % 顶点坐标
        quiver3(ss_process_P(4,1,iter),ss_process_P(5,1,iter),ss_process_P(6,1,iter),process_p_c_r (1)-ss_process_P(4,1,iter),process_p_c_r (2)-ss_process_P(5,1,iter),process_p_c_r (3)-ss_process_P(6,1,iter),'Linewidth',1,'Color',cp_color,'MaxHeadSize',0.5);
    end
    
end

hold off
axis([-200 200 -200 200 0 150]);
axis equal
view(-0,35)

[final_fusion_known_map,ia]=unique(add_known_map,'rows');
final_fusion_known_map_corner=add_known_map_corner(ia,:);

entire_process_str=[initial_H_map_str; process_map_str];
entire_process_object_sequence=[1,object_sequence];
final_mapping_str=zeros(Time,singleobject_num);

for k_t=1:Time
    
    %%找到对应的时序的位置
    vi_ob_sequence=find(entire_process_object_sequence==k_t);
    %%
    timenum=length(vi_ob_sequence);
    
    for k_t_num=1:timenum
        final_mapping_str(k_t,:)=final_mapping_str(k_t,:)+entire_process_str(vi_ob_sequence(k_t_num),:);
    end
    
    for k_tp=1:singleobject_num
        if final_mapping_str(k_t,k_tp)>1
            final_mapping_str(k_t,k_tp)=1;
        end
    end
    
    sumH_map_each(k_t)=sum(final_mapping_str(k_t,:));
end


Mapping_rate=sumH_map_each/singleobject_num*100;

figure(6)
plot(1:1:Time,Mapping_rate,'r.');
hold on
xlabel('Each Deformation Body');
ylabel('Mapping Rate')
axis([0 Time 0 100]);
hold off


figure(7)
plot(1:Iteration_T,process_all_sumH_map,'r-o');
xlabel('Iteration');
ylabel('Cost Function H')


toc


