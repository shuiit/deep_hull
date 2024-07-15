clear 
close all
clc


exp = '\2022_01_31\'
path = 'J:\My Drive\dark 2022\2022_01_31\hull\hull_Reorder\'
save_dir = 'J:\My Drive\Roni\'

save_frame = [save_dir,exp,'3d_data\'];
movie = 15
frame = 210
mov_name = sprintf('mov%d',movie)
file_name = sprintf('hull3d_mov%d',movie)
struct_file_name = sprintf('Shull_mov%d',movie)
save_file = sprintf('hull_data_mov%d_frame%d.csv',movie,frame)
path_to_use = [path,mov_name,'/hull_op/']
load([path_to_use,file_name])
load([path_to_use,struct_file_name])
mkdir(save_frame)

%%

frame = 275
wing_left_bound = [hull3d.leftwing.hull.LE{frame};hull3d.leftwing.hull.TE{frame}];
wing_right_bound = [hull3d.rightwing.hull.LE{frame};hull3d.rightwing.hull.TE{frame}];
rot_mat = Shull.rotmat_EWtoL;
realc = Shull.real_coord{frame};


[body] = ew_to_lab(rot_mat,realc,hull3d.body.body4plot{frame})';
[wing_left] = ew_to_lab(rot_mat,realc,hull3d.leftwing.hull.hull3d{frame})';
[wing_right] = ew_to_lab(rot_mat,realc,hull3d.rightwing.hull.hull3d{frame})';
[right_bound] = ew_to_lab(rot_mat,realc,wing_right_bound)';
[left_bound] = ew_to_lab(rot_mat,realc,wing_left_bound)';

figure
tiledlayout(1,2)
ax1 = nexttile;
plot3(body(:,1),body(:,2),body(:,3),'.g');hold on;axis equal
plot3(wing_left(:,1),wing_left(:,2),wing_left(:,3),'.b')
plot3(wing_right(:,1),wing_right(:,2),wing_right(:,3),'.r')
xlabel('x [m]');ylabel('y [m]');zlabel('z [m]')

ax2 = nexttile
plot3(body(:,1),body(:,2),body(:,3),'.g');hold on;axis equal
plot3(left_bound(:,1),left_bound(:,2),left_bound(:,3),'.b','MarkerSize',15)
plot3(right_bound(:,1),right_bound(:,2),right_bound(:,3),'.r','MarkerSize',15)
xlabel('x [m]');ylabel('y [m]');zlabel('z [m]')

linkaxes([ax1,ax2],'xyz')
linkprop([ax1 ax2],{'View','XLim','YLim','ZLim'})
