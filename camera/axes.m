
clear 
% close all
clc

movie = 15
path = 'H:\My Drive\dark 2022\2022_01_31\hull\hull_Reorder\'
exp = '\2022_01_31\'

struct_file_name = sprintf('Shull_mov%d',movie)
mov_name = sprintf('mov%d',movie)

path_to_use = [path,mov_name,'/hull_op/']

load([path_to_use,struct_file_name])


% path = 'J:\My Drive\dark 2022\2023_08_09_60ms\hull\hull_Reorder\'
save_dir = sprintf('G:/My Drive/%s/',exp)
save_camera_matrices = [save_dir,'camera'];
easyWand_name = '1+2_31_01_2022_skip5_easyWandData'
% easyWand_name = '10_8_23_allmovs_easyWandData'
load([path,easyWand_name])
mkdir([save_dir])
mkdir(save_camera_matrices)
camvec = [2,3,4,1]%

mesh = pcread('G:\My Drive\2022_01_31\3d_data\mov15_frame210.ply');
fly = mesh.Location*10;

ew_to_pytorch = [1,0,0;0,0,1;0,1,0];
fly_pytorch = (ew_to_pytorch * fly')';
%%
rot_try = [ 1.0000   -0.0013   -0.0026;-0.0013   -1.0000    0.0000;   -0.0026    0.0000   -1.0000]

i = 2
coefs = easyWandData.coefs(:,i);
H=[coefs(1),coefs(2),coefs(3);coefs(5),coefs(6),coefs(7);coefs(9),coefs(10),coefs(11)];
h=[coefs(4);coefs(8);1];
Rz = [-1,0,0;0,-1,0;0,0,1];
X0 = -inv(H)*h;
[R,K] = qr(inv(H));
K=inv(K);
K = K*Rz/K(3,3);
R = (Rz*R')

ax = R(1,:);
axang = [ax pi];
rotm = axang2rotm(axang)   ;  

R2 = rotm*R

t1 = R*X0
t2 = R2*X0




clr = {'r','g','b'}
clr2 = {'magenta','k','cyan'}

% axis equal
% hold on;plot3(fly(:,1),fly(:,2),fly(:,3),'.b')
% for k = 1:1:3
% quiver3(t2(1),t2(2),t2(3),R2(1,k),R2(2,k),R2(3,k),0.1,color = clr{k})
% quiver3(t1(1),t1(2),t1(3),R(1,k),R(2,k),R(3,k),0.1,color = clr2{k})
% 
% % quiver3(t1(1),t1(2),t1(3),R2(1,k),R2(2,k),R2(3,k),0.1,color = clr2{k})
% 
% % quiver3(X0(1),X0(2),X0(3),R(1,k),R(2,k),R(3,k),0.1,color = clr2{k})
% 
% end
% ylabel('y');xlabel('x')

%%

clr = {'r','g','b'}
clr2 = {'magenta','k','cyan'}
figure
axis equal
fly2 = (Shull.rotmat_EWtoL*fly')';
hold on;plot3(fly2(:,1),fly2(:,2),fly2(:,3),'.b')
for j = 1:1:4
for k = 1:1:3
[R,K,X0] = decompose_dlt(easyWandData.coefs(:,j))
if j == 1
R = R'
end
R = Shull.rotmat_EWtoL*R;
X0 = Shull.rotmat_EWtoL*X0;
ax = R(1,:);
axang = [ax pi];
rotm = axang2rotm(axang)   ;  
R = rotm*R

% 
% if j == 4

quiver3(X0(1),X0(2),X0(3),R(1,k),R(2,k),R(3,k),0.1,color = clr{k})
% else
%     quiver3(X0(1),X0(2),X0(3),R(k,1),R(k,2),R(k,3),0.1,color = clr2{k})
% 
% end
% quiver3(X0(1),X0(2),X0(3),R(k,1),R(k,2),R(3,k),0.1,color = clr2{k})

end
ylabel('y');xlabel('x')
end



