function [occlusion] = node_judge2(k,k_2,P,Object,temp_tk)
global Set_Feature_Corner
%%在该子函数中导入的P是左（右）相机的位置，是一个1*3的向量

%%目标：求直线L（相机Cn与三角形K中心）与三角形K_2的平面交点，并判断交点Q是否在三角形K_2内部。
%%给定一系列临时变量。

temp_A=Object(k_2,4)*(P(1,1)-Object(k,1))+Object(k_2,5)*(P(1,2)-Object(k,2))+Object(k_2,6)*(P(1,3)-Object(k,3));

%%temp_A=0, 则直线与三角形K2平面平行，即无交点。
if temp_A==0
    occlusion=0;  %%平行时无遮挡
    
else
    %%求t。temp_A为分母，temp_B为分子
    temp_B=Object(k_2,4)*(Object(k_2,1)-P(1,1))+Object(k_2,5)*(P(1,2)-Object(k_2,2))+Object(k_2,6)*(P(1,3)-Object(k_2,3));
    temp_t= temp_B/temp_A;
    
    %%用t 算出交点的坐标
    temp_jiao_x=P(1,1)+(P(1,1)-Object(k,1))*temp_t;
    temp_jiao_y=P(1,2)+(P(1,2)-Object(k,2))*temp_t;
    temp_jiao_z=P(1,3)+(P(1,3)-Object(k,3))*temp_t;
    
    %%有两个条件需要判断，条件1.判断交点是否在线段之间，不在线段之间，在则判断条件2。
    if    0< (temp_jiao_x-P(1,1))/(Object(k,1)-P(1,1)) < 1
          occlusion=0;
    else
        
     %%条件2：判断交点P是否在K_2三角形内部，K_2三角形的三个顶点取为Temp_a,Temp_b,Temp_c。
     %%在本个程序中k_2的三角形片需要从Set_Feature_Corner处导入，并且需要判断两个三角形片。
    temp_jiao_P=[temp_jiao_x,temp_jiao_y,temp_jiao_z];
    Temp_a=[Set_Feature_Corner(k_2,1,temp_tk),Set_Feature_Corner(k_2,2,temp_tk),Set_Feature_Corner(k_2,3,temp_tk)];
    Temp_b=[Set_Feature_Corner(k_2,4,temp_tk),Set_Feature_Corner(k_2,5,temp_tk),Set_Feature_Corner(k_2,6,temp_tk)];
    Temp_c=[Set_Feature_Corner(k_2,7,temp_tk),Set_Feature_Corner(k_2,8,temp_tk),Set_Feature_Corner(k_2,9,temp_tk)];
    occlusion=Is_in_triangle(temp_jiao_P,Temp_a,Temp_b,Temp_c);

    end
    
end 


end

