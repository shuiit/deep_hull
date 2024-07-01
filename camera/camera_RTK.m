
clear 
close all
clc
exp = '\2022_01_31\'

path = 'H:\My Drive\dark 2022\2022_01_31\hull\hull_Reorder\'
save_dir = sprintf('G:/My Drive/%s/',exp)
save_camera_matrices = [save_dir,'camera'];
easyWand_name = '1+2_31_01_2022_skip5_easyWandData'
load([path,easyWand_name])
mkdir([save_dir])
mkdir(save_camera_matrices)
camvec = [2,3,4,1]%

rotation_matrices = easyWandData.rotationMatrices
translation_vectors = easyWandData.translationVector

focal_length = easyWandData.focalLengths;
principal_point = reshape(easyWandData.principalPoints,2,4);
idx = 1
for i = camvec
    coefs = easyWandData.coefs(:,i);
    camera_name = sprintf('/camera%d_KRT',idx)
    H=[coefs(1),coefs(2),coefs(3);coefs(5),coefs(6),coefs(7);coefs(9),coefs(10),coefs(11)];
    h=[coefs(4);coefs(8);1];

    Rz = [-1,0,0;0,-1,0;0,0,1]
    X0 = -inv(H)*h;
    [R,K] = qr(inv(H))
    K=inv(K)
    K = K*Rz/K(3,3)
    R = Rz*R'
    DLT = [K*R,-K*R*X0]
    DLT = DLT /DLT(3,4)
    T(idx,1:3) = X0
    T2(idx,1:3) = (R*X0)'

    p = reshape([coefs;1],4,3)'

    % T might be X0 , for now R*X0
    writematrix([K;R;(-R*X0)'],[save_camera_matrices,camera_name])
idx = idx+ 1
end






