function Plot_object_map_experiment(known_map,known_map_corner,num_know_map)
fa_norm_plot=4;
Mapped_color=[230, 126, 34]/255;
for k_sfp=1:num_know_map
    scatter3(known_map(k_sfp,1),known_map(k_sfp,2),known_map(k_sfp,3),'k*');
    quiver3(known_map(k_sfp,1),known_map(k_sfp,2),known_map(k_sfp,3),known_map(k_sfp,4)*fa_norm_plot,known_map(k_sfp,5)*fa_norm_plot,known_map(k_sfp,6)*fa_norm_plot,'LineWidth',1,'Color','b','MaxHeadSize',0.5);
    
      
    fill3([known_map_corner(k_sfp,1) known_map_corner(k_sfp,4) known_map_corner(k_sfp,7)],[known_map_corner(k_sfp,2) known_map_corner(k_sfp,5) known_map_corner(k_sfp,8)],[known_map_corner(k_sfp,3) known_map_corner(k_sfp,6) known_map_corner(k_sfp,9)],Mapped_color,'FaceAlpha','0.15','EdgeAlpha','0');
    fill3([known_map_corner(k_sfp,1) known_map_corner(k_sfp,10) known_map_corner(k_sfp,7)],[known_map_corner(k_sfp,2) known_map_corner(k_sfp,11) known_map_corner(k_sfp,8)],[known_map_corner(k_sfp,3) known_map_corner(k_sfp,12) known_map_corner(k_sfp,9)],Mapped_color,'FaceAlpha','0.15','EdgeAlpha','0');   
end

