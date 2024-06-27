

exp = '\2022_01_31\'

path = 'J:\My Drive\dark 2022\2022_01_31\hull\hull_Reorder\'
save_dir = 'J:\My Drive\Roni\'
save_camera_matrices = [save_dir,exp,'camera'];
easyWand_name = '1+2_31_01_2022_skip5_easyWandData'
load([path,easyWand_name])
mkdir([save_dir,exp])
mkdir(save_camera_matrices)

rotation_matrices = easyWandData.rotationMatrices
translation_vectors = easyWandData.translationVector

focal_length = easyWandData.focalLengths;
principal_point = reshape(easyWandData.principalPoints,2,4);
coefs1 = easyWandData.coefs
% for i = 1:1:4
i = 4;
    camera_name = sprintf('/camera%d_KRT',i)
    coefs = coefs1(:,i);
    Rzp = [-1,0,0;0,-1,0;0,0,1];
    H=[coefs(1),coefs(2),coefs(3);coefs(5),coefs(6),coefs(7);coefs(9),coefs(10),coefs(11)];
    h=[-coefs(4);-coefs(8);-1];
    % p = reshape([coefs(:,i);1],4,3)';
    % p(:,end) = -p(:,end)
    % H = p(1:3,1:3);
    % h=p(1:3,4);
    [R,K] = qr(inv(H));
    k=inv(K);
    T = -inv(H)*h;
    K=Rzp*(k/k(3,3));
    K(1:2,3) =    K(1:2,3);
    R = Rzp*R';

    p_calc = [K*R,-K*R*T];

    reshape(p',1,12)

    % K = [focal_length(i), 0, principal_point(1,i);0, focal_length(i), principal_point(2,i);0, 0, 1];
    % R = rotation_matrices(:,:,i);
    % T = translation_vectors(:,:,i);
    % writematrix([K;R;T],[save_camera_matrices,camera_name])
    
% end

% coefs = easyWandData.coefs
[xyz,T,ypr,Uo,Vo,Z] = DLTcameraPosition(coefs)







