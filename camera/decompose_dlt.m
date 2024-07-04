function [R,K,X0] = decompose_dlt(coefs)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

H=[coefs(1),coefs(2),coefs(3);coefs(5),coefs(6),coefs(7);coefs(9),coefs(10),coefs(11)];
h=[coefs(4);coefs(8);1];
Rz = [-1,0,0;0,-1,0;0,0,1];
X0 = -inv(H)*h;
[R,K] = qr(inv(H));
K=inv(K);
K = K*Rz/K(3,3);
R = (Rz*R')

end