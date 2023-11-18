
%画电机

Real_N= motor_position_NSEW(temp_tk,1);
Real_S= motor_position_NSEW(temp_tk,2);
Real_E= motor_position_NSEW(temp_tk,3);
Real_W= motor_position_NSEW(temp_tk,4);

%%四个小盒顶点的坐标
%%北
Motor_N=[-motor_l/2,Real_N+motor_w/2,91;motor_l/2,Real_N+motor_w/2,91;motor_l/2,Real_N-motor_w/2,91;-motor_l/2,Real_N-motor_w/2,91;
    -motor_l/2,Real_N+motor_w/2,95;motor_l/2,Real_N+motor_w/2,95;motor_l/2,Real_N-motor_w/2,95;-motor_l/2,Real_N-motor_w/2,95];
%%南
Motor_S=[-4,-(Real_S+motor_w/2),91;4,-(Real_S+motor_w/2),91;4,-(Real_S-motor_w/2),91;-4,-(Real_S-motor_w/2),91;
    -4,-(Real_S+motor_w/2),95;4,-(Real_S+motor_w/2),95;4,-(Real_S-motor_w/2),95;-4,-(Real_S-motor_w/2),95];
%%东
Motor_E=[(Real_E-motor_w/2),-4,91;(Real_E-motor_w/2),4,91;(Real_E+motor_w/2),4,91;(Real_E+motor_w/2),-4,91;
    (Real_E-motor_w/2),-4,95;(Real_E-motor_w/2),4,95;(Real_E+motor_w/2),4,95;(Real_E+motor_w/2),-4,95];
%%西
Motor_W=[-(Real_W+motor_w/2),-4,91;-(Real_W+motor_w/2),4,91;-(Real_W-motor_w/2),4,91;-(Real_W-motor_w/2),-4,91;
    -(Real_W+motor_w/2),-4,95;-(Real_W+motor_w/2),4,95;-(Real_W-motor_w/2),4,95;-(Real_W-motor_w/2),-4,95];

drawCuboid(Motor_N, Motor_color);drawCuboid(Motor_S, Motor_color);
drawCuboid(Motor_E, Motor_color);drawCuboid(Motor_W, Motor_color);


%%画Face
Segment_vertice_all=Segment_vertice_deform(:,:,temp_tk);

for k_face=1:32
temp_face_vertuces=[Segment_vertice_all(k_face,1),Segment_vertice_all(k_face,2),0;Segment_vertice_all(k_face+1,1),Segment_vertice_all(k_face+1,2),0;
                                    Segment_vertice_all(k_face+1,1),Segment_vertice_all(k_face+1,2),91;Segment_vertice_all(k_face,1),Segment_vertice_all(k_face,2),91];
drawColoredQuadrilateral(temp_face_vertuces,Face_mesh_color);
end


%%画Mesh
temp_Set_Feature=Set_Feature(:,:,temp_tk);
scatter3(temp_Set_Feature(:,1),temp_Set_Feature(:,2),temp_Set_Feature(:,3),'b*');
quiver3(temp_Set_Feature(:,1),temp_Set_Feature(:,2),temp_Set_Feature(:,3),temp_Set_Feature(:,4),temp_Set_Feature(:,5),temp_Set_Feature(:,6),'LineWidth',1,'Color','b','MaxHeadSize',0.5);

%画角点
temp_Set_Feature_Corner=Set_Feature_Corner(:,:,temp_tk);
for k_fp=1:224
temp_mesh_vertices(:,:,k_fp)=[temp_Set_Feature_Corner(k_fp,1:3);temp_Set_Feature_Corner(k_fp,4:6);temp_Set_Feature_Corner(k_fp,7:9);temp_Set_Feature_Corner(k_fp,10:12)];
drawColoredQuadrilateral(temp_mesh_vertices(:,:,k_fp),Mesh_color);
end
